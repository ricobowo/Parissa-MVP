-- @file 20260723000100_initial_mvp_foundation.sql
-- @version 0.1.0
-- @description Enam tabel P0, RLS, dan mutation atomik Parissa POS.

create extension if not exists pgcrypto with schema extensions;

create sequence public.transaction_number_seq;

-- Role dibatasi permanen ke 'owner' dan 'cashier' pada P0; tidak ada editor
-- role yang fleksibel (lihat Document/MVP/02-MVP-Scope.md). Menambah role
-- baru berarti migration baru, bukan data yang bisa diubah bebas dari UI.
create table public.roles (
  id uuid primary key default extensions.gen_random_uuid(),
  code text not null unique check (code in ('owner', 'cashier')),
  name text not null check (char_length(trim(name)) between 1 and 60),
  permissions jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

-- id sengaja sama dengan auth.users(id): baris ini adalah profil bisnis
-- (nama, role, status aktif) dari identitas yang sama di Supabase Auth.
-- on delete restrict mencegah akun auth dihapus selagi masih punya profil
-- dan riwayat transaksi terkait di public.
create table public.users (
  id uuid primary key references auth.users(id) on delete restrict,
  name text not null check (char_length(trim(name)) between 1 and 120),
  role_id uuid not null references public.roles(id) on delete restrict,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.products (
  id uuid primary key default extensions.gen_random_uuid(),
  name text not null check (char_length(trim(name)) between 1 and 120),
  category text not null check (category in ('Dessert', 'Minuman', 'Bundling')),
  selling_price numeric(14, 2) not null check (selling_price >= 0),
  standard_cost numeric(14, 2) not null check (standard_cost >= 0),
  image_url text,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.transactions (
  id uuid primary key default extensions.gen_random_uuid(),
  transaction_number text not null unique,
  business_date date not null default (timezone('Asia/Jakarta', now()))::date,
  customer_name text check (
    customer_name is null or char_length(trim(customer_name)) between 1 and 120
  ),
  customer_phone text check (
    customer_phone is null or char_length(trim(customer_phone)) between 1 and 40
  ),
  payment_status text not null check (payment_status in ('Sudah', 'Belum')),
  total_amount numeric(14, 2) not null check (total_amount >= 0),
  total_cost numeric(14, 2) not null check (total_cost >= 0),
  notes text check (notes is null or char_length(notes) <= 500),
  -- Kunci idempotensi dibuat client saat submit; unique constraint ini
  -- adalah lapisan terakhir anti-duplikat bila advisory lock di
  -- create_transaction lolos karena alasan tak terduga.
  idempotency_key uuid not null unique,
  is_void boolean not null default false,
  void_reason text,
  voided_at timestamptz,
  voided_by uuid references public.users(id) on delete restrict,
  paid_at timestamptz,
  paid_by uuid references public.users(id) on delete restrict,
  created_by uuid not null references public.users(id) on delete restrict,
  created_at timestamptz not null default now(),
  -- Piutang ('Belum') wajib punya nama pelanggan untuk penagihan; transaksi
  -- lunas boleh anonim dan tampil sebagai "Pelanggan Umum" di UI.
  constraint transactions_customer_required_when_unpaid check (
    payment_status = 'Sudah'
    or nullif(trim(customer_name), '') is not null
  ),
  -- paid_at/paid_by adalah pasangan tak terpisahkan: keduanya wajib terisi
  -- persis ketika status 'Sudah'. Tanggal pengakuan finansial (omzet, HPP,
  -- gross profit) memakai paid_at, bukan created_at, sehingga konsistensi
  -- pasangan ini menjaga agregat dashboard tetap benar.
  constraint transactions_payment_fields_consistent check (
    (payment_status = 'Sudah' and paid_at is not null and paid_by is not null)
    or (payment_status = 'Belum' and paid_at is null and paid_by is null)
  ),
  -- Void tidak pernah setengah tercatat: alasan, waktu, dan actor void harus
  -- ada bersamaan agar audit void selalu lengkap (tidak ada hard delete,
  -- jadi baris ini menjadi satu-satunya jejak transaksi yang dibatalkan).
  constraint transactions_void_fields_consistent check (
    (is_void = false and void_reason is null and voided_at is null and voided_by is null)
    or (
      is_void = true
      and nullif(trim(void_reason), '') is not null
      and voided_at is not null
      and voided_by is not null
    )
  )
);

create table public.transaction_items (
  id uuid primary key default extensions.gen_random_uuid(),
  transaction_id uuid not null references public.transactions(id) on delete restrict,
  product_id uuid not null references public.products(id) on delete restrict,
  product_name_snapshot text not null,
  unit_price_snapshot numeric(14, 2) not null check (unit_price_snapshot >= 0),
  unit_cost_snapshot numeric(14, 2) not null check (unit_cost_snapshot >= 0),
  quantity integer not null check (quantity > 0 and quantity <= 999),
  subtotal numeric(14, 2)
    generated always as (unit_price_snapshot * quantity) stored,
  cost_total numeric(14, 2)
    generated always as (unit_cost_snapshot * quantity) stored,
  created_at timestamptz not null default now(),
  unique (transaction_id, product_id)
);

create table public.audit_logs (
  id uuid primary key default extensions.gen_random_uuid(),
  entity_type text not null check (entity_type = 'transaction'),
  entity_id uuid not null references public.transactions(id) on delete restrict,
  action text not null check (action in ('create', 'mark_paid', 'mark_unpaid', 'void')),
  old_values jsonb,
  new_values jsonb,
  actor_id uuid not null references public.users(id) on delete restrict,
  created_at timestamptz not null default now()
);

-- Index business_date menopang filter tanggal di riwayat transaksi.
create index transactions_business_date_idx on public.transactions (business_date);
-- Index parsial (hanya baris berpaid_at) menopang agregasi dashboard yang
-- mengelompokkan omzet/HPP/gross profit berdasarkan tanggal paid_at, bukan
-- created_at, sesuai aturan pengakuan finansial.
create index transactions_paid_at_idx on public.transactions (paid_at) where paid_at is not null;
-- Index parsial ini menopang daftar piutang aktif (status Belum, tidak void)
-- tanpa perlu memindai seluruh tabel transaksi historis.
create index transactions_receivable_idx
  on public.transactions (created_at)
  where payment_status = 'Belum' and is_void = false;
create index transaction_items_transaction_id_idx
  on public.transaction_items (transaction_id);
create index audit_logs_entity_idx
  on public.audit_logs (entity_type, entity_id, created_at);

create or replace function public.set_updated_at()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

-- Hanya users dan products yang punya trigger updated_at karena keduanya
-- adalah entitas yang boleh diubah di tempat. Transactions tidak diedit
-- langsung (hanya lewat RPC append-only/audit), sehingga tidak perlu jejak
-- updated_at generik.
create trigger users_set_updated_at
before update on public.users
for each row execute function public.set_updated_at();

create trigger products_set_updated_at
before update on public.products
for each row execute function public.set_updated_at();

-- Tiga fungsi helper berikut, serta seluruh RPC mutation di bawah, memakai
-- kombinasi `security definer` + `set search_path = ''`. Pola ini wajib untuk
-- fungsi security definer di Postgres/Supabase: search_path kosong memaksa
-- setiap referensi objek ditulis lengkap (mis. public.users, extensions.*)
-- sehingga search_path pemanggil tidak bisa dibajak untuk menyisipkan fungsi
-- atau tabel palsu. `security definer` sendiri dipakai agar helper role-check
-- ini bisa membaca public.users/public.roles tanpa terjebak rekursi RLS
-- (policy pada users/roles yang memanggil balik fungsi ini).
create or replace function public.current_user_is_active()
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1
    from public.users
    where id = (select auth.uid())
      and is_active = true
  );
$$;

create or replace function public.current_user_role()
returns text
language sql
stable
security definer
set search_path = ''
as $$
  select roles.code
  from public.users
  join public.roles on roles.id = users.role_id
  where users.id = (select auth.uid())
    and users.is_active = true;
$$;

create or replace function public.current_user_is_owner()
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select coalesce((select public.current_user_role()) = 'owner', false);
$$;

-- Strategi RLS keseluruhan: setiap tabel default-deny (RLS enabled, lalu di
-- bawah semua grant dicabut dan diberi ulang secara selektif). Tidak ada
-- policy `for delete` sama sekali untuk transactions dan transaction_items
-- karena transaksi tidak pernah di-hard-delete; void adalah satu-satunya
-- cara "membatalkan" dan tetap meninggalkan jejak. Insert/update transaksi,
-- item, dan audit log juga tidak diberi policy karena seluruh mutation itu
-- hanya boleh lewat RPC security definer (create_transaction,
-- set_transaction_payment_status, void_transaction) yang memvalidasi role
-- dan menulis audit sendiri, bukan lewat query langsung dari client.
alter table public.roles enable row level security;
alter table public.users enable row level security;
alter table public.products enable row level security;
alter table public.transactions enable row level security;
alter table public.transaction_items enable row level security;
alter table public.audit_logs enable row level security;

create policy roles_select_active_user
on public.roles for select
to authenticated
using ((select public.current_user_is_active()));

-- Kasir hanya boleh melihat profilnya sendiri; Owner boleh melihat semua
-- user karena perlu mengelola tim (mis. menonaktifkan akun Kasir).
create policy users_select_self_or_owner
on public.users for select
to authenticated
using (
  (select public.current_user_is_active())
  and (id = (select auth.uid()) or (select public.current_user_is_owner()))
);

-- Hanya Owner dapat mengubah baris users (mis. is_active, role_id); Kasir
-- tidak boleh mengaktifkan/menonaktifkan diri sendiri atau user lain.
create policy users_update_owner
on public.users for update
to authenticated
using ((select public.current_user_is_owner()))
with check ((select public.current_user_is_owner()));

-- Kasir hanya melihat produk aktif (produk nonaktif hilang dari POS grid
-- sesuai acceptance criteria); Owner tetap melihat produk nonaktif agar bisa
-- mengelola/mengaktifkan kembali dari halaman produk.
create policy products_select_active_user
on public.products for select
to authenticated
using (
  (select public.current_user_is_active())
  and (is_active = true or (select public.current_user_is_owner()))
);

create policy products_insert_owner
on public.products for insert
to authenticated
with check ((select public.current_user_is_owner()));

create policy products_update_owner
on public.products for update
to authenticated
using ((select public.current_user_is_owner()))
with check ((select public.current_user_is_owner()));

-- Semua user aktif (Owner maupun Kasir) melihat seluruh transaksi, bukan
-- hanya transaksi yang dia buat sendiri, karena riwayat/piutang di P0 adalah
-- tampilan bersama satu outlet, bukan per-kasir.
create policy transactions_select_active_user
on public.transactions for select
to authenticated
using ((select public.current_user_is_active()));

-- Klausa exists di sini pada dasarnya selalu benar untuk user aktif (karena
-- policy transactions di atas sudah mengizinkan semua user aktif melihat
-- semua transaksi); ini dipertahankan sebagai defense-in-depth agar jika
-- policy select transactions suatu saat dipersempit (mis. per-kasir),
-- visibilitas item transaksi otomatis ikut menyempit tanpa perlu diubah lagi.
create policy transaction_items_select_active_user
on public.transaction_items for select
to authenticated
using (
  (select public.current_user_is_active())
  and exists (
    select 1
    from public.transactions
    where transactions.id = transaction_items.transaction_id
  )
);

-- Audit log hanya bisa dibaca Owner; ini sejalan dengan permission seed
-- Kasir ("users":"none") dan menjaga jejak actor/perubahan sensitif tidak
-- terekspos ke Kasir.
create policy audit_logs_select_owner
on public.audit_logs for select
to authenticated
using ((select public.current_user_is_owner()));

-- Cabut semua grant default lalu berikan ulang secara eksplisit (default
-- deny). Anonymous (anon) sengaja tidak mendapat grant apa pun sehingga
-- percobaan akses tanpa login gagal di level grant, bukan hanya di RLS.
revoke all on all tables in schema public from anon, authenticated;
revoke all on all sequences in schema public from anon, authenticated;

grant usage on schema public to authenticated;
grant select on public.roles, public.users, public.products to authenticated;
grant select on public.transactions, public.transaction_items, public.audit_logs to authenticated;
-- Grant insert/update products ini sengaja luas (semua authenticated); yang
-- benar-benar membatasi hanya Owner yang bisa menulis adalah RLS policy
-- products_insert_owner/products_update_owner di atas. Grant di sini hanya
-- syarat perlu (tanpa ini semua ditolak di level SQL sebelum RLS dievaluasi).
grant insert, update on public.products to authenticated;
grant update on public.users to authenticated;

revoke all on function public.set_updated_at() from public, anon, authenticated;
revoke all on function public.current_user_is_active() from public, anon;
revoke all on function public.current_user_role() from public, anon;
revoke all on function public.current_user_is_owner() from public, anon;

grant execute on function public.current_user_is_active() to authenticated;
grant execute on function public.current_user_role() to authenticated;
grant execute on function public.current_user_is_owner() to authenticated;

-- RPC ini adalah satu-satunya jalan resmi membuat transaksi. Header dan
-- seluruh item disimpan dalam satu transaksi database (atomik): jika bagian
-- mana pun gagal (produk tidak valid, item kosong, dsb.), seluruh insert
-- dibatalkan. Total dan snapshot harga/HPP dihitung ulang di sini dari
-- public.products saat ini, bukan dipercaya dari payload client, sehingga
-- angka pada payload tidak bisa memanipulasi total_amount/total_cost akhir.
create or replace function public.create_transaction(
  p_idempotency_key uuid,
  p_payment_status text,
  p_items jsonb,
  p_customer_name text default null,
  p_customer_phone text default null,
  p_notes text default null
)
returns public.transactions
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_actor uuid := auth.uid();
  v_transaction public.transactions;
  v_item_count integer;
  v_product_count integer;
  v_total_amount numeric(14, 2);
  v_total_cost numeric(14, 2);
begin
  if v_actor is null or not public.current_user_is_active() then
    raise exception 'Pengguna tidak aktif atau belum login.' using errcode = '42501';
  end if;

  if p_payment_status not in ('Sudah', 'Belum') then
    raise exception 'Status pembayaran tidak valid.' using errcode = '22023';
  end if;

  if p_payment_status = 'Belum' and nullif(trim(p_customer_name), '') is null then
    raise exception 'Nama pelanggan wajib untuk transaksi piutang.' using errcode = '22023';
  end if;

  if jsonb_typeof(p_items) <> 'array'
    or jsonb_array_length(p_items) < 1
    or jsonb_array_length(p_items) > 100
  then
    raise exception 'Transaksi harus memiliki 1 sampai 100 item.' using errcode = '22023';
  end if;

  -- Advisory lock per idempotency key mencegah dua request bersamaan dengan
  -- key yang sama lolos "belum ada baris" secara bersamaan (race condition
  -- yang tidak sepenuhnya dicegah oleh unique constraint saja, karena unique
  -- constraint baru menolak pada saat insert, setelah kedua request sudah
  -- sama-sama lewat pengecekan `found` di bawah). Lock otomatis lepas saat
  -- transaksi database ini selesai (xact lock).
  perform pg_catalog.pg_advisory_xact_lock(
    pg_catalog.hashtextextended(p_idempotency_key::text, 0)
  );

  select *
  into v_transaction
  from public.transactions
  where idempotency_key = p_idempotency_key;

  if found then
    -- Retry submit yang sah (network timeout, double-click) akan memakai
    -- idempotency key yang sama dari actor yang sama, dan cukup dikembalikan
    -- transaksi yang sudah ada. Jika actor berbeda, key kemungkinan
    -- bentrok/disalahgunakan sehingga ditolak sebagai konflik.
    if v_transaction.created_by <> v_actor then
      raise exception 'Idempotency key sudah digunakan.' using errcode = '23505';
    end if;
    return v_transaction;
  end if;

  with requested as (
    select
      (item ->> 'product_id')::uuid as product_id,
      (item ->> 'quantity')::integer as quantity
    from jsonb_array_elements(p_items) as source(item)
  )
  select
    count(*),
    count(distinct product_id)
  into v_item_count, v_product_count
  from requested
  where quantity between 1 and 999;

  -- Setiap produk hanya boleh muncul sekali per transaksi (quantity yang
  -- ditambah, bukan baris duplikat); ini juga sejalan dengan constraint
  -- unique (transaction_id, product_id) pada transaction_items.
  if v_item_count <> jsonb_array_length(p_items)
    or v_product_count <> v_item_count
  then
    raise exception 'Item duplikat atau quantity tidak valid.' using errcode = '22023';
  end if;

  -- Mengunci baris produk yang dipesan (FOR SHARE, urutan id konsisten untuk
  -- hindari deadlock) sebelum menghitung total. Ini menutup celah di mana
  -- Owner mengubah selling_price/standard_cost persis di antara pembacaan
  -- harga dan penulisan snapshot item, yang bisa membuat subtotal item tidak
  -- konsisten dengan total_amount/total_cost header.
  perform 1
  from public.products
  join (
    select (item ->> 'product_id')::uuid as product_id
    from jsonb_array_elements(p_items) as source(item)
  ) as requested on requested.product_id = products.id
  order by products.id
  for share of products;

  -- Total dan HPP dihitung dari harga/HPP produk aktif saat ini di database,
  -- bukan dari nilai apa pun yang dikirim client (payload item hanya berisi
  -- product_id dan quantity). Join mensyaratkan is_active = true agar produk
  -- yang baru dinonaktifkan tidak bisa lagi dipakai walau UI client sempat
  -- menampilkannya sebelum refresh.
  with requested as (
    select
      (item ->> 'product_id')::uuid as product_id,
      (item ->> 'quantity')::integer as quantity
    from jsonb_array_elements(p_items) as source(item)
  )
  select
    count(products.id),
    coalesce(sum(products.selling_price * requested.quantity), 0),
    coalesce(sum(products.standard_cost * requested.quantity), 0)
  into v_product_count, v_total_amount, v_total_cost
  from requested
  join public.products
    on products.id = requested.product_id
   and products.is_active = true;

  -- Jika jumlah produk yang cocok (aktif) lebih sedikit dari jumlah item
  -- yang diminta, berarti ada product_id yang tidak ada atau sudah
  -- dinonaktifkan sejak client memuat data; transaksi ditolak alih-alih
  -- diam-diam mengecilkan total.
  if v_product_count <> v_item_count then
    raise exception 'Produk tidak tersedia atau sudah nonaktif.' using errcode = '22023';
  end if;

  insert into public.transactions (
    transaction_number,
    customer_name,
    customer_phone,
    payment_status,
    total_amount,
    total_cost,
    notes,
    idempotency_key,
    paid_at,
    paid_by,
    created_by
  )
  values (
    'PRS-'
      || to_char(timezone('Asia/Jakarta', now()), 'YYYYMMDD')
      || '-'
      || lpad(nextval('public.transaction_number_seq')::text, 6, '0'),
    nullif(trim(p_customer_name), ''),
    nullif(trim(p_customer_phone), ''),
    p_payment_status,
    v_total_amount,
    v_total_cost,
    nullif(trim(p_notes), ''),
    p_idempotency_key,
    case when p_payment_status = 'Sudah' then now() else null end,
    case when p_payment_status = 'Sudah' then v_actor else null end,
    v_actor
  )
  returning * into v_transaction;

  insert into public.transaction_items (
    transaction_id,
    product_id,
    product_name_snapshot,
    unit_price_snapshot,
    unit_cost_snapshot,
    quantity
  )
  select
    v_transaction.id,
    products.id,
    products.name,
    products.selling_price,
    products.standard_cost,
    requested.quantity
  from (
    select
      (item ->> 'product_id')::uuid as product_id,
      (item ->> 'quantity')::integer as quantity
    from jsonb_array_elements(p_items) as source(item)
  ) as requested
  join public.products on products.id = requested.product_id;

  -- Create wajib diaudit beserta actor dan timestamp; old_values null karena
  -- ini adalah kejadian pembuatan baru, bukan perubahan atas baris lama.
  insert into public.audit_logs (
    entity_type,
    entity_id,
    action,
    old_values,
    new_values,
    actor_id
  )
  values (
    'transaction',
    v_transaction.id,
    'create',
    null,
    jsonb_build_object(
      'payment_status', v_transaction.payment_status,
      'total_amount', v_transaction.total_amount,
      'total_cost', v_transaction.total_cost
    ),
    v_actor
  );

  return v_transaction;
end;
$$;

-- Satu-satunya jalan resmi mengubah status pembayaran. 'Belum' -> 'Sudah'
-- boleh siapa saja yang aktif (mis. Kasir melunasi piutang); 'Sudah' ->
-- 'Belum' (mark-as-unpaid) hanya Owner karena mengoreksi agregat finansial
-- yang sudah diakui pada tanggal paid_at sebelumnya.
create or replace function public.set_transaction_payment_status(
  p_transaction_id uuid,
  p_payment_status text,
  p_customer_name text default null
)
returns public.transactions
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_actor uuid := auth.uid();
  v_before public.transactions;
  v_after public.transactions;
  v_customer_name text;
begin
  if v_actor is null or not public.current_user_is_active() then
    raise exception 'Pengguna tidak aktif atau belum login.' using errcode = '42501';
  end if;

  if p_payment_status not in ('Sudah', 'Belum') then
    raise exception 'Status pembayaran tidak valid.' using errcode = '22023';
  end if;

  -- Lock baris (FOR UPDATE) mencegah dua permintaan perubahan status
  -- berjalan bersamaan atas transaksi yang sama (mis. mark-paid ganda).
  select *
  into v_before
  from public.transactions
  where id = p_transaction_id
  for update;

  if not found then
    raise exception 'Transaksi tidak ditemukan.' using errcode = 'P0002';
  end if;

  if v_before.is_void then
    raise exception 'Transaksi void tidak dapat diubah.' using errcode = '22023';
  end if;

  -- Idempotent: jika status yang diminta sama dengan status saat ini, tidak
  -- ada perubahan dan tidak ada audit log baru yang ditulis.
  if v_before.payment_status = p_payment_status then
    return v_before;
  end if;

  if p_payment_status = 'Belum' and not public.current_user_is_owner() then
    raise exception 'Hanya Owner dapat mengembalikan transaksi menjadi belum lunas.'
      using errcode = '42501';
  end if;

  -- Transaksi lunas boleh tanpa nama pelanggan; jika dikembalikan ke 'Belum'
  -- dan belum ada nama tersimpan, caller (Owner) wajib menyertakan nama agar
  -- validasi "piutang wajib bernama" tetap terjaga setelah perubahan status.
  v_customer_name := coalesce(nullif(trim(p_customer_name), ''), v_before.customer_name);

  if p_payment_status = 'Belum' and v_customer_name is null then
    raise exception 'Nama pelanggan wajib untuk transaksi piutang.' using errcode = '22023';
  end if;

  -- Mark-as-unpaid membersihkan paid_at/paid_by (bukan sekadar mengganti
  -- status) agar transaksi ini benar-benar keluar dari agregat tanggal
  -- pembayaran lama dan kembali terhitung sebagai piutang aktif.
  update public.transactions
  set
    payment_status = p_payment_status,
    customer_name = v_customer_name,
    paid_at = case when p_payment_status = 'Sudah' then now() else null end,
    paid_by = case when p_payment_status = 'Sudah' then v_actor else null end
  where id = p_transaction_id
  returning * into v_after;

  -- Perubahan status pembayaran ke arah mana pun wajib diaudit; nama action
  -- dibedakan agar riwayat audit bisa membedakan pelunasan dari koreksi
  -- Owner yang mengembalikan status ke belum lunas.
  insert into public.audit_logs (
    entity_type,
    entity_id,
    action,
    old_values,
    new_values,
    actor_id
  )
  values (
    'transaction',
    v_after.id,
    case when p_payment_status = 'Sudah' then 'mark_paid' else 'mark_unpaid' end,
    jsonb_build_object(
      'payment_status', v_before.payment_status,
      'paid_at', v_before.paid_at,
      'paid_by', v_before.paid_by
    ),
    jsonb_build_object(
      'payment_status', v_after.payment_status,
      'paid_at', v_after.paid_at,
      'paid_by', v_after.paid_by
    ),
    v_actor
  );

  return v_after;
end;
$$;

-- Satu-satunya jalan resmi membatalkan transaksi. Void bukan hard delete:
-- baris transaksi tetap ada dan dikecualikan dari agregat finansial lewat
-- flag is_void, bukan dihapus.
create or replace function public.void_transaction(
  p_transaction_id uuid,
  p_reason text
)
returns public.transactions
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_actor uuid := auth.uid();
  v_before public.transactions;
  v_after public.transactions;
begin
  if v_actor is null or not public.current_user_is_owner() then
    raise exception 'Hanya Owner dapat melakukan void.' using errcode = '42501';
  end if;

  -- Alasan void wajib non-kosong; ini bukan sekadar validasi form UI,
  -- melainkan ditegakkan ulang di database agar void tanpa alasan mustahil
  -- terjadi lewat jalur apa pun.
  if nullif(trim(p_reason), '') is null or char_length(trim(p_reason)) > 500 then
    raise exception 'Alasan void wajib diisi dan maksimal 500 karakter.'
      using errcode = '22023';
  end if;

  select *
  into v_before
  from public.transactions
  where id = p_transaction_id
  for update;

  if not found then
    raise exception 'Transaksi tidak ditemukan.' using errcode = 'P0002';
  end if;

  -- Idempotent: void ulang atas transaksi yang sudah void bukan error, cukup
  -- mengembalikan state yang sudah ada (tidak menimpa void_reason/voided_at
  -- lama dan tidak menulis audit log kedua).
  if v_before.is_void then
    return v_before;
  end if;

  update public.transactions
  set
    is_void = true,
    void_reason = trim(p_reason),
    voided_at = now(),
    voided_by = v_actor
  where id = p_transaction_id
  returning * into v_after;

  insert into public.audit_logs (
    entity_type,
    entity_id,
    action,
    old_values,
    new_values,
    actor_id
  )
  values (
    'transaction',
    v_after.id,
    'void',
    jsonb_build_object('is_void', v_before.is_void),
    jsonb_build_object(
      'is_void', v_after.is_void,
      'void_reason', v_after.void_reason,
      'voided_at', v_after.voided_at,
      'voided_by', v_after.voided_by
    ),
    v_actor
  );

  return v_after;
end;
$$;

-- Fungsi security definer berjalan dengan privilege pemiliknya, sehingga
-- grant execute adalah satu-satunya pintu masuk yang perlu dikontrol; revoke
-- eksplisit dari public/anon memastikan hanya sesi authenticated yang bisa
-- memanggil ketiga RPC mutation ini sama sekali (di luar validasi role di
-- dalam masing-masing fungsi).
revoke all on function public.create_transaction(uuid, text, jsonb, text, text, text)
  from public, anon;
revoke all on function public.set_transaction_payment_status(uuid, text, text)
  from public, anon;
revoke all on function public.void_transaction(uuid, text)
  from public, anon;

grant execute on function public.create_transaction(uuid, text, jsonb, text, text, text)
  to authenticated;
grant execute on function public.set_transaction_payment_status(uuid, text, text)
  to authenticated;
grant execute on function public.void_transaction(uuid, text)
  to authenticated;
