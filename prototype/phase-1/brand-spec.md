<!--
@file brand-spec.md
@version 0.2.0
@description Spesifikasi brand untuk prototype UX Parissa POS Phase 1.
-->

# Parissa — Brand Spec Prototype

> Dikumpulkan: 22 Juli 2026
>
> Sumber utama: `2019-12-parissa final.pdf` dari Owner
>
> Asset lengkap: Sebagian; logo dan guideline tersedia, foto produk belum tersedia

## Core Assets

### Logo

- File prototype: `assets/parissa-logo.png`.
- Sumber: logo resmi pada halaman 2 brand guideline, dirender langsung dari PDF dan dipotong tanpa menggambar ulang.
- Gunakan pada latar putih atau sangat terang.
- Jangan diregangkan, digambar ulang, diberi outline, atau dipakai sebagai pola dekoratif.
- Versi gelap/transparan belum diekstrak; prototype menggunakan satu versi hitam resmi.

### Foto Produk

- Foto produk aktual belum tersedia.
- Prototype menggunakan placeholder netral dengan label “Foto produk belum tersedia”.
- Jangan mengganti foto produk Parissa dengan stock photo atau ilustrasi generik.
- Sebelum visual final, dibutuhkan foto enam produk dengan rasio dan pencahayaan konsisten.

## Palette

Nilai berikut diambil dari bidang warna brand guideline yang dirender; gunakan sebagai token prototype, bukan sebagai pengganti master file desain.

| Token | HEX | Penggunaan |
|---|---|---|
| Exclusive Red | `#E85C6D` | Aksen brand nonteks dan asset pemasaran |
| Operational Red | `#BD4052` | Primary action/pilihan aktif dengan teks putih |
| Exclusive Dark | `#5A5758` | Elemen brand gelap terbatas |
| Exclusive Blue | `#5A72C1` | Focus ring jika lolos kontras |
| Friendly Yellow | `#F7EDB7` | Asset pemasaran; bukan permukaan operasional default |
| Friendly Lilac | `#EBB9E0` | Asset pemasaran; tidak dipakai sebagai kategori POS |
| Friendly Coral | `#F57C5B` | Asset pemasaran; bukan CTA kedua |

### Keputusan warna UI

UI POS menggunakan palet operasional minimal:

- Canvas `#F3F2F1`, surface lembut `#FAF9F8`, dan surface utama `#FFFFFF`.
- Teks utama `#252324`, teks sekunder `#757173`, border `#E8E5E3`.
- Satu keluarga merah: `#E85C6D` untuk indikator nonteks dan `#BD4052` untuk primary action/pilihan aktif dengan teks putih.
- Hijau, amber, dan merah hanya untuk status sukses, peringatan/piutang, dan error.
- Kategori serta placeholder foto tidak dibedakan dengan warna. Label dan struktur navigasi sudah cukup.

Target proporsi visual adalah dominan netral, satu keluarga aksen brand, lalu semantic color hanya ketika status memang perlu dibaca. Shade operasional `#BD4052` memberi kontras 5,23:1 terhadap putih; warna guideline `#E85C6D` hanya 3,40:1 sehingga tidak dipakai di belakang teks kecil. Palet lengkap brand tetap dipertahankan untuk kebutuhan pemasaran, bukan ditampilkan bersamaan di layar POS.

## Typography

- UI/body: `Circular Std` jika file font berlisensi disediakan; fallback prototype `Avenir Next`, `Segoe UI`, sans-serif.
- Brand script: `Astina`, hanya untuk wordmark/logo dan aksen sangat terbatas.
- Nilai finansial menggunakan angka tabular dari font UI.
- Script tidak digunakan untuk tombol, tabel, field, atau informasi operasional.

### Keputusan bobot dan hierarki

- `400` untuk body, helper, dan metadata.
- `500` untuk label, nama produk, input, dan tombol sekunder.
- `600` untuk heading, total, CTA utama, dan state aktif.
- Hindari `700–900`; hierarki dibentuk dengan ukuran, spacing, dan posisi.
- Body minimum 14px pada aplikasi production. Ukuran lebih kecil di file perbandingan hanya untuk mensimulasikan layar dalam frame.

## Character

- Bersih, hangat, ramah, dan tetap premium.
- Produk menjadi pusat perhatian; elemen dekoratif tidak boleh mengganggu kecepatan transaksi.
- Latar terang, type gelap, satu CTA utama, dan semantic color yang mudah dibedakan.
- Hindari gradient, glassmorphism, purple-tech aesthetic, icon dekoratif, dan card berlapis tanpa fungsi.

## Reference Boundary

Referensi Behance “Restaurant Table Booking POS” dan “ERP UI — POS & Restaurant Operations System” dipakai untuk prinsip berikut:

- navigasi desktop yang ringkas;
- search dan kategori di atas product grid;
- product grid sebagai area utama;
- cart/checkout yang tetap terlihat pada desktop.
- palet permukaan netral dan aksen tunggal;
- hierarchy melalui ruang, ukuran, dan progressive disclosure;
- tipografi sans-serif dengan bobot ringan–menengah.

Warna, font, brand, table booking, restaurant seating, dan fitur di luar P0 tidak disalin.

Tautan sumber untuk review agent berikutnya:

- [POS for Restaurant — Table Booking & POS System UI/UX](https://www.behance.net/gallery/116691607/POS-for-Restaurant-Table-Booking-POS-System-UIUX)
- [ERP UI — POS & Restaurant Operations System](https://www.behance.net/gallery/231001803/ERP-UI-POS-Restaurant-Operations-System)

## Signature Detail

Logo resmi pada permukaan putih dan satu keluarga merah untuk action sudah cukup membawa identitas Parissa. Warna ramah lainnya tidak dipaksakan masuk ke layar operasional.
