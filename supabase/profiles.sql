-- Ejecuta esto en Supabase: SQL Editor -> New query -> Run

create table if not exists public.profiles (
  id          uuid primary key references auth.users (id) on delete cascade,
  username    text not null unique,
  full_name   text not null,
  email       text not null,
  created_at  timestamptz not null default now()
);

alter table public.profiles enable row level security;

create policy "Insertar mi propio perfil"
  on public.profiles for insert
  to authenticated
  with check (auth.uid() = id);

create policy "Leer mi propio perfil"
  on public.profiles for select
  to authenticated
  using (auth.uid() = id);
