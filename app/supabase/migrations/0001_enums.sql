-- =====================================================================
-- TuturTangan — 0001: Tipe ENUM
-- Jalankan berurutan: 0001 -> 0002 -> 0003 -> 0004 -> 0005
-- =====================================================================

create type public.user_role as enum ('pengguna', 'jbi', 'admin');

create type public.verification_status as enum ('pending', 'approved', 'rejected');

create type public.consent_type as enum ('transkripsi', 'notifikasi', 'lokasi');

create type public.validation_status as enum ('menunggu', 'disetujui', 'ditolak');

create type public.difficulty_level as enum ('mudah', 'sedang', 'sulit');

create type public.mastery_status as enum ('belum', 'belajar', 'dikuasai');

create type public.question_type as enum ('teks', 'video');

create type public.session_status as enum ('berlangsung', 'selesai');

create type public.notification_type as enum (
  'verifikasi_jbi',
  'validasi_materi',
  'umum'
);
