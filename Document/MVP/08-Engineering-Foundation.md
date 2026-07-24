<!--
@file 08-Engineering-Foundation.md
@version 0.3.0
@description Struktur, konvensi, dan status verifikasi Phase 2 Parissa POS.
-->

# 08 — Engineering Foundation

**Tanggal:** 23 Juli 2026

**Versi:** Parissa-MVP `v0.4.0`

**Status:** Phase 2 selesai; Gate C disetujui Owner pada 23 Juli 2026.

## Tujuan

Menyediakan fondasi aplikasi yang buildable, typed, dapat diuji, dan memiliki boundary database aman sebelum fitur Core POS dimulai.

## Struktur Utama

- `src/app/`: App Router, root provider, theme, dan halaman status foundation.
- `src/components/ui/`: source component shadcn/ui yang dimiliki repository.
- `src/lib/domain/`: schema Zod dan formula finansial tunggal.
- `src/lib/query/`: konvensi TanStack Query.
- `src/lib/supabase/`: factory browser/server client.
- `src/types/database.generated.ts`: tipe yang dihasilkan dari schema Supabase lokal tervalidasi.
- `supabase/migrations/`: perubahan schema yang immutable setelah diterapkan.
- `supabase/seed.sql`: role tetap dan data produk development.
- `supabase/tests/database/`: pgTAP untuk RLS.
- `tests/e2e/`: smoke test Playwright lintas viewport.

## Boundary Data

Enam tabel minimum:

1. `roles`
2. `users`
3. `products`
4. `transactions`
5. `transaction_items`
6. `audit_logs`

Client tidak menerima grant insert/update langsung untuk transaksi, item, atau audit. Mutation dilakukan melalui:

- `create_transaction`: atomik, menghitung snapshot/total di database, dan mengunci idempotency key.
- `set_transaction_payment_status`: mencatat `paid_at`/`paid_by`; mark-as-unpaid hanya Owner.
- `void_transaction`: Owner-only, alasan wajib, dan idempotent saat transaksi sudah void.

Tidak ada policy `DELETE` untuk transaksi atau item.

## Konvensi Aplikasi

- Server Component untuk data awal/noninteraktif.
- TanStack Query untuk query interaktif dan mutation.
- Query Supabase tidak diletakkan langsung di page atau component.
- Semua input eksternal divalidasi dengan Zod dan constraint database.
- Formula finansial berada di `src/lib/domain/transaction.ts`.
- Komponen UI memakai token semantik shadcn; raw brand color hanya didefinisikan pada `globals.css`.
- Dark mode, inventory, dan fitur di luar P0 tidak ditambahkan.

## Command

```bash
npm run lint
npm run type-check
npm run test:run
npm run build
npm run test:e2e
```

Untuk database lokal:

```bash
npm run supabase:start
npm run db:reset
npm run db:lint
npm run db:test
```

## Hasil Verifikasi

- ESLint: lulus.
- TypeScript strict: lulus.
- Unit test: 10/10 lulus.
- Production build: lulus.
- Playwright: 4/4 lulus pada 360/768/1280/1920px.
- Horizontal overflow: tidak ditemukan.
- Runtime lokal: OrbStack 2.2.1 dengan Docker engine 29.4.0 tersedia.
- Database reset: lulus dengan dua migration dan seed HPP resmi.
- Database lint: lulus tanpa schema error.
- pgTAP: 23/23 lulus, terdiri dari 5 RLS test dan 18 integration test transaksi.
- Database types: dihasilkan ulang dari schema lokal dan digunakan oleh Supabase client.
- HPP seed: enam nilai Airtable terverifikasi langsung pada tabel `products`.

## Hasil Gate C

1. HPP resmi keenam produk telah dikonfirmasi menggunakan Airtable Parissa (nilai disimpan di sistem internal, tidak dipublikasikan di repository publik).
2. OrbStack dan Docker engine tersedia untuk menjalankan Supabase lokal.
3. Database reset, lint, pgTAP, dan generate database types telah lulus.
4. Guard input `items = null` ditambahkan melalui migration korektif.
5. Schema, RLS, seed, snapshot HPP, idempotensi, payment mutation, void, dan audit telah diverifikasi.

Owner menyetujui Gate C pada 23 Juli 2026. Foundation menjadi baseline stabil `v0.4.0` dan Phase 3 — Core POS boleh dimulai.
