/**
 * @file transaction.ts
 * @version 0.1.0
 * @description Schema input dan formula finansial tunggal transaksi.
 */

import { z } from "zod";

// Hanya dua status pembayaran yang valid pada P0. "Overdue" bukan bagian dari
// enum ini karena statusnya turunan (piutang "Belum" berumur >3 hari), bukan
// nilai yang tersimpan langsung di kolom `payment_status`.
export const paymentStatusSchema = z.enum(["Sudah", "Belum"]);

// Input dari client hanya berupa productId + quantity. Harga, HPP, dan nama
// produk sengaja TIDAK diterima dari client di sini: nilai snapshot tersebut
// harus diambil ulang oleh server/RPC `create_transaction` dari tabel
// `products` saat transaksi dibuat, agar client tidak bisa memanipulasi harga.
export const transactionItemInputSchema = z.object({
  productId: z.uuid(),
  quantity: z.number().int().positive().max(999),
});

/**
 * Boundary validasi untuk pembuatan transaksi baru (dipakai frontend sebelum
 * memanggil RPC `create_transaction`, dan dapat dipakai ulang di test).
 *
 * - `idempotencyKey` dibuat di client (bukan server) supaya double-submit
 *   (mis. klik ganda pada tombol submit) tetap terdeteksi sebagai request
 *   yang sama walau request pertama belum sempat direspons.
 * - `customerName` wajib diisi hanya jika `paymentStatus` adalah "Belum"
 *   (piutang); untuk "Sudah" nama pelanggan opsional dan UI menampilkan
 *   default "Pelanggan Umum". Aturan ini ditegakkan lewat `superRefine`
 *   karena kewajibannya bergantung pada field lain, bukan validasi per-field.
 */
export const createTransactionInputSchema = z
  .object({
    idempotencyKey: z.uuid(),
    paymentStatus: paymentStatusSchema,
    customerName: z.string().trim().max(120).nullable().optional(),
    customerPhone: z.string().trim().max(40).nullable().optional(),
    notes: z.string().trim().max(500).nullable().optional(),
    items: z.array(transactionItemInputSchema).min(1).max(100),
  })
  .superRefine((value, context) => {
    if (value.paymentStatus === "Belum" && !value.customerName) {
      context.addIssue({
        code: "custom",
        path: ["customerName"],
        message: "Nama pelanggan wajib untuk transaksi piutang.",
      });
    }
  });

export type CreateTransactionInput = z.infer<
  typeof createTransactionInputSchema
>;

// `totalAmount`/`totalCost` di sini adalah hasil hitung server (SUM dari
// snapshot item), bukan nilai yang dipercaya begitu saja dari client.
export interface TransactionFinancialInput {
  paymentStatus: z.infer<typeof paymentStatusSchema>;
  totalAmount: number;
  totalCost: number;
  isVoid: boolean;
}

export interface TransactionFinancialResult {
  revenue: number;
  cost: number;
  grossProfit: number;
  receivable: number;
}

/**
 * Satu-satunya sumber kebenaran untuk aturan pengakuan finansial transaksi
 * (lihat 03-Business-Rules.md bagian Formula). Dipakai bersama oleh
 * agregat dashboard maupun test, supaya definisi omzet/HPP/gross profit/
 * piutang tidak pernah didefinisikan ulang secara berbeda di tempat lain.
 *
 * Urutan pengecekan sengaja void lebih dulu daripada payment status: transaksi
 * void selalu dikeluarkan dari seluruh agregat finansial apa pun status
 * pembayarannya sebelum dibatalkan.
 */
export function calculateTransactionFinancials(
  transaction: TransactionFinancialInput,
): TransactionFinancialResult {
  if (transaction.isVoid) {
    return { revenue: 0, cost: 0, grossProfit: 0, receivable: 0 };
  }

  // Transaksi "Belum" (piutang) tidak diakui sebagai omzet/HPP/gross profit;
  // seluruh nilai jatuh ke `receivable` sampai berubah status jadi "Sudah"
  // (dicatat lewat `paid_at`/`paid_by` di level database, bukan di fungsi ini).
  if (transaction.paymentStatus === "Belum") {
    return {
      revenue: 0,
      cost: 0,
      grossProfit: 0,
      receivable: transaction.totalAmount,
    };
  }

  return {
    revenue: transaction.totalAmount,
    cost: transaction.totalCost,
    grossProfit: transaction.totalAmount - transaction.totalCost,
    receivable: 0,
  };
}
