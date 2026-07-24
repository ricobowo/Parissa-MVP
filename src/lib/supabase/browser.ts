/**
 * @file browser.ts
 * @version 0.1.1
 * @description Factory Supabase client untuk browser.
 */

import { createBrowserClient } from "@supabase/ssr";

import { parsePublicEnvironment } from "@/lib/env";
import type { Database } from "@/types/database.generated";

/**
 * Factory Supabase client untuk Client Component. Terpisah dari
 * `createSupabaseServerClient` karena browser tidak punya akses ke cookie
 * store Next.js (`next/headers`) dan hanya boleh memakai anon key + sesi yang
 * disimpan `@supabase/ssr` di cookie/localStorage sisi klien; RLS tetap
 * menjadi lapisan otorisasi sebenarnya, bukan pemisahan client ini.
 * `Database` di-generic-kan agar query lewat client ini typed sesuai schema
 * hasil `supabase gen types`.
 */
export function createSupabaseBrowserClient() {
  const environment = parsePublicEnvironment();

  return createBrowserClient<Database>(
    environment.NEXT_PUBLIC_SUPABASE_URL,
    environment.NEXT_PUBLIC_SUPABASE_ANON_KEY,
  );
}
