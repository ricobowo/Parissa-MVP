/**
 * @file prettier.config.mjs
 * @version 0.1.0
 * @description Konfigurasi formatter dan urutan class Tailwind.
 */

/** @type {import("prettier").Config} */
const config = {
  plugins: ["prettier-plugin-tailwindcss"],
  semi: true,
  singleQuote: false,
  trailingComma: "all",
};

export default config;
