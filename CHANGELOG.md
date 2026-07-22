<!--
@file CHANGELOG.md
@version 0.2.0
@description Riwayat perubahan repository Parissa POS MVP.
-->

# Changelog

Semua perubahan penting repository dicatat di dokumen ini. Versi repository mengikuti Semantic Versioning dan terpisah dari versi PRD.

## [Unreleased]

### Planned

- Perencanaan detail dan prototype UX Phase 1 sebelum Gate B.

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
