<!--
@file 01-Product-Brief.md
@version 1.1.2
@description Ringkasan produk dan keputusan inti MVP Parissa POS.
-->

# 01 — Product Brief

**Baseline:** PRD MVP v3.1 — Gate A disetujui 22 Juli 2026.

**Fase aktif:** Phase 3 — Core POS; Gate C disetujui 23 Juli 2026.

## Ringkasan

Parissa POS MVP adalah alat pencatatan penjualan untuk bisnis dessert dan minuman premium Parissa di Bandung. Produk ini membantu Owner dan Kasir mencatat transaksi dengan cepat serta melihat omzet, gross profit, dan piutang yang dapat dipercaya.

## Masalah yang Diselesaikan

- Input Airtable memerlukan 2–3 menit per transaksi.
- Data penjualan dan profit tersebar.
- Implementasi sebelumnya terlalu luas dan belum tervalidasi.
- Pengguna membutuhkan POS yang bekerja baik di ponsel, bukan business suite besar.

## Pengguna Utama

- **Owner:** mengelola produk, melihat dashboard, piutang, riwayat, dan void.
- **Kasir:** mencatat transaksi dan memperbarui status pembayaran.

## Value Proposition

> Catat penjualan Parissa dalam kurang dari 30 detik dan dapatkan angka usaha harian yang dapat dipercaya.

## Job to Be Done Utama

Ketika ada pembelian, Kasir ingin memilih produk, jumlah, dan status pembayaran dengan cepat agar transaksi tercatat tanpa menghambat pelayanan.

## Keputusan Produk

- Bahasa MVP: Bahasa Indonesia.
- Light mode terlebih dahulu.
- Produk bundling menjadi SKU tersendiri.
- Nama pelanggan opsional untuk transaksi lunas, wajib untuk piutang.
- HPP disimpan sebagai snapshot pada item transaksi.
- Margin resmi adalah gross margin terhadap harga jual.
- Omzet, HPP, dan gross profit diakui pada tanggal pembayaran (`paid_at`).
- Piutang dilaporkan terpisah sampai pembayaran diterima.
- Transaksi historis ditunda dari release awal dan dapat dimigrasikan setelah rekonsiliasi.
- Tidak ada inventory/batching pada MVP.

## North Star dan Guardrail

- **North star:** median waktu transaksi selesai <30 detik.
- **Guardrail:** selisih omzet/HPP/profit <1% dari manual.
- **Guardrail:** tidak ada transaksi ganda akibat double-submit.

## Source of Truth

- PRD: `Document/PRD-Parissa-MVP.md` v3.1.
- Scope: `Document/MVP/02-MVP-Scope.md`.
- Acceptance: `Document/MVP/07-Acceptance-Criteria.md`.
