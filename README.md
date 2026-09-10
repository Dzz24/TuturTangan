# TuturTangan

> **Aplikasi Pendukung Komunikasi dan Pembelajaran BISINDO**

TuturTangan adalah aplikasi yang dirancang untuk **mendukung komunikasi, pembelajaran, dan akses informasi bagi penyandang tunarungu, keluarga, serta masyarakat umum** melalui Bahasa Isyarat Indonesia (BISINDO).

Proyek ini dikembangkan sebagai bagian dari mata kuliah **Rekayasa Perangkat Lunak** oleh Kelompok 12, Program Studi Teknik Informatika, Universitas Padjadjaran, dengan mengacu pada **SDG 10 — Reduced Inequalities**.

---

## 📌 Project Status

**MVP 1 — In Development**

MVP 1 mencakup modul **A–E dan G**, sementara fitur lanjutan telah dicatat sebagai backlog untuk pengembangan berikutnya.

> **Catatan:** Backend dan implementasi aplikasi mobile direncanakan mulai dikembangkan pada Oktober 2026.

---

## 🎯 Tujuan

TuturTangan dikembangkan untuk membantu:

* 🧏 **Penyandang tunarungu** dalam memperoleh akses komunikasi dan pembelajaran BISINDO.
* 👨‍👩‍👧 **Keluarga** dalam mempelajari dan berkomunikasi menggunakan BISINDO.
* 👥 **Masyarakat umum** dalam memahami serta menggunakan Bahasa Isyarat Indonesia.
* 🤝 **Juru Bahasa Isyarat (JBI)** dalam menyediakan layanan penerjemahan dan komunikasi.
* 🏢 **Penyedia layanan** dalam menemukan serta menyediakan fasilitas yang lebih ramah terhadap komunitas tuli.

Pengembangan aplikasi ini diharapkan dapat berkontribusi dalam mengurangi kesenjangan akses komunikasi dan informasi bagi penyandang tunarungu.

---

# ✨ Fitur Utama

| Modul                     | Fitur                                                                                                    |
| ------------------------- | -------------------------------------------------------------------------------------------------------- |
| **A. Akun & Profil**      | Registrasi & login, manajemen profil, reset kata sandi, role Pengguna/JBI/Admin, verifikasi JBI          |
| **B. Belajar & Kuis**     | Katalog kosakata BISINDO, kategori materi, video gerakan, kuis, skor & riwayat, progres belajar, favorit |
| **C. Kamus & Komunikasi** | Kamus kata → isyarat, speech-to-text secara real-time, riwayat transkripsi                               |
| **D. Booking JBI**        | Daftar JBI, rating, booking, konfirmasi booking, panggilan video, notifikasi, ulasan                     |
| **E. Direktori**          | Lokasi ramah tuli, pencarian & filter lokasi, pengusulan lokasi, review                                  |
| **G. Admin**              | Manajemen pengguna, katalog, verifikasi JBI, booking, serta dashboard statistik                          |

### 🚧 Backlog

Fitur berikut belum termasuk dalam MVP 1 dan direncanakan untuk pengembangan selanjutnya:

* Rekomendasi materi belajar secara otomatis
* Penerjemahan teks → urutan gerakan isyarat
* Pengenalan isyarat → teks menggunakan kamera
* Integrasi dengan Zoom / Google Meet

---

# 🏗️ Tech Stack

| Layer              | Technology                     | Status    |
| ------------------ | ------------------------------ | --------- |
| **Mobile**         | Flutter (Dart)                 | ✅ Dipilih |
| **Backend**        | REST API — NestJS / Laravel    | 🔄 Usulan |
| **Database**       | PostgreSQL                     | 🔄 Usulan |
| **Speech-to-Text** | External Streaming API         | 🔄 Usulan |
| **Video Storage**  | Cloud Storage + CDN            | 🔄 Usulan |
| **Notification**   | Firebase Cloud Messaging (FCM) | 🔄 Usulan |

### Flutter Dependencies

Dependensi utama yang direncanakan:

```text
dio
flutter_riverpod
video_player / chewie
speech_to_text
google_maps_flutter
firebase_messaging
flutter_secure_storage
image_picker
intl
```

> Pemilihan teknologi backend dan beberapa layanan eksternal masih dalam tahap finalisasi.

---

# 📂 Project Structure

Struktur repository yang direncanakan:

```text
.
├── mobile/                         # Flutter mobile application
│   └── lib/
│       └── features/
│           ├── auth/
│           ├── belajar/
│           ├── kamus/
│           ├── booking/
│           ├── direktori/
│           └── admin/
│
├── backend/                        # REST API & database
    ├── src/
    ├── migrations/
    └── ...
---

# 📚 Project Documentation

Dokumentasi proyek tersedia di folder `Keperluan Dokumen/`.

### Dokumen Utama

| Dokumen                                     | Deskripsi                                                                 |
| ------------------------------------------- | ------------------------------------------------------------------------- |
| `Dokumentasi_RPL_Kelompok12.tex`            | Dokumen utama Rekayasa Perangkat Lunak                                    |
| `Rancangan_FR_dan_Database_Kelompok12.docx` | Functional Requirement, User Story, Use Case, ERD, dan rancangan database |
| `Database_RPL(Kelompok12) (2).docx`         | Lembar kerja requirement gathering                                        |
| `Diagram_Mermaid/`                          | Source diagram Use Case & Activity dalam format Mermaid                   |
| `Image/`                                    | Diagram dan aset visual untuk dokumentasi                                 |

---

# ⚙️ Requirements

Sebelum menjalankan aplikasi, pastikan environment berikut telah tersedia:

* **Flutter SDK** 3.32+
* **Dart** 3.8+
* **Android Studio**
* **Android SDK**
* **JDK** 17
* **Git**
* Android Emulator atau perangkat Android fisik dengan **Android 8.0+**

Untuk pengembangan iOS, diperlukan **macOS + Xcode**.

> Pengembangan utama di Windows difokuskan pada Android. Build iOS dapat dilakukan menggunakan mesin macOS atau layanan CI/CD seperti Codemagic atau GitHub Actions.

---

# 🚀 Getting Started

## 1. Clone Repository

```bash
git clone <repository-url>
cd <repository-folder>
```

## 2. Pastikan Flutter Siap

```powershell
flutter doctor
```

Jika diperlukan, setujui lisensi Android:

```powershell
flutter doctor --android-licenses
```

## 3. Masuk ke Folder Mobile

```powershell
Set-Location mobile
```

## 4. Install Dependencies

```powershell
flutter pub get
```

## 5. Konfigurasi Environment

Salin file environment:

```powershell
Copy-Item .env.example .env
```

Kemudian isi konfigurasi yang diperlukan, seperti:

```env
BASE_URL=<backend-url>
```

> Jangan commit file `.env` yang berisi credential atau API key ke repository.

## 6. Jalankan Aplikasi

Pastikan emulator aktif atau perangkat Android telah terhubung melalui USB dengan USB Debugging aktif.

```powershell
flutter run
```

---

# 🛠️ Development Commands

### Menjalankan aplikasi

```powershell
flutter run
```

### Menjalankan melalui Chrome

```powershell
flutter run -d chrome
```

> Mode Chrome hanya digunakan untuk pengujian cepat. Beberapa fitur seperti microphone, camera, dan integrasi native mungkin memiliki keterbatasan.

### Menjalankan test

```powershell
flutter test
```

### Static analysis

```powershell
flutter analyze
```

### Build APK

```powershell
flutter build apk --release
```

---

# 🔐 Security & Data

Beberapa prinsip keamanan yang digunakan dalam pengembangan aplikasi:

* Token autentikasi disimpan menggunakan secure storage.
* Credential dan API key tidak disimpan langsung di source code.
* File `.env` tidak boleh di-commit ke repository.
* Akses fitur dibatasi berdasarkan role pengguna.
* Data pengguna harus diproses sesuai kebutuhan fungsional aplikasi.
* Materi BISINDO yang digunakan sebagai konten resmi harus melalui proses validasi.

---

# 🧩 Development Guidelines

Untuk menjaga repository tetap terstruktur:

### Branch

Gunakan branch berdasarkan jenis pekerjaan:

```text
main
develop
feature/<nama-fitur>
fix/<nama-perbaikan>
docs/<nama-dokumentasi>
```

Contoh:

```text
feature/login
feature/bisindo-dictionary
feature/jbi-booking
fix/auth-validation
```

### Commit

Gunakan commit message yang deskriptif:

```text
feat: add user authentication
feat: add BISINDO vocabulary catalog
fix: resolve booking validation
docs: update project documentation
refactor: improve authentication service
```

---

# 👥 Team

**Kelompok 12 — Teknik Informatika
Universitas Padjadjaran**

| Role                | Member                          |
| ------------------- | ------------------------------- |
| **Project Leader**  | Dzikri Fakhry                   |
| **Member**          | Syifa Azzahra                   |
| **Member**          | Farell Tirtawijaya              |
| **Member**          | Srikandi Rahmawati              |
| **Member**          | Jovianie Felisia Suryadi        |
| **Project Sponsor** | Dr. Mira Suryani, S.Pd., M.Kom. |

---

# 🌏 SDG Alignment

TuturTangan mendukung:

### SDG 10 — Reduced Inequalities

> **Reduce inequality within and among countries.**

Aplikasi ini berfokus pada peningkatan akses komunikasi, pembelajaran, dan informasi bagi penyandang tunarungu serta masyarakat yang ingin berkomunikasi menggunakan BISINDO.

---

# ⚠️ Content & Accessibility Disclaimer

TuturTangan merupakan proyek akademik yang dikembangkan untuk mendukung pembelajaran dan komunikasi menggunakan BISINDO.

Materi berupa **video, kosakata, dan contoh gerakan BISINDO wajib divalidasi oleh Juru Bahasa Isyarat (JBI) dan/atau komunitas tuli** sebelum digunakan sebagai konten resmi aplikasi.

Pengembangan fitur juga mempertimbangkan prinsip aksesibilitas dan kebutuhan pengguna tuli berdasarkan hasil requirement gathering dan validasi pengguna.

---

# 📄 License

Proyek ini dikembangkan untuk **keperluan akademik mata kuliah Rekayasa Perangkat Lunak, Teknik Informatika, Universitas Padjadjaran**.

© 2026 Kelompok 12 — Teknik Informatika, Universitas Padjadjaran.
