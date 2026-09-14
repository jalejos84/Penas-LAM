-- Penas LAM - Supabase schema (project: penas-lam)
create extension if not exists pgcrypto;

create table if not exists public.profiles (
  user_id uuid primary key references auth.users(id) on delete cascade,
  nombre text,
  created_at timestamptz not null default now()
);

create table if not exists public.article_progress (
  user_id uuid not null references auth.users(id) on delete cascade,
  articulo integer not null check (articulo between 99 and 138),
  dominio integer not null default 0 check (dominio between 0 and 100),
  intentos integer not null default 0,
  correctas integer not null default 0,
  incorrectas integer not null default 0,
  flashcards integer not null default 0,
  ease_factor numeric not null default 2.5,
  intervalo integer not null default 0,
  repeticiones integer not null default 0,
  ultima_revision timestamptz,
  proxima_revision timestamptz,
  errores jsonb not null default '{}'::jsonb,
  payload jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now(),
  primary key (user_id, articulo)
);

create table if not exists public.attempts (
  id text primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  articulo integer not null check (articulo between 99 and 138),
  tipo_pregunta text,
  correcta boolean not null,
  tipo_error text,
  fecha timestamptz not null default now(),
  metadata jsonb not null default '{}'::jsonb
);

create table if not exists public.study_sessions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  inicio timestamptz not null default now(),
  fin timestamptz,
  preguntas integer not null default 0,
  correctas integer not null default 0,
  puntaje numeric
);

create table if not exists public.user_settings (
  user_id uuid primary key references auth.users(id) on delete cascade,
  configuracion jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

create index if not exists idx_article_progress_user on public.article_progress(user_id);
create index if not exists idx_attempts_user on public.attempts(user_id);
create index if not exists idx_attempts_user_fecha on public.attempts(user_id, fecha);
create index if not exists idx_study_sessions_user on public.study_sessions(user_id);

grant select, insert, update, delete on public.profiles to authenticated;
grant select, insert, update, delete on public.article_progress to authenticated;
grant select, insert, update, delete on public.attempts to authenticated;
grant select, insert, update, delete on public.study_sessions to authenticated;
grant select, insert, update, delete on public.user_settings to authenticated;

alter table public.profiles enable row level security;
alter table public.article_progress enable row level security;
alter table public.attempts enable row level security;
alter table public.study_sessions enable row level security;
alter table public.user_settings enable row level security;

drop policy if exists "profiles own" on public.profiles;
create policy "profiles own" on public.profiles for all to authenticated
using ((select auth.uid()) is not null and (select auth.uid())=user_id)
with check ((select auth.uid()) is not null and (select auth.uid())=user_id);

drop policy if exists "article_progress own" on public.article_progress;
create policy "article_progress own" on public.article_progress for all to authenticated
using ((select auth.uid()) is not null and (select auth.uid())=user_id)
with check ((select auth.uid()) is not null and (select auth.uid())=user_id);

drop policy if exists "attempts own" on public.attempts;
create policy "attempts own" on public.attempts for all to authenticated
using ((select auth.uid()) is not null and (select auth.uid())=user_id)
with check ((select auth.uid()) is not null and (select auth.uid())=user_id);

drop policy if exists "study_sessions own" on public.study_sessions;
create policy "study_sessions own" on public.study_sessions for all to authenticated
using ((select auth.uid()) is not null and (select auth.uid())=user_id)
with check ((select auth.uid()) is not null and (select auth.uid())=user_id);

drop policy if exists "user_settings own" on public.user_settings;
create policy "user_settings own" on public.user_settings for all to authenticated
using ((select auth.uid()) is not null and (select auth.uid())=user_id)
with check ((select auth.uid()) is not null and (select auth.uid())=user_id);

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path=''
as $$
begin
  insert into public.profiles(user_id,nombre)
  values(new.id,coalesce(new.raw_user_meta_data->>'name',split_part(new.email,'@',1)))
  on conflict do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
after insert on auth.users
for each row execute procedure public.handle_new_user();

revoke execute on function public.handle_new_user() from public;
revoke execute on function public.handle_new_user() from anon;
revoke execute on function public.handle_new_user() from authenticated;
