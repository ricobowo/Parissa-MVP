---
name: parissa-code-handoff
description: Menjelaskan kode Parissa-MVP untuk pembelajaran dan handoff dengan komentar Bahasa Indonesia yang selektif, dokumentasi arsitektur yang terhubung ke source code, serta verifikasi tanpa mengubah perilaku aplikasi. Gunakan ketika diminta mengomentari kode yang sudah ada, menjelaskan fungsi modul, membuat atau memperbarui Engineering Code Guide, menyiapkan onboarding developer/AI baru, atau menjaga dokumentasi implementasi Phase 3 dan seterusnya.
---

# Parissa Code Handoff

Jelaskan alasan dan hubungan antarmodul tanpa mengulang setiap baris kode. Pertahankan business rule, scope, dan perilaku aplikasi.

## 1. Bangun konteks minimum

Baca seluruh:

1. `AGENTS.md`
2. `README.md`
3. `Document/MVP/02-MVP-Scope.md`
4. `Document/MVP/03-Business-Rules.md`
5. `Document/MVP/04-Data-Model.md`
6. `Document/MVP/05-POS-Flow.md`
7. `Document/MVP/07-Acceptance-Criteria.md`
8. `Document/MVP/08-Engineering-Foundation.md`

Baca `Document/MVP/06-Design-Brief.md`, `prototype/phase-1/design-handoff.md`, dan prototype hanya untuk pekerjaan UI. Gunakan PRD v3.1 hanya untuk requirement yang belum cukup jelas atau konflik source of truth. Jangan menggunakan PRD v2.4 atau repository lama sebagai baseline implementasi.

## 2. Audit sebelum mengomentari

1. Identifikasi file yang memuat domain rule, boundary data, security, state, dan control flow tidak langsung.
2. Pisahkan komentar yang benar-benar membantu dari komentar yang hanya menerjemahkan syntax.
3. Catat dokumentasi yang sudah ada agar informasi tidak diduplikasi.
4. Jelaskan daftar target komentar dan dokumen sebelum mengedit.
5. Jangan mengubah logic, public API, schema, dependency, atau tampilan kecuali diminta terpisah.

## 3. Terapkan komentar bernilai tinggi

Gunakan Bahasa Indonesia dan prioritaskan:

- Header file yang menjelaskan tujuan, bukan riwayat panjang.
- TSDoc/JSDoc untuk exported function, hook, data-access method, schema, atau abstraction yang kontraknya tidak terlihat jelas.
- Komentar `mengapa` untuk HPP snapshot, `paid_at`, idempotency, atomic transaction, audit, permission, serta koreksi agregat.
- Komentar SQL pada RPC, RLS policy, constraint, dan bagian security-sensitive.
- Penjelasan input, output, side effect, error, dan invariant bila membantu penggunaan yang benar.
- Workaround yang benar-benar diperlukan beserta kondisi kapan dapat dihapus.

Hindari:

- Komentar pada setiap baris.
- Komentar yang hanya mengulang nama variabel atau syntax.
- Tutorial framework umum yang tidak khusus pada keputusan Parissa.
- Detail sementara yang cepat kedaluwarsa.
- Komentar yang menyatakan asumsi bisnis baru.
- Penonaktifan lint/type-check atau perubahan test hanya agar komentar lolos.

Contoh yang dihindari:

```ts
// Menghitung total harga.
const total = price * quantity;
```

Contoh yang dianjurkan:

```ts
// Nilai dari client tidak dipercaya; database tetap menghitung ulang total
// agar harga snapshot dan agregat transaksi tidak dapat dimanipulasi.
const total = calculateTransactionTotal(items);
```

## 4. Buat panduan handoff

Buat atau perbarui `Document/Engineering-Code-Guide.md` ketika dokumentasi handoff diminta. Isi minimum:

1. Arsitektur aplikasi dan batas tiap layer.
2. Fungsi folder serta file entry point.
3. Alur authentication dan permission.
4. Alur produk dan transaksi dari UI sampai RPC/database.
5. Aturan HPP snapshot, pembayaran, piutang, void, dan audit.
6. Strategi validation, error, loading, empty state, serta retry.
7. Peta test dan command verifikasi.
8. Panduan menelusuri satu use case end-to-end.

Referensikan path dan nama fungsi/modul; hindari nomor baris yang cepat berubah. Jangan menyalin seluruh source code ke dokumen.

## 5. Gunakan skill pendamping secara kondisional

Jika tersedia pada agent:

- Gunakan `frontend-patterns` dan `shadcn` untuk React/Next.js/UI.
- Gunakan `postgres-patterns` dan `database-migrations` untuk PostgreSQL, Supabase, RLS, atau migration.
- Gunakan `security-review` untuk auth, permission, input, secret, dan RPC.
- Gunakan `architecture-decision-records` hanya ketika ada keputusan arsitektur baru.
- Gunakan `prompt-optimizer` hanya ketika menyusun atau memperbaiki prompt handoff berikutnya.
- Gunakan `verification-loop` atau `webapp-testing` untuk pemeriksaan akhir.

Jangan berhenti hanya karena skill pendamping tidak tersedia. Ikuti aturan repository dan lanjutkan dengan kemampuan agent yang ada.

## 6. Verifikasi

1. Jalankan format check, lint, type-check, unit test, dan build.
2. Jalankan E2E bila file UI atau flow berubah.
3. Jalankan database reset/lint/test bila SQL berubah.
4. Pastikan diff hanya berisi komentar dan dokumentasi bila scope-nya explanation-only.
5. Pastikan komentar tetap benar terhadap kode dan tidak mengklaim test yang belum dijalankan.
6. Perbarui README, CHANGELOG, VERSION, dan header versi sesuai aturan `AGENTS.md`.
7. Tutup dengan `SESSION SUMMARY`.
