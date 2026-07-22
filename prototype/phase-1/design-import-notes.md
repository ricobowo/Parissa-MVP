<!--
@file design-import-notes.md
@version 0.1.0
@description Catatan adaptasi mockup eksternal ke prototype Parissa POS yang dapat dijalankan mandiri.
-->

# Design Import Notes — 23 Juli 2026

## Sumber

- File Owner: `Parissa POS Mockup.dc.html`.
- SHA-256: `4b1363f4e1868f2ecff0ab2e6cb01e5de6cb36f65478401e9395af1884c8668d`.
- Format: Design Composer HTML dengan custom element `x-dc`, template `sc-if`/`sc-for`, `DCLogic`, dan dependency runtime tool.

File sumber tidak disalin mentah sebagai prototype utama karena tidak dapat dijalankan mandiri tanpa `support.js` dan design-system bundle milik tool. Hasil visualnya diadaptasi ke `pos-prototype.html` yang tetap berupa HTML/CSS/JavaScript lokal tanpa dependency.

## Diadopsi

- Grid desktop 84px navigation, katalog fleksibel, dan cart 392px.
- Kartu produk vertikal dengan placeholder netral, nama, harga, dan add control.
- Category chip dengan ikon garis dan kategori `Semua`, `Dessert`, `Minuman`, `Bundling`.
- Bottom navigation pada mobile.
- Loading skeleton sebagai skenario prototype yang dapat dipilih.
- Spacing, radius, elevation, dan density dari mockup terbaru.
- Token warna, typography 400/500/600, dan semantic status yang sudah konsisten dengan brand spec.

## Tidak Diadopsi

- Runtime, custom element, dan syntax binding khusus tool desain.
- Tab `Foundations`, `Components`, `POS Desktop`, `POS Mobile`, dan `States` di dalam aplikasi POS; konten tersebut adalah review board, bukan navigation production.
- Label `Order #...` sebelum transaksi tersimpan. Nomor transaksi tetap dibuat dan ditampilkan setelah submit berhasil agar tidak memberi kesan transaksi sudah tercatat.
- Duplikasi guideline dan asset pada `.design-sync/`; folder tersebut diperlakukan sebagai cache lokal dan diabaikan Git.

## Flow

Tidak ada perubahan flow atau business rule. Urutan produk → cart → quantity → status pembayaran eksplisit → pelanggan kondisional → total → submit → konfirmasi tetap menjadi kontrak Gate B.

## Source of Truth

Jika mockup eksternal berbeda dengan repository, urutan prioritas tetap:

1. Keputusan Owner terbaru.
2. `Document/MVP/05-POS-Flow.md`.
3. `Document/MVP/06-Design-Brief.md`.
4. `Document/MVP/07-Acceptance-Criteria.md`.
5. `prototype/phase-1/design-handoff.md`.
6. Mockup eksternal sebagai referensi visual.
