/**
 * @file transaction.ts
 * @version 0.1.0
 * @description Schema input dan formula finansial tunggal transaksi.
 */

import { z } from "zod";

export const paymentStatusSchema = z.enum(["Sudah", "Belum"]);

export const transactionItemInputSchema = z.object({
  productId: z.uuid(),
  quantity: z.number().int().positive().max(999),
});

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

export function calculateTransactionFinancials(
  transaction: TransactionFinancialInput,
): TransactionFinancialResult {
  if (transaction.isVoid) {
    return { revenue: 0, cost: 0, grossProfit: 0, receivable: 0 };
  }

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
