# TuturTangan

**Aplikasi Pendukung Komunikasi dan Pembelajaran BISINDO** — membantu penyandang tunarungu, keluarga, dan masyarakat umum berkomunikasi serta mempelajari Bahasa Isyarat Indonesia.

Proyek Rekayasa Perangkat Lunak — Kelompok 12, Teknik Informatika, Universitas Padjadjaran. Mendukung **SDG 10: Reduced Inequalities**.

> Status: **MVP 1** (modul A–E, G). Fitur lanjutan dicatat sebagai backlog, lihat [Rancangan FR & Database](Keperluan%20Dokumen/Rancangan_FR_dan_Database_Kelompok12.docx).

## Fitur (MVP 1)

| Modul | Fitur |
|---|---|
| A. Akun & Profil | Registrasi/login (peran Pengguna/JBI/Admin), kelola profil, reset kata sandi, verifikasi JBI |
| B. Belajar & Kuis | Katalog kosakata BISINDO per kategori, video gerakan, kuis + skor/riwayat, progres belajar, favorit |
| C. Kamus & Komunikasi | Kamus kata→isyarat, speech-to-text real-time, riwayat transkripsi |
| D. Booking JBI | Daftar JBI + rating, buat/konfirmasi booking, panggilan video, notifikasi, ulasan |
| E. Direktori | Lokasi ramah tuli, filter, usul lokasi, review |
| G. Admin | Kelola pengguna/katalog/verifikasi, dashboard statistik, kelola booking |

**Backlog (di luar MVP 1):** rekomendasi materi otomatis, terjemah teks→urutan isyarat, isyarat→teks via kamera, integrasi Zoom/Google Meet.

## Tech Stack

| Lapisan | Teknologi | Status |
|---|---|---|
| Mobile | **Flutter (Dart)** — satu codebase Android & iOS | Dipilih |
| Backend | REST API (NestJS/Laravel) + PostgreSQL | Usulan, finalisasi Okt 2026 |
| Speech-to-text | API eksternal (streaming) | Usulan |
| Video materi | Cloud storage/CDN, format terkompresi | Usulan |
| Notifikasi | Push notification (FCM) | Usulan |

Dependensi Flutter utama (rencana): `dio`, `flutter_riverpod`, `video_player`/`chewie`, `speech_to_text`, `google_maps_flutter`, `firebase_messaging`, `flutter_secure_storage`, `image_picker`, `intl`.

## Struktur Repo (rencana)

```
.
├── mobile/                 # aplikasi Flutter (dibuat Oktober 2026)
│   └── lib/features/       # auth, belajar, kamus, booking, direktori, admin
├── backend/                # REST API + migrasi database (dibuat Oktober 2026)
├── Keperluan Dokumen/      # dokumentasi RPL (lihat di bawah)
└── README.md
```

**Dokumen yang sudah ada** di `Keperluan Dokumen/`:
- `Dokumentasi_RPL_Kelompok12.tex` — dokumen utama (Bab 1 terisi, MVP 1)
- `Rancangan_FR_dan_Database_Kelompok12.docx` — FR, US, UC, ERD/skema database
- `Diagram_Mermaid/` — diagram use case & activity (`.mmd`)
- `Image/` — diagram PNG untuk Bab 1.8
- `Database_RPL(Kelompok12) (2).docx` — lembar kerja requirement gathering

## Prasyarat

- Flutter SDK 3.32+ (`flutter --version`), Dart 3.8+
- Android Studio + Android SDK (emulator atau HP fisik Android 8.0+)
- JDK 17
- Git

> Catatan iOS: build iOS membutuhkan macOS/Xcode. Pengembangan di Windows difokuskan ke Android; build iOS dapat lewat mesin macOS atau CI (mis. Codemagic/GitHub Actions).

## Setup (Windows)

```powershell
# 1. Install Flutter SDK (lewati jika sudah ada, mis. D:\flutter)
#    Unduh dari https://docs.flutter.dev/get-started/install/windows

# 2. Cek environment
flutter doctor

# 3. Setujui lisensi Android
flutter doctor --android-licenses

# 4. Masuk ke folder aplikasi dan ambil dependensi
Set-Location mobile
flutter pub get

# 5. Siapkan konfigurasi environment (contoh: base URL backend)
Copy-Item .env.example .env   # lalu isi nilainya

# 6. Jalankan (emulator menyala / HP tersambung via USB + USB debugging)
flutter run
```

Perintah lain yang sering dipakai:

```powershell
flutter run -d chrome            # coba cepat di browser (terbatas: mic/kamera)
flutter build apk --release      # APK rilis untuk demo/pengujian
flutter test                     # unit & widget test
flutter analyze                  # static analysis
```

## Tim

- Project Leader: Dzikri Fakhry
- Anggota: Syifa Azzahra, Farell Tirtawijaya, Srikandi Rahmawati, Jovianie Felisia Suryadi
- Sponsor: Dr. Mira Suryani, S.Pd., M.Kom. — Owner: Hafizh Fadhl Muhammad

## Lisensi

Proyek akademik untuk keperluan mata kuliah Rekayasa Perangkat Lunak. Materi BISINDO (video/kosakata) wajib tervalidasi JBI/komunitas sebelum dipakai sebagai konten resmi.
