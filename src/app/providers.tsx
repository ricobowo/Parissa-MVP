"use client";

/**
 * @file providers.tsx
 * @version 0.1.0
 * @description Provider client global untuk TanStack Query.
 */

import { QueryClientProvider } from "@tanstack/react-query";
import { useState } from "react";

import { createQueryClient } from "@/lib/query/query-client";

/**
 * Membungkus root layout dengan context TanStack Query. Hanya dipasang satu kali
 * di `layout.tsx`; jangan dipasang ulang di halaman turunan.
 */
export function AppProviders({
  children,
}: Readonly<{ children: React.ReactNode }>) {
  // QueryClient dibuat lewat lazy initializer useState, bukan konstanta di luar
  // komponen, agar setiap mount komponen (mis. tab/browser berbeda) mendapat cache
  // sendiri, sambil tetap stabil (tidak dibuat ulang) selama re-render.
  const [queryClient] = useState(createQueryClient);

  return (
    <QueryClientProvider client={queryClient}>{children}</QueryClientProvider>
  );
}
