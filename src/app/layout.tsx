/**
 * @file layout.tsx
 * @version 0.1.0
 * @description Root layout aplikasi Parissa POS.
 */

import type { Metadata } from "next";

import { AppProviders } from "@/app/providers";

import "./globals.css";

export const metadata: Metadata = {
  title: "Parissa POS",
  description: "Aplikasi pencatatan penjualan Parissa.",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    // lang="id" wajib karena seluruh UI berbahasa Indonesia (AGENTS.md); memengaruhi
    // perilaku screen reader dan bukan sekadar metadata.
    <html lang="id">
      <body>
        {/* AppProviders dipasang sekali di root agar seluruh route berbagi satu
            QueryClient/context TanStack Query, bukan membuat provider baru per halaman. */}
        <AppProviders>{children}</AppProviders>
      </body>
    </html>
  );
}
