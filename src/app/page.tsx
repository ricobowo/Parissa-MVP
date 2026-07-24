/**
 * @file page.tsx
 * @version 0.2.0
 * @description Halaman status Gate C dan transisi ke Core POS Parissa.
 */

import Image from "next/image";

import { Alert, AlertDescription, AlertTitle } from "@/components/ui/alert";
import { Badge } from "@/components/ui/badge";
import {
  Card,
  CardAction,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { Separator } from "@/components/ui/separator";

// Data ditulis statis, bukan hasil fetch, karena halaman ini hanya merangkum status
// Gate C yang sudah diverifikasi manual (lihat AGENTS.md); bukan metrik operasional.
const foundationAreas = [
  {
    title: "Application",
    description: "Next.js App Router, TypeScript strict, dan Tailwind CSS v4.",
    status: "Siap",
  },
  {
    title: "Design system",
    description: "shadcn/ui base-nova dengan token semantik Parissa.",
    status: "Siap",
  },
  {
    title: "Data & security",
    description: "Supabase migration, RLS, seed development, dan RPC atomik.",
    status: "Siap",
  },
  {
    title: "Quality",
    description: "ESLint, type-check, Vitest, Playwright, dan CI.",
    status: "Siap",
  },
] as const;

/**
 * Halaman root sementara: konfirmasi status Gate C/foundation, bukan tampilan POS.
 * Akan digantikan oleh entry point Core POS (product grid, cart, submit) sesuai
 * `05-POS-Flow.md` begitu Phase 3 tersedia.
 */
export default function Home() {
  return (
    <main className="mx-auto flex min-h-svh w-full max-w-6xl flex-col gap-10 px-5 py-8 sm:px-8 sm:py-12 lg:px-10">
      <header className="flex items-center justify-between gap-4">
        <div className="flex items-center gap-3">
          <Image
            className="size-12 object-contain"
            src="/brand/parissa-logo.png"
            alt="Logo Parissa"
            width={48}
            height={48}
            priority
          />
          <div>
            <p className="font-medium">Parissa POS</p>
            <p className="text-muted-foreground text-sm">
              Engineering foundation
            </p>
          </div>
        </div>
        <Badge variant="secondary">Phase 3</Badge>
      </header>

      <section className="flex max-w-3xl flex-col gap-4">
        <Badge className="w-fit">Gate C disetujui</Badge>
        <h1 className="text-4xl leading-tight font-medium tracking-tight sm:text-5xl">
          Fondasi teknis siap digunakan.
        </h1>
        <p className="text-muted-foreground max-w-2xl text-base leading-7 sm:text-lg">
          Schema, RLS, seed, mutation contract, dan quality gate telah
          disetujui. Implementasi Core POS Phase 3 sekarang dapat dimulai.
        </p>
      </section>

      <Separator />

      <section
        className="grid gap-4 sm:grid-cols-2"
        aria-label="Status engineering foundation"
      >
        {foundationAreas.map((area) => (
          <Card key={area.title}>
            <CardHeader>
              <CardTitle>{area.title}</CardTitle>
              <CardDescription>{area.description}</CardDescription>
              <CardAction>
                <Badge variant="secondary">{area.status}</Badge>
              </CardAction>
            </CardHeader>
            <CardContent>
              <p className="text-muted-foreground text-sm">
                Konfigurasi minimum tersedia dan telah masuk quality gate.
              </p>
            </CardContent>
          </Card>
        ))}
      </section>

      <Alert>
        <AlertTitle>Gate C disetujui</AlertTitle>
        <AlertDescription>
          HPP resmi Airtable, schema, RLS, seed, dan mutation contract sudah
          lulus verifikasi lokal. Phase 2 selesai dan Phase 3 aktif.
        </AlertDescription>
      </Alert>

      <footer className="text-muted-foreground mt-auto text-sm">
        Parissa-MVP v0.4.0 · Tidak menggunakan data production
      </footer>
    </main>
  );
}
