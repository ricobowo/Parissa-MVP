/**
 * @file env.ts
 * @version 0.1.0
 * @description Validasi environment variable pada boundary aplikasi.
 */

import { z } from "zod";

const publicEnvironmentSchema = z.object({
  NEXT_PUBLIC_SUPABASE_URL: z.url(),
  NEXT_PUBLIC_SUPABASE_ANON_KEY: z.string().min(1),
});

export type PublicEnvironment = z.infer<typeof publicEnvironmentSchema>;

export function parsePublicEnvironment(
  input: Record<string, string | undefined> = process.env,
): PublicEnvironment {
  return publicEnvironmentSchema.parse(input);
}
