-- @file transactions.test.sql
-- @version 0.1.0
-- @description Integration test mutation transaksi, snapshot HPP, dan audit.

begin;

create extension if not exists pgtap with schema extensions;

-- 18 kasus ini memverifikasi jalur RPC (create_transaction,
-- set_transaction_payment_status, void_transaction) sesuai Business Rules:
-- total/HPP dihitung server, idempotensi anti double-submit, wajib nama
-- pelanggan untuk piutang, paid_at/paid_by, Owner-only mark-as-unpaid dan
-- void beserta audit log-nya, serta guard inactive-user pada level RPC
-- (bukan hanya level select tabel seperti di rls.test.sql).
select plan(18);

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
    '31000000-0000-4000-8000-000000000001',
    'authenticated',
    'authenticated',
    'owner-transaction@test.local',
    '',
    now(),
    now(),
    now()
  ),
  (
    '00000000-0000-0000-0000-000000000000',
    '31000000-0000-4000-8000-000000000002',
    'authenticated',
    'authenticated',
    'cashier-transaction@test.local',
    '',
    now(),
    now(),
    now()
  ),
  (
    '00000000-0000-0000-0000-000000000000',
    '31000000-0000-4000-8000-000000000003',
    'authenticated',
    'authenticated',
    'inactive-transaction@test.local',
    '',
    now(),
    now(),
    now()
  );

insert into public.users (id, name, role_id, is_active)
values
  (
    '31000000-0000-4000-8000-000000000001',
    'Owner Transaction Test',
    '10000000-0000-4000-8000-000000000001',
    true
  ),
  (
    '31000000-0000-4000-8000-000000000002',
    'Kasir Transaction Test',
    '10000000-0000-4000-8000-000000000002',
    true
  ),
  (
    '31000000-0000-4000-8000-000000000003',
    'Inactive Transaction Test',
    '10000000-0000-4000-8000-000000000002',
    false
  );

select set_config(
  'request.jwt.claim.sub',
  '31000000-0000-4000-8000-000000000002',
  true
);
select set_config('request.jwt.claim.role', 'authenticated', true);
set local role authenticated;

-- Guard ini memastikan seed HPP placeholder yang dipakai seluruh perhitungan
-- di bawah memang nilai dev yang disepakati di seed.sql, bukan angka
-- indikatif PRD lama; test lain di bawah akan diam-diam salah jika seed ini
-- pernah drift.
select is(
  (
    select array_agg(standard_cost order by id)
    from public.products
  ),
  array[
    8000,
    9500,
    28500,
    11000,
    12000,
    13000
  ]::numeric[],
  'Seed menyimpan enam HPP placeholder development'
);

-- Menguji guard null eksplisit yang ditambahkan migration
-- 20260723000200_harden_create_transaction.sql; tanpa guard itu, payload
-- items null bisa lolos dari pengecekan `not in (...)`/`<>` yang bernilai
-- NULL (bukan TRUE) saat operand-nya NULL.
select throws_ok(
  $$select public.create_transaction(
    '41000000-0000-4000-8000-000000000001'::uuid,
    'Sudah',
    null::jsonb
  )$$,
  '22023',
  null,
  'Create menolak items null'
);

-- Menegakkan Business Rule 2: transaksi 'Belum' wajib nama pelanggan, dan
-- ini divalidasi di database, bukan cuma di form UI, sehingga tidak bisa
-- dilewati lewat panggilan RPC langsung.
select throws_ok(
  $$select public.create_transaction(
    '41000000-0000-4000-8000-000000000002'::uuid,
    'Belum',
    jsonb_build_array(
      jsonb_build_object(
        'product_id',
        '20000000-0000-4000-8000-000000000001',
        'quantity',
        1
      )
    )
  )$$,
  '22023',
  null,
  'Create piutang menolak nama pelanggan kosong'
);

-- Transaksi acuan berikut dipakai berulang oleh beberapa kasus di bawah
-- (total, HPP, paid_at/paid_by, idempotensi, void) supaya satu skenario
-- "transaksi lunas 2x Vanilla Pannacotta" bisa diverifikasi dari banyak sisi
-- tanpa mengulang setup. Payload hanya berisi product_id dan quantity —
-- tidak ada harga yang dikirim sama sekali — sehingga kasus berikutnya yang
-- mencocokkan total_amount/total_cost membuktikan angka itu murni hasil
-- perhitungan server dari public.products.
select public.create_transaction(
  '41000000-0000-4000-8000-000000000003',
  'Sudah',
  jsonb_build_array(
    jsonb_build_object(
      'product_id',
      '20000000-0000-4000-8000-000000000001',
      'quantity',
      2
    )
  )
);

select is(
  (
    select total_amount
    from public.transactions
    where idempotency_key = '41000000-0000-4000-8000-000000000003'
  ),
  40000.00::numeric,
  'Create menghitung total dari harga produk'
);

select is(
  (
    select total_cost
    from public.transactions
    where idempotency_key = '41000000-0000-4000-8000-000000000003'
  ),
  16000.00::numeric,
  'Create menghitung total HPP placeholder'
);

-- Business Rule 3: transaksi yang dibuat langsung 'Sudah' harus langsung
-- mengisi paid_at/paid_by saat create, bukan menunggu mutation terpisah.
select ok(
  (
    select paid_at is not null and paid_by = auth.uid()
    from public.transactions
    where idempotency_key = '41000000-0000-4000-8000-000000000003'
  ),
  'Transaksi lunas mencatat paid_at dan paid_by'
);

-- Snapshot HPP item tidak boleh berubah walau standard_cost produk berubah
-- di masa depan; ini membuktikan nilai disalin ke transaction_items saat
-- create, bukan dijoin ulang ke products setiap kali dibaca.
select is(
  (
    select unit_cost_snapshot
    from public.transaction_items
    where transaction_id = (
      select id
      from public.transactions
      where idempotency_key = '41000000-0000-4000-8000-000000000003'
    )
  ),
  8000.00::numeric,
  'Item menyimpan snapshot HPP placeholder'
);

-- Simulasi double-submit: memanggil create_transaction lagi dengan
-- idempotency key yang sama (payload identik, actor sama) harus
-- mengembalikan transaksi yang sudah ada, bukan membuat baris kedua.
select is(
  (
    select id
    from public.create_transaction(
      '41000000-0000-4000-8000-000000000003',
      'Sudah',
      jsonb_build_array(
        jsonb_build_object(
          'product_id',
          '20000000-0000-4000-8000-000000000001',
          'quantity',
          2
        )
      )
    )
  ),
  (
    select id
    from public.transactions
    where idempotency_key = '41000000-0000-4000-8000-000000000003'
  ),
  'Idempotency key mengembalikan transaksi yang sama'
);

select is(
  (
    select count(*)
    from public.transactions
    where idempotency_key = '41000000-0000-4000-8000-000000000003'
  ),
  1::bigint,
  'Retry tidak membuat transaksi duplikat'
);

-- Transaksi acuan kedua: piutang aktif dengan nama pelanggan, dipakai untuk
-- menguji pelunasan (Kasir boleh) dan pengembalian ke belum lunas
-- (Owner-only) di kelompok kasus berikut ini.
select public.create_transaction(
  '41000000-0000-4000-8000-000000000004',
  'Belum',
  jsonb_build_array(
    jsonb_build_object(
      'product_id',
      '20000000-0000-4000-8000-000000000002',
      'quantity',
      1
    )
  ),
  'Pelanggan Piutang'
);

select public.set_transaction_payment_status(
  (
    select id
    from public.transactions
    where idempotency_key = '41000000-0000-4000-8000-000000000004'
  ),
  'Sudah'
);

select ok(
  (
    select paid_at is not null and paid_by = auth.uid()
    from public.transactions
    where idempotency_key = '41000000-0000-4000-8000-000000000004'
  ),
  'Kasir dapat melunasi piutang'
);

-- Arah sebaliknya (Sudah -> Belum) mengoreksi agregat finansial yang sudah
-- diakui, sehingga sengaja dibatasi hanya Owner walau Kasir boleh melunasi.
select throws_ok(
  $$select public.set_transaction_payment_status(
    (
      select id
      from public.transactions
      where idempotency_key = '41000000-0000-4000-8000-000000000004'
    ),
    'Belum'
  )$$,
  '42501',
  null,
  'Kasir tidak dapat mengembalikan transaksi menjadi belum lunas'
);

select throws_ok(
  $$select public.void_transaction(
    (
      select id
      from public.transactions
      where idempotency_key = '41000000-0000-4000-8000-000000000003'
    ),
    'Tidak diizinkan'
  )$$,
  '42501',
  null,
  'Kasir tidak dapat melakukan void'
);

reset role;
select set_config(
  'request.jwt.claim.sub',
  '31000000-0000-4000-8000-000000000001',
  true
);
select set_config('request.jwt.claim.role', 'authenticated', true);
set local role authenticated;

-- Beralih ke sesi Owner untuk sisa kasus: audit_logs hanya bisa dibaca
-- Owner (policy audit_logs_select_owner), dan hanya Owner yang boleh
-- mark-as-unpaid serta void, jadi kasus-kasus berikut memverifikasi kedua
-- hal itu sekaligus lewat query yang sama.
select is(
  (
    select count(*)
    from public.audit_logs
    where
      entity_id = (
        select id
        from public.transactions
        where idempotency_key = '41000000-0000-4000-8000-000000000003'
      )
      and action = 'create'
  ),
  1::bigint,
  'Create menulis satu audit log yang dapat dibaca Owner'
);

select is(
  (
    select count(*)
    from public.audit_logs
    where
      entity_id = (
        select id
        from public.transactions
        where idempotency_key = '41000000-0000-4000-8000-000000000004'
      )
      and action = 'mark_paid'
  ),
  1::bigint,
  'Pelunasan menulis audit log yang dapat dibaca Owner'
);

select public.set_transaction_payment_status(
  (
    select id
    from public.transactions
    where idempotency_key = '41000000-0000-4000-8000-000000000004'
  ),
  'Belum'
);

-- Memverifikasi Business Rule 3: mark-as-unpaid benar-benar membersihkan
-- paid_at/paid_by (bukan hanya mengganti label status), sehingga transaksi
-- ini kembali terhitung sebagai piutang aktif.
select ok(
  (
    select
      payment_status = 'Belum'
      and paid_at is null
      and paid_by is null
    from public.transactions
    where idempotency_key = '41000000-0000-4000-8000-000000000004'
  ),
  'Owner dapat mengembalikan transaksi menjadi belum lunas'
);

select public.void_transaction(
  (
    select id
    from public.transactions
    where idempotency_key = '41000000-0000-4000-8000-000000000003'
  ),
  'Kesalahan input'
);

-- Void wajib meninggalkan jejak lengkap (bukan hard delete): reason, waktu,
-- dan actor semuanya harus terisi konsisten sesuai constraint
-- transactions_void_fields_consistent di migration schema.
select ok(
  (
    select
      is_void
      and void_reason = 'Kesalahan input'
      and voided_at is not null
      and voided_by = auth.uid()
    from public.transactions
    where idempotency_key = '41000000-0000-4000-8000-000000000003'
  ),
  'Owner dapat melakukan void dengan alasan'
);

select is(
  (
    select count(*)
    from public.audit_logs
    where
      entity_id = (
        select id
        from public.transactions
        where idempotency_key = '41000000-0000-4000-8000-000000000003'
      )
      and action = 'void'
  ),
  1::bigint,
  'Void menulis satu audit log'
);

reset role;
select set_config(
  'request.jwt.claim.sub',
  '31000000-0000-4000-8000-000000000003',
  true
);
select set_config('request.jwt.claim.role', 'authenticated', true);
set local role authenticated;

-- Guard inactive-user ditegakkan lagi di dalam RPC (current_user_is_active),
-- melengkapi rls.test.sql yang menguji guard yang sama pada level select
-- tabel biasa; di sini dibuktikan bahwa jalur mutation RPC juga tertutup.
select throws_ok(
  $$select public.create_transaction(
    '41000000-0000-4000-8000-000000000005'::uuid,
    'Sudah',
    jsonb_build_array(
      jsonb_build_object(
        'product_id',
        '20000000-0000-4000-8000-000000000001',
        'quantity',
        1
      )
    )
  )$$,
  '42501',
  null,
  'User inactive tidak dapat membuat transaksi'
);

reset role;

select * from finish();
rollback;
