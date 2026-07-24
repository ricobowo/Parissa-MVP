/**
 * @file env.ts
 * @version 0.1.0
 * @description Validasi environment variable pada boundary aplikasi.
 */

import { z } from "zod";

// Hanya variabel NEXT_PUBLIC_* (aman terekspos ke browser) yang divalidasi di
// sini. Secret server-only (mis. service role key) sengaja tidak masuk schema
// ini agar tidak tergoda diekspos lewat client bundle.
const publicEnvironmentSchema = z.object({
  NEXT_PUBLIC_SUPABASE_URL: z.url(),
  NEXT_PUBLIC_SUPABASE_ANON_KEY: z.string().min(1),
});

export type PublicEnvironment = z.infer<typeof publicEnvironmentSchema>;

/**
 * Validasi environment variable Supabase publik. Dipanggil di dalam factory
 * client (`createSupabaseBrowserClient`/`createSupabaseServerClient`) alih-alih
 * sekali di module scope, supaya kegagalan konfigurasi gagal cepat dengan
 * pesan Zod yang jelas saat client benar-benar dibutuhkan, dan supaya nilai
 * input dapat di-override saat test (lihat `env.test.ts`) tanpa mengubah
 * `process.env` global.
 */
export function parsePublicEnvironment(
  input: Record<string, string | undefined> = process.env,
): PublicEnvironment {
  return publicEnvironmentSchema.parse(input);
}
