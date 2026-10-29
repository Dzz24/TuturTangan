-- =====================================================================
-- TuturTangan — 0002: Tabel & Indeks (19 tabel MVP + quiz_answers)
--
-- Catatan keputusan teknis (lihat docs/RANCANGAN_FITUR.md §9):
--   * users.id bertipe UUID dan = auth.users.id
--   * kolom password_hash TIDAK ada (dikelola Supabase Auth)
--   * quiz_answers ditambahkan agar FR-010 (pembahasan per soal) terpenuhi
-- =====================================================================

-- ---------------------------------------------------------------- MODUL A
-- Akun, profil, privasi

create table public.users (
  id          uuid primary key references auth.users (id) on delete cascade,
  full_name   varchar(150) not null,
  email       varchar(255) not null unique,
  role        public.user_role not null default 'pengguna',
  is_active   boolean not null default true,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

create table public.user_profiles (
  user_id               uuid primary key references public.users (id) on delete cascade,
  photo_url             text,
  bio                   varchar(300),
  special_needs         varchar(300),
  default_sign_language varchar(20) not null default 'BISINDO',
  created_at            timestamptz not null default now(),
  updated_at            timestamptz not null default now()
);

create table public.user_consents (
  id           bigserial primary key,
  user_id      uuid not null references public.users (id) on delete cascade,
  consent_type public.consent_type not null,
  is_granted   boolean not null default false,
  granted_at   timestamptz,
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now(),
  unique (user_id, consent_type)
);

create table public.login_sessions (
  id          bigserial primary key,
  user_id     uuid not null references public.users (id) on delete cascade,
  token_hash  varchar(255) not null,
  device_info varchar(255),
  expires_at  timestamptz not null,
  is_revoked  boolean not null default false,
  created_at  timestamptz not null default now()
);

create table public.password_resets (
  id         bigserial primary key,
  user_id    uuid not null references public.users (id) on delete cascade,
  token_hash varchar(255) not null,
  expires_at timestamptz not null,
  is_used    boolean not null default false,
  created_at timestamptz not null default now()
);

create table public.jbi_profiles (
  user_id               uuid primary key references public.users (id) on delete cascade,
  certification_doc_url text not null,
  affiliation           varchar(150),
  experience_years      int check (experience_years >= 0),
  verification_status   public.verification_status not null default 'pending',
  rejection_reason      varchar(300),
  verified_by           uuid references public.users (id),
  verified_at           timestamptz,
  created_at            timestamptz not null default now(),
  updated_at            timestamptz not null default now()
);

create table public.notifications (
  id         bigserial primary key,
  user_id    uuid not null references public.users (id) on delete cascade,
  type       public.notification_type not null default 'umum',
  title      varchar(150) not null,
  content    text not null,
  is_read    boolean not null default false,
  created_at timestamptz not null default now()
);

-- ---------------------------------------------------------------- MODUL B
-- Katalog, kuis, progres

create table public.categories (
  id          bigserial primary key,
  name        varchar(100) not null unique,
  description varchar(300),
  created_at  timestamptz not null default now()
);

create table public.vocabularies (
  id                bigserial primary key,
  category_id       bigint not null references public.categories (id) on delete restrict,
  term              varchar(255) not null,
  description       text,
  difficulty_level  public.difficulty_level not null default 'mudah',
  validation_status public.validation_status not null default 'menunggu',
  created_by        uuid references public.users (id),
  validated_by      uuid references public.users (id),
  validated_at      timestamptz,
  rejection_reason  varchar(300),
  created_at        timestamptz not null default now(),
  updated_at        timestamptz not null default now()
);

create table public.vocabulary_media (
  id                   bigserial primary key,
  vocabulary_id        bigint not null references public.vocabularies (id) on delete cascade,
  video_url            text not null,
  thumbnail_url        text,
  movement_description text,
  is_main              boolean not null default false,
  created_at           timestamptz not null default now()
);

create table public.vocabulary_synonyms (
  id            bigserial primary key,
  vocabulary_id bigint not null references public.vocabularies (id) on delete cascade,
  synonym       varchar(255) not null,
  unique (vocabulary_id, synonym)
);

create table public.vocabulary_progress (
  id            bigserial primary key,
  user_id       uuid not null references public.users (id) on delete cascade,
  vocabulary_id bigint not null references public.vocabularies (id) on delete cascade,
  mastery_status public.mastery_status not null default 'belum',
  updated_at    timestamptz not null default now(),
  unique (user_id, vocabulary_id)
);

create table public.favorite_vocabularies (
  id            bigserial primary key,
  user_id       uuid not null references public.users (id) on delete cascade,
  vocabulary_id bigint not null references public.vocabularies (id) on delete cascade,
  added_at      timestamptz not null default now(),
  unique (user_id, vocabulary_id)
);

create table public.quizzes (
  id          bigserial primary key,
  category_id bigint not null references public.categories (id) on delete restrict,
  title       varchar(150) not null,
  description text,
  is_published boolean not null default false,
  created_by  uuid references public.users (id),
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

create table public.quiz_questions (
  id            bigserial primary key,
  quiz_id       bigint not null references public.quizzes (id) on delete cascade,
  question_type public.question_type not null default 'teks',
  question_text text not null,
  media_id      bigint references public.vocabulary_media (id) on delete set null,
  explanation   text,
  order_index   int not null default 0
);

create table public.quiz_options (
  id          bigserial primary key,
  question_id bigint not null references public.quiz_questions (id) on delete cascade,
  option_text varchar(255) not null,
  is_correct  boolean not null default false
);

create table public.quiz_results (
  id               bigserial primary key,
  user_id          uuid not null references public.users (id) on delete cascade,
  quiz_id          bigint not null references public.quizzes (id) on delete cascade,
  total_questions  int not null,
  correct_answers  int not null,
  score            decimal(5, 2) not null,
  duration_seconds int,
  taken_at         timestamptz not null default now()
);

-- Ditambahkan agar FR-010 dapat menampilkan pembahasan per soal.
create table public.quiz_answers (
  id         bigserial primary key,
  result_id  bigint not null references public.quiz_results (id) on delete cascade,
  question_id bigint not null references public.quiz_questions (id) on delete cascade,
  option_id  bigint references public.quiz_options (id) on delete set null,
  is_correct boolean not null default false,
  unique (result_id, question_id)
);

-- ---------------------------------------------------------------- MODUL C
-- Kamus & komunikasi

create table public.transcript_sessions (
  id         bigserial primary key,
  user_id    uuid not null references public.users (id) on delete cascade,
  consent_id bigint not null references public.user_consents (id),
  language   varchar(10) not null default 'id-ID',
  status     public.session_status not null default 'berlangsung',
  started_at timestamptz not null default now(),
  ended_at   timestamptz
);

create table public.transcript_lines (
  id          bigserial primary key,
  session_id  bigint not null references public.transcript_sessions (id) on delete cascade,
  line_number int not null,
  speaker     varchar(50),
  content     text not null,
  confidence  decimal(4, 3),
  created_at  timestamptz not null default now(),
  unique (session_id, line_number)
);

-- ---------------------------------------------------------------- INDEKS
-- Semua foreign key diberi indeks (NFR-002).

create index idx_user_profiles_user on public.user_profiles (user_id);
create index idx_user_consents_user on public.user_consents (user_id);
create index idx_login_sessions_user on public.login_sessions (user_id);
create index idx_login_sessions_active on public.login_sessions (user_id, is_revoked);
create index idx_password_resets_user on public.password_resets (user_id);
create index idx_jbi_profiles_status on public.jbi_profiles (verification_status);
create index idx_notifications_user on public.notifications (user_id, is_read);

create index idx_vocabularies_category on public.vocabularies (category_id);
create index idx_vocabularies_status on public.vocabularies (validation_status);
create index idx_vocabulary_media_vocab on public.vocabulary_media (vocabulary_id);
create index idx_vocabulary_synonyms_vocab on public.vocabulary_synonyms (vocabulary_id);
create index idx_vocabulary_progress_user on public.vocabulary_progress (user_id);
create index idx_vocabulary_progress_vocab on public.vocabulary_progress (vocabulary_id);
create index idx_favorites_user on public.favorite_vocabularies (user_id);
create index idx_favorites_vocab on public.favorite_vocabularies (vocabulary_id);
create index idx_quizzes_category on public.quizzes (category_id);
create index idx_quiz_questions_quiz on public.quiz_questions (quiz_id);
create index idx_quiz_options_question on public.quiz_options (question_id);
create index idx_quiz_results_user on public.quiz_results (user_id, taken_at desc);
create index idx_quiz_results_quiz on public.quiz_results (quiz_id);
create index idx_quiz_answers_result on public.quiz_answers (result_id);
create index idx_transcript_sessions_user on public.transcript_sessions (user_id, started_at desc);
create index idx_transcript_sessions_consent on public.transcript_sessions (consent_id);
create index idx_transcript_lines_session on public.transcript_lines (session_id, line_number);

-- Pencarian cepat pada istilah kosakata (NFR-002).
-- Supabase memasang pg_trgm di skema `extensions`, jadi operator class
-- harus ditulis lengkap.
create extension if not exists pg_trgm with schema extensions;
create index idx_vocabularies_term_trgm
  on public.vocabularies using gin (term extensions.gin_trgm_ops);
create index idx_synonyms_synonym_trgm
  on public.vocabulary_synonyms using gin (synonym extensions.gin_trgm_ops);
