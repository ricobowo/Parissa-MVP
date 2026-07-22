<!--
@file Project-Restart-Plan.md
@version 1.4.0
@description Rencana pembangunan ulang Parissa POS berdasarkan PRD MVP v3.1.
-->

# Parissa POS — Project Restart Plan

**Baseline:** PRD MVP v3.1

**Tanggal:** 22 Juli 2026

**Status:** Gate A disetujui — Phase 1 aktif

## 1. Strategi Restart

Gunakan **repository baru** agar source, migration, dependency, dan history tidak tercampur dengan eksperimen lama. Repository lama tetap read-only sebagai arsip dan sumber data.

Prinsip utama:

- Restart code, bukan restart domain knowledge.
- Validasi POS sebelum menambah dashboard atau modul operasional.
- Setiap phase memiliki exit criteria yang dapat diuji.
- Tidak memindahkan komponen UI lama secara copy-paste.
- Migration lama dibaca sebagai referensi, bukan dijalankan wholesale.

## 2. Artefak yang Dipindahkan

### Dipindahkan setelah review

- PRD MVP v3.1 dan tujuh dokumen MVP.
- Data produk tervalidasi.
- Copy Bahasa Indonesia yang masih relevan.
- Formula finansial final yang disetujui pada Gate A.
- Test fixture nilai produk dan transaksi.

### Tidak dipindahkan

- UI/component lama.
- Database trigger stok dan batching lama.
- Design prototype lama.
- Task dan changelog eksperimen redesign.
- Sessions/tooling dan terminal transcript.
- Dependency yang tidak dipakai MVP.
- Transaksi historis pada release awal; data tetap disimpan untuk migrasi terpisah setelah rekonsiliasi.

## 3. Phase Plan

### Phase 0 — Product Definition

**Durasi:** 2–3 hari

- [x] Rico menyetujui PRD v3.1 dan scope P0.
- [x] Gross margin ditetapkan sebagai definisi margin resmi.
- [x] HPP manual dengan snapshot dipakai; BOM ditunda.
- [x] Migrasi transaksi historis ditunda sampai pasca-MVP.
- [x] Rekonsiliasi 54 vs 53 transaksi dipindahkan ke Phase 6.
- [x] Placeholder jujur disetujui sampai logo, warna, dan foto produk final tersedia.
- [x] Aturan finansial berdasarkan `paid_at` disetujui.
- [x] Scope P0 dibekukan.

**Exit:** Tercapai pada 22 Juli 2026; seluruh keputusan Gate A tercatat di PRD v3.1.

### Phase 1 — UX Prototype

**Durasi:** 3–4 hari

**Progress 22 Juli 2026:** Flow prototype telah diuji manual Owner dan dinyatakan aman. `design-handoff.md` disiapkan untuk penyempurnaan visual eksternal; Gate B menunggu review visual final dan validasi transaksi <30 detik.

- [x] Buat prototype POS mobile 360px dengan guided checkout.
- [x] Uji manual flow produk → cart → status bayar → submit; Owner menyatakan flow aman.
- [x] Buat varian desktop Speed First tanpa `max-width` sempit.
- [x] Implementasikan validasi prototype nama pelanggan opsional/wajib.
- [ ] Uji skenario lunas, piutang, server error, dan retry.
- [x] Kunci design tokens visual minimum: font/fallback, bobot 400/500/600, surface netral, satu brand accent, dan semantic color terbatas.
- [x] Siapkan handoff terstruktur untuk AI Design/UI designer eksternal.
- [ ] Kunci component inventory minimum setelah hasil uji prototype disetujui.

**Exit:** Rico menyetujui flow; transaksi simulasi selesai <30 detik.

### Phase 2 — Engineering Foundation

**Durasi:** 3–4 hari

- [ ] Scaffold aplikasi pada repository baru yang telah disetujui.
- [ ] Setup Next.js strict, Tailwind, shadcn/ui, Supabase.
- [ ] Setup ESLint, formatter, type-check, test, Playwright, CI.
- [ ] Buat schema enam tabel dan RLS.
- [ ] Seed dua role dan enam produk.
- [ ] Buat conventions untuk query, validation, error, dan version header.

**Exit:** Empty app build dan seluruh quality gate lulus.

### Phase 3 — Core POS

**Durasi:** 5–7 hari

- [ ] Product list dan owner CRUD sederhana.
- [ ] Quick-sale grid.
- [ ] Cart dengan quantity dan total.
- [ ] Zod validation.
- [ ] RPC transaksi atomik.
- [ ] Payment status dan customer conditional requirement.
- [ ] Confirmation screen.
- [ ] Unit dan integration test transaksi.

**Exit:** Happy path, validation failure, DB failure, dan double-submit diuji.

### Phase 4 — History, Receivables, Dashboard

**Durasi:** 4–5 hari

- [ ] Riwayat dan search/filter minimum.
- [ ] Void dengan alasan dan permission Owner.
- [ ] Daftar piutang dan mark-as-paid.
- [ ] Owner-only mark-as-unpaid dengan koreksi agregat dan audit.
- [ ] Audit create/payment/void.
- [ ] Dashboard empat metrik dan lima transaksi terbaru.
- [ ] Reconciliation tests.

**Exit:** Angka dashboard sama dengan fixture manual dan SQL aggregate.

### Phase 5 — Validation & Release

**Durasi:** 4–5 hari

- [ ] Playwright E2E untuk transaksi, piutang, dan void.
- [ ] RLS test Owner/Kasir/anonymous/inactive.
- [ ] QA 360px, 768px, 1280px, dan 1920px.
- [ ] Performance test simulasi 4G.
- [ ] Accessibility keyboard dan contrast check.
- [ ] UAT lima pengguna.
- [ ] Backup, restore, dan rollback drill.
- [ ] Production deploy dan smoke test.

**Exit:** Definition of Done PRD terpenuhi.

### Phase 6 — Pasca-MVP

**Mulai:** Setelah dua minggu penggunaan production

- [ ] Evaluasi metrik penggunaan dan feedback pengguna.
- [ ] Rekonsiliasi transaksi historis beserta HPP dan profit (detail dikelola internal).
- [ ] Siapkan staging, dry-run, validasi total, dan import idempotent sebelum migrasi historis.
- [ ] Prioritaskan pre-order, export, customer directory, lalu BOM/inventory berdasarkan data penggunaan.

**Exit:** Migrasi historis, jika dijalankan, lolos rekonsiliasi dan tidak menghasilkan duplikat; backlog berikutnya memiliki prioritas berbasis bukti.

## 4. Backlog Setelah MVP

Prioritas hanya ditentukan setelah dua minggu penggunaan:

1. Pre-order.
2. Export sederhana.
3. Customer directory ringan.
4. Recipe/BOM.
5. Inventory model yang benar.
6. Batching dan expiry.
7. Waste dan production planner.
8. WhatsApp notification.

## 5. Risiko dan Mitigasi

| Risiko | Dampak | Mitigasi |
|--------|--------|----------|
| Scope kembali membesar | MVP terlambat | Setiap fitur baru memerlukan trade-off tertulis. |
| Data lama tidak konsisten | Angka salah | Rekonsiliasi sebelum migrasi. |
| Margin kembali ambigu | Keputusan harga salah | Gunakan label `gross margin` dan `markup` eksplisit. |
| UI dipoles sebelum flow benar | Rework | Approve prototype sebelum implementation. |
| Query tersebar | Cache/error sulit | Query layer + TanStack Query convention. |
| Trigger terlalu kompleks | Debug sulit | Satu RPC transaksi atomik dan aggregate sederhana. |

## 6. Milestone Keputusan

- **Gate A:** PRD v3.1, formula, scope, dan strategi data disetujui 22 Juli 2026.
- **Gate B:** Approve UX prototype.
- **Gate C:** Approve schema dan seed.
- **Gate D:** Core POS UAT.
- **Gate E:** Production release.
