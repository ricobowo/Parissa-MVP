<!--
@file 07-Acceptance-Criteria.md
@version 1.2.2
@description Acceptance criteria dan release gate MVP Parissa POS.
-->

# 07 — Acceptance Criteria

**Status:** Gate A disetujui 22 Juli 2026.

**Fase aktif:** Phase 2 — Engineering Foundation; Gate C menjadi approval berikutnya.

## Authentication

- [ ] User aktif dapat login dengan kredensial valid.
- [ ] Kredensial salah menampilkan pesan Bahasa Indonesia.
- [ ] User inactive dan anonymous tidak dapat membuka aplikasi.
- [ ] Kasir tidak dapat mengakses product mutation atau void.

## Products

- [ ] Owner dapat membuat, mengubah, dan menonaktifkan produk valid.
- [ ] Form menolak harga/HPP negatif dan nama kosong.
- [ ] Produk nonaktif tidak muncul di POS baru.
- [ ] Histori item lama tetap menampilkan snapshot produk.

## POS

- [ ] Cart tidak dapat disubmit dalam keadaan kosong.
- [ ] Checkout detail tidak ditampilkan saat cart kosong.
- [ ] Status pembayaran tidak memiliki default dan wajib dipilih eksplisit.
- [ ] Quantity stepper dan input langsung hanya menerima integer positif mulai dari 1.
- [ ] Mobile tidak memiliki vertical scroll tambahan ketika isi katalog masih muat dan floating cart belum tampil.
- [ ] Nama pelanggan wajib saat status `Belum`.
- [ ] Total client dan server sesuai fixture.
- [ ] Satu submit menghasilkan satu transaksi dan semua item.
- [ ] Double-click submit tidak membuat duplikat.
- [ ] Cart dipertahankan jika server gagal.
- [ ] Success state menampilkan nomor, total, dan status.
- [ ] Median transaksi umum <30 detik pada UAT.

## Payment & Receivables

- [ ] Semua transaksi `Belum` aktif tampil di piutang.
- [ ] Mark as paid memperbarui dashboard tanpa reload manual.
- [ ] `paid_at` dan `paid_by` tercatat.
- [ ] Transaksi yang dibuat langsung lunas mengisi `paid_at` dan `paid_by` saat create.
- [ ] Owner-only mark as unpaid membersihkan data pembayaran, mengoreksi agregat, dan mencatat audit.
- [ ] Piutang >3 hari ditandai Overdue.
- [ ] Void tidak tampil sebagai piutang aktif.

## History & Void

- [ ] Search nomor/nama dan filter tanggal/status bekerja.
- [ ] Owner dapat void dengan alasan.
- [ ] Kasir tidak dapat void.
- [ ] Tidak tersedia hard delete.
- [ ] Create, payment change, dan void tercatat di audit log.

## Dashboard

- [ ] Empat metrik cocok dengan query manual/database fixture.
- [ ] Void dikecualikan.
- [ ] Omzet, HPP, dan gross profit hanya mengakui transaksi aktif `Sudah` pada tanggal `paid_at` di Asia/Jakarta.
- [ ] Transaksi `Belum` menghasilkan omzet/HPP/gross profit Rp0 dan masuk total piutang aktif.
- [ ] Pelunasan piutang masuk agregat tanggal pembayaran, bukan tanggal transaksi awal.
- [ ] Loading, error, dan empty state berbeda secara jelas.
- [ ] CTA Transaksi Baru terlihat tanpa scroll.

## UI & Accessibility

- [ ] Tidak ada horizontal scroll pada 360px.
- [ ] Layout menggunakan ruang secara proporsional pada 1920px.
- [ ] Touch target minimum 44px.
- [ ] Keyboard flow dan focus state berfungsi.
- [ ] Contrast memenuhi WCAG AA.
- [ ] Tidak ada text/legend/control terpotong.
- [ ] UI memakai satu keluarga warna brand; warna lain hanya memiliki makna semantik.
- [ ] Bobot font 400/500/600 membentuk hierarki tanpa membuat seluruh UI bold.

## Engineering Quality Gate

- [ ] Lint lulus.
- [ ] Type-check lulus.
- [ ] Unit test lulus.
- [ ] Integration test lulus.
- [ ] E2E lulus.
- [ ] Production build lulus.
- [ ] RLS tests lulus.
- [ ] Tidak ada secret atau personal transcript di repository.
- [ ] Backup/restore dan rollback diuji.

## UAT Scenarios

1. Transaksi lunas satu produk.
2. Transaksi lunas multi-item.
3. Transaksi belum dibayar dengan pelanggan.
4. Menandai piutang lunas.
5. Owner melakukan void.

Release hanya dilakukan setelah seluruh P0 dan quality gate selesai.
