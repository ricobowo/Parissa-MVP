/**
 * @file transaction.test.ts
 * @version 0.1.0
 * @description Unit test aturan finansial dan validasi transaksi.
 */

import { describe, expect, it } from "vitest";

import {
  calculateTransactionFinancials,
  createTransactionInputSchema,
} from "@/lib/domain/transaction";

describe("calculateTransactionFinancials", () => {
  // Ketiga test berikut memverifikasi tiga cabang aturan pengakuan finansial
  // di 03-Business-Rules.md bagian Formula: lunas, piutang, dan void.
  it("mengakui omzet, HPP, dan gross profit transaksi lunas", () => {
    expect(
      calculateTransactionFinancials({
        paymentStatus: "Sudah",
        totalAmount: 100_000,
        totalCost: 60_000,
        isVoid: false,
      }),
    ).toEqual({
      revenue: 100_000,
      cost: 60_000,
      grossProfit: 40_000,
      receivable: 0,
    });
  });

  it("memindahkan transaksi belum lunas ke piutang tanpa pengakuan finansial", () => {
    expect(
      calculateTransactionFinancials({
        paymentStatus: "Belum",
        totalAmount: 100_000,
        totalCost: 60_000,
        isVoid: false,
      }),
    ).toEqual({
      revenue: 0,
      cost: 0,
      grossProfit: 0,
      receivable: 100_000,
    });
  });

  it("mengeluarkan transaksi void dari seluruh agregat", () => {
    expect(
      calculateTransactionFinancials({
        paymentStatus: "Sudah",
        totalAmount: 100_000,
        totalCost: 60_000,
        isVoid: true,
      }),
    ).toEqual({
      revenue: 0,
      cost: 0,
      grossProfit: 0,
      receivable: 0,
    });
  });
});

describe("createTransactionInputSchema", () => {
  // Kasus di bawah menegaskan aturan "nama pelanggan wajib untuk piutang,
  // opsional untuk lunas" dan boundary quantity integer positif dari
  // 03-Business-Rules.md, tanpa perlu database untuk mengujinya.
  const baseInput = {
    idempotencyKey: "00000000-0000-4000-8000-000000000001",
    items: [{ productId: "00000000-0000-4000-8000-000000000010", quantity: 1 }],
  };

  it("menerima nama pelanggan kosong untuk transaksi lunas", () => {
    expect(
      createTransactionInputSchema.safeParse({
        ...baseInput,
        paymentStatus: "Sudah",
      }).success,
    ).toBe(true);
  });

  it("mewajibkan nama pelanggan untuk transaksi piutang", () => {
    const result = createTransactionInputSchema.safeParse({
      ...baseInput,
      paymentStatus: "Belum",
    });

    expect(result.success).toBe(false);
  });

  it.each([0, -1, 1.5])("menolak quantity tidak valid: %s", (quantity) => {
    const result = createTransactionInputSchema.safeParse({
      ...baseInput,
      paymentStatus: "Sudah",
      items: [{ ...baseInput.items[0], quantity }],
    });

    expect(result.success).toBe(false);
  });
});
