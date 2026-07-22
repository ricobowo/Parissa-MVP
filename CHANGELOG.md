<!--
@file CHANGELOG.md
@version 0.3.0-alpha.4
@description Riwayat perubahan repository Parissa POS MVP.
-->

# Changelog

Semua perubahan penting repository dicatat di dokumen ini. Versi repository mengikuti Semantic Versioning dan terpisah dari versi PRD.

## [Unreleased]

### Planned

- Review visual final prototype hasil adaptasi dan validasi waktu transaksi sebelum Gate B.

## [0.3.0-alpha.4] — 2026-07-23

### Changed

- Mengadaptasi visual mockup eksternal terbaru ke prototype HTML mandiri tanpa runtime tool desain.
- Menyesuaikan desktop menjadi navigation 84px, katalog fleksibel, cart 392px, kartu produk vertikal, serta ikon kategori.
- Menambahkan bottom navigation mobile dan skenario loading skeleton.
- Mempertahankan nomor transaksi hanya pada confirmation state setelah submit berhasil.

### Added

- Catatan provenance, checksum sumber, keputusan adaptasi, dan batas source of truth pada `design-import-notes.md`.
- `.gitignore` untuk mengecualikan cache lokal `.design-sync/` yang menduplikasi guideline dan asset repository.

### Validation

- HTML parse, JavaScript syntax, logo asset, dan konsistensi VERSION lulus pemeriksaan statis.
- Playwright lulus pada 360px, 768px, 1280px, dan 1920px tanpa horizontal page scroll.
- Flow desktop lunas, server error/retry, serta flow mobile piutang dan validasi nama pelanggan lulus uji klik.
- Bottom sheet mobile diverifikasi mengikuti tinggi konten dan tidak menyisakan ruang kosong berlebihan.

### Status

- Flow dan business rule tidak berubah.
- Gate B masih menunggu review visual final dan validasi transaksi umum kurang dari 30 detik.

## [0.3.0-alpha.3] — 2026-07-22

### Added

- AI Design Handoff yang merangkum artefak sumber, scope, flow terkunci, responsive layout, seluruh state wajib, mini design system, data contoh, format deliverable, dan acceptance checklist.
- Prompt ringkas yang dapat diberikan bersama handoff kepada AI Design lain.

### Changed

- Status Phase 1 diperbarui: flow utama telah diuji manual Owner dan dinyatakan aman; penyempurnaan visual masih berlangsung.
- Gate B difokuskan pada review visual final dan validasi transaksi umum kurang dari 30 detik.

### Status

- Tidak ada perubahan flow, business rule, dependency, atau kode aplikasi production.
- Push tidak dilakukan oleh agent.

## [0.3.0-alpha.2] — 2026-07-22

### Changed

- Menyederhanakan UI ke surface netral dengan satu keluarga warna brand dan semantic color terbatas; action memakai shade merah yang memenuhi kontras AA.
- Membatasi bobot tipografi ke 400/500/600 serta mendokumentasikan fallback saat `Circular Std` belum tersedia.
- Mengubah kartu produk menjadi lebih ringkas dan menghapus warna rasa, category label ganda, serta placeholder dominan.
- Mengganti indikator navigasi berbentuk kotak dengan ikon garis dan label yang jelas.
- Menyamakan search serta kategori, termasuk `Bundling`, pada seluruh layout comparison.
- Menerapkan progressive disclosure: checkout tersembunyi ketika cart kosong.
- Menghapus default status `Sudah`; Kasir wajib memilih status pembayaran secara eksplisit.
- Menampilkan nama pelanggan sebagai opsional untuk transaksi lunas dan wajib untuk piutang.

### Validation

- Struktur HTML, link asset, whitespace, dan sintaks JavaScript lulus pemeriksaan statis.
- Kontras teks utama, teks sekunder, CTA, serta status paid/unpaid/error lulus ambang 4,5:1 pada token yang dipakai.
- Responsive render dan uji klik Owner masih diperlukan sebelum Gate B.

### Status

- Phase 1 tetap aktif dan Gate B belum disetujui.
- Tidak ada dependency, backend, migration, atau kode aplikasi production.

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
