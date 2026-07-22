<!--
@file 03-Business-Rules.md
@version 1.1.0
@description Aturan bisnis dan formula resmi untuk MVP Parissa POS.
-->

# 03 — Business Rules

**Status:** Gate A disetujui 22 Juli 2026.

**Fase aktif:** Phase 1 — UX Prototype.

## 1. Transaksi

- Transaksi memiliki header dan satu atau lebih item.
- Transaksi tidak boleh disimpan tanpa item.
- Quantity harus bilangan bulat positif.
- Harga dan HPP item menggunakan snapshot saat transaksi dibuat.
- Perubahan harga produk tidak mengubah histori.
- Submit header dan item harus atomik.
- Client-generated idempotency key mencegah double-submit.

## 2. Pelanggan

- Transaksi `Sudah`: nama pelanggan opsional dan default tampilan “Pelanggan Umum”.
- Transaksi `Belum`: nama pelanggan wajib.
- Nomor telepon opsional, tetapi direkomendasikan untuk piutang.

## 3. Pembayaran dan Piutang

- Status valid: `Sudah` dan `Belum`.
- `Overdue` adalah status turunan untuk transaksi `Belum` lebih dari tiga hari.
- Mengubah `Belum` → `Sudah` mencatat `paid_at` dan `paid_by`.
- Transaksi yang dibuat langsung `Sudah` mengisi `paid_at` dan `paid_by` saat create.
- Perubahan `Sudah` → `Belum` hanya Owner, membersihkan `paid_at`/`paid_by`, mengoreksi agregat tanggal pembayaran sebelumnya, dan harus diaudit.
- Tanggal pengakuan finansial adalah tanggal `paid_at` dalam timezone `Asia/Jakarta`.

## 4. Void

- Tidak ada hard delete transaksi.
- Hanya Owner dapat melakukan void.
- Void wajib alasan non-kosong.
- Void mencatat `voided_at`, `voided_by`, dan `void_reason`.
- Transaksi void tidak masuk omzet, profit, jumlah transaksi aktif, atau piutang.

## 5. Formula

```text
item_subtotal = quantity × unit_price_snapshot
item_cost = quantity × unit_cost_snapshot
transaction_total = SUM(item_subtotal)
transaction_cost = SUM(item_cost)
```

Untuk transaksi aktif dan lunas:

```text
revenue = transaction_total
gross_profit = transaction_total - transaction_cost
```

Untuk transaksi aktif dan belum dibayar:

```text
revenue = 0
recognized_cost = 0
gross_profit = 0
receivable = transaction_total
```

Untuk transaksi void:

```text
revenue = 0
cost = 0
gross_profit = 0
```

## 6. Margin vs Markup

```text
gross_margin_pct = ((price - cost) / price) × 100
markup_pct = ((price - cost) / cost) × 100
```

- UI tidak boleh memakai label generik “Margin” jika maksudnya markup.
- Dashboard menggunakan gross profit, bukan markup.
- Dashboard hanya mengakui omzet, HPP, dan gross profit transaksi lunas berdasarkan `paid_at`; piutang ditampilkan terpisah.
- Gross margin produk tidak dihitung jika harga jual ≤0.

## 7. Rupiah dan Waktu

- Nilai finansial disimpan dalam Rupiah.
- UI memakai format `Rp 1.000.000`.
- Waktu database menggunakan `timestamptz`.
- Tanggal bisnis ditampilkan dalam timezone `Asia/Jakarta`.
- `business_date` tetap menyimpan tanggal transaksi, sedangkan tanggal pengakuan finansial berasal dari `paid_at`.

## 8. Scope Stok

Tidak ada mutasi stok pada MVP. Ketika inventory dibangun, model harus memisahkan bahan baku dan barang jadi agar bahan tidak terpotong saat produksi dan penjualan sekaligus.
