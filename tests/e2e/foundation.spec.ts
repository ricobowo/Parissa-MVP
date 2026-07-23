/**
 * @file foundation.spec.ts
 * @version 0.2.0
 * @description Smoke test status Gate C dan transisi Phase 3.
 */

import { expect, test } from "@playwright/test";

test("menampilkan status Gate C tanpa horizontal overflow", async ({
  page,
}) => {
  await page.goto("/");

  await expect(
    page.getByRole("heading", { name: "Fondasi teknis siap digunakan." }),
  ).toBeVisible();
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
