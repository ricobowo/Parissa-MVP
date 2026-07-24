/**
 * @file query-client.ts
 * @version 0.1.0
 * @description Konvensi QueryClient untuk server state interaktif.
 */

import { QueryClient } from "@tanstack/react-query";

/**
 * Factory QueryClient tunggal supaya default konfigurasi konsisten di semua
 * pemakaian TanStack Query (dipanggil per request/provider, bukan module
 * singleton, agar cache tidak bocor antar sesi/user di server).
 *
 * Default yang dipilih:
 * - `queries.staleTime: 30_000` — data POS (produk, riwayat) tidak berubah
 *   tiap detik; jeda 30 detik mengurangi refetch berlebihan tanpa membuat
 *   data terasa basi untuk operasional kasir.
 * - `queries.refetchOnWindowFocus: false` — POS sering di-switch tab di kasir;
 *   refetch otomatis saat fokus kembali dapat mengganggu cart yang sedang diisi.
 * - `mutations.retry: 0` — mutation di sini menyentuh transaksi/pembayaran/void;
 *   retry otomatis TanStack Query tidak boleh menggantikan idempotency key
 *   eksplisit yang dijaga di layer domain (`createTransactionInputSchema`),
 *   supaya kegagalan network tidak diam-diam mencoba ulang side effect.
 */
export function createQueryClient() {
  return new QueryClient({
    defaultOptions: {
      queries: {
        staleTime: 30_000,
        retry: 1,
        refetchOnWindowFocus: false,
      },
      mutations: {
        retry: 0,
      },
    },
  });
}
