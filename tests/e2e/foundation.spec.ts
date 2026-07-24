/**
 * @file foundation.spec.ts
 * @version 0.2.0
 * @description Smoke test status Gate C dan transisi Phase 3.
 */

import { expect, test } from "@playwright/test";

// Smoke test ini menguji halaman status foundation Phase 2 (bukan flow POS
// Phase 3), sengaja tetap dipertahankan sebagai sinyal cepat bahwa build
// dasar, badge/alert Gate, dan layout responsif tidak rusak sebelum
// Playwright suite Phase 3 yang lebih lengkap ditambahkan.
test("menampilkan status Gate C tanpa horizontal overflow", async ({
  page,
}) => {
  await page.goto("/");

  await expect(
    page.getByRole("heading", { name: "Fondasi teknis siap digunakan." }),
  ).toBeVisible();
  // Teks "Gate C disetujui" sengaja muncul dua kali di halaman (Badge
  // ringkas di header dan AlertTitle pada detail status); count 2 memverifikasi
  // keduanya tetap konsisten, bukan duplikasi yang tidak disengaja.
  await expect(page.getByText("Gate C disetujui", { exact: true })).toHaveCount(
    2,
  );
  await expect(page.getByText("Parissa-MVP v0.4.0")).toBeVisible();

  const hasHorizontalOverflow = await page.evaluate(
    () =>
      document.documentElement.scrollWidth >
      document.documentElement.clientWidth,
  );
  expect(hasHorizontalOverflow).toBe(false);
});
