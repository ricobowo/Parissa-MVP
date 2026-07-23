<!--
@file README.md
@version 0.5.1
@description Cara meninjau prototype UX Parissa POS Phase 1.
-->

# Phase 1 — UX Prototype

Artefak ini memvalidasi flow POS sebelum engineering foundation dan kini menjadi acuan implementasi Core POS Phase 3.

## Files

- `layout-variations.html`: perbandingan setara A — Speed First, B — Guided Checkout, dan C — Compact Operations.
- `pos-prototype.html`: prototype interaktif alpha, memakai A pada desktop dan progressive checkout B pada mobile.
- `brand-spec.md`: sumber logo, warna, font, dan batas penggunaan brand.
- `design-handoff.md`: brief siap pakai untuk AI Design atau UI designer lain tanpa mengubah flow tervalidasi.
- `design-import-notes.md`: provenance dan keputusan adaptasi mockup eksternal 23 Juli 2026.
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

Flow utama sudah diuji manual oleh Owner dan dinyatakan aman pada 22 Juli 2026. Perbaikan kontras, densitas, target sentuh, navigasi, empty state, padding mobile kondisional, dan input quantity integer positif diterapkan pada 23 Juli 2026.

Validasi waktu pada 23 Juli 2026 menghasilkan 4, 8, 9, 7, dan 3 detik: median 7 detik, rata-rata 6,2 detik, dan seluruh percobaan berada di bawah target 30 detik. Owner menyetujui Gate B pada 23 Juli 2026; setelah Gate C disetujui pada tanggal yang sama, prototype ini menjadi acuan flow dan visual untuk Phase 3.

Mockup eksternal terbaru telah diadaptasi ke `pos-prototype.html` pada 23 Juli 2026. Prototype utama tetap mandiri dan tidak membutuhkan runtime tool desain.

## External Design Handoff

Gunakan `design-handoff.md` sebagai entry point. Designer tetap perlu menerima seluruh artefak sumber yang tercantum di dalamnya; file handoff tidak menggantikan PRD atau business rules.

## Limitations

- Semua data tersimpan di memory browser dan hilang setelah refresh.
- Login, database, RLS, audit, serta dashboard belum diimplementasikan.
- Foto produk menggunakan placeholder sampai asset resmi tersedia.
- Font `Circular Std` belum dibundel; browser memakai fallback lokal sampai file berlisensi tersedia.
- Prototype ini tidak boleh dipakai sebagai kode production.
