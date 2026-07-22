<!--
@file brand-spec.md
@version 0.1.0
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
| Exclusive Blue | `#5A72C1` | Aksen sekunder terbatas |
| Exclusive Red | `#E85C6D` | Primary action dan pilihan aktif |
| Exclusive Dark | `#5A5758` | Elemen brand gelap |
| Friendly Yellow | `#F7EDB7` | Highlight dan permukaan hangat |
| Friendly Lilac | `#EBB9E0` | Penanda rasa/kategori terbatas |
| Friendly Coral | `#F57C5B` | Aksen rasa/kategori terbatas |

Untuk UI POS, hanya `#E85C6D` yang menjadi brand action utama. Warna lain dipakai sebagai highlight atau penanda kategori, bukan sebagai CTA yang bersaing.

## Typography

- UI/body: `Circular Std`; fallback prototype `Avenir Next`, `Helvetica Neue`, sans-serif.
- Brand script: `Astina`, hanya untuk wordmark/logo dan aksen sangat terbatas.
- Nilai finansial menggunakan angka tabular dari font UI.
- Script tidak digunakan untuk tombol, tabel, field, atau informasi operasional.

## Character

- Bersih, hangat, ramah, dan tetap premium.
- Produk menjadi pusat perhatian; elemen dekoratif tidak boleh mengganggu kecepatan transaksi.
- Latar terang, type gelap, satu CTA utama, dan semantic color yang mudah dibedakan.
- Hindari gradient, glassmorphism, purple-tech aesthetic, icon dekoratif, dan card berlapis tanpa fungsi.

## Reference Boundary

Referensi Behance “Restaurant Table Booking POS” dipakai untuk pola structural berikut:

- navigasi desktop yang ringkas;
- search dan kategori di atas product grid;
- product grid sebagai area utama;
- cart/checkout yang tetap terlihat pada desktop.

Warna, font, brand, table booking, restaurant seating, dan fitur di luar P0 tidak disalin.

## Signature Detail

Gunakan friendly yellow sebagai bidang highlight tipis dan coral-red sebagai satu primary action. Logo resmi ditempatkan pada header putih agar karakter tulisan tangan tetap terbaca tanpa mengurangi kejelasan kontrol operasional.
