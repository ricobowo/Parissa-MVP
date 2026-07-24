/**
 * @file server.ts
 * @version 0.1.1
 * @description Factory Supabase client untuk Server Component dan Route Handler.
 */

import { createServerClient } from "@supabase/ssr";
import { cookies } from "next/headers";

import { parsePublicEnvironment } from "@/lib/env";
import type { Database } from "@/types/database.generated";

/**
 * Factory Supabase client untuk Server Component dan Route Handler. Dipisah
 * dari `createSupabaseBrowserClient` karena harus dibuat ulang per request
 * (membaca cookie request saat ini via `next/headers`) sehingga sesi user
 * yang benar terbawa saat query dijalankan di server, bukan di-cache lintas
 * request seperti module-level client biasa.
 */
export async function createSupabaseServerClient() {
  const cookieStore = await cookies();
  const environment = parsePublicEnvironment();

  return createServerClient<Database>(
    environment.NEXT_PUBLIC_SUPABASE_URL,
    environment.NEXT_PUBLIC_SUPABASE_ANON_KEY,
    {
      cookies: {
        getAll: () => cookieStore.getAll(),
        setAll: (cookiesToSet) => {
          try {
            cookiesToSet.forEach(({ name, value, options }) => {
              cookieStore.set(name, value, options);
            });
          } catch {
            // Server Component tidak selalu boleh menulis cookie; middleware akan menyegarkannya.
          }
        },
      },
    },
  );
}
