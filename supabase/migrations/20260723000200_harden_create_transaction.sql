-- @file 20260723000200_harden_create_transaction.sql
-- @version 0.1.0
-- @description Guard eksplisit untuk input null pada RPC create transaction.

-- Migration korektif Gate C: fungsi create_transaction lama (migration 100)
-- memvalidasi p_payment_status/p_items dengan operator seperti `not in (...)`
-- dan `<>`. Di SQL/PL-pgSQL, operator ini menghasilkan NULL (bukan TRUE)
-- ketika salah satu operand NULL, sehingga `if <kondisi> then raise
-- exception` diam-diam tidak pernah terpicu untuk input null — payload null
-- bisa lolos lebih jauh ke logic sebelum akhirnya gagal dengan error yang
-- kurang jelas. Perbaikan di sini menambah guard eksplisit
-- `is null`/`is not null` sebelum logic lama dijalankan, tanpa mengubah
-- logic lama sama sekali. Karena migration 100 sudah diterapkan dan tidak
-- boleh diedit ulang, fungsi lama di-rename menjadi *_internal (private,
-- tanpa grant execute) dan dipanggil dari wrapper public baru di bawah.
alter function public.create_transaction(uuid, text, jsonb, text, text, text)
  rename to create_transaction_internal;

revoke all on function public.create_transaction_internal(
  uuid,
  text,
  jsonb,
  text,
  text,
  text
) from public, anon, authenticated;

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
begin
  -- Guard eksplisit ini menutup celah null yang dijelaskan di atas: setiap
  -- parameter wajib dicek `is null` secara langsung sebelum diteruskan ke
  -- logic lama, karena perbandingan seperti `p_payment_status not in (...)`
  -- tidak pernah mengevaluasi ke TRUE saat operand-nya NULL.
  if p_idempotency_key is null then
    raise exception 'Idempotency key wajib diisi.' using errcode = '22023';
  end if;

  if p_payment_status is null then
    raise exception 'Status pembayaran wajib diisi.' using errcode = '22023';
  end if;

  if p_items is null or jsonb_typeof(p_items) <> 'array' then
    raise exception 'Item transaksi wajib berupa array.' using errcode = '22023';
  end if;

  -- Setelah guard null lolos, seluruh validasi bisnis dan logic atomik yang
  -- sudah diverifikasi pgTAP di migration 100 tetap dipakai apa adanya.
  return public.create_transaction_internal(
    p_idempotency_key,
    p_payment_status,
    p_items,
    p_customer_name,
    p_customer_phone,
    p_notes
  );
end;
$$;

revoke all on function public.create_transaction(uuid, text, jsonb, text, text, text)
  from public, anon;

grant execute on function public.create_transaction(uuid, text, jsonb, text, text, text)
  to authenticated;
