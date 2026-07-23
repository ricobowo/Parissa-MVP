-- @file 20260723000200_harden_create_transaction.sql
-- @version 0.1.0
-- @description Guard eksplisit untuk input null pada RPC create transaction.

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
  if p_idempotency_key is null then
    raise exception 'Idempotency key wajib diisi.' using errcode = '22023';
  end if;

  if p_payment_status is null then
    raise exception 'Status pembayaran wajib diisi.' using errcode = '22023';
  end if;

  if p_items is null or jsonb_typeof(p_items) <> 'array' then
    raise exception 'Item transaksi wajib berupa array.' using errcode = '22023';
  end if;

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
