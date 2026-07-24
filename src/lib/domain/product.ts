/**
 * @file product.ts
 * @version 0.1.0
 * @description Schema domain produk P0 Parissa POS.
 */

import { z } from "zod";

export const productCategorySchema = z.enum(["Dessert", "Minuman", "Bundling"]);

/**
 * Boundary validasi untuk create/update produk oleh Owner.
 *
 * `sellingPrice` dan `standardCost` memakai `z.number().int()` karena Rupiah
 * disimpan sebagai nilai numerik tanpa desimal (lihat 03-Business-Rules.md
 * bagian Rupiah dan Waktu), bukan karena unit terkecilnya sen/cent.
 * `standardCost` di sini adalah HPP standar produk, bukan snapshot transaksi;
 * snapshot HPP per item transaksi ada di `transaction_items` dan tidak
 * berubah walau `standardCost` produk diperbarui setelahnya.
 */
export const productInputSchema = z.object({
  name: z.string().trim().min(1).max(120),
  category: productCategorySchema,
  sellingPrice: z.number().int().nonnegative(),
  standardCost: z.number().int().nonnegative(),
  imageUrl: z.url().nullable().optional(),
  isActive: z.boolean().default(true),
});

export type ProductInput = z.infer<typeof productInputSchema>;
