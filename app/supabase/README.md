# Konfigurasi Supabase — TuturTangan

Panduan lengkap dari nol sampai aplikasi tersambung. Perkiraan waktu: 15–20 menit.

---

## 1. Buat akun & project

1. Buka https://supabase.com → **Start your project** → daftar dengan GitHub/email.
2. **New project**, isi:

   | Field | Nilai |
   |---|---|
   | Name | `tuturtangan` |
   | Database Password | kata sandi kuat — **simpan**, dipakai untuk akses DB langsung |
   | Region | **Southeast Asia (Singapore)** — terdekat ke Indonesia |
   | Plan | Free |

3. Tunggu ±2 menit sampai status project **Active**.

> Free tier: 500 MB database, 1 GB storage, 2 project aktif. Cukup untuk MVP.

---

## 2. Ambil kredensial

**Project Settings → API** (atau **Data API**):

| Yang dicari | Dipakai untuk |
|---|---|
| **Project URL** (`https://xxxx.supabase.co`) | `--dart-define=SUPABASE_URL` |
| **anon / public key** (`eyJhbGciOi...`) | `--dart-define=SUPABASE_ANON_KEY` |

Jangan pernah memakai **service_role key** di aplikasi — kunci itu melewati RLS.

---

## 3. Jalankan migrasi

Buka **SQL Editor** → **New query**, lalu tempel isi file **berurutan** dan klik **Run** setiap kali:

| Urutan | File | Isi |
|---|---|---|
| 1 | `migrations/0001_enums.sql` | 9 tipe ENUM |
| 2 | `migrations/0002_tables.sql` | 19 tabel MVP + `quiz_answers` + indeks |
| 3 | `migrations/0003_rls.sql` | RLS, policy, bucket storage |
| 4 | `migrations/0004_triggers.sql` | `updated_at`, sinkronisasi `auth.users`, penjaga eskalasi peran, view opsi kuis |
| 5 | `migrations/0005_seed.sql` | 5 kategori, 10 kosakata, 2 kuis |

**Jangan lompat urutan** — `0002` butuh ENUM dari `0001`, dan `0003` butuh tabel dari `0002`.

Setelah selesai, cek di **Table Editor**: harus ada **20 tabel** di skema `public`.

---

## 4. Setelan Authentication

**Authentication → Sign In / Providers → Email**:

| Setelan | Nilai untuk pengembangan | Alasan |
|---|---|---|
| Enable Email provider | ✅ aktif | FR-001 |
| **Confirm email** | ❌ **matikan** | agar akun baru langsung bisa login tanpa cek inbox |
| Minimum password length | `8` | FR-001 |

> Saat demo/sidang, nyalakan kembali *Confirm email* supaya sesuai NFR-001.

**Authentication → URL Configuration**:

- **Site URL**: `http://localhost:3000` (sementara)
- **Redirect URLs** → tambahkan:
  ```
  tuturtangan://reset-password
  ```

Tanpa entri ini, tautan reset kata sandi (FR-003) akan ditolak Supabase.

---

## 5. Storage

Bucket sudah dibuat otomatis oleh `0003_rls.sql`. Verifikasi di **Storage**:

| Bucket | Publik | Dipakai untuk |
|---|---|---|
| `avatars` | ✅ | foto profil (FR-004) |
| `vocab-media` | ✅ | video & thumbnail kosakata (FR-007) |
| `jbi-docs` | ❌ | dokumen sertifikasi JBI (FR-005) |

---

## 6. Jalankan aplikasi

```powershell
cd "D:\Kuliah\Semester 5\RPL\app"

flutter run -d edge `
  --dart-define=SUPABASE_URL=https://xxxx.supabase.co `
  --dart-define=SUPABASE_ANON_KEY=eyJhbGciOi...
```

Kalau kredensial benar, kartu **"Mode pengembangan"** di halaman login hilang dan
akun demo mock tidak berlaku lagi — daftar akun baru lewat halaman **Registrasi**.

Agar tidak mengetik ulang setiap kali, simpan di `.vscode/launch.json`:

```json
{
  "name": "Supabase (web)",
  "request": "launch",
  "type": "dart",
  "deviceId": "edge",
  "toolArgs": [
    "--dart-define=SUPABASE_URL=https://xxxx.supabase.co",
    "--dart-define=SUPABASE_ANON_KEY=eyJhbGciOi..."
  ]
}
```

> File `launch.json` berisi kunci — jangan di-commit. Anon key memang aman
> dipublikasikan (dibatasi RLS), tetapi tetap lebih rapi tidak masuk repo.

---

## 7. Jadikan akun pertama sebagai Admin

Daftar dulu lewat aplikasi, lalu di **SQL Editor**:

```sql
-- lihat semua akun
select id, email, role, is_active, created_at from public.users order by created_at;

-- jadikan admin
update public.users set role = 'admin' where email = 'emailkamu@gmail.com';
```

> Trigger `users_prevent_role_escalation` **tidak** memblokir perintah ini karena
> dijalankan dari SQL Editor (tanpa `auth.uid()`). Pengguna biasa tetap tidak
> bisa menaikkan perannya sendiri lewat aplikasi.

---

## 8. Verifikasi cepat

Jalankan di SQL Editor:

```sql
-- 1. jumlah tabel & policy
select count(*) as tabel from pg_tables where schemaname = 'public';       -- 20
select count(*) as policy from pg_policies where schemaname = 'public';    -- 30+

-- 2. seed masuk
select count(*) as kategori from public.categories;    -- 5
select count(*) as kosakata from public.vocabularies;  -- 10
select count(*) as kuis from public.quizzes;           -- 2

-- 3. bucket storage
select id, public from storage.buckets order by id;

-- 4. trigger sinkronisasi user terpasang
select tgname from pg_trigger where tgname = 'on_auth_user_created';

-- 5. kunci jawaban tidak terekspos ke pengguna biasa
select * from public.quiz_options_public limit 3;      -- hanya id, question_id, option_text
```

Uji RLS dari aplikasi: login sebagai pengguna biasa, lalu coba buka data
pengguna lain — seharusnya **0 baris**, bukan error.

---

## 9. Troubleshooting

| Gejala | Penyebab & solusi |
|---|---|
| `permission denied for schema auth` | Query dijalankan sebagai role terbatas. Pakai **SQL Editor** (berjalan sebagai `postgres`), bukan koneksi anon. |
| `relation "auth.users" does not exist` | Sedang menunjuk Postgres lokal, bukan project Supabase. |
| `new row violates row-level security policy` | Tidak ada sesi login, atau policy belum dibuat (ulangi `0003`). |
| Login berhasil tapi profil kosong | Trigger `on_auth_user_created` belum ada saat signup. Hapus user di **Authentication → Users**, jalankan ulang `0004`, lalu daftar lagi. |
| Tautan reset tidak kembali ke app | `tuturtangan://reset-password` belum ada di **Redirect URLs**. |
| `type "user_role" does not exist` | `0001_enums.sql` belum dijalankan. |
| Indeks trigram gagal | pg_trgm belum aktif — jalankan `create extension pg_trgm with schema extensions;` lalu ulangi `0002`. |

---

## 10. Yang belum dicakup

| Komponen | Kapan |
|---|---|
| Edge Function `quiz-submit` (skor di server) | Fase 5 — butuh Supabase CLI |
| Edge Function notifikasi JBI/materi | Fase 7 |
| FCM (push notification) | Fase 7 — butuh `google-services.json` |
| RLS policy untuk `quiz_answers` pembahasan | sudah ada di `0003` |

Untuk Edge Functions nanti:

```powershell
npm install -g supabase
supabase login
supabase link --project-ref <project-ref>
supabase functions deploy quiz-submit
```
