-- @file seed.sql
-- @version 0.2.0
-- @description Role tetap dan enam produk development Parissa POS.

-- id role dan produk di seed ini sengaja tetap (bukan gen_random_uuid) agar
-- stabil lintas db:reset dan bisa dirujuk langsung oleh pgTAP di
-- supabase/tests/database/*.sql. `on conflict ... do update` membuat seed
-- ini aman dijalankan berulang tanpa error duplikat maupun perlu truncate.
insert into public.roles (id, code, name, permissions)
values
  (
    '10000000-0000-4000-8000-000000000001',
    'owner',
    'Owner',
    '{"products":"write","transactions":"write","void":"write","users":"write"}'::jsonb
  ),
  (
    '10000000-0000-4000-8000-000000000002',
    'cashier',
    'Kasir',
    '{"products":"read","transactions":"write","void":"none","users":"none"}'::jsonb
  )
on conflict (code) do update
set
  name = excluded.name,
  permissions = excluded.permissions;

-- HPP di bawah ini adalah nilai PLACEHOLDER untuk kebutuhan development lokal,
-- Bundling 3pcs memakai tiga kali HPP placeholder per pcs: 3 × 9.500 = 28.500.
insert into public.products (
  id,
  name,
  category,
  selling_price,
  standard_cost,
  is_active
)
values
  (
    '20000000-0000-4000-8000-000000000001',
    'Vanilla Pannacotta',
    'Dessert',
    20000,
    8000,
    true
  ),
  (
    '20000000-0000-4000-8000-000000000002',
    'Earl Grey Pannacotta',
    'Dessert',
    20000,
    9500,
    true
  ),
  (
    '20000000-0000-4000-8000-000000000003',
    'Bundling 3pcs',
    'Bundling',
    50000,
    28500,
    true
  ),
  (
    '20000000-0000-4000-8000-000000000004',
    'Fresh Creamy Earl Grey',
    'Minuman',
    28000,
    11000,
    true
  ),
  (
    '20000000-0000-4000-8000-000000000005',
    'Fresh Creamy Matcha',
    'Minuman',
    28000,
    12000,
    true
  ),
  (
    '20000000-0000-4000-8000-000000000006',
    'Fresh Creamy Lotus',
    'Minuman',
    28000,
    13000,
    true
  )
on conflict (id) do update
set
  name = excluded.name,
  category = excluded.category,
  selling_price = excluded.selling_price,
  standard_cost = excluded.standard_cost,
  is_active = excluded.is_active;
