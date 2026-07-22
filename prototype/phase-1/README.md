<!--
@file README.md
@version 0.3.0
@description Cara meninjau prototype UX Parissa POS Phase 1.
-->

# Phase 1 — UX Prototype

Artefak ini memvalidasi flow POS sebelum engineering foundation dimulai.

## Files

- `layout-variations.html`: perbandingan setara A — Speed First, B — Guided Checkout, dan C — Compact Operations.
- `pos-prototype.html`: prototype interaktif alpha, memakai A pada desktop dan progressive checkout B pada mobile.
- `brand-spec.md`: sumber logo, warna, font, dan batas penggunaan brand.
- `design-handoff.md`: brief siap pakai untuk AI Design atau UI designer lain tanpa mengubah flow tervalidasi.
- `product-facts.md`: fakta produk dan skenario yang tidak boleh diasumsikan ulang.
- `assets/parissa-logo.png`: ekstraksi raster logo resmi dari PDF brand guideline.

## Open Locally

Buka file HTML langsung dari Finder atau browser. Prototype tidak membutuhkan server, dependency, login, atau koneksi database.

## Required Review

1. Selesaikan transaksi lunas satu produk.
2. Selesaikan transaksi piutang dan pastikan nama pelanggan wajib.
3. Pilih skenario server error, simpan, lalu retry.
4. Bandingkan pengalaman pada lebar 360px dan 1280px.
5. Pastikan status pembayaran tidak terpilih otomatis dan checkout tersembunyi saat cart kosong.

Flow utama sudah diuji manual oleh Owner dan dinyatakan aman pada 22 Juli 2026. Gate B tetap terbuka sampai visual final hasil handoff direview dan target waktu transaksi tervalidasi.

## External Design Handoff

Gunakan `design-handoff.md` sebagai entry point. Designer tetap perlu menerima seluruh artefak sumber yang tercantum di dalamnya; file handoff tidak menggantikan PRD atau business rules.

## Limitations

- Semua data tersimpan di memory browser dan hilang setelah refresh.
- Login, database, RLS, audit, serta dashboard belum diimplementasikan.
- Foto produk menggunakan placeholder sampai asset resmi tersedia.
- Font `Circular Std` belum dibundel; browser memakai fallback lokal sampai file berlisensi tersedia.
- Prototype ini tidak boleh dipakai sebagai kode production.
