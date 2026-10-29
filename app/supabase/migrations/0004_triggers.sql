-- =====================================================================
-- TuturTangan — 0004: Fungsi & Trigger
-- =====================================================================

-- ------------------------------------------------- updated_at otomatis
create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create trigger users_set_updated_at
  before update on public.users
  for each row execute function public.set_updated_at();

create trigger user_profiles_set_updated_at
  before update on public.user_profiles
  for each row execute function public.set_updated_at();

create trigger user_consents_set_updated_at
  before update on public.user_consents
  for each row execute function public.set_updated_at();

create trigger jbi_profiles_set_updated_at
  before update on public.jbi_profiles
  for each row execute function public.set_updated_at();

create trigger vocabularies_set_updated_at
  before update on public.vocabularies
  for each row execute function public.set_updated_at();

create trigger quizzes_set_updated_at
  before update on public.quizzes
  for each row execute function public.set_updated_at();

-- ------------------------------------------- consent granted_at otomatis
create or replace function public.set_consent_granted_at()
returns trigger
language plpgsql
as $$
begin
  if new.is_granted and (old.is_granted is distinct from true) then
    new.granted_at = now();
  elsif not new.is_granted then
    new.granted_at = null;
  end if;
  return new;
end;
$$;

create trigger user_consents_set_granted_at
  before update on public.user_consents
  for each row execute function public.set_consent_granted_at();

-- ------------------------------------- registrasi: salin user ke tabel app
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_role public.user_role;
begin
  v_role := coalesce(
    nullif(new.raw_user_meta_data ->> 'role', '')::public.user_role,
    'pengguna'
  );

  insert into public.users (id, full_name, email, role)
  values (
    new.id,
    coalesce(nullif(new.raw_user_meta_data ->> 'full_name', ''),
             split_part(new.email, '@', 1)),
    new.email,
    v_role
  );

  insert into public.user_profiles (user_id) values (new.id);

  insert into public.user_consents (user_id, consent_type, is_granted)
  values
    (new.id, 'transkripsi', false),
    (new.id, 'notifikasi', true),
    (new.id, 'lokasi', false);

  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- ------------------------ view opsi kuis tanpa kunci jawaban (FR-009)
-- Sengaja TIDAK memakai security_invoker: view dijalankan sebagai pemilik
-- (postgres) sehingga RLS quiz_options tidak memblokir pengguna biasa,
-- tetapi kolom is_correct tetap tidak pernah terekspos.
create or replace view public.quiz_options_public as
select id, question_id, option_text
from public.quiz_options;

grant select on public.quiz_options_public to authenticated;

-- =====================================================================
-- Penjaga eskalasi hak akses (NFR-001)
--
-- RLS saja tidak cukup: policy "update baris milik sendiri" tetap
-- mengizinkan pengguna mengubah kolom sensitif. Trigger berikut menutup
-- celah tersebut.
-- =====================================================================

-- Pengguna tidak boleh menaikkan peran dirinya sendiri.
create or replace function public.prevent_role_escalation()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if new.role is distinct from old.role
     and auth.uid() is not null
     and not public.is_admin() then
    raise exception 'Perubahan peran hanya boleh dilakukan oleh Admin.';
  end if;
  return new;
end;
$$;

create trigger users_prevent_role_escalation
  before update on public.users
  for each row execute function public.prevent_role_escalation();

-- JBI tidak boleh menyetujui pengajuannya sendiri.
create or replace function public.prevent_jbi_self_approval()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if new.verification_status is distinct from old.verification_status
     and auth.uid() is not null
     and not public.is_admin() then
    raise exception 'Status verifikasi hanya boleh diubah oleh Admin.';
  end if;
  return new;
end;
$$;

create trigger jbi_profiles_prevent_self_approval
  before update on public.jbi_profiles
  for each row execute function public.prevent_jbi_self_approval();
