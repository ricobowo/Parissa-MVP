<!--
@file README.md
@version 0.2.0
@description Baseline repository Parissa POS berdasarkan PRD MVP v3.1.
-->

# Parissa POS MVP

Parissa POS adalah aplikasi web responsif untuk membantu bisnis dessert dan minuman Parissa di Bandung mencatat penjualan dalam kurang dari 30 detik dan menghasilkan angka omzet, HPP, gross profit, serta piutang yang dapat dipercaya.

> **Status:** Gate A disetujui pada 22 Juli 2026. Phase 1 — UX Prototype aktif; coding foundation belum boleh dimulai sampai Gate B disetujui.

## Sasaran MVP

- Median transaksi lunas kurang dari 30 detik.
- Selisih omzet, HPP, dan profit kurang dari 1% terhadap perhitungan manual.
- Lima dari lima pengguna UAT menyelesaikan transaksi tanpa bantuan.
- POS dapat digunakan pada layar 360px tanpa horizontal scroll.
- Seluruh quality gate lulus sebelum production.

## Scope P0

1. Login email/password dengan role Owner dan Kasir.
2. Katalog dan pengelolaan produk aktif.
3. POS cepat dengan cart, status pembayaran, snapshot harga/HPP, dan submit atomik/idempotent.
4. Piutang dan perubahan status pembayaran dengan audit.
5. Riwayat, search/filter, dan Owner-only void tanpa hard delete.
6. Dashboard ringkas berisi empat metrik hari ini dan lima transaksi terbaru.

MVP menggunakan Bahasa Indonesia, light mode, dan layout mobile-first dari 360px sampai desktop 1920px.

## Tidak Termasuk MVP

Recipe/BOM, pricing calculator, inventory, purchase/supplier, batching/expiry, production planner, waste, CRM/VIP, WhatsApp, advanced reports/chart, flexible role editor, dark mode, offline mutation, payment gateway/QRIS, loyalty, multi-outlet, barcode, dan aplikasi native ditunda sampai core POS tervalidasi.

## Keputusan Gate A

| Area | Keputusan | Status |
|---|---|---|
| Definisi margin | Gross margin terhadap harga jual | Disetujui |
| Sumber HPP | Manual per produk, disalin sebagai snapshot | Disetujui |
| Pelanggan transaksi lunas | Opsional; tampil sebagai “Pelanggan Umum” | Disetujui |
| Pelanggan piutang | Nama wajib, telepon opsional | Disetujui |
| Pre-order | Di luar P0 | Disetujui |
| Transaksi historis | Ditunda dari release awal; dapat dimigrasikan setelah rekonsiliasi | Disetujui |
| Strategi repository | Repository baru dengan history bersih | Disetujui |
| Pengakuan finansial | Omzet, HPP, dan gross profit berdasarkan tanggal `paid_at` | Disetujui |
| Brand asset | Placeholder jujur sampai asset final tersedia | Disetujui |

### Aturan finansial sederhana

Untuk penjualan Rp100.000 dengan HPP Rp60.000:

- Saat belum dibayar: piutang Rp100.000; omzet, HPP, dan gross profit dashboard masih Rp0.
- Saat dibayar: omzet Rp100.000, HPP Rp60.000, dan gross profit Rp40.000 masuk pada tanggal pembayaran.
- Jika transaksi di-void atau dikembalikan menjadi belum lunas, agregat terkait dikoreksi dan tindakannya diaudit.

Data historis belum dimasukkan karena ditemukan selisih jumlah transaksi dan angka cost/profit antara sumber data dan dashboard lama. Data tidak dibuang: rekonsiliasi dan migrasi dilakukan sebagai proyek pasca-MVP dengan staging, dry-run, validasi total, dan pencegahan duplikat.

## Stack yang Direncanakan

- Next.js App Router dan TypeScript strict.
- Tailwind CSS dan shadcn/ui.
- Supabase PostgreSQL, Auth, dan RLS.
- TanStack Query untuk server state interaktif.
- Zod untuk form dan input boundary.
- Unit/integration test dan Playwright E2E.
- Vercel untuk preview dan production.

Stack ini baru boleh di-scaffold setelah prototype UX dan Gate B disetujui.

## Roadmap dan Gate

| Fase | Outcome | Gate |
|---|---|---|
| 0 — Product Definition | PRD v3.1, formula, scope, strategi data, dan asset fallback disetujui | Gate A — selesai |
| 1 — UX Prototype | Flow POS mobile/desktop tervalidasi <30 detik | Gate B |
| 2 — Engineering Foundation | App kosong, schema, RLS, seed, CI, quality gate | Gate C |
| 3 — Core POS | Produk, cart, transaksi, dan konfirmasi | Gate D/UAT |
| 4 — History & Dashboard | Piutang, void, audit, dan metrik terverifikasi | Gate D/UAT |
| 5 — Validation & Release | E2E, device QA, UAT, backup/rollback, deploy | Gate E |
| 6 — Pasca-MVP | Evaluasi dua minggu, rekonsiliasi/migrasi historis, prioritas backlog | Gate terpisah |

## Dokumen

- [PRD MVP v3.1](Document/PRD-Parissa-MVP.md)
- [Project Restart Plan](Document/Project-Restart-Plan.md)
- [Product Brief](Document/MVP/01-Product-Brief.md)
- [MVP Scope](Document/MVP/02-MVP-Scope.md)
- [Business Rules](Document/MVP/03-Business-Rules.md)
- [Data Model](Document/MVP/04-Data-Model.md)
- [POS Flow](Document/MVP/05-POS-Flow.md)
- [Design Brief](Document/MVP/06-Design-Brief.md)
- [Acceptance Criteria](Document/MVP/07-Acceptance-Criteria.md)
- [Instruksi Agent](AGENTS.md)
- [Riwayat Perubahan](CHANGELOG.md)

## Struktur Repository Saat Ini

```text
.
├── AGENTS.md
├── CHANGELOG.md
├── Document/
│   ├── MVP/
│   ├── PRD-Parissa-MVP.md
│   └── Project-Restart-Plan.md
├── README.md
└── VERSION
```

## Langkah Berikutnya

Buat rencana detail dan prototype UX Phase 1 untuk POS mobile 360px dan desktop 1280px. Validasi skenario lunas, piutang, server error, dan retry; coding foundation tetap menunggu Gate B.

## Versi

- Repository/software: `0.2.0`.
- Baseline PRD: MVP `v3.1`.

Lihat `CHANGELOG.md` untuk perubahan repository.
