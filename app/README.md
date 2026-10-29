# TuturTangan — Aplikasi Mobile

Aplikasi Flutter untuk mendukung komunikasi dan pembelajaran BISINDO.
Proyek RPL Kelompok 12, Teknik Informatika, Universitas Padjadjaran.

> **Status: Fase 1 selesai** — scaffold, struktur folder, tema, validator, dan
> smoke test. Backend (Supabase) belum disambungkan.

---

## Prasyarat

| Kebutuhan | Versi |
|---|---|
| Flutter SDK | 3.32.7 (`D:\flutter`) |
| Dart | 3.8.1 |
| Editor | VS Code + ekstensi `dart-code.dart-code`, `dart-code.flutter` |
| Android SDK | **belum dipasang** — hanya perlu saat `flutter build apk` |
| JDK | 17 (untuk Gradle, saat build Android) |

---

## Menjalankan

```powershell
cd app
flutter pub get

# Cepat, tanpa Android SDK (memakai backend tiruan / mode mock)
flutter run -d edge

# Setelah Android SDK + HP/emulator siap
flutter run
```

### Menyambungkan ke Supabase

Kredensial dibaca dari `--dart-define`, jadi tidak ada file rahasia di repo:

```powershell
flutter run -d edge `
  --dart-define=SUPABASE_URL=https://xxxx.supabase.co `
  --dart-define=SUPABASE_ANON_KEY=eyJhbGciOi...
```

Tanpa kedua nilai itu aplikasi otomatis berjalan pada **mode mock** dengan
akun demo `demo@tuturtangan.id` / `demo1234`.

Perintah lain:

```powershell
flutter analyze     # static analysis (harus "No issues found!")
flutter test        # unit & widget test
flutter build web   # verifikasi kompilasi tanpa Android SDK
```

---

## Struktur

```
lib/
├─ main.dart                     # entry point + ProviderScope
├─ app.dart                      # MaterialApp + tema
├─ core/
│  ├─ config/                    # env (.env) & inisialisasi Supabase
│  ├─ router/                    # go_router + guard auth/role
│  ├─ theme/app_theme.dart       # kontras tinggi, teks besar (NFR-003/007)
│  ├─ widgets/                   # komponen bersama
│  └─ utils/validators.dart      # email, kata sandi >= 8 karakter
└─ features/
   ├─ auth/          FR-001..003
   ├─ profile/       FR-004
   ├─ jbi/           FR-005
   ├─ catalog/       FR-006, FR-007, FR-012
   ├─ validation/    FR-008
   ├─ quiz/          FR-009, FR-010
   ├─ progress/      FR-011
   ├─ dictionary/    FR-013
   ├─ stt/           FR-014
   └─ notifications/ penunjang FR-005, FR-008
```

Tiap folder fitur berisi `data/` (repository + model) dan `presentation/`
(screen, widget, provider).

---

## Konvensi

- **State management:** Riverpod 3 (`flutter_riverpod` 3.3.2). Gunakan
  `Notifier`/`AsyncNotifier`; `StateProvider`/`StateNotifierProvider` sudah
  masuk `legacy` di v3.
- **Navigasi:** `go_router` 17, dengan `redirect` untuk penjagaan sesi dan
  peran (Pengguna / JBI / Admin).
- **Lint:** `analysis_options.yaml` memakai strict casts/inference/raw-types.
- **Rahasia:** kredensial lewat `--dart-define`; tidak ada `.env` yang di-commit.
- **Backend ganda:** `AuthRepository` punya dua implementasi —
  `MockAuthRepository` (tanpa jaringan) dan `SupabaseAuthRepository`.
  Pemilihan otomatis di `authRepositoryProvider` berdasarkan `AppConfig`.

---

## Database

Migrasi SQL ada di `supabase/migrations/` dan dijalankan berurutan.
Panduan setup lengkap (buat project, ambil kredensial, setelan Auth, verifikasi):
**[`supabase/README.md`](supabase/README.md)**.

| File | Isi |
|---|---|
| `0001_enums.sql` | 9 tipe ENUM |
| `0002_tables.sql` | 19 tabel MVP + `quiz_answers` + indeks |
| `0003_rls.sql` | RLS, policy, helper peran, bucket storage |
| `0004_triggers.sql` | `updated_at`, consent, sinkronisasi `auth.users` |
| `0005_seed.sql` | 5 kategori, 10 kosakata, 2 kuis |

---

## Roadmap

Rancangan rinci tiap fitur (layar, alur, data, state, edge case, kriteria
terima) ada di [`docs/RANCANGAN_FITUR.md`](../docs/RANCANGAN_FITUR.md).

| Fase | Isi | Status |
|---|---|---|
| 1 | Scaffold, struktur, tema, validator, smoke test | ✅ |
| 2 | Supabase: 19 tabel + `quiz_answers`, RLS, storage, seed | ✅ SQL siap, belum dijalankan |
| 3 | Modul A — auth, profil, verifikasi JBI | 🟡 auth selesai, profil & JBI menyusul |
| 4 | Modul B — katalog, video, favorit, validasi materi | ⬜ |
| 5 | Modul B — kuis, skor, riwayat, progres | ⬜ |
| 6 | Modul C — kamus, STT real-time, consent | ⬜ |
| 7 | Notifikasi FCM, aksesibilitas, error state | ⬜ |
| 8 | Eksekusi 34 test case, RTM, build APK | ⬜ |
