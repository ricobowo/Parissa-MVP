/**
 * @file server.ts
 * @version 0.1.1
 * @description Factory Supabase client untuk Server Component dan Route Handler.
 */

import { createServerClient } from "@supabase/ssr";
import { cookies } from "next/headers";

import { parsePublicEnvironment } from "@/lib/env";
import type { Database } from "@/types/database.generated";

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
