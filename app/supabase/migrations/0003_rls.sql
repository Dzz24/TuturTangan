-- =====================================================================
-- TuturTangan — 0003: Row Level Security
--
-- Prinsip:
--   * Data pribadi hanya dapat dibaca pemiliknya (dan Admin).
--   * Konten katalog dapat dibaca semua pengguna terautentikasi,
--     tetapi hanya JBI approved / Admin yang boleh menulis.
--   * Kunci jawaban kuis tidak pernah diekspos ke client.
-- =====================================================================

-- Helper: baca peran user saat ini tanpa memicu rekursi RLS.
create or replace function public.current_user_role()
returns public.user_role
language sql
stable
security definer
set search_path = public
as $$
  select role from public.users where id = auth.uid();
$$;

create or replace function public.is_admin()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select coalesce(public.current_user_role() = 'admin', false);
$$;

create or replace function public.is_approved_jbi()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.jbi_profiles
    where user_id = auth.uid()
      and verification_status = 'approved'
  );
$$;

-- Aktifkan RLS pada seluruh tabel.
alter table public.users                enable row level security;
alter table public.user_profiles        enable row level security;
alter table public.user_consents        enable row level security;
alter table public.login_sessions       enable row level security;
alter table public.password_resets      enable row level security;
alter table public.jbi_profiles         enable row level security;
alter table public.notifications        enable row level security;
alter table public.categories           enable row level security;
alter table public.vocabularies         enable row level security;
alter table public.vocabulary_media     enable row level security;
alter table public.vocabulary_synonyms  enable row level security;
alter table public.vocabulary_progress  enable row level security;
alter table public.favorite_vocabularies enable row level security;
alter table public.quizzes              enable row level security;
alter table public.quiz_questions       enable row level security;
alter table public.quiz_options         enable row level security;
alter table public.quiz_results         enable row level security;
alter table public.quiz_answers         enable row level security;
alter table public.transcript_sessions  enable row level security;
alter table public.transcript_lines     enable row level security;

-- ---------------------------------------------------------------- users
create policy users_select_self on public.users
  for select using (id = auth.uid() or public.is_admin());

create policy users_update_self on public.users
  for update using (id = auth.uid()) with check (id = auth.uid());

-- ------------------------------------------------------- user_profiles
create policy profiles_select on public.user_profiles
  for select using (user_id = auth.uid() or public.is_admin());

create policy profiles_insert on public.user_profiles
  for insert with check (user_id = auth.uid());

create policy profiles_update on public.user_profiles
  for update using (user_id = auth.uid()) with check (user_id = auth.uid());

-- ------------------------------------------------------- user_consents
create policy consents_select on public.user_consents
  for select using (user_id = auth.uid() or public.is_admin());

create policy consents_insert on public.user_consents
  for insert with check (user_id = auth.uid());

create policy consents_update on public.user_consents
  for update using (user_id = auth.uid()) with check (user_id = auth.uid());

-- ------------------------------------------------------ login_sessions
create policy sessions_select on public.login_sessions
  for select using (user_id = auth.uid() or public.is_admin());

create policy sessions_insert on public.login_sessions
  for insert with check (user_id = auth.uid());

create policy sessions_update on public.login_sessions
  for update using (user_id = auth.uid()) with check (user_id = auth.uid());

-- ----------------------------------------------------- password_resets
create policy resets_select on public.password_resets
  for select using (user_id = auth.uid() or public.is_admin());

-- -------------------------------------------------------- jbi_profiles
create policy jbi_select on public.jbi_profiles
  for select using (user_id = auth.uid() or public.is_admin());

create policy jbi_insert on public.jbi_profiles
  for insert with check (user_id = auth.uid());

create policy jbi_update_self on public.jbi_profiles
  for update using (user_id = auth.uid()) with check (user_id = auth.uid());

create policy jbi_update_admin on public.jbi_profiles
  for update using (public.is_admin()) with check (public.is_admin());

-- ------------------------------------------------------ notifications
create policy notif_select on public.notifications
  for select using (user_id = auth.uid());

create policy notif_update on public.notifications
  for update using (user_id = auth.uid()) with check (user_id = auth.uid());

create policy notif_insert on public.notifications
  for insert with check (public.is_admin() or public.is_approved_jbi());

-- ----------------------------------------------------------- categories
create policy categories_select on public.categories
  for select to authenticated using (true);

create policy categories_write on public.categories
  for all to authenticated
  using (public.is_admin() or public.is_approved_jbi())
  with check (public.is_admin() or public.is_approved_jbi());

-- --------------------------------------------------------- vocabularies
-- Pengguna hanya melihat materi yang sudah disetujui; JBI/Admin melihat semua.
create policy vocab_select on public.vocabularies
  for select to authenticated
  using (
    validation_status = 'disetujui'
    or public.is_admin()
    or public.is_approved_jbi()
  );

create policy vocab_insert on public.vocabularies
  for insert to authenticated
  with check (public.is_admin() or public.is_approved_jbi());

create policy vocab_update on public.vocabularies
  for update to authenticated
  using (public.is_admin() or public.is_approved_jbi())
  with check (public.is_admin() or public.is_approved_jbi());

-- ------------------------------------------- vocabulary_media / synonyms
create policy media_select on public.vocabulary_media
  for select to authenticated using (true);

create policy media_write on public.vocabulary_media
  for all to authenticated
  using (public.is_admin() or public.is_approved_jbi())
  with check (public.is_admin() or public.is_approved_jbi());

create policy synonym_select on public.vocabulary_synonyms
  for select to authenticated using (true);

create policy synonym_write on public.vocabulary_synonyms
  for all to authenticated
  using (public.is_admin() or public.is_approved_jbi())
  with check (public.is_admin() or public.is_approved_jbi());

-- ------------------------------------------------ vocabulary_progress
create policy progress_all on public.vocabulary_progress
  for all using (user_id = auth.uid()) with check (user_id = auth.uid());

-- ----------------------------------------------- favorite_vocabularies
create policy favorites_all on public.favorite_vocabularies
  for all using (user_id = auth.uid()) with check (user_id = auth.uid());

-- -------------------------------------------------------------- quizzes
create policy quizzes_select on public.quizzes
  for select to authenticated
  using (is_published or public.is_admin() or public.is_approved_jbi());

create policy quizzes_write on public.quizzes
  for all to authenticated
  using (public.is_admin() or public.is_approved_jbi())
  with check (public.is_admin() or public.is_approved_jbi());

create policy questions_select on public.quiz_questions
  for select to authenticated using (true);

create policy questions_write on public.quiz_questions
  for all to authenticated
  using (public.is_admin() or public.is_approved_jbi())
  with check (public.is_admin() or public.is_approved_jbi());

-- Kunci jawaban: kolom is_correct hanya boleh dibaca JBI/Admin.
-- Client pengguna membaca opsi lewat view quiz_options_public (lihat 0004).
create policy options_select on public.quiz_options
  for select to authenticated
  using (public.is_admin() or public.is_approved_jbi());

create policy options_write on public.quiz_options
  for all to authenticated
  using (public.is_admin() or public.is_approved_jbi())
  with check (public.is_admin() or public.is_approved_jbi());

-- -------------------------------------------------------- quiz_results
create policy results_select on public.quiz_results
  for select using (user_id = auth.uid() or public.is_admin());

create policy results_insert on public.quiz_results
  for insert with check (user_id = auth.uid());

create policy answers_select on public.quiz_answers
  for select using (
    exists (
      select 1 from public.quiz_results r
      where r.id = result_id and r.user_id = auth.uid()
    )
    or public.is_admin()
  );

create policy answers_insert on public.quiz_answers
  for insert with check (
    exists (
      select 1 from public.quiz_results r
      where r.id = result_id and r.user_id = auth.uid()
    )
  );

-- -------------------------------------------------- transcript_sessions
create policy transcript_sessions_all on public.transcript_sessions
  for all using (user_id = auth.uid()) with check (user_id = auth.uid());

create policy transcript_lines_all on public.transcript_lines
  for all using (
    exists (
      select 1 from public.transcript_sessions s
      where s.id = session_id and s.user_id = auth.uid()
    )
  ) with check (
    exists (
      select 1 from public.transcript_sessions s
      where s.id = session_id and s.user_id = auth.uid()
    )
  );

-- ------------------------------------------------------------- STORAGE
-- Bucket: avatars (publik), vocab-media (publik), jbi-docs (privat).
insert into storage.buckets (id, name, public)
values
  ('avatars', 'avatars', true),
  ('vocab-media', 'vocab-media', true),
  ('jbi-docs', 'jbi-docs', false)
on conflict (id) do nothing;

create policy avatars_public_read on storage.objects
  for select using (bucket_id = 'avatars');

create policy avatars_owner_write on storage.objects
  for insert with check (
    bucket_id = 'avatars' and (storage.foldername(name))[1] = auth.uid()::text
  );

create policy media_public_read on storage.objects
  for select using (bucket_id = 'vocab-media');

create policy media_admin_write on storage.objects
  for insert with check (
    bucket_id = 'vocab-media' and (public.is_admin() or public.is_approved_jbi())
  );

create policy jbi_docs_owner on storage.objects
  for select using (
    bucket_id = 'jbi-docs'
    and ((storage.foldername(name))[1] = auth.uid()::text or public.is_admin())
  );

create policy jbi_docs_upload on storage.objects
  for insert with check (
    bucket_id = 'jbi-docs' and (storage.foldername(name))[1] = auth.uid()::text
  );
