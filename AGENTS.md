<!--
@file AGENTS.md
@version 0.3.0
@description Instruksi kerja wajib untuk agent pada repository Parissa POS MVP.
-->

# AGENTS.md — Parissa POS MVP

Dokumen ini berlaku untuk seluruh repository. Instruksi yang lebih spesifik di subfolder boleh menambah batasan, tetapi tidak boleh melonggarkan aturan produk, keamanan, kualitas, atau approval di dokumen ini.

## Status Repository

- Baseline produk: PRD MVP v3.1, disetujui 22 Juli 2026.
- Versi repository: lihat `VERSION`.
- Fase aktif: Phase 2 — Engineering Foundation.
- Status: Gate A dan Gate B disetujui. Flow serta visual prototype diterima Owner pada 23 Juli 2026; median transaksi 7 detik dari lima percobaan.
- Batas fase: scaffold dan kode foundation Phase 2 boleh dimulai. Jangan mengimplementasikan fitur di luar scope P0 atau melompati Gate C.

## Source of Truth

Gunakan urutan berikut ketika dokumen berbeda:

1. Keputusan Owner terbaru yang tertulis.
2. `Document/PRD-Parissa-MVP.md` untuk tujuan, requirement, formula, dan Definition of Done.
3. `Document/MVP/02-MVP-Scope.md` untuk batas P0, P1, dan fitur yang ditunda.
4. `Document/MVP/03-Business-Rules.md` untuk aturan bisnis dan formula.
5. `Document/MVP/04-Data-Model.md` untuk model data minimum.
6. `Document/MVP/05-POS-Flow.md`, `06-Design-Brief.md`, dan `07-Acceptance-Criteria.md` untuk flow, desain, dan release gate.
7. `prototype/phase-1/design-handoff.md` untuk brief visual eksternal dan `design-import-notes.md` untuk keputusan adaptasinya; kedua file tidak boleh mengubah source of truth di atasnya.
8. `Document/Project-Restart-Plan.md` untuk urutan fase.

Jika konflik memengaruhi scope, data, formula, permission, atau perilaku bisnis, berhenti dan minta keputusan Owner. Jangan menyelesaikan konflik dengan asumsi tersembunyi.

## Approval Gates

### Gate A — disetujui 22 Juli 2026

Keputusan final:

- PRD MVP v3.1 dan scope P0.
- Gross margin sebagai definisi margin resmi.
- HPP manual per produk dengan snapshot transaksi; BOM ditunda.
- Nama pelanggan opsional untuk transaksi lunas dan wajib untuk piutang.
- Pre-order tidak masuk P0.
- Transaksi historis ditunda dari release awal dan dapat dimigrasikan setelah rekonsiliasi pasca-MVP.
- Repository baru digunakan dengan history bersih.
- Omzet, HPP, dan gross profit diakui berdasarkan tanggal `paid_at`; piutang dilaporkan terpisah.

Brand asset boleh menyusul dengan placeholder jujur, tetapi ketersediaannya harus dicatat sebelum visual final. Gate A tidak perlu dibuka kembali kecuali Owner mengubah keputusan produk di atas.

### Gate B — disetujui 23 Juli 2026

Flow produk → cart → pembayaran → pelanggan → submit → konfirmasi, perilaku responsif, state error/retry, dan arah visual prototype disetujui. Lima pengujian manual menghasilkan median 7 detik dan seluruhnya di bawah 30 detik.

### Gate berikutnya

- Gate C: schema, RLS, seed, dan fixture disetujui sebelum migration.
- Gate D: core POS lulus UAT.
- Gate E: seluruh acceptance criteria dan quality gate lulus sebelum production.

## Scope P0

- Login email/password; role tetap `owner` dan `cashier`; inactive-user guard dan RLS.
- Produk: list aktif serta add/edit/deactivate oleh Owner; harga dan HPP standar; gambar opsional.
- POS: quick-sale grid, multi-item cart, quantity, status `Sudah`/`Belum`, validasi pelanggan, snapshot harga/HPP, submit atomik dan idempotent, serta konfirmasi.
- Operasional minimum: riwayat, search/filter, piutang, mark as paid, Owner-only void, audit minimum.
- Dashboard: empat metrik hari ini dan lima transaksi terbaru.
- Bahasa Indonesia, light mode, responsif 360–1920px, dan accessibility minimum WCAG AA.

Di luar P0: BOM/pricing calculator, inventory, purchase/supplier, batching/expiry, production planning, waste, CRM/VIP, WhatsApp, advanced reporting/chart, flexible role editor, dark mode, offline mutation, payment gateway/QRIS, loyalty, multi-outlet, barcode, dan native app.

Fitur baru hanya boleh masuk P0 jika transaksi utama tidak dapat selesai tanpanya atau ada risiko akurasi/keamanan material, dan trade-off scope/timeline disetujui tertulis.

## Aturan Bisnis Kritis

- Transaksi memiliki minimal satu item; quantity adalah integer positif.
- Harga, HPP, dan nama produk disimpan sebagai snapshot item transaksi.
- Total dihitung server/database; nilai total dari client tidak dipercaya.
- Header dan seluruh item disimpan atomik melalui mutation/RPC yang idempotent.
- Transaksi `Belum` wajib memiliki nama pelanggan; nomor telepon opsional.
- `Overdue` adalah status turunan untuk piutang lebih dari tiga hari.
- Transaksi tidak pernah di-hard-delete. Hanya Owner dapat void dan alasan wajib dicatat.
- Create, perubahan pembayaran, dan void harus diaudit beserta actor dan timestamp.
- Transaksi `Sudah` mengisi `paid_at`/`paid_by`; transaksi `Belum` menghasilkan omzet, HPP, dan gross profit Rp0 serta masuk piutang.
- Pengakuan finansial menggunakan tanggal `paid_at` di `Asia/Jakarta`. Owner-only mark-as-unpaid membersihkan data pembayaran dan mengoreksi agregat dengan audit.
- Transaksi void dikeluarkan dari seluruh agregat finansial, transaksi aktif, dan piutang.
- Rupiah disimpan sebagai nilai numerik tanpa simbol dan ditampilkan tanpa desimal.
- Timestamp database menggunakan `timestamptz`; tanggal bisnis menggunakan `Asia/Jakarta`.
- Tidak ada mutasi stok pada MVP.
- Tidak ada migrasi transaksi historis pada P0; data lama tetap dipertahankan untuk proses staging dan import idempotent pasca-MVP.

## Konvensi Implementasi Setelah Gate Disetujui

- Stack: Next.js App Router, TypeScript strict, Tailwind CSS, shadcn/ui, Supabase PostgreSQL/Auth/RLS, TanStack Query, Zod, unit test, Playwright, dan Vercel.
- Server Components dipakai untuk initial/non-interactive data; TanStack Query untuk server state interaktif dan mutation.
- Jangan menyebarkan direct Supabase query di page/component. Gunakan query/data-access layer.
- Formula bisnis harus berada di domain module tunggal dan digunakan oleh test fixture frontend/backend.
- Semua boundary input divalidasi dengan Zod dan ditegakkan kembali di database bila relevan.
- Setiap halaman data wajib memiliki loading, error, dan empty state yang berbeda.
- Semua komentar kode menggunakan Bahasa Indonesia.
- Setiap file baru memiliki header versi jika format file mendukung komentar.
- Schema hanya berubah melalui migration baru; migration yang telah diterapkan tidak diedit ulang.
- Jangan menyalin UI, dependency, trigger, atau migration lama secara wholesale. Repository lama hanya referensi read-only.

## Keputusan UX Phase 1

- Desktop memakai layout Speed First; mobile memakai katalog yang sama dengan cart bottom sheet dan progressive checkout.
- Font UI memakai `Circular Std` bila asset berlisensi tersedia, dengan fallback `Avenir Next`/`Segoe UI`; bobot dibatasi pada 400/500/600.
- Surface netral mendominasi; `#E85C6D` menjadi aksen nonteks dan shade satu keluarga `#BD4052` menjadi action/pilihan aktif yang memenuhi kontras; warna lain hanya untuk status semantik.
- Foto yang belum tersedia memakai thumbnail netral kecil, tanpa warna rasa/kategori atau stock image.
- Mobile hanya menyediakan ruang bawah ekstra ketika floating cart summary tampil; jangan menyisakan gap yang memicu scroll tanpa kebutuhan.
- Quantity dapat diubah melalui stepper atau input langsung, tetapi hanya integer positif mulai dari 1 yang diterima.
- Checkout disembunyikan saat cart kosong.
- Status pembayaran tidak memiliki default dan wajib dipilih eksplisit sebelum submit.

## Quality Gate

Sebelum release, semuanya wajib lulus:

- lint;
- type-check tanpa ignored error;
- unit test;
- integration test;
- Playwright E2E;
- production build;
- RLS test untuk Owner, Kasir, anonymous, dan inactive user;
- responsive QA pada 360px, 768px, 1280px, dan 1920px;
- keyboard, focus visible, touch target minimum 44px, dan contrast WCAG AA;
- rekonsiliasi angka dengan fixture manual;
- backup, restore, rollback, dan production smoke test.

## Cara Kerja dan Git

- Sebelum mengedit, jelaskan file, bagian, dan alasan. Persetujuan tambahan tidak diperlukan jika Owner sudah mengatakan “lanjutkan”, “kerjakan”, atau setara untuk scope sesi tersebut.
- Laporkan command penting beserta tujuan dan hasilnya.
- Jaga perubahan tetap kecil dan sesuai fase aktif. Jangan menyentuh perubahan pengguna yang tidak terkait.
- Perbarui `CHANGELOG.md`, `VERSION`, dan `README.md` ketika perubahan memengaruhi versi, progress, dependency, struktur, atau cara menjalankan proyek.
- Gunakan semantic versioning untuk versi repository. Jangan menyamakan versi repository dengan versi PRD.
- Jangan commit sebelum baseline dan scope MVP disetujui Owner.
- Jangan menjalankan `git push`; serahkan langkah upload/push kepada Owner.
- Jangan menyimpan secret, data pribadi, transcript, atau artefak lokal di repository.

## Format Laporan Sesi

Tutup setiap sesi menggunakan format berikut dan isi sesuai pekerjaan sebenarnya:

```text
SESSION SUMMARY — <tanggal Indonesia>
Files changed: <daftar file atau “Tidak ada pada sesi ini”>
Current version: Parissa-MVP v<versi>
Next suggested step: <satu langkah berikutnya>
```

Tambahkan hasil verifikasi atau keputusan terbuka sebelum blok tersebut jika relevan. Jangan menyatakan pekerjaan selesai jika approval gate atau acceptance criterion terkait belum terpenuhi.
