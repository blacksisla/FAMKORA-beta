-- FAMKORA BETA — Supabase/PostgreSQL
create extension if not exists pgcrypto;
create table if not exists public.beta_feedback (
 id uuid primary key default gen_random_uuid(),
 user_id uuid not null references auth.users(id) on delete cascade,
 workspace_slug text not null check (workspace_slug in ('AAMF','NASCORP')),
 message text not null,
 created_at timestamptz not null default now()
);
alter table public.beta_feedback enable row level security;
create policy "users insert own feedback" on public.beta_feedback for insert to authenticated with check (auth.uid()=user_id);
create policy "users read own feedback" on public.beta_feedback for select to authenticated using (auth.uid()=user_id);

-- Future production tables should follow the same tenant/workspace boundary:
-- workspaces, memberships, environments, records, documents, audit_events, sync_operations.
-- Never trust workspace ids supplied by the browser; derive authorization from membership server-side.
