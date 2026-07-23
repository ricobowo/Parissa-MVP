-- @file transactions.test.sql
-- @version 0.1.0
-- @description Integration test mutation transaksi, snapshot HPP, dan audit.

begin;

create extension if not exists pgtap with schema extensions;

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

select ok(
  (
    select paid_at is not null and paid_by = auth.uid()
    from public.transactions
    where idempotency_key = '41000000-0000-4000-8000-000000000003'
  ),
  'Transaksi lunas mencatat paid_at dan paid_by'
);

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
  8000::numeric,
  'Item menyimpan snapshot HPP placeholder'
);

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
