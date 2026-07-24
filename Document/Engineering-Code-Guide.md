<!--
@file Engineering-Code-Guide.md
@version 0.1.1
@description Panduan arsitektur dan handoff engineering untuk developer/AI berikutnya di Parissa POS MVP.
-->

# Engineering Code Guide — Parissa POS MVP

**Fase aktif saat penulisan:** Phase 3 — Core POS (baru dimulai). Phase 2 — Engineering Foundation selesai dan disetujui melalui Gate C pada 23 Juli 2026.

Dokumen ini melengkapi `AGENTS.md` dan `Document/MVP/08-Engineering-Foundation.md`, bukan menggantikannya. Jika ada perbedaan mengenai scope, formula, atau keputusan bisnis, `AGENTS.md` dan dokumen `Document/MVP/*` tetap menjadi source of truth. Referensi di sini memakai path dan nama fungsi/modul, bukan nomor baris, karena isi file akan terus berubah seiring Phase 3 berjalan.

## 1. Arsitektur Aplikasi & Batas Layer

Aplikasi mengikuti rantai layer searah berikut, dari sumber data ke tampilan:

```
App Router (Server Component, data awal/noninteraktif)
        │
        ▼
TanStack Query (server state interaktif & mutation, sisi client)
        │
        ▼
Domain module — src/lib/domain/ (schema Zod + formula finansial tunggal)
        │
        ▼
Supabase client — src/lib/supabase/ (browser vs server, hanya factory)
        │
        ▼
RPC / database (Supabase Postgres): RLS + function security definer
```

- **Server Component** dipakai untuk data awal/noninteraktif (mis. render pertama sebuah halaman). **TanStack Query** dipakai untuk server state interaktif dan mutation di sisi client (cart, submit transaksi, mark-as-paid), dengan konvensi default di `src/lib/query/query-client.ts`.
- **Domain module** (`src/lib/domain/`) adalah satu-satunya tempat schema validasi Zod dan formula bisnis (lihat `calculateTransactionFinancials` di `src/lib/domain/transaction.ts`). Layer di atasnya (UI/komponen) tidak boleh menghitung ulang formula finansial sendiri.
- **Supabase client** dipisah menjadi `src/lib/supabase/browser.ts` (Client Component) dan `src/lib/supabase/server.ts` (Server Component/Route Handler), karena akses cookie (`next/headers`) hanya tersedia di server dan client server harus dibuat ulang per request agar sesi user yang terbawa benar.
- **RPC/database** adalah lapisan otorisasi dan integritas data yang sebenarnya: RLS default-deny plus function `security definer` (`create_transaction`, `set_transaction_payment_status`, `void_transaction`) yang menjalankan validasi bisnis, penghitungan snapshot/total, dan penulisan audit log secara atomik di dalam database — bukan sekadar dipercaya dari input client.

**Aturan tegas dari `AGENTS.md`:** jangan menyebarkan query Supabase langsung di page/component. Gunakan query/data-access layer sebagai perantara (mis. hook TanStack Query yang memanggil factory client dari `src/lib/supabase/`), sehingga akses data tetap terpusat, typed melalui `Database` (`src/types/database.generated.ts`), dan mudah diaudit.

Formula bisnis harus berada di domain module tunggal dan dipakai bersama oleh test fixture frontend/backend — bukan didefinisikan ulang di komponen UI, hook, maupun query dashboard.

## 2. Fungsi Folder & Entry Point

| Path | Fungsi |
|---|---|
| `src/app/` | App Router: `layout.tsx` (root layout, memasang `AppProviders` sekali), `providers.tsx` (`AppProviders`, provider TanStack Query), `page.tsx` (entry point root — saat ini masih halaman status foundation Gate C, akan digantikan entry point Core POS sesuai `05-POS-Flow.md`), `globals.css` (token visual/tema). |
| `src/components/ui/` | Primitive shadcn/ui (`base-nova`, berbasis Base UI): `alert.tsx`, `badge.tsx`, `button.tsx`, `card.tsx`, `separator.tsx`, `skeleton.tsx`. Belum ada komponen POS spesifik (product grid, cart, dsb.) — masih fondasi murni menjelang Phase 3. |
| `src/lib/domain/` | Schema Zod dan formula bisnis: `product.ts` (`productInputSchema`), `transaction.ts` (`paymentStatusSchema`, `transactionItemInputSchema`, `createTransactionInputSchema`, `calculateTransactionFinancials`), plus `transaction.test.ts`. |
| `src/lib/errors/` | `app-error.ts` — kelas `AppError` dan union tertutup `AppErrorCode` untuk error yang aman ditampilkan ke user. |
| `src/lib/query/` | `query-client.ts` — factory `createQueryClient` dengan default TanStack Query (staleTime, retry, refetchOnWindowFocus) yang dikaitkan konteks POS. |
| `src/lib/supabase/` | `browser.ts` (`createSupabaseBrowserClient`) dan `server.ts` (`createSupabaseServerClient`) — factory client per lingkungan eksekusi. |
| `src/lib/env.ts` (+ `env.test.ts`) | `parsePublicEnvironment` — validasi Zod untuk env var `NEXT_PUBLIC_*` saja; secret server-only sengaja di luar schema ini. |
| `src/types/database.generated.ts` | Tipe `Database` hasil `supabase gen types --local`, dipakai runtime oleh `browser.ts`/`server.ts`. Regenerasi via `npm run types:db`; tidak diedit manual. Satu-satunya sumber type database di repo ini — `src/types/database.ts` (referensi manual yang tidak terpakai) sudah dihapus pada `0.4.3` untuk menghindari sumber kebenaran ganda. |
| `supabase/migrations/` | Perubahan schema immutable setelah diterapkan: `20260723000100_initial_mvp_foundation.sql` (schema enam tabel, RLS, RPC awal) dan `20260723000200_harden_create_transaction.sql` (migration korektif guard null, lihat bagian 5). |
| `supabase/seed.sql` | Role tetap (Owner/Kasir) dan enam produk development dengan HPP Airtable; `on conflict do update` agar idempotent untuk `db:reset` berulang. |
| `supabase/tests/database/` | pgTAP: `rls.test.sql` (5 test RLS Owner/Kasir/anonymous/inactive user) dan `transactions.test.sql` (18 test integration RPC transaksi). |
| `tests/e2e/` | `foundation.spec.ts` — smoke test Playwright untuk halaman status Phase 2 (bukan flow POS Phase 3); akan digantikan/ditambah saat fitur Core POS dibangun. |
| `.github/workflows/ci.yml` | Job `quality` (format, lint, type-check, unit test, build) dan job `e2e` (`needs: quality`, Playwright). Lihat bagian 7 untuk gap `db:lint`/`db:test`. |

## 3. Alur Authentication & Permission

- Role P0 tetap dua: `owner` dan `cashier` (tabel `roles`, kolom `code`). Tidak ada flexible role editor pada MVP — ini keputusan Gate A/scope, bukan keterbatasan teknis sementara.
- `users.id` adalah **user id Supabase Auth** itu sendiri (uuid PK/FK ke `auth.users`), bukan id independen. Setiap baris `users` juga menyimpan `role_id` (FK ke `roles`) dan `is_active`.
- **Inactive-user guard**: user dengan `is_active = false` tidak boleh mengakses aplikasi meski kredensial valid. Guard ini ditegakkan di dua tempat sekaligus — level RLS (helper `current_user_is_active()` di migration `20260723000100`) dan level RPC (`transactions.test.sql` mencantumkan test guard inactive-user langsung di RPC, bukan hanya di select tabel seperti `rls.test.sql`).
- **RLS per role**: policy dasar seperti `products_select_active_user`, `products_insert_owner`, `products_update_owner`, `transactions_select_active_user`, `transaction_items_select_active_user`, dan `audit_logs_select_owner` didefinisikan di migration `20260723000100_initial_mvp_foundation.sql`. Helper `current_user_role()` dan `current_user_is_owner()` dipakai policy untuk membedakan hak akses Owner vs Kasir. Tidak ada policy `DELETE` untuk `transactions`/`transaction_items` — konsisten dengan aturan "tidak ada hard delete".
- Ketiga helper (`current_user_is_active`, `current_user_role`, `current_user_is_owner`) dan RPC mutation dideklarasikan `security definer` + `set search_path = ''`. Kombinasi ini wajib untuk fungsi security definer di Postgres: `search_path` kosong mencegah search-path hijacking (skema/tabel palsu disisipkan lewat search_path), sementara `security definer` sendiri diperlukan supaya helper role-check dan RPC mutation bisa membaca tabel `roles`/`users` tanpa memicu rekursi RLS pada tabel yang sama.
- Kasir tidak dapat mengakses product mutation (`products_insert_owner`/`products_update_owner` Owner-only) atau void (`void_transaction` Owner-only, lihat bagian 4).

## 4. Alur Produk & Transaksi: UI → RPC/Database

Rantai untuk P0 (per `05-POS-Flow.md` dan Business Rules):

1. **UI (Phase 3, sedang dibangun)** — quick-sale grid, cart, pemilihan status pembayaran (`Sudah`/`Belum` tanpa default), field pelanggan kondisional. Saat ini `src/app/page.tsx` masih halaman status Gate C sebagai placeholder; komponen POS nyata belum ada di `src/components/`.
2. **Validasi client** — sebelum memanggil RPC, input divalidasi dengan `createTransactionInputSchema` (`src/lib/domain/transaction.ts`): item minimal satu, quantity integer positif, `idempotencyKey` (uuid) dibuat di client, `customerName` wajib jika `paymentStatus === "Belum"` (lewat `superRefine` karena aturannya bergantung pada field lain). Perlu ditegaskan: `transactionItemInputSchema` hanya menerima `productId` dan `quantity` — harga/HPP **tidak** dikirim dari client sama sekali.
3. **RPC `create_transaction`** (migration `20260723000100`, di-wrap ulang oleh migration `20260723000200`) — menjalankan dalam satu transaksi database:
   - Guard eksplisit `is null`/`is not null` pada parameter (ditambahkan migration `200`, lihat bagian 5).
   - Advisory lock (`pg_advisory_xact_lock`) berbasis idempotency key untuk mencegah proses ganda pada request yang sama.
   - Lock produk `FOR SHARE` saat menghitung total, mencegah race condition perubahan harga produk di tengah transaksi berjalan.
   - Snapshot `product_name_snapshot`, `unit_price_snapshot`, `unit_cost_snapshot` diambil ulang dari tabel `products` saat itu juga (bukan dari input client).
   - Total (`total_amount`, `total_cost`) dihitung di database dari SUM snapshot item.
   - Insert header `transactions` + seluruh `transaction_items` atomik, plus penulisan `audit_logs` (action `create`).
4. **Tabel hasil** — `transactions` (header) dan `transaction_items` (baris snapshot per produk).

Aturan "total dari client tidak dipercaya" ditegakkan dua lapis: Zod tidak menerima field total/harga dari client, dan RPC menghitung ulang dari snapshot produk di database.

## 5. HPP Snapshot, Pembayaran, Piutang, Void, Audit

- **HPP snapshot**: `unit_price_snapshot`/`unit_cost_snapshot` di `transaction_items` disalin dari `products.selling_price`/`products.standard_cost` saat transaksi dibuat. Jika harga/HPP produk berubah setelahnya, histori transaksi lama **tidak berubah** — hanya `standardCost` di `src/lib/domain/product.ts` (HPP standar produk saat ini) yang berubah, bukan snapshot transaksi lama.
- **Status pembayaran**: hanya dua nilai tersimpan di kolom `payment_status` — `Sudah` dan `Belum` (`paymentStatusSchema` di `src/lib/domain/transaction.ts`). `Overdue` **bukan** nilai kolom; ia adalah status turunan untuk transaksi `Belum` yang berumur lebih dari tiga hari (dihitung saat query/tampilan, bukan disimpan).
- **`paid_at`/`paid_by`** adalah basis pengakuan finansial, dalam timezone `Asia/Jakarta`:
  - Transaksi yang langsung dibuat `Sudah` mengisi `paid_at`/`paid_by` saat `create_transaction` berhasil.
  - Perubahan `Belum` → `Sudah` melalui RPC `set_transaction_payment_status` mencatat `paid_at`/`paid_by` pada saat itu.
  - Perubahan `Sudah` → `Belum` (mark-as-unpaid) **Owner-only**: membersihkan `paid_at`/`paid_by`, mengoreksi agregat pada tanggal pembayaran sebelumnya, dan wajib tercatat di `audit_logs`.
- **Piutang** = himpunan transaksi aktif (`is_void = false`) berstatus `Belum`. `calculateTransactionFinancials` (`src/lib/domain/transaction.ts`) mengembalikan `revenue=0, cost=0, grossProfit=0, receivable=totalAmount` untuk kasus ini — piutang tidak diakui sebagai omzet sampai berubah status jadi `Sudah`.
- **Void**: hanya Owner (`void_transaction`, Owner-only via RLS/helper `current_user_is_owner`), alasan (`void_reason`) wajib non-kosong, mencatat `voided_at`/`voided_by`, dan idempotent (memanggil void pada transaksi yang sudah void tidak error/duplikat efek). Transaksi void dikeluarkan dari seluruh agregat finansial, jumlah transaksi aktif, dan piutang — `calculateTransactionFinancials` mengecek `isVoid` **lebih dulu** sebelum status pembayaran, sehingga void selalu menang atas status apa pun.
- **Audit log** (`audit_logs`): mencatat empat aksi — `create`, `mark_paid`, `mark_unpaid`, `void` — dengan `actor_id` dan timestamp. Tidak ada hard delete transaksi/item pada skema (tidak ada policy `DELETE`).
- Migration korektif `20260723000200_harden_create_transaction.sql`: bug pada migration awal — operator seperti `not in (...)` dan `<>` di SQL/PL-pgSQL menghasilkan `NULL` (bukan `TRUE`) ketika salah satu operand `NULL`, sehingga guard `if <kondisi> then raise exception` diam-diam tidak pernah terpicu untuk payload `items = null`. Perbaikan: fungsi lama di-rename jadi `create_transaction_internal` (private, tanpa grant execute), dan fungsi publik baru `create_transaction` menambahkan guard eksplisit `is null`/`is not null` sebelum memanggil logic lama apa adanya. Migration lama (`100`) tidak diedit — sesuai konvensi immutable migration di `AGENTS.md`.

## 6. Validation, Error, Loading, Empty State, Retry, Idempotency

- **Validation**: Zod di boundary input (`src/lib/domain/product.ts`, `src/lib/domain/transaction.ts`) sebagai lapis pertama, ditegakkan kembali oleh constraint database (kolom `not null`, check constraint pasangan `paid_at`/`paid_by`, kelengkapan field void saat `is_void`, dsb. di migration `20260723000100`) sebagai lapis kedua yang tidak bisa dilewati meski client di-bypass.
- **Error**: konvensi `AppError`/`AppErrorCode` (`src/lib/errors/app-error.ts`). `AppError.message` diasumsikan **aman ditampilkan ke user** dalam Bahasa Indonesia; detail teknis/sensitif (mis. pesan mentah dari Supabase/Postgres) harus dipetakan ke salah satu `AppErrorCode` (`AUTH_REQUIRED`, `FORBIDDEN`, `VALIDATION_ERROR`, `CONFLICT`, `NOT_FOUND`, `UNEXPECTED`) sebelum dilempar, bukan diteruskan mentah.
- **Loading state**: `src/components/ui/skeleton.tsx` — memenuhi syarat wajib "setiap halaman data memiliki loading, error, dan empty state yang berbeda" dari `AGENTS.md`. Implementasi konkret per halaman POS (skeleton grid saat produk dimuat, dsb.) menjadi bagian pekerjaan Phase 3, mengikuti daftar state di `05-POS-Flow.md` (Loading, Ready/Empty cart, Cart active, Validation error, Submitting, Success, Server error, No products).
- **Retry & idempotency**: `mutations.retry: 0` di `createQueryClient` (`src/lib/query/query-client.ts`) sengaja menonaktifkan retry otomatis TanStack Query untuk mutation, karena mutation di sini menyentuh transaksi/pembayaran/void — retry otomatis tanpa idempotency key eksplisit berisiko menduplikasi side effect. Pencegahan double-submit yang sebenarnya berlapis dua: `idempotencyKey` client-generated (unik per percobaan submit, tetap sama saat retry manual dari cart yang dipertahankan) divalidasi di `createTransactionInputSchema`, lalu ditegakkan ulang di database lewat kolom `idempotency_key unique` plus advisory lock di RPC `create_transaction`.

## 7. Peta Test & Command Verifikasi

| Jenis test | File | Cakupan |
|---|---|---|
| Unit test (aplikasi) | `src/lib/domain/transaction.test.ts` | Formula `calculateTransactionFinancials` dan schema `createTransactionInputSchema`. |
| Unit test (env) | `src/lib/env.test.ts` | `parsePublicEnvironment` — validasi env var publik. |
| pgTAP — RLS | `supabase/tests/database/rls.test.sql` | 5 test: akses Owner, Kasir, anonymous, inactive user pada tabel `roles`/`products`. |
| pgTAP — transaksi | `supabase/tests/database/transactions.test.sql` | 18 test: guard HPP seed, guard null (migration `200`), wajib nama piutang, total dihitung server, snapshot HPP tidak berubah walau harga produk berubah, idempotensi double-submit, Owner-only mark-unpaid/void, kelengkapan audit log, guard inactive-user di level RPC. |
| E2E | `tests/e2e/foundation.spec.ts` | Smoke test halaman status Phase 2 (bukan flow POS Phase 3). |
| CI | `.github/workflows/ci.yml` | Job `quality` (format, lint, type-check, unit test, build) → job `e2e` dan job `database` berjalan paralel (keduanya `needs: quality`). Job `database` menjalankan `supabase:start` → `db:reset` → `db:lint` → `db:test` → `supabase:stop` (`if: always()`), memakai CLI Supabase dari devDependency `supabase` (tidak perlu setup action terpisah) dan Docker bawaan runner GitHub-hosted. |

Command verifikasi:

```bash
npm run lint
npm run type-check
npm run test:run
npm run build
npm run test:e2e
```

Database lokal (dan di CI job `database`):

```bash
npm run supabase:start
npm run db:reset
npm run db:lint
npm run db:test
```

CI sudah menjalankan seluruh command di atas secara otomatis pada tiap PR/push ke `main` sejak `0.4.3`, menutup gap Quality Gate "RLS test untuk Owner, Kasir, anonymous, dan inactive user" di `AGENTS.md`.

## 8. Panduan Menelusuri Satu Transaksi End-to-End

Contoh naratif satu transaksi umum, mengikuti `05-POS-Flow.md` dan rantai layer di bagian 1:

1. Kasir memilih produk di quick-sale grid, menambah ke cart (quantity via stepper atau input langsung, hanya integer positif mulai dari 1).
2. Kasir mengisi status pembayaran (`Sudah` atau `Belum`, wajib eksplisit — tidak ada default) dan nama pelanggan (wajib hanya jika `Belum`).
3. Kasir menekan submit. Client membangun payload sesuai `createTransactionInputSchema` (`src/lib/domain/transaction.ts`) — item berisi `productId` + `quantity` saja (harga/HPP tidak dikirim), plus `idempotencyKey` yang dibuat di client sekali per percobaan submit.
4. Payload tervalidasi dikirim ke RPC `create_transaction` (Supabase, via client dari `src/lib/supabase/browser.ts`).
5. Di database: RPC mengunci idempotency key (advisory lock) untuk mencegah proses ganda saat double-click atau retry; mengunci baris produk terkait `FOR SHARE`; mengambil ulang harga/HPP produk sebagai snapshot; menghitung `total_amount`/`total_cost` dari SUM snapshot item; insert header `transactions` dan seluruh `transaction_items` dalam satu transaksi atomik; menulis `audit_logs` (action `create`).
6. Jika status `Sudah`: RPC langsung mengisi `paid_at`/`paid_by` pada transaksi yang sama. Jika status `Belum`: transaksi masuk sebagai piutang aktif — `calculateTransactionFinancials` mengembalikan `revenue=0`/`cost=0`/`grossProfit=0`, dan `receivable = total_amount` sampai kelak dilunasi lewat `set_transaction_payment_status`.
7. Client menerima response RPC (header transaksi + nomor transaksi) dan menampilkan confirmation state (nomor, total, status).
8. Dashboard mengagregasi omzet/HPP/gross profit berdasarkan tanggal `paid_at` (`Asia/Jakarta`) pada transaksi aktif berstatus `Sudah` — bukan tanggal `business_date` saat transaksi dibuat. Jika piutang baru dilunasi di kemudian hari, nilainya masuk agregat pada tanggal pelunasan tersebut, bukan tanggal transaksi awal.

Skenario kegagalan yang harus tetap konsisten dengan alur di atas (lihat `05-POS-Flow.md` bagian Failure Scenarios): produk dinonaktifkan setelah masuk cart, harga berubah sebelum submit (di-guard oleh `FOR SHARE` lock dan snapshot ulang saat RPC berjalan), koneksi putus saat submit, submit dua kali (di-guard oleh idempotency key + advisory lock), session expired, dan RPC berhasil tetapi response client terputus (idempotency key memungkinkan retry aman tanpa duplikasi).

## 9. Status & Keterbatasan Dokumen

Dokumen ini mencerminkan kondisi kode pada saat penulisan: Phase 3 — Core POS baru dimulai, dan sebagian besar `src/app/`, `src/components/` masih fondasi Phase 2 (halaman status Gate C, primitive shadcn/ui dasar) — belum ada implementasi quick-sale grid, cart, atau halaman transaksi/piutang/void/dashboard yang nyata. Bagian 4 dan 8 di atas menjelaskan alur yang **akan** terjadi begitu UI Phase 3 dibangun, berdasarkan kontrak RPC/database yang sudah ada dan disetujui (Gate C), bukan implementasi UI yang sudah berjalan.

Dokumen ini perlu diperbarui setiap kali fitur Core POS bertambah signifikan (mis. quick-sale grid, cart, halaman riwayat/piutang/void, dashboard) agar bagian 2, 4, dan 8 tetap mencerminkan struktur folder dan alur nyata, bukan hanya kontrak yang direncanakan.

Dua pertanyaan terbuka dari audit sebelumnya sudah diputuskan Owner pada `0.4.3`:

1. **`src/types/database.ts`** (tidak dipakai runtime) — **dihapus**. `src/types/database.generated.ts` menjadi satu-satunya sumber type database.
2. **Gap CI database test** — **ditutup**. Job `database` ditambahkan ke `.github/workflows/ci.yml` (lihat bagian 7), menjalankan `db:reset`/`db:lint`/`db:test` otomatis pada tiap PR/push ke `main`.
