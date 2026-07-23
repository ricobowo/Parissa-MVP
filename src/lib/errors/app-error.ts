/**
 * @file app-error.ts
 * @version 0.1.0
 * @description Error aplikasi terstruktur yang aman ditampilkan ke pengguna.
 */

export type AppErrorCode =
  | "AUTH_REQUIRED"
  | "FORBIDDEN"
  | "VALIDATION_ERROR"
  | "CONFLICT"
  | "NOT_FOUND"
  | "UNEXPECTED";

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
