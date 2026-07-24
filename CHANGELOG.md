<!--
@file CHANGELOG.md
@version 0.4.4
@description Riwayat perubahan repository Parissa POS MVP.
-->

# Changelog

Semua perubahan penting repository dicatat di dokumen ini. Versi repository mengikuti Semantic Versioning dan terpisah dari versi PRD.

## [Unreleased]

### Planned

- Implementation plan dan pengembangan Core POS Phase 3.

## [0.4.4] — 2026-07-24

### Changed

- Mengganti nilai HPP asli produk di `supabase/seed.sql` dan `supabase/tests/database/transactions.test.sql` dengan nilai placeholder development; data biaya bisnis resmi kini disimpan di sistem internal, tidak dipublikasikan di repository publik.
- Meringkas Appendix A `Document/PRD-Parissa-MVP.md` (tabel HPP/margin/markup per produk dan statistik rekonsiliasi historis) menjadi catatan naratif tanpa angka literal; formula margin/markup tetap dijelaskan.
- Meringkas item "Hasil Gate C" di `Document/MVP/08-Engineering-Foundation.md` agar tidak lagi mencantumkan nilai HPP literal, tetap menyatakan Gate C telah memverifikasi HPP enam produk.
- Meringkas catatan rekonsiliasi historis di `README.md` tanpa angka pasti.
- Menghapus sebutan AI tool spesifik di `Document/PRD-Parissa-MVP.md`, digantikan frasa generik tanpa mengubah aturan operasional yang dimaksud.
- Menambahkan `.claude/settings.local.json` ke `.gitignore` repository (sebelumnya hanya diabaikan lewat gitignore global milik satu developer).

### Validation

- `format:check`, `lint`, `type-check`, `test:run` (10/10), `build`, `db:reset`, `db:lint`, dan `db:test` (23/23 pgTAP) lulus setelah seluruh redaksi, diverifikasi dua kali secara independen.

## [0.4.3] — 2026-07-24

### Added

- `Document/Engineering-Code-Guide.md` sebagai panduan arsitektur handoff: batas layer, peta folder/entry point, alur auth/permission, alur transaksi UI→RPC/database, aturan HPP snapshot/pembayaran/piutang/void/audit, peta test dan command verifikasi, serta panduan menelusuri satu transaksi end-to-end.
- Job `database` di `.github/workflows/ci.yml` (`needs: quality`, paralel dengan `e2e`): menjalankan `supabase:start` → `db:reset` → `db:lint` → `db:test` → `supabase:stop` otomatis pada tiap PR/push ke `main`, menutup gap Quality Gate RLS/pgTAP yang sebelumnya hanya diverifikasi manual.

### Changed

- Menambahkan komentar edukatif Bahasa Indonesia (TSDoc/JSDoc dan komentar "mengapa") pada `src/app/`, `src/components/ui/`, `src/lib/`, `src/types/`, migration/seed/pgTAP di `supabase/`, `tests/e2e/foundation.spec.ts`, dan `.github/workflows/ci.yml`, mengikuti `.agents/skills/parissa-code-handoff/SKILL.md`. Perubahan bersifat komentar/dokumentasi saja — tidak ada logic, schema, kontrak fungsi, atau tampilan yang berubah (dikonfirmasi via `git diff`: hanya insertion pada bagian ini).

### Removed

- `src/types/database.ts` — tipe database manual yang tidak diimpor oleh `src/lib/supabase/browser.ts` maupun `server.ts` mana pun (keduanya memakai `src/types/database.generated.ts`). Dihapus untuk menghindari sumber kebenaran ganda; `database.generated.ts` (hasil `supabase gen types --local`) menjadi satu-satunya sumber type database.

### Validation

- `format:check`, `lint`, `type-check`, `test:run` (10/10), `build`, dan `test:e2e` (4/4 lintas viewport) lulus setelah seluruh komentar ditambahkan dan setelah `src/types/database.ts` dihapus.
- `db:reset`, `db:lint`, dan `db:test` (23/23 pgTAP) dijalankan ulang secara lokal meniru urutan job `database` yang baru — hasil tetap sama dengan Gate C.

## [0.4.2] — 2026-07-24

### Changed

- Memindahkan katalog skill dari root ke `Document/AI/SKILLS_CATALOG.md`.
- Mengubah katalog dari snapshot 222 skill global menjadi daftar kurasi dan routing skill khusus kebutuhan Parissa.
- Menetapkan katalog kurasi proyek sebagai file yang dilacak Git, sementara inventaris lengkap skill global tetap berada di luar repository.

## [0.4.1] — 2026-07-24

### Added

- Skill repository `parissa-code-handoff` untuk komentar kode edukatif, Engineering Code Guide, dan onboarding AI/developer.
- Metadata skill agar dapat ditemukan dan dipanggil oleh agent yang mendukung format Agent Skills.

### Changed

- Menambahkan routing skill pendamping untuk frontend, shadcn, PostgreSQL/migration, security, ADR, dan verification bila tersedia.
- Menjelaskan kebijakan penyimpanan skill proyek pada AGENTS dan README.
- Awalnya mengabaikan snapshot `SKILLS_CATALOG.md`; kebijakan ini kemudian diganti pada `0.4.2` dengan katalog kurasi proyek yang dilacak Git.

## [0.4.0] — 2026-07-23

### Changed

- Menutup Engineering Foundation sebagai Gate C dan mengaktifkan Core POS Phase 3.
- Menyelaraskan PRD, dokumen MVP, restart plan, handoff prototype, README, AGENTS, dan timeline interaktif dengan status terbaru.
- Menetapkan versi stabil foundation menjadi `0.4.0`.
- Menetapkan Airtable Parissa sebagai sumber HPP resmi setelah Owner menyatakan angka PRD v2.4 keliru.
- Menyelaraskan HPP enam produk pada seed dan dokumentasi dengan presisi dua desimal.
- Menghitung HPP Bundling 3pcs sebagai tiga kali HPP per pcs Airtable.
- Mencatat OrbStack sebagai runtime Docker-compatible untuk verifikasi Supabase lokal.
- Menambahkan migration guard eksplisit untuk menolak input transaction `items = null`.
- Menggunakan database types hasil generate schema lokal pada Supabase client.

### Added

- 18 integration test database untuk HPP seed, transaksi atomik, snapshot, idempotensi, pembayaran, void, dan audit.

### Validation

- Database reset lulus dengan dua migration dan seed resmi Airtable.
- Database lint lulus tanpa schema error.
- Seluruh 23 pgTAP test lulus: 5 RLS test dan 18 integration test transaksi.
- Enam HPP terverifikasi tepat pada tabel `products`.
- Format, lint, TypeScript strict, 10 unit test, production build, serta 4 Playwright viewport lulus.

### Status

- Gate C disetujui Owner pada 23 Juli 2026.
- Engineering Foundation Phase 2 selesai dan Core POS Phase 3 aktif.
- HPP dan seluruh verifikasi lokal tidak lagi menjadi keputusan terbuka.

## [0.4.0-alpha.1] — 2026-07-23

### Added

- Scaffold Next.js 16 App Router, React 19, TypeScript strict, Tailwind CSS v4, dan shadcn/ui `base-nova`.
- Token warna semantik Parissa, halaman status foundation, dan asset logo lokal.
- Supabase CLI, migration enam tabel, RLS Owner/Kasir/anonymous/inactive, seed dua role, dan enam produk development.
- RPC atomik/idempotent untuk create transaction, perubahan pembayaran, dan Owner-only void.
- TanStack Query provider, Zod boundary, Supabase client factory, database types, serta error convention.
- Vitest, Playwright empat viewport, ESLint, Prettier, dan GitHub Actions CI.

### Validation

- ESLint, TypeScript strict, 10 unit test, production build, dan empat smoke test Playwright lulus.
- Smoke test lulus pada 360px, 768px, 1280px, dan 1920px tanpa horizontal overflow.
- Database test belum dijalankan karena mesin lokal belum memiliki Docker-compatible runtime.
- Audit dependency mencatat enam advisory upstream/transitive tanpa critical issue; perbaikan otomatis memerlukan downgrade/breaking change dan tidak diterapkan.

### Status

- Phase 2 aktif dan Gate C belum disetujui.
- HPP pada seed mengikuti angka indikatif Appendix A PRD v3.1 sampai dikonfirmasi Owner.

## [0.3.0] — 2026-07-23

### Changed

- Menetapkan prototype UX Phase 1 sebagai baseline implementasi yang disetujui.
- Mengaktifkan Phase 2 — Engineering Foundation.

### Validation

- Flow lunas, piutang, server error, retry, input quantity, dan perilaku responsif telah diverifikasi.
- Lima percobaan transaksi menghasilkan median 7 detik dan seluruhnya berada di bawah target 30 detik.

### Status

- Gate B disetujui Owner pada 23 Juli 2026.
- Scaffold dan kode foundation Phase 2 boleh dimulai; Gate C menjadi approval berikutnya.

## [0.3.0-alpha.7] — 2026-07-23

### Added

- Timeline development interaktif dari Gate A sampai monitoring pasca-MVP dan proyek migrasi historis.
- Filter status fase, detail deliverable/exit gate, serta visual hasil pengukuran transaksi pada timeline.

### Validation

- Lima percobaan transaksi manual menghasilkan 4, 8, 9, 7, dan 3 detik.
- Median 7 detik, rata-rata 6,2 detik, rentang 3–9 detik, dan seluruh percobaan berada di bawah target 30 detik.

### Status

- Kriteria waktu Gate B dinyatakan lulus.
- Gate B masih terbuka pada versi ini dan kemudian disetujui pada `0.3.0`.

## [0.3.0-alpha.6] — 2026-07-23

### Changed

- Membuat padding bawah katalog mobile kondisional agar ruang ekstra hanya tersedia saat floating cart bar tampil.
- Mengganti angka quantity statis dengan input langsung yang tetap didampingi tombol tambah dan kurang.
- Menolak quantity nol, minus, desimal, huruf, simbol, dan nilai di luar integer aman tanpa mengubah nilai cart terakhir yang valid.

### Validation

- Kategori mobile dengan satu produk terukur tanpa vertical scroll pada viewport 360×800px; padding katalog kembali menjadi 24px saat cart kosong.
- Input quantity menerima `3` dan memperbarui total menjadi Rp60.000, sedangkan `0`, `-2`, `1.5`, serta `abc` ditolak dan kembali ke nilai valid terakhir.
- Input dan tombol quantity terukur minimum 44px; flow lunas, piutang, server error, dan retry tetap lulus tanpa console error.

### Status

- Flow, business rule, dependency, dan kode aplikasi production tidak berubah.
- Gate B tetap menunggu review visual akhir dan validasi transaksi umum kurang dari 30 detik.

## [0.3.0-alpha.5] — 2026-07-23

### Changed

- Memadatkan kartu produk dan menambah kolom katalog pada desktop lebar tanpa mengubah flow transaksi.
- Memperkuat kontras placeholder, search, dan teks sekunder serta menyatukan focus ring dengan keluarga warna brand.
- Memperbesar target sentuh kategori dan kontrol kuantitas, meningkatkan keterbacaan navigasi, serta menyederhanakan copy empty cart.
- Mengurangi kombinasi border dan shadow pada kartu agar tampilan lebih tenang dan minimal.

### Validation

- Playwright lulus pada 360px, 768px, 1280px, dan 1920px tanpa horizontal page scroll atau console error.
- Target sentuh kategori dan kontrol kuantitas terukur minimum 44×44px.
- Flow lunas lulus pada seluruh viewport; validasi piutang lulus pada mobile; server error dan retry lulus pada desktop.
- Kontras teks sekunder, placeholder produk, search, CTA, dan navigasi aktif memenuhi WCAG AA.

### Status

- Tidak ada perubahan flow, business rule, dependency, atau kode aplikasi production.
- Gate B tetap menunggu review visual akhir dan validasi transaksi umum kurang dari 30 detik.

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
