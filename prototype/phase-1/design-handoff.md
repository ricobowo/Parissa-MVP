<!--
@file design-handoff.md
@version 0.2.3
@description Brief handoff untuk penyempurnaan visual Parissa POS oleh AI Design atau UI designer lain.
-->

# Parissa POS — AI Design Handoff

**Tanggal:** 22 Juli 2026

**Repository:** Parissa-MVP `v0.3.0`

**Fase:** Phase 1 — selesai; baseline untuk Phase 2

**Status:** Flow dan visual final disetujui Owner sebagai Gate B pada 23 Juli 2026. Dokumen ini menjadi acuan implementasi, bukan lagi brief eksplorasi.

## 1. Tujuan Handoff

Sempurnakan visual POS Parissa agar terasa minimal, tenang, hangat, premium, dan cepat dibaca oleh Kasir. Pertahankan flow serta aturan bisnis yang sudah tervalidasi. Pekerjaan ini adalah desain, bukan development aplikasi.

Hasil desain harus cukup jelas untuk diterjemahkan ke Next.js, Tailwind CSS, dan shadcn/ui tanpa menebak ulang layout, state, maupun perilaku responsif.

## 2. Artefak Sumber Wajib

Berikan seluruh file berikut kepada AI Design atau designer:

1. `prototype/phase-1/pos-prototype.html` — flow interaktif yang sudah diuji.
2. `prototype/phase-1/layout-variations.html` — keputusan struktur desktop dan mobile.
3. `prototype/phase-1/brand-spec.md` — logo, warna, font, dan batas penggunaan referensi.
4. `prototype/phase-1/product-facts.md` — produk dan harga contoh yang tervalidasi.
5. `Document/MVP/05-POS-Flow.md` — urutan flow dan failure state.
6. `Document/MVP/06-Design-Brief.md` — aturan visual dan responsive.
7. `Document/MVP/07-Acceptance-Criteria.md` — acceptance criteria UI.
8. `prototype/phase-1/assets/parissa-logo.png` — logo resmi untuk prototype.

Jika terjadi konflik, flow, aturan bisnis, dan acceptance criteria repository lebih tinggi prioritasnya daripada saran visual AI.

## 3. Scope Desain Saat Ini

### Wajib

- POS desktop 1280px.
- POS mobile 360px.
- Adaptasi tablet 768px.
- Perilaku saat layar melebar hingga 1920px.
- Mini design system untuk komponen yang dipakai pada POS.
- Seluruh state wajib pada bagian 7.

### Belum diminta

- Dashboard lengkap.
- Riwayat transaksi.
- Daftar piutang.
- Product management Owner.
- Login.
- Dark mode.
- Pre-order, table booking, inventory, QRIS, dan fitur di luar P0.

AI boleh menunjukkan pola navigasi menuju modul P0 lain, tetapi tidak boleh merancang fitur baru seolah sudah disetujui.

## 4. Pengguna dan Kondisi Penggunaan

- Pengguna utama: Kasir Parissa.
- Penggunaan berulang dalam kondisi toko dan kemungkinan koneksi tidak stabil.
- Target transaksi umum: kurang dari 30 detik.
- Bahasa UI: Bahasa Indonesia.
- Prioritas: kecepatan, keterbacaan, pencegahan salah status pembayaran, dan touch target yang aman.

## 5. Flow yang Dikunci

Urutan berikut tidak boleh diubah tanpa proposal terpisah:

1. Pilih atau cari produk.
2. Tambahkan produk ke cart.
3. Atur quantity.
4. Pilih status pembayaran secara eksplisit: `Sudah` atau `Belum`.
5. Jika `Sudah`, nama pelanggan opsional.
6. Jika `Belum`, nama pelanggan wajib dan nomor telepon opsional.
7. Tinjau total.
8. Simpan transaksi.
9. Tampilkan konfirmasi nomor transaksi, total, dan status.

Aturan keselamatan:

- Tidak ada status pembayaran default.
- Checkout tidak muncul saat cart kosong.
- Submit tidak boleh berjalan jika cart kosong atau status pembayaran belum dipilih.
- Server error mempertahankan cart dan menyediakan retry.
- Double-submit harus dicegah.

## 6. Struktur Layout yang Dikunci

### Desktop

- Navigasi ringkas di sisi kiri.
- Search dan kategori berada di atas katalog.
- Product grid memakai ruang utama secara fleksibel.
- Cart tetap terlihat di sisi kanan dengan lebar target 360–420px.
- Tidak memakai content cap sempit pada layar besar.

### Mobile

- Katalog tetap menjadi layar utama.
- Ringkasan cart muncul di bagian bawah setelah ada item.
- Checkout dibuka sebagai bottom sheet.
- Tidak ada horizontal scroll pada 360px.
- Tidak ada vertical scroll tambahan ketika isi katalog masih muat dan floating cart belum tampil.
- Seluruh interactive target minimum 44×44px.

## 7. State Wajib untuk Didesain

Setiap state perlu tersedia untuk desktop dan mobile jika perilakunya berbeda:

1. Loading produk dengan skeleton.
2. Ready dengan cart kosong.
3. Cart berisi satu item.
4. Cart multi-item dan quantity berubah.
5. Search tanpa hasil.
6. Tidak ada produk aktif.
7. Status pembayaran belum dipilih.
8. `Sudah` dengan pelanggan kosong dan dengan pelanggan terisi.
9. `Belum` dengan validasi nama pelanggan kosong.
10. Submitting/disabled untuk mencegah double-submit.
11. Server error dengan cart tetap tersimpan dan tombol retry.
12. Success confirmation.

## 8. Komponen Minimum

Desain dan beri nama variant/state untuk:

- App shell dan navigation item.
- Logo/brand area.
- Search field.
- Category chip.
- Product card dengan placeholder foto dan dengan foto final.
- Add-product control.
- Cart item dengan quantity stepper dan input integer positif langsung.
- Mobile cart summary bar.
- Mobile checkout bottom sheet.
- Payment status selector: default, paid, unpaid, focus, disabled.
- Text input: default, optional, required, error, disabled.
- Primary dan secondary button.
- Inline error dan retry action.
- Empty state, loading skeleton, dan success confirmation.
- Toast/status feedback bila benar-benar diperlukan.

Hindari membuat card baru jika grouping dapat diselesaikan dengan spacing, divider, atau hierarchy teks.

## 9. Arah Visual

### Karakter

- Minimal, bersih, hangat, profesional, dan premium.
- Produk dan transaksi menjadi fokus, bukan dekorasi.
- Hierarki dibentuk melalui ukuran, spacing, alignment, dan weight.

### Typography

- Gunakan `Circular Std` hanya jika file font berlisensi tersedia.
- Fallback aman: `Avenir Next`, lalu `Segoe UI`.
- Weight hanya 400, 500, dan 600.
- Body production minimum 14px; important control mobile minimum 16px.
- Angka finansial memakai tabular numerals.
- Astina hanya hadir melalui wordmark/logo resmi, bukan pada control operasional.

Jika AI memilih font alternatif, hasil wajib menyertakan nama font, lisensi, alasan pemilihan, fallback, dan mapping ukuran/weight. Font alternatif tidak otomatis disetujui.

### Color

- Canvas `#F3F2F1`.
- Soft surface `#FAF9F8`.
- Main surface `#FFFFFF`.
- Primary text `#252324`.
- Secondary text `#757173`.
- Border `#E8E5E3`.
- Brand accent nonteks `#E85C6D`.
- Accessible primary action `#BD4052` dengan teks putih.
- Hijau, amber, dan merah hanya untuk status sukses, piutang/peringatan, dan error.
- Semua pasangan teks/background minimum WCAG AA 4,5:1.

Jangan memakai warna berbeda untuk setiap kategori atau rasa. Jangan menampilkan seluruh palet brand secara bersamaan.

### Image

- Foto produk final belum tersedia.
- Gunakan placeholder netral kecil dan jujur.
- Jangan memakai stock photo, AI food image, gradient, atau warna rasa sebagai pengganti foto aktual.

### Hindari

- Semua teks bold.
- Rainbow palette.
- Gradient, glassmorphism, dan purple-tech aesthetic.
- Sidebar dominan.
- Icon berbentuk kotak yang terlihat seperti checkbox.
- Product card terlalu tinggi.
- Informasi produk berulang antara badge, kategori, dan nama.
- Widget, chart, table booking, restaurant seating, atau fitur dekoratif di luar scope.

## 10. Data Contoh

Gunakan data berikut agar semua output konsisten:

| Produk | Kategori | Harga |
|---|---|---:|
| Vanilla Pannacotta | Dessert | Rp20.000 |
| Earl Grey Pannacotta | Dessert | Rp20.000 |
| Bundling 3pcs | Bundling | Rp50.000 |
| Fresh Creamy Earl Grey | Minuman | Rp28.000 |
| Fresh Creamy Matcha | Minuman | Rp28.000 |
| Fresh Creamy Lotus | Minuman | Rp28.000 |

Kategori wajib: `Semua`, `Dessert`, `Minuman`, dan `Bundling`.

## 11. Referensi dan Batas Penggunaannya

- [POS for Restaurant — Table Booking & POS System UI/UX](https://www.behance.net/gallery/116691607/POS-for-Restaurant-Table-Booking-POS-System-UIUX)
- [ERP UI — POS & Restaurant Operations System](https://www.behance.net/gallery/231001803/ERP-UI-POS-Restaurant-Operations-System)

Gunakan sebagai referensi untuk typography, spacing, surface netral, information hierarchy, density, dan progressive disclosure. Jangan menyalin brand, asset, ilustrasi, susunan layar, atau fitur restoran secara 1:1.

## 12. Format Deliverable

### Direkomendasikan

- File/link Figma dengan edit access.
- Page `Foundations`: color, typography, spacing, radius, shadow, icon rules.
- Page `Components`: seluruh komponen dan variant/state pada bagian 8.
- Page `POS Desktop`: frame 1280px dan catatan perilaku 1920px.
- Page `POS Mobile`: frame 360px dan adaptasi 768px.
- Page `States`: seluruh state pada bagian 7.
- Prototype link untuk flow lunas, piutang, server error/retry, dan success.

### Handoff Teknis

- Ukuran frame, grid, spacing, dan breakpoint.
- Token warna dan typography yang dapat diterjemahkan ke CSS variables.
- Nama component/variant yang konsisten.
- Asset export SVG/PNG beserta lisensi dan sumber.
- Catatan responsive behavior, focus, hover, pressed, disabled, dan error.

Screenshot atau HTML boleh menyertai hasil, tetapi bukan pengganti source design dan specification. Kode hasil generator tidak otomatis menjadi kode production.

## 13. Acceptance Checklist Desain

- [ ] Flow terkunci tetap dapat diselesaikan tanpa langkah baru yang tidak perlu.
- [ ] Tidak ada status pembayaran yang dipilih otomatis.
- [ ] Checkout tersembunyi ketika cart kosong.
- [ ] Nama pelanggan jelas opsional untuk `Sudah` dan wajib untuk `Belum`.
- [ ] Search dan empat kategori konsisten pada seluruh breakpoint.
- [ ] Product card ringkas dan tidak mengulang informasi.
- [ ] Mobile 360px tidak memiliki horizontal scroll.
- [ ] Mobile tidak menyisakan padding bawah yang memicu vertical scroll ketika floating cart belum tampil.
- [ ] Quantity stepper dan input langsung hanya menerima integer positif mulai dari 1.
- [ ] Touch target minimum 44×44px.
- [ ] Teks dan control memenuhi WCAG AA.
- [ ] Hierarki tidak bergantung pada semua teks bold atau banyak warna.
- [ ] Loading, empty, error, disabled, submitting, dan success berbeda jelas.
- [ ] Font dan asset memiliki sumber/lisensi yang dapat dipakai.
- [ ] Semua keputusan yang berbeda dari brief diberi catatan dan alasan.

Gate B disetujui pada 23 Juli 2026 setelah output final direview dan lima transaksi umum selesai dengan median 7 detik.

## 14. Prompt Ringkas untuk AI Design

```text
Sempurnakan visual Parissa POS berdasarkan seluruh file handoff yang diberikan. Pertahankan flow dan business rules; jangan menambah fitur. Buat desain minimal, hangat, premium, dan operasional dengan surface netral, satu keluarga aksen merah Parissa, typography weight 400/500/600, serta WCAG AA. Deliver desktop 1280px, mobile 360px, adaptasi 768px/1920px, mini design system, seluruh state wajib, dan prototype flow lunas/piutang/error-retry/success. Jelaskan setiap penyimpangan dari brief. Jangan gunakan stock/AI food image atau menyalin referensi Behance secara 1:1.
```
