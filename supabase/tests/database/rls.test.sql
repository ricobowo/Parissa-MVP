-- @file rls.test.sql
-- @version 0.1.0
-- @description Pengujian RLS Owner, Kasir, anonymous, dan user inactive.

begin;

create extension if not exists pgtap with schema extensions;

-- Lima kasus di bawah menutupi empat identitas yang membutuhkan perilaku RLS
-- berbeda sesuai acceptance criteria: anonymous dan user inactive tidak
-- boleh mengakses aplikasi sama sekali, Kasir hanya boleh baca produk aktif,
-- dan hanya Owner yang boleh menulis produk.
select plan(5);

insert into auth.users (
  instance_id,
  id,
  aud,
  role,
  email,
  encrypted_password,
  email_confirmed_at,
  created_at,
  updated_at
)
values
  (
    '00000000-0000-0000-0000-000000000000',
    '30000000-0000-4000-8000-000000000001',
    'authenticated',
    'authenticated',
    'owner@test.local',
    '',
    now(),
    now(),
    now()
  ),
  (
    '00000000-0000-0000-0000-000000000000',
    '30000000-0000-4000-8000-000000000002',
    'authenticated',
    'authenticated',
    'cashier@test.local',
    '',
    now(),
    now(),
    now()
  ),
  (
    '00000000-0000-0000-0000-000000000000',
    '30000000-0000-4000-8000-000000000003',
    'authenticated',
    'authenticated',
    'inactive@test.local',
    '',
    now(),
    now(),
    now()
  );

insert into public.users (id, name, role_id, is_active)
values
  (
    '30000000-0000-4000-8000-000000000001',
    'Owner Test',
    '10000000-0000-4000-8000-000000000001',
    true
  ),
  (
    '30000000-0000-4000-8000-000000000002',
    'Kasir Test',
    '10000000-0000-4000-8000-000000000002',
    true
  ),
  (
    '30000000-0000-4000-8000-000000000003',
    'Inactive Test',
    '10000000-0000-4000-8000-000000000002',
    false
  );

-- Anon tidak punya grant select sama sekali (revoke all + tidak diberi
-- ulang di migration), jadi harusnya gagal di level privilege (42501)
-- sebelum RLS policy manapun sempat dievaluasi.
set local role anon;
select throws_ok(
  'select * from public.products',
  '42501',
  null,
  'Anonymous tidak memiliki akses tabel produk'
);
reset role;

select set_config(
  'request.jwt.claim.sub',
  '30000000-0000-4000-8000-000000000002',
  true
);
select set_config('request.jwt.claim.role', 'authenticated', true);
set local role authenticated;
-- Kasir aktif harus tetap bisa membaca katalog produk (dibutuhkan POS grid),
-- tapi grant insert/update yang luas ke authenticated tidak berarti Kasir
-- boleh menulis: policy products_insert_owner yang menegakkan batasannya.
select is(
  (select count(*) from public.products),
  6::bigint,
  'Kasir aktif dapat membaca enam produk aktif'
);
select throws_ok(
  $$insert into public.products (name, category, selling_price, standard_cost)
    values ('Tidak Boleh', 'Dessert', 10000, 5000)$$,
  '42501',
  null,
  'Kasir tidak dapat membuat produk'
);
reset role;

select set_config(
  'request.jwt.claim.sub',
  '30000000-0000-4000-8000-000000000001',
  true
);
set local role authenticated;
-- Kontras langsung dengan kasus Kasir di atas: identity yang sama (grant
-- tabel yang sama), hanya role_id yang berbeda, membuktikan pembatasan
-- benar-benar datang dari RLS berbasis role, bukan dari grant SQL.
select lives_ok(
  $$insert into public.products (name, category, selling_price, standard_cost)
    values ('Produk Owner', 'Dessert', 10000, 5000)$$,
  'Owner dapat membuat produk'
);
reset role;

select set_config(
  'request.jwt.claim.sub',
  '30000000-0000-4000-8000-000000000003',
  true
);
set local role authenticated;
-- User dengan is_active = false harus terlihat "buta" terhadap seluruh data
-- meski sesi authenticated-nya sah; ini menegakkan guard inactive-user yang
-- juga jadi acceptance criterion login ("user inactive tidak dapat membuka
-- aplikasi"), diuji di sini pada level tabel produk sebagai representatif.
select is(
  (select count(*) from public.products),
  0::bigint,
  'User inactive tidak dapat membaca produk'
);
reset role;

select * from finish();
rollback;
