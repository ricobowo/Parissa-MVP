<!--
@file product-facts.md
@version 0.1.0
@description Fakta produk yang digunakan sebagai dasar prototype Parissa POS Phase 1.
-->

# Product Facts — Parissa POS Prototype

## Sources

- `Document/PRD-Parissa-MVP.md` v3.1.
- Tujuh dokumen pada `Document/MVP/`.
- `Document/Project-Restart-Plan.md`.
- Brand guideline Owner: `2019-12-parissa final.pdf`.
- Referensi layout: Behance “POS for Restaurant | Table Booking POS System | UI/UX”.

## Current State

- Gate A disetujui 22 Juli 2026.
- Fase aktif adalah Phase 1 — UX Prototype.
- Prototype bukan aplikasi production dan tidak terhubung ke database.
- Gate B belum disetujui; engineering foundation belum dimulai.

## Primary Users

- Kasir: mencatat transaksi dengan cepat.
- Owner: mengelola produk, riwayat, piutang, void, dan ringkasan bisnis.

## Prototype Products

| Product | Category | Price |
|---|---|---:|
| Vanilla Pannacotta | Dessert | Rp20.000 |
| Earl Grey Pannacotta | Dessert | Rp20.000 |
| Bundling 3pcs | Bundling | Rp50.000 |
| Fresh Creamy Earl Grey | Minuman | Rp28.000 |
| Fresh Creamy Matcha | Minuman | Rp28.000 |
| Fresh Creamy Lotus | Minuman | Rp28.000 |

Harga berasal dari Appendix A PRD v3.1 dan dipakai sebagai data simulasi UX. HPP tidak ditampilkan pada POS Kasir.

## Flow Under Test

1. Memilih produk.
2. Mengubah quantity.
3. Memilih status `Sudah` atau `Belum`.
4. Memasukkan nama pelanggan jika `Belum`.
5. Menyimpan transaksi tanpa double-submit.
6. Melihat nomor transaksi, total, dan status pada confirmation state.
7. Menangani server error tanpa kehilangan cart, lalu retry.

## Success Target

- Transaksi lunas umum selesai dengan maksimal tiga aksi utama.
- Median penyelesaian transaksi kurang dari 30 detik pada UAT.
- Tidak ada horizontal scroll pada 360px.
- Desktop menggunakan area 1280px secara proporsional.
