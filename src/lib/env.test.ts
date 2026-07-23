/**
 * @file env.test.ts
 * @version 0.1.0
 * @description Unit test validasi environment variable.
 */

import { describe, expect, it } from "vitest";

import { parsePublicEnvironment } from "@/lib/env";

describe("parsePublicEnvironment", () => {
  it("menerima konfigurasi Supabase valid", () => {
    expect(
      parsePublicEnvironment({
        NEXT_PUBLIC_SUPABASE_URL: "http://127.0.0.1:54321",
        NEXT_PUBLIC_SUPABASE_ANON_KEY: "anon-key",
      }),
    ).toEqual({
      NEXT_PUBLIC_SUPABASE_URL: "http://127.0.0.1:54321",
      NEXT_PUBLIC_SUPABASE_ANON_KEY: "anon-key",
    });
  });

  it("menolak environment yang belum lengkap", () => {
    expect(() => parsePublicEnvironment({})).toThrow();
  });
});
