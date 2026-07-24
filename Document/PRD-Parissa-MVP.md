<!--
@file PRD-Parissa-MVP.md
@version 1.1.3
@description PRD ringkas untuk pembangunan ulang MVP Parissa POS.
-->

# PRD: Parissa POS — MVP Pencatatan Penjualan

| Field | Value |
|-------|-------|
| **PRD Version** | v3.1 |
| **Last Updated** | 23 Juli 2026 |
| **Author** | Rico (Owner) |
| **Status** | Approved — Gate A (22 Juli 2026) |
| **Fase Aktif** | Phase 3 — Core POS; Gate C disetujui 23 Juli 2026 |
| **Repository Lama** | https://github.com/ricobowo/Parissa.git |
| **Data Source** | Airtable Base “Parissa” + seed data repository lama |
| **Dokumen Sebelumnya** | `Document/PRD-Parissa.md` v2.4 |

---

## Changelog

| Version | Date | Changes |
|---------|------|---------|
| v1.0–v2.4 | 9–27 Apr 2026 | PRD awal, penambahan seluruh modul operasional, dan tiga pivot design direction. |
| v3.0 | 22 Jul 2026 | Reset scope menjadi MVP POS: fokus transaksi cepat, produk, piutang, riwayat/void, dan dashboard ringkas. Menunda stok, batching, CRM, waste, WhatsApp, advanced report, dan role editor. Menetapkan gross margin sebagai definisi margin resmi. |
| v3.1 | 22 Jul 2026 | Menutup Gate A: mengesahkan scope P0, pengakuan omzet/HPP/gross profit berdasarkan `paid_at`, penundaan migrasi transaksi historis, penggunaan placeholder asset yang jujur, dan repository baru dengan history bersih. |

---

## 1. Introduction/Overview

Parissa adalah bisnis dessert dan minuman premium di Bandung. Sistem lama berkembang menjadi suite operasional besar sebelum alur transaksi utamanya diuji bersama pengguna. MVP baru dibangun ulang untuk menjawab satu kebutuhan paling penting: **mencatat penjualan secara cepat dan menghasilkan angka omzet, HPP, profit, serta piutang yang dapat dipercaya**.

### Masalah utama

- Input penjualan harus selesai dalam kurang dari 30 detik.
- Implementasi lama terlalu luas dan belum melewati E2E, UAT, serta responsive QA.
- Definisi margin dan alur stok lama tidak konsisten.
- Tampilan production memiliki hierarchy dan pemanfaatan layar yang buruk.
- Dokumentasi arsitektur tidak sesuai dengan implementasi sebenarnya.

### Solusi MVP

Aplikasi POS web responsif dengan enam kemampuan: login sederhana, katalog produk, transaksi cepat, piutang, riwayat/void, dan dashboard ringkas.

---

## 2. Goals

1. Transaksi lunas dapat dicatat dalam **<30 detik**.
2. Omzet, HPP, gross profit, dan piutang memiliki selisih **<1%** dari perhitungan manual.
3. Owner dapat memahami kondisi hari ini dalam satu layar tanpa dashboard panjang.
4. Kasir dapat menggunakan POS pada ponsel 360px tanpa horizontal scroll.
5. Semua quality gate—lint, type-check, unit test, integration test, dan E2E—lulus sebelum production.
6. Lima pengguna uji dapat menyelesaikan transaksi tanpa bantuan.

### Non-goal produk awal

MVP tidak ditujukan untuk mengelola seluruh produksi, supply chain, CRM, atau otomasi notifikasi.

---

## 3. User Stories

### Owner

- US-001: Melihat omzet, gross profit, transaksi, dan piutang hari ini.
- US-002: Mengelola produk aktif, harga jual, dan HPP standar.
- US-003: Mencari transaksi dan melakukan void dengan alasan.
- US-004: Melihat daftar piutang dan menandainya lunas.
- US-005: Melihat audit minimum untuk transaksi yang diubah atau di-void.

### Kasir

- US-006: Login dan membuka POS langsung.
- US-007: Menambah produk ke keranjang dengan satu tap.
- US-008: Mengubah jumlah dan melihat total secara real-time.
- US-009: Menyimpan transaksi sebagai “Sudah” atau “Belum” dibayar.
- US-010: Menerima konfirmasi yang jelas setelah transaksi tersimpan.

---

## 4. Functional Requirements

### 4.1 Authentication & Access

- FR-001: Login menggunakan email dan password.
- FR-002: Hanya dua role MVP: `Owner` dan `Kasir`.
- FR-003: Role didefinisikan di kode/migration; tidak ada role editor pada MVP.
- FR-004: Owner memiliki semua akses MVP; Kasir memiliki POS, riwayat terbatas, dan update pembayaran.
- FR-005: User tidak aktif tidak dapat login.

### 4.2 Product Catalog

- FR-006: Produk memiliki nama, kategori, harga jual, HPP standar, status aktif, dan gambar opsional.
- FR-007: Owner dapat menambah, mengubah, dan menonaktifkan produk.
- FR-008: Produk tidak dihapus permanen jika sudah memiliki transaksi.
- FR-009: Harga dan HPP disalin sebagai snapshot ke item transaksi agar histori tidak berubah saat harga produk diedit.
- FR-010: Bundling direpresentasikan sebagai produk tersendiri pada MVP.

### 4.3 POS / Transaksi

- FR-011: POS menampilkan produk aktif dalam quick-sale grid.
- FR-012: Kasir dapat menambah produk, mengubah qty, dan menghapus item dari keranjang.
- FR-013: Tanggal default hari ini dan dapat diubah sesuai permission.
- FR-014: Status pembayaran wajib: `Sudah` atau `Belum`.
- FR-015: Nama pelanggan opsional untuk transaksi `Sudah`, tetapi wajib untuk transaksi `Belum`.
- FR-016: Nomor telepon dan catatan bersifat opsional.
- FR-017: Total transaksi dihitung dari jumlah `qty × unit_price_snapshot`.
- FR-018: Submit menyimpan header transaksi dan semua item secara atomik.
- FR-019: Setelah berhasil, tampilkan nomor transaksi, total, dan status pembayaran.
- FR-020: Double-submit harus dicegah.

### 4.4 Payment & Receivables

- FR-021: Transaksi `Belum` tampil di daftar piutang.
- FR-022: Owner/Kasir dapat mengubah `Belum` menjadi `Sudah` dengan `paid_at` dan `paid_by`; transaksi yang dibuat langsung lunas juga mengisi kedua field tersebut.
- FR-023: Piutang lebih dari tiga hari diberi status turunan `Overdue`.
- FR-024: Transaksi void tidak dihitung sebagai omzet atau piutang aktif.

### 4.5 History & Void

- FR-025: Riwayat dapat dicari berdasarkan nomor transaksi atau nama pelanggan.
- FR-026: Filter minimum: tanggal dan status pembayaran.
- FR-027: Transaksi tidak boleh hard delete.
- FR-028: Void wajib memiliki alasan, waktu, dan user pelaksana.
- FR-029: Void hanya dapat dilakukan Owner.
- FR-030: Audit minimum dicatat untuk create, payment update, dan void.

### 4.6 Dashboard

- FR-031: Dashboard menampilkan empat metrik: omzet lunas dan gross profit yang diakui hari ini berdasarkan `paid_at`, jumlah transaksi aktif hari ini, dan total piutang aktif saat ini.
- FR-032: Dashboard menampilkan maksimal satu daftar ringkas: lima transaksi terbaru.
- FR-033: Dashboard memiliki CTA utama “Transaksi Baru”.
- FR-034: Tidak ada chart pada milestone pertama; chart hanya ditambahkan jika terbukti membantu keputusan pengguna.
- FR-035: Empty, loading, dan error state wajib tersedia.

---

## 5. Formulas & Calculation Logic

### 5.1 Total item dan transaksi

```text
item_subtotal = unit_price_snapshot × quantity
transaction_total = SUM(item_subtotal)
```

### 5.2 HPP dan gross profit

```text
item_cost = unit_cost_snapshot × quantity
transaction_cost = SUM(item_cost)

IF payment_status == "Sudah" AND is_void == false:
    recognized_revenue = transaction_total
    recognized_cost = transaction_cost
    gross_profit = recognized_revenue - recognized_cost
ELSE IF payment_status == "Belum" AND is_void == false:
    recognized_revenue = 0
    recognized_cost = 0
    gross_profit = 0
ELSE:
    recognized_revenue = 0
    recognized_cost = 0
    gross_profit = 0
```

Tanggal pengakuan omzet, HPP, dan gross profit adalah tanggal `paid_at` dalam timezone `Asia/Jakarta`. Transaksi yang langsung lunas mengisi `paid_at` saat dibuat. Pelunasan piutang di kemudian hari diakui pada tanggal pembayaran, bukan tanggal transaksi awal.

Jika Owner mengubah transaksi lunas menjadi belum lunas, `paid_at` dan `paid_by` dibersihkan, nilai transaksi dikeluarkan dari agregat tanggal pembayaran sebelumnya, dan perubahan dicatat di audit log. Transaksi void selalu dikeluarkan dari seluruh agregat finansial dan piutang.

### 5.3 Definisi margin resmi

Istilah **margin** berarti gross margin terhadap harga jual:

```text
gross_margin_pct = ((selling_price - cost_per_unit) / selling_price) × 100
```

Istilah **markup** dipisahkan:

```text
markup_pct = ((selling_price - cost_per_unit) / cost_per_unit) × 100
```

Pricing calculator—jika ditambahkan setelah MVP—menggunakan gross margin:

```text
minimum_selling_price = cost_per_unit / (1 - target_gross_margin_pct / 100)
```

### 5.4 Format mata uang

- Penyimpanan: numeric Rupiah tanpa simbol.
- Tampilan: `Rp 1.000.000`.
- Tidak menampilkan desimal untuk nilai Rupiah.

---

## 6. Non-Goals (Out of Scope MVP)

- Resep/BOM editor dan pricing calculator.
- Bahan baku, restock, supplier, batching, expiry, dan finished-goods inventory.
- Production planner dan forecasting.
- CRM, label VIP, customer analytics, dan follow-up history kompleks.
- Waste/spoilage tracking.
- WhatsApp/Fonnte.
- Export Excel dan advanced reporting.
- Flexible role management UI.
- Bilingual UI; MVP menggunakan Bahasa Indonesia.
- PWA offline, dark mode, density controls, dan theme presets.
- Marketplace, payment gateway, QRIS, loyalty, multi-outlet, barcode, dan native app.

---

## 7. Design Considerations — “Focused Commerce”

### 7.1 Prinsip

- Light mode terlebih dahulu; dark mode bukan acceptance criterion MVP.
- Satu primary action per layar.
- Mobile-first 360px, lalu 768px dan 1280px+.
- Desktop memakai ruang tersedia secara proporsional; hindari content canvas 1.040px pada viewport lebar.
- Maksimal empat metrik pada dashboard.
- Sans-serif yang mudah dibaca; angka tabular hanya untuk nilai finansial.
- Warna brand dipakai untuk aksi, warna semantic untuk status.
- Tidak ada gradient dekoratif, dev tweaks, atau chart tanpa kebutuhan pengguna.
- Semua komponen interaktif memakai shadcn/ui dan token desain.

### 7.2 Prioritas layar

1. POS.
2. Konfirmasi transaksi.
3. Riwayat dan piutang.
4. Dashboard.
5. Produk.

### 7.3 Brand asset yang dibutuhkan

- Logo Parissa versi SVG/PNG.
- Foto keenam produk dengan rasio dan pencahayaan konsisten.
- Warna brand final.

Jika aset belum tersedia, gunakan placeholder jujur; jangan membuat kartu gradient generik sebagai pengganti foto produk.

---

## 8. Technical Considerations

### 8.1 Stack

- Next.js App Router + TypeScript strict.
- Tailwind CSS + shadcn/ui.
- Supabase PostgreSQL + Auth + RLS.
- TanStack Query untuk client-side server state.
- Zod untuk seluruh form dan boundary input.
- Vitest/Jest untuk unit test dan Playwright untuk E2E.
- Vercel untuk preview dan production.

### 8.2 Data model minimum

- `roles`
- `users`
- `products`
- `transactions`
- `transaction_items`
- `audit_logs`

Detail terdapat di `Document/MVP/04-Data-Model.md`.

### 8.3 Arsitektur

- Server Components untuk initial page/data yang tidak interaktif.
- TanStack Query untuk data interaktif, mutation, cache invalidation, dan retry policy.
- Tidak melakukan direct Supabase query tersebar di page component.
- Business formula berada di satu domain module dan digunakan frontend maupun backend test fixture.
- Database mutation transaksi menggunakan function/RPC atomik.

### 8.4 Quality gates

- `lint`, `type-check`, `unit`, `integration`, `e2e`, dan `build` wajib lulus.
- Tidak ada ignored TypeScript error.
- Tidak ada secret atau data pribadi di repository.
- RLS diuji minimal untuk Owner, Kasir, anonymous, dan inactive user.

---

## 9. Diagrams

- POS flow terbaru: `Document/MVP/05-POS-Flow.md`.
- ERD MVP: `Document/MVP/04-Data-Model.md`.
- Diagram lama di `Document/` dipertahankan sebagai referensi historis, bukan source of truth MVP.

---

## 10. Development Timeline & Phases

| Phase | Estimasi | Outcome |
|-------|----------|---------|
| 0 — Definition | Selesai | PRD v3.1, formula, scope, strategi data, dan asset fallback disetujui. |
| 1 — UX Prototype | 3–4 hari | POS mobile + desktop tervalidasi sebelum coding. |
| 2 — Foundation | 3–4 hari | Repo baru, auth, schema, design tokens, CI. |
| 3 — Core POS | 5–7 hari | Produk, cart, transaksi atomik, konfirmasi. |
| 4 — History & Dashboard | 4–5 hari | Piutang, void, audit, dashboard empat metrik. |
| 5 — Validation | 4–5 hari | E2E, device QA, UAT, performance, production. |
| 6 — Post-MVP | Setelah 2 minggu | Evaluasi penggunaan, rekonsiliasi dan migrasi historis terpisah, serta prioritas backlog. |

Target: MVP tervalidasi dalam sekitar 4 minggu, bukan berdasarkan banyaknya halaman tetapi berdasarkan acceptance criteria.

---

## 11. Working Rules (WAJIB)

### RULE 1 — EXPLAIN BEFORE DOING

Sebelum edit file: sebutkan nama file, bagian, dan alasan. Tunggu konfirmasi. Jika Rico mengatakan “lanjutkan”, “kerjakan”, atau “sudah dikonfirmasi”, konfirmasi tambahan tidak diperlukan untuk sesi itu.

### RULE 2 — COMMAND TRANSPARENCY

Setiap terminal command dilaporkan dengan format:

```text
COMMAND RUNNING: $ <command>
WHAT IT DOES:    <penjelasan>
RESULT:          ✅/❌ <hasil>
```

### RULE 3 — SESSION SUMMARY

Setiap sesi ditutup dengan files changed, added, fixed, removed, current version, dan next suggested steps.

### RULE 4 — NEVER GIT PUSH

Agent/asisten AI tidak menjalankan `git push`. Gunakan pesan: “Ready to push. Please follow the GitHub upload steps.”

### RULE 5 — ALWAYS UPDATE CHANGELOG

Setiap perubahan terencana memperbarui `CHANGELOG.md` dan `VERSION` sesuai semantic versioning project.

### RULE 6 — VERSION HEADER + KOMENTAR BAHASA INDONESIA

Setiap file baru memiliki header versi. Semua komentar kode menggunakan Bahasa Indonesia.

### RULE 7 — TANYA JIKA AMBIGU

Ambiguitas yang mengubah scope, data, formula, atau perilaku bisnis wajib ditanyakan sebelum coding.

### RULE 8 — MIGRATION WAJIB

Perubahan schema selalu dibuat melalui migration baru; migration yang sudah diterapkan tidak diedit ulang.

### RULE 9 — TRI-STATE UI

Setiap halaman data wajib memiliki loading, error, dan empty state.

### RULE 10 — ALWAYS UPDATE README BEFORE PUSH

README harus sinkron dengan PRD, VERSION, CHANGELOG, progress, dependency, dan struktur folder sebelum siap push.

---

## 12. Success Metrics

| Metric | Target |
|--------|--------|
| Waktu transaksi lunas | Median <30 detik |
| Akurasi omzet/HPP/profit | Selisih <1% vs manual |
| Task completion UAT | 5/5 pengguna tanpa bantuan |
| Mobile usability | Tidak ada horizontal scroll pada 360px |
| Dashboard load | <2 detik pada simulasi 4G |
| Error transaksi | <1% dari submit |
| Quality gates | 100% lulus |
| Piutang teridentifikasi | 100% transaksi `Belum` tampil |

---

## 13. Keputusan Gate A

| # | Keputusan | Status |
|---|------------|--------|
| 1 | Gross margin menjadi definisi margin resmi. | **Disetujui.** |
| 2 | HPP MVP diinput manual per produk dan disimpan sebagai snapshot; BOM ditunda. | **Disetujui.** |
| 3 | Nama pelanggan opsional untuk transaksi lunas dan wajib untuk piutang. | **Disetujui.** |
| 4 | Pre-order tidak masuk P0. | **Disetujui.** |
| 5 | Transaksi historis tidak masuk release awal dan dapat dimigrasikan setelah rekonsiliasi. | **Disetujui.** |
| 6 | Asset yang belum tersedia menggunakan placeholder jujur sampai asset final diterima. | **Disetujui.** |
| 7 | Gunakan repository baru dengan history bersih. | **Disetujui.** |
| 8 | Omzet, HPP, dan gross profit diakui berdasarkan tanggal `paid_at`; piutang dilaporkan terpisah. | **Disetujui.** |

---

## Appendix A — Data Aktual Parissa

### Produk dan normalisasi margin

Margin dinormalisasi menggunakan gross margin terhadap harga jual: `gross_margin_pct = ((price - cost) / price) × 100`, markup: `markup_pct = ((price - cost) / cost) × 100` (lihat `Document/MVP/03-Business-Rules.md` §6). Nilai HPP resmi dan margin/markup aktual per produk bersumber dari Airtable Parissa dan dikonfirmasi Owner pada 23 Juli 2026, disimpan di sistem internal, dan tidak dipublikasikan di repository publik ini untuk menjaga kerahasiaan struktur biaya bisnis. Angka dari PRD v2.4 dinyatakan keliru dan tidak boleh digunakan sebagai source of truth. Database menyimpan presisi dua desimal, sedangkan UI menampilkan Rupiah tanpa desimal.

### Statistik historis

Rekonsiliasi data historis (jumlah transaksi, total unit, revenue, cost, profit, piutang, dan produk terlaris periode sebelumnya) dikelola secara internal dan tidak dipublikasikan di repository publik ini. Lihat catatan rekonsiliasi pasca-MVP di `Document/Project-Restart-Plan.md` untuk konteks proses migrasinya.

### Sumber data yang dipertahankan

- `supabase/migrations/002_seed_data.sql`
- `Document/PRD-Parissa.md` Appendix lama
- `src/lib/i18n/id.json` sebagai referensi copy
- `src/lib/formulas.ts` dan test sebagai referensi historis, bukan source of truth sampai formula diperbaiki

---

## Appendix B — Definition of Done MVP

MVP dinyatakan selesai hanya jika:

1. Semua requirement P0 lulus acceptance test.
2. Lint, type-check, unit, integration, E2E, dan production build lulus.
3. Owner menyelesaikan UAT dan menyetujui rekonsiliasi fixture transaksi MVP.
4. POS lolos pengujian 360px, 768px, dan desktop 1280px+.
5. Tidak ada blocker severity tinggi.
6. Rollback dan backup database telah diuji.
