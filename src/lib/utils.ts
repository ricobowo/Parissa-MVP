/**
 * @file utils.ts
 * @version 0.1.0
 * @description Utilitas className untuk komponen shadcn/ui.
 */
import { clsx, type ClassValue } from "clsx";
import { twMerge } from "tailwind-merge";

// `twMerge` di atas hasil `clsx` supaya class Tailwind yang saling
// bertentangan (mis. className default komponen vs. override dari caller)
// tidak keduanya ikut ter-render; class yang datang belakangan yang menang.
export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}
