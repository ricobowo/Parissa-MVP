/**
 * @file browser.ts
 * @version 0.1.1
 * @description Factory Supabase client untuk browser.
 */

import { createBrowserClient } from "@supabase/ssr";

import { parsePublicEnvironment } from "@/lib/env";
import type { Database } from "@/types/database.generated";

export function createSupabaseBrowserClient() {
  const environment = parsePublicEnvironment();

  return createBrowserClient<Database>(
    environment.NEXT_PUBLIC_SUPABASE_URL,
    environment.NEXT_PUBLIC_SUPABASE_ANON_KEY,
  );
}
