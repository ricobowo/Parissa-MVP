/**
 * @file skeleton.tsx
 * @version 0.1.0
 * @description Komponen skeleton shadcn/ui.
 */
import { cn } from "@/lib/utils";

// Primitive loading state ini yang memenuhi syarat "setiap halaman data wajib
// memiliki loading state berbeda" (AGENTS.md) dan state skeleton grid pada
// `05-POS-Flow.md`; bukan sekadar dekorasi animasi.
function Skeleton({ className, ...props }: React.ComponentProps<"div">) {
  return (
    <div
      data-slot="skeleton"
      className={cn("bg-muted animate-pulse rounded-md", className)}
      {...props}
    />
  );
}

export { Skeleton };
