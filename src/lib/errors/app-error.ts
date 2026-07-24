/**
 * @file app-error.ts
 * @version 0.1.0
 * @description Error aplikasi terstruktur yang aman ditampilkan ke pengguna.
 */

// Kode error tertutup (bukan string bebas) supaya UI dapat memutuskan
// tampilan/aksi (mis. redirect login untuk AUTH_REQUIRED, pesan generik untuk
// UNEXPECTED) tanpa mem-parsing pesan error yang bisa berubah kapan saja.
export type AppErrorCode =
  | "AUTH_REQUIRED"
  | "FORBIDDEN"
  | "VALIDATION_ERROR"
  | "CONFLICT"
  | "NOT_FOUND"
  | "UNEXPECTED";

/**
 * Error terstruktur untuk boundary aplikasi (route handler, server action,
 * data-access layer). `message` di sini diasumsikan aman ditampilkan langsung
 * ke pengguna dalam Bahasa Indonesia; detail teknis/sensitif (mis. pesan error
 * mentah dari Supabase/Postgres) sebaiknya dipetakan ke salah satu `code` di
 * atas sebelum dilempar sebagai `AppError`, bukan diteruskan apa adanya.
 */
export class AppError extends Error {
  constructor(
    public readonly code: AppErrorCode,
    message: string,
    options?: ErrorOptions,
  ) {
    super(message, options);
    this.name = "AppError";
  }
}
