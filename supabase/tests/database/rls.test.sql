-- @file rls.test.sql
-- @version 0.1.0
-- @description Pengujian RLS Owner, Kasir, anonymous, dan user inactive.

begin;

create extension if not exists pgtap with schema extensions;

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
select is(
  (select count(*) from public.products),
  0::bigint,
  'User inactive tidak dapat membaca produk'
);
reset role;

select * from finish();
rollback;
