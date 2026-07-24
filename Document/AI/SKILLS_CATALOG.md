<!--
@file SKILLS_CATALOG.md
@version 0.1.0
@description Katalog skill AI yang direkomendasikan untuk pengembangan Parissa-MVP.
-->

# Katalog Skill AI — Parissa-MVP

Dokumen ini mencatat skill yang relevan untuk proyek Parissa. Ini bukan snapshot seluruh skill yang terpasang pada satu komputer.

## Tingkat Ketersediaan

| Tingkat | Arti |
|---|---|
| Repository | Disimpan di repository dan menjadi pilihan utama karena tersedia lintas mesin. |
| Global | Terpasang pada mesin tertentu; gunakan hanya jika agent dapat menemukannya. |
| Plugin/connector | Tergantung aplikasi, session, login, dan permission yang aktif. |

Skill tidak boleh mengubah source of truth produk. Jika instruksi skill bertentangan dengan `AGENTS.md`, PRD, scope, business rules, atau keputusan Owner terbaru, ikuti source of truth repository.

## Skill Repository

| Skill | Lokasi | Digunakan untuk |
|---|---|---|
| `parissa-code-handoff` | `.agents/skills/parissa-code-handoff/SKILL.md` | Komentar kode edukatif, Engineering Code Guide, penjelasan arsitektur, serta onboarding AI/developer tanpa mengubah perilaku aplikasi. |

Skill repository wajib dilacak Git. AI baru harus membaca `SKILL.md` secara penuh ketika nama atau pekerjaannya sesuai dengan permintaan pengguna.

## Skill Rekomendasi Berdasarkan Pekerjaan

### Code learning dan handoff

1. `parissa-code-handoff` — workflow utama dan selalu diprioritaskan.
2. `prompt-optimizer` — hanya untuk menyusun atau memperbaiki prompt handoff.
3. `architecture-decision-records` — hanya ketika ada keputusan arsitektur baru yang perlu dicatat.

### Frontend dan UI

1. `shadcn` — menambah, memeriksa, dan menyusun komponen shadcn/ui.
2. `frontend-patterns` — pola React/Next.js, state, performance, dan struktur frontend.
3. `huashu-design` — prototype HTML, eksplorasi visual, dan review desain.
4. `browser:control-in-app-browser` atau `webapp-testing` — pemeriksaan UI lokal dan interaction flow.

### Supabase dan database

1. `postgres-patterns` — schema, query, indexing, dan keamanan PostgreSQL.
2. `database-migrations` — migration baru, rollback, dan perubahan schema yang aman.
3. `security-review` — auth, RLS, permission, input boundary, secret, dan RPC.

### Testing dan quality gate

1. `verification-loop` — pemeriksaan menyeluruh sebelum handoff.
2. `webapp-testing` — Playwright, UI state, dan interaction testing.
3. `tdd-workflow` — digunakan bila task secara eksplisit meminta pengembangan test-first.

### Git dan kolaborasi

1. Skill GitHub hanya digunakan jika connector/plugin GitHub tersedia dan pengguna meminta pekerjaan GitHub.
2. `github:yeet` tidak digunakan untuk Parissa kecuali pengguna secara eksplisit meminta push atau pull request.
3. Aturan repository tetap berlaku: agent tidak menjalankan push tanpa instruksi Owner.

## Routing Cepat

| Permintaan | Skill utama | Tambahan bila tersedia |
|---|---|---|
| “Jelaskan dan komentari kode ini” | `parissa-code-handoff` | `frontend-patterns`, `postgres-patterns`, atau `security-review` sesuai file |
| “Implementasikan UI dari prototype” | `shadcn` | `frontend-patterns`, `huashu-design`, browser testing |
| “Ubah schema/RPC/RLS” | `database-migrations` | `postgres-patterns`, `security-review` |
| “Review sebelum commit/release” | `verification-loop` | `webapp-testing`, `security-review` |
| “Catat keputusan arsitektur” | `architecture-decision-records` | `parissa-code-handoff` |

## Aturan Penggunaan

1. Sebutkan skill yang digunakan dan alasannya sebelum menjalankan workflow.
2. Baca `SKILL.md` yang dipilih secara penuh sebelum bertindak.
3. Gunakan jumlah skill minimum yang menutup kebutuhan task.
4. Jangan berhenti hanya karena skill global tidak tersedia; lanjutkan dengan aturan repository dan kemampuan agent yang ada.
5. Jangan menyalin seluruh skill global ke repository tanpa kebutuhan dan persetujuan Owner.
6. Jangan menganggap daftar global pada mesin lain identik dengan daftar pada mesin saat ini.
7. Verifikasi hasil sesuai quality gate di `AGENTS.md`.

## Penyimpanan dan Pemeliharaan

- Dokumen ini dilacak Git karena merupakan katalog kurasi proyek, bukan data mesin lokal.
- Perbarui hanya ketika skill repository, rekomendasi utama, atau routing task berubah.
- Inventaris lengkap skill global sebaiknya disimpan di luar repository atau dibuat ulang dari mesin masing-masing.
- Jangan menambahkan output scan ratusan skill global ke dokumen ini.
