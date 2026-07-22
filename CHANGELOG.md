<!--
@file CHANGELOG.md
@version 0.3.0-alpha.1
@description Riwayat perubahan repository Parissa POS MVP.
-->

# Changelog

Semua perubahan penting repository dicatat di dokumen ini. Versi repository mengikuti Semantic Versioning dan terpisah dari versi PRD.

## [Unreleased]

### Planned

- Review Owner dan uji klik prototype Phase 1 sebelum Gate B.

## [0.3.0-alpha.1] — 2026-07-22

### Added

- Brand spec hasil review visual PDF brand guideline Parissa.
- Logo resmi prototype yang diekstrak langsung dari PDF sumber.
- Product facts dan panduan review untuk mencegah asumsi ulang oleh agent berikutnya.
- Perbandingan tiga arah layout: Speed First, Guided Checkout, dan Compact Operations.
- Prototype HTML interaktif dengan pola Speed First pada desktop dan Guided Checkout pada mobile.
- Simulasi cart, quantity, status pembayaran, validasi pelanggan piutang, double-submit guard, confirmation state, server error, dan retry.

### Validation

- Struktur file, link asset, dan sintaks JavaScript diperiksa secara statis.
- Pemeriksaan visual otomatis file lokal diblokir oleh kebijakan browser; review klik Owner masih diperlukan sebelum Gate B.

### Status

- Phase 1 aktif dan prototype berstatus alpha.
- Tidak ada dependency, backend, migration, atau kode aplikasi production.
- Engineering foundation tetap diblokir sampai Gate B disetujui.

## [0.2.0] — 2026-07-22

### Changed

- PRD dinaikkan ke v3.1 dan ditetapkan `Approved — Gate A`.
- Scope P0, gross margin, HPP manual snapshot, aturan pelanggan, penundaan pre-order, dan repository baru disahkan.
- Formula finansial diselaraskan agar omzet, HPP, dan gross profit hanya diakui berdasarkan `paid_at`; piutang aktif dilaporkan terpisah.
- Transaksi historis ditunda dari release awal dan dipindahkan ke proses rekonsiliasi serta migrasi idempotent pasca-MVP.
- Phase 1 ditetapkan aktif dan roadmap diperluas sampai Phase 6.
- Placeholder asset yang jujur disetujui sampai asset brand final tersedia.

### Status

- Baseline dokumentasi siap menjadi initial commit.
- Repository belum memiliki kode aplikasi, dependency, migration, atau deployment config.
- Coding foundation tetap diblokir sampai Gate B disetujui.

## [0.1.0] — 2026-07-22

### Added

- Baseline `AGENTS.md` untuk source of truth, approval gate, scope, business rules, quality gate, dan workflow repository.
- Baseline `README.md` untuk tujuan produk, scope P0, non-goals, stack rencana, roadmap, dan status keputusan.
- `VERSION` sebagai sumber versi repository.
- Sembilan dokumen produk di `Document/` sebagai baseline PRD MVP v3.0 dan rencana restart.

### Reviewed

- Seluruh folder `Document/` sebagai dasar baseline.
- Ketidaksesuaian definisi gross profit piutang dan inkonsistensi data historis dicatat sebagai blocker sebelum implementasi terkait.

### Status

- Repository belum memiliki kode aplikasi, dependency, migration, atau deployment config.
- Baseline masih menunggu persetujuan Gate A sebelum initial commit.
- Coding diblokir selama Gate A belum disetujui.
