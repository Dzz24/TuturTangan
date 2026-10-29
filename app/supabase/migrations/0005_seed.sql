-- =====================================================================
-- TuturTangan — 0005: Seed data pengembangan
--
-- PERHATIAN:
--   * video_url masih memakai contoh video publik, BUKAN gerakan BISINDO.
--     Ganti dengan aset komunitas/JBI yang sudah tervalidasi sebelum demo.
--   * seed ini hanya untuk pengembangan lokal & pengujian awal.
-- =====================================================================

-- ----------------------------------------------------------- kategori
insert into public.categories (id, name, description) values
  (1, 'Keluarga',              'Kosakata anggota keluarga'),
  (2, 'Makanan & Minuman',     'Kosakata makanan dan minuman sehari-hari'),
  (3, 'Sapaan',                'Salam dan sapaan umum'),
  (4, 'Angka',                 'Angka dasar'),
  (5, 'Kegiatan Sehari-hari',  'Aktivitas rutin')
on conflict (id) do nothing;

-- --------------------------------------------------------- kosakata
insert into public.vocabularies
  (id, category_id, term, description, difficulty_level, validation_status)
values
  (1,  1, 'Ibu',    'Isyarat untuk menyebut ibu',    'mudah',  'disetujui'),
  (2,  1, 'Ayah',   'Isyarat untuk menyebut ayah',   'mudah',  'disetujui'),
  (3,  1, 'Kakak',  'Isyarat untuk menyebut kakak',  'mudah',  'disetujui'),
  (4,  2, 'Makan',  'Isyarat untuk kegiatan makan',  'mudah',  'disetujui'),
  (5,  2, 'Minum',  'Isyarat untuk kegiatan minum',  'mudah',  'disetujui'),
  (6,  2, 'Air',    'Isyarat untuk air',             'mudah',  'disetujui'),
  (7,  3, 'Halo',   'Sapaan umum',                   'mudah',  'disetujui'),
  (8,  3, 'Terima kasih', 'Ungkapan terima kasih',   'sedang', 'disetujui'),
  (9,  4, 'Satu',   'Angka satu',                    'mudah',  'disetujui'),
  (10, 5, 'Belajar', 'Isyarat kegiatan belajar',     'sedang', 'menunggu')
on conflict (id) do nothing;

-- ------------------------------------------------------------- media
insert into public.vocabulary_media
  (vocabulary_id, video_url, thumbnail_url, movement_description, is_main)
values
  (1,  'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',  null, 'Tangan menyentuh dagu lalu turun', true),
  (2,  'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4', null, 'Tangan menyentuh dahi lalu turun', true),
  (3,  'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4',     null, 'Tangan bergerak ke samping kepala', true),
  (4,  'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4', null, 'Tangan mendekat ke mulut', true),
  (5,  'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4', null, 'Tangan seperti memegang gelas', true),
  (6,  'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',  null, 'Jari membentuk aliran air', true),
  (7,  'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4', null, 'Tangan melambai di dekat kepala', true),
  (8,  'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4',     null, 'Tangan menyentuh dagu lalu menjauh', true),
  (9,  'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4', null, 'Telunjuk diangkat', true),
  (10, 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4', null, 'Kedua tangan membuka seperti buku', true);

-- ---------------------------------------------------------- sinonim
insert into public.vocabulary_synonyms (vocabulary_id, synonym) values
  (4, 'makanan'),
  (4, 'mengonsumsi'),
  (5, 'minuman'),
  (7, 'hai'),
  (8, 'makasih'),
  (10, 'studi')
on conflict do nothing;

-- -------------------------------------------------------------- kuis
insert into public.quizzes (id, category_id, title, description, is_published)
values
  (1, 2, 'Kuis Makanan & Minuman', 'Uji pemahaman kosakata makan, minum, dan air', true),
  (2, 1, 'Kuis Keluarga',          'Uji pemahaman kosakata anggota keluarga',     true)
on conflict (id) do nothing;

insert into public.quiz_questions (id, quiz_id, question_type, question_text, explanation, order_index)
values
  (1, 1, 'teks',  'Isyarat manakah yang berarti "makan"?',  'Isyarat "makan" dilakukan dengan tangan mendekat ke mulut.', 1),
  (2, 1, 'teks',  'Isyarat manakah yang berarti "minum"?',  'Isyarat "minum" menyerupai gerakan memegang gelas.',          2),
  (3, 1, 'teks',  'Isyarat manakah yang berarti "air"?',    'Isyarat "air" digambarkan dengan jari membentuk aliran.',     3),
  (4, 2, 'teks',  'Isyarat manakah yang berarti "ibu"?',    'Isyarat "ibu" menyentuh dagu lalu turun.',                    1),
  (5, 2, 'teks',  'Isyarat manakah yang berarti "ayah"?',   'Isyarat "ayah" menyentuh dahi lalu turun.',                   2)
on conflict (id) do nothing;

insert into public.quiz_options (question_id, option_text, is_correct) values
  (1, 'Tangan mendekat ke mulut',  true),
  (1, 'Tangan diangkat ke atas',   false),
  (1, 'Telunjuk menunjuk depan',   false),
  (2, 'Tangan seperti memegang gelas', true),
  (2, 'Tangan menyentuh dahi',     false),
  (2, 'Kedua tangan mengepal',     false),
  (3, 'Jari membentuk aliran air', true),
  (3, 'Tangan melambai',           false),
  (3, 'Tangan menyilang dada',     false),
  (4, 'Menyentuh dagu lalu turun', true),
  (4, 'Menyentuh dahi lalu turun', false),
  (4, 'Menunjuk ke samping',       false),
  (5, 'Menyentuh dahi lalu turun', true),
  (5, 'Menyentuh dagu lalu turun', false),
  (5, 'Mengetuk meja',             false);

-- Seed selesai. Akun demo dibuat lewat Supabase Auth (lihat README),
-- karena kata sandi dikelola auth.users, bukan tabel public.users.
