<!--
@file 02-MVP-Scope.md
@version 1.1.0
@description Batas scope P0, P1, dan fitur yang ditunda dari MVP Parissa POS.
-->

# 02 — MVP Scope

**Status:** Gate A disetujui dan P0 dibekukan pada 22 Juli 2026.

**Fase aktif:** Phase 1 — UX Prototype.

## P0 — Wajib untuk Release

### Foundation

- Login email/password.
- Role Owner dan Kasir.
- RLS dan inactive-user guard.
- Bahasa Indonesia.
- Responsive 360px–1920px.

### Produk

- List produk aktif.
- Owner add/edit/deactivate.
- Harga jual dan HPP standar.
- Gambar produk opsional.

### POS

- Quick-sale grid.
- Multi-item cart.
- Quantity controls.
- Status `Sudah`/`Belum`.
- Customer conditional validation.
- Transaction total dan HPP snapshot.
- Submit atomik dan confirmation state.

### Operasional Minimum

- Riwayat transaksi.
- Search nomor transaksi/nama pelanggan.
- Filter tanggal/status.
- Mark piutang as paid.
- Void Owner-only dengan alasan.
- Audit create/payment/void.
- Dashboard empat metrik dan transaksi terbaru.
- Omzet/HPP/gross profit harian berdasarkan `paid_at`; total piutang aktif dilaporkan terpisah.

## P1 — Kandidat Setelah MVP Stabil

- Pre-order.
- Export CSV/XLSX sederhana.
- Customer directory ringan.
- Gambar produk wajib.
- Bilingual ID/EN.
- PWA installable tanpa offline mutation.

## Ditunda

- Recipe/BOM editor dan pricing calculator.
- Inventory bahan/finished goods.
- Purchase, supplier, batching, expiry.
- Production planner dan waste.
- CRM/label/VIP.
- WhatsApp/Fonnte.
- Advanced charts dan monthly comparison.
- Flexible role editor.
- Dark mode dan density settings.
- Migrasi transaksi historis; rekonsiliasi dan import ditangani setelah MVP stabil.

## Aturan Anti-Scope-Creep

Fitur baru hanya masuk P0 jika:

1. Tanpa fitur tersebut transaksi utama tidak dapat diselesaikan; atau
2. Ada risiko akurasi/keamanan material; dan
3. Fitur pengganti dengan effort setara dikeluarkan atau timeline disetujui ulang.

## Release Boundary

MVP berakhir pada transaksi, pembayaran, histori, dan ringkasan. Produksi dan supply chain adalah domain fase berikutnya.
