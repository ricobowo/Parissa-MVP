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
    <html lang="id">
      <body>
        <AppProviders>{children}</AppProviders>
      </body>
    </html>
  );
}
