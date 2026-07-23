/**
 * @file utils.ts
 * @version 0.1.0
 * @description Utilitas className untuk komponen shadcn/ui.
 */
import { clsx, type ClassValue } from "clsx";
import { twMerge } from "tailwind-merge";

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}
