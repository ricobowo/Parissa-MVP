<!--
@file 06-Design-Brief.md
@version 1.2.3
@description Arahan desain dan batas visual MVP Parissa POS.
-->

# 06 — Design Brief

**Status:** Gate A disetujui 22 Juli 2026.

**Fase aktif:** Phase 3 — Core POS; arah visual dikunci oleh Gate B dan siap diimplementasikan di atas fondasi Gate C.

## Design Goal

Membuat POS yang terasa cepat, tenang, dan dipercaya—bukan dashboard SaaS generik. Desain harus membantu Kasir menyelesaikan transaksi, bukan memamerkan jumlah widget.

## Karakter

- Bersih.
- Hangat tetapi profesional.
- Berorientasi produk.
- Terbaca dalam kondisi toko.
- Tidak dekoratif berlebihan.

## Hierarki Layar

### POS

1. Product grid.
2. Cart dan total.
3. Status pembayaran.
4. Customer conditional input.
5. Submit.

### Dashboard

1. CTA Transaksi Baru.
2. Omzet hari ini.
3. Gross profit, transaksi, dan piutang.
4. Lima transaksi terbaru.

## Layout Rules

- Mobile baseline 360px.
- Tablet baseline 768px.
- Desktop baseline 1280px dan verify 1920px.
- Tidak ada content cap 1.040px untuk dashboard utama.
- Desktop POS: product area fleksibel + cart 360–420px.
- Mobile hanya menambah ruang bawah katalog ketika floating cart summary sedang tampil.
- Touch target minimum 44×44px.
- Gunakan spacing scale konsisten 4/8/12/16/24/32.

## Visual Rules

- Light mode sebagai release target.
- Maksimal satu brand accent dan tiga semantic colors.
- Maksimal dua font families.
- Body minimum 14px; important control 16px pada mobile.
- Angka finansial memakai tabular numerals, tidak semua teks mono.
- Card hanya ketika grouping membantu; hindari setiap elemen menjadi card.
- Chart tidak masuk MVP awal.
- Animasi dibatasi ke feedback submit dan state transition.

## Keputusan Visual Phase 1

- Font UI adalah `Circular Std` jika asset berlisensi tersedia, dengan fallback `Avenir Next` dan `Segoe UI`.
- Bobot UI dibatasi pada 400, 500, dan 600. Hierarki tidak dibangun dengan membuat semua teks bold.
- Surface putih/abu netral mendominasi; satu keluarga merah menjadi brand accent: `#E85C6D` untuk indikator nonteks dan `#BD4052` untuk action/pilihan aktif dengan teks putih yang memenuhi AA.
- Warna hijau, amber, dan merah hanya dipakai untuk makna status, bukan dekorasi atau kategori.
- Placeholder foto produk berukuran kecil dan netral; rasa/kategori tidak mendapat warna tersendiri.
- Empty cart hanya menampilkan petunjuk ringkas. Status pembayaran, pelanggan, total, dan submit muncul setelah ada item.
- Status pembayaran tidak memiliki default. Kasir wajib memilih `Sudah` atau `Belum` secara eksplisit.

Referensi eksternal dipakai sebagai arahan prinsip tipografi, ruang, palet netral, dan progressive disclosure. Komposisi serta identitas visual tidak disalin.

## Asset Checklist

Asset yang belum tersedia menggunakan placeholder netral dan berlabel jelas. Placeholder tidak boleh menyerupai asset brand final atau memakai gradient dekoratif sebagai pengganti foto.

- [ ] Logo utama dan versi satu warna.
- [ ] Foto 6 produk, minimal 1200px, rasio konsisten.
- [ ] Brand primary color.
- [ ] Nama kategori final.
- [ ] Copy CTA dan success message final.

## Anti-Patterns

- Dashboard dengan enam atau lebih KPI.
- Sidebar kosong atau terlalu dominan.
- Gradient sebagai pengganti foto produk.
- Dark surfaces dengan kontras terlalu rendah.
- Filter dan widget yang tidak mengubah data.
- Dev tools/tweaks tampil di production.
- Legend terpotong dan chart berwarna tanpa kebutuhan.

## Validation

- Screenshot review di 360/768/1280/1920px.
- Keyboard navigation dan focus visible.
- WCAG AA untuk teks dan controls.
- Uji transaksi di ponsel menggunakan satu tangan.
