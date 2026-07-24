<!--
@file README.md
@version 0.4.2
@description Engineering foundation Parissa POS berdasarkan PRD MVP v3.1.
-->

# Parissa POS MVP

Parissa POS adalah aplikasi web responsif untuk membantu bisnis dessert dan minuman Parissa di Bandung mencatat penjualan dalam kurang dari 30 detik dan menghasilkan angka omzet, HPP, gross profit, serta piutang yang dapat dipercaya.

> **Status:** Gate A, Gate B, dan Gate C disetujui. Phase 2 — Engineering Foundation selesai pada `0.4.0`; Phase 3 — Core POS aktif.

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
| Sumber HPP | Airtable Parissa, disimpan manual per produk dan disalin sebagai snapshot | Disetujui |
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

## Stack Phase 2

- Next.js 16 App Router, React 19, dan TypeScript strict.
- Tailwind CSS v4 dan shadcn/ui `base-nova` berbasis Base UI.
- Supabase PostgreSQL/Auth/RLS dan Supabase CLI lokal.
- TanStack Query untuk server state interaktif.
- Zod 4 untuk form dan input boundary.
- Vitest, Playwright, ESLint, Prettier, dan GitHub Actions.
- Vercel untuk preview dan production.

Token shadcn menggunakan warna semantik Parissa. Dark mode tidak diaktifkan karena berada di luar scope MVP.

## Menjalankan Foundation

Prasyarat:

- Node.js 20.9 atau lebih baru.
- npm 11.
- Docker Desktop, OrbStack, atau runtime Docker-compatible lain untuk Supabase lokal.

```bash
npm install
cp .env.example .env.local
npm run dev
```

Quality gate aplikasi:

```bash
npm run lint
npm run type-check
npm run test:run
npm run build
npm run test:e2e
```

Database lokal:

```bash
npm run supabase:start
npm run db:reset
npm run db:lint
npm run db:test
```

Nilai `NEXT_PUBLIC_SUPABASE_ANON_KEY` lokal diperoleh dari output `npm run supabase:start`. Jangan commit `.env.local` atau secret Supabase.

## Prototype Phase 1

- [Perbandingan tiga layout](prototype/phase-1/layout-variations.html).
- [Prototype POS interaktif](prototype/phase-1/pos-prototype.html).
- [Brand spec](prototype/phase-1/brand-spec.md).
- [AI Design Handoff](prototype/phase-1/design-handoff.md).
- [Catatan adaptasi mockup eksternal](prototype/phase-1/design-import-notes.md).
- [Panduan review](prototype/phase-1/README.md).

Prototype adalah satu file HTML dengan CSS dan JavaScript lokal. Tidak ada dependency, backend, authentication, atau database; artefak ini hanya untuk memvalidasi flow sebelum Phase 2.

Keputusan visual sementara: tipografi ringan–menengah (400/500/600), surface netral, satu keluarga aksen merah Parissa dengan shade action yang memenuhi kontras, thumbnail foto netral, progressive checkout, dan status pembayaran tanpa default. Rincian tersedia di [brand spec](prototype/phase-1/brand-spec.md).

## Roadmap dan Gate

| Fase | Outcome | Gate |
|---|---|---|
| 0 — Product Definition | PRD v3.1, formula, scope, strategi data, dan asset fallback disetujui | Gate A — selesai |
| 1 — UX Prototype | Flow POS mobile/desktop tervalidasi <30 detik | Gate B — selesai |
| 2 — Engineering Foundation | App kosong, schema, RLS, seed, CI, quality gate | Gate C — selesai |
| 3 — Core POS | Produk, cart, transaksi, dan konfirmasi | Aktif; menuju Gate D/UAT |
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
- [Engineering Foundation](Document/MVP/08-Engineering-Foundation.md)
- [Timeline Development Interaktif](Document/Parissa-Development-Timeline.html)
- [Instruksi Agent](AGENTS.md)
- [Riwayat Perubahan](CHANGELOG.md)

## Skill AI Proyek

- [Parissa Code Handoff](.agents/skills/parissa-code-handoff/SKILL.md) digunakan untuk komentar kode edukatif, dokumentasi engineering, dan onboarding AI/developer.
- [Katalog Skill AI](Document/AI/SKILLS_CATALOG.md) membantu memilih skill berdasarkan jenis pekerjaan.
- Skill repository disimpan di `.agents/skills/` dan dilacak Git.
- Katalog yang dilacak hanya berisi skill relevan untuk Parissa; snapshot lengkap instalasi global tidak disimpan di repository.

## Struktur Repository Saat Ini

```text
.
├── AGENTS.md
├── CHANGELOG.md
├── .agents/
│   └── skills/
│       └── parissa-code-handoff/
├── Document/
│   ├── AI/
│   │   └── SKILLS_CATALOG.md
│   ├── MVP/
│   ├── Parissa-Development-Timeline.html
│   ├── PRD-Parissa-MVP.md
│   └── Project-Restart-Plan.md
├── README.md
├── package.json
├── src/
│   ├── app/
│   ├── components/ui/
│   ├── lib/
│   └── types/
├── supabase/
│   ├── migrations/
│   ├── tests/
│   └── seed.sql
├── tests/
│   └── e2e/
├── prototype/
│   └── phase-1/
│       ├── assets/
│       ├── brand-spec.md
│       ├── design-handoff.md
│       ├── design-import-notes.md
│       ├── layout-variations.html
│       ├── pos-prototype.html
│       ├── product-facts.md
│       └── README.md
├── VERSION
└── .github/workflows/ci.yml
```

## Langkah Berikutnya

Susun implementation plan Phase 3, lalu bangun login, katalog produk, quick-sale grid, cart, transaksi atomik, dan konfirmasi berdasarkan prototype yang telah disetujui.

## Versi

- Repository/software: `0.4.2`.
- Baseline PRD: MVP `v3.1`.

Lihat `CHANGELOG.md` untuk perubahan repository.
