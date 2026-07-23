/**
 * @file product.ts
 * @version 0.1.0
 * @description Schema domain produk P0 Parissa POS.
 */

import { z } from "zod";

export const productCategorySchema = z.enum(["Dessert", "Minuman", "Bundling"]);

export const productInputSchema = z.object({
  name: z.string().trim().min(1).max(120),
  category: productCategorySchema,
  sellingPrice: z.number().int().nonnegative(),
  standardCost: z.number().int().nonnegative(),
  imageUrl: z.url().nullable().optional(),
  isActive: z.boolean().default(true),
});

export type ProductInput = z.infer<typeof productInputSchema>;
