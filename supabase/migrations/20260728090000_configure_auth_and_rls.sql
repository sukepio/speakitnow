alter table public.users
  alter column email drop not null;

create or replace function public.handle_new_auth_user()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  insert into public.users (id, email, display_name)
  values (
    new.id,
    new.email,
    coalesce(
      nullif(new.raw_user_meta_data ->> 'display_name', ''),
      nullif(split_part(coalesce(new.email, ''), '@', 1), ''),
      'Guest'
    )
  )
  on conflict (id) do update
  set email = excluded.email;

  return new;
end;
$$;

revoke execute on function public.handle_new_auth_user() from public, anon, authenticated;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_auth_user();

insert into public.users (id, email, display_name)
select
  auth_user.id,
  auth_user.email,
  coalesce(
    nullif(auth_user.raw_user_meta_data ->> 'display_name', ''),
    nullif(split_part(coalesce(auth_user.email, ''), '@', 1), ''),
    'Guest'
  )
from auth.users as auth_user
on conflict (id) do update
set email = excluded.email;

do $$
begin
  if not exists (
    select 1
    from pg_constraint
    where conrelid = 'public.users'::regclass
      and confrelid = 'auth.users'::regclass
      and contype = 'f'
  ) then
    alter table public.users
      add constraint users_auth_user_fkey
      foreign key (id)
      references auth.users (id)
      on delete cascade
      not valid;
  end if;
end;
$$;

do $$
begin
  if exists (
    select 1
    from pg_constraint
    where conrelid = 'public.users'::regclass
      and conname = 'users_auth_user_fkey'
      and not convalidated
  ) then
    alter table public.users validate constraint users_auth_user_fkey;
  end if;
end;
$$;

create index if not exists output_sessions_user_id_idx
  on public.output_sessions (user_id);

create index if not exists instant_composition_sessions_output_session_id_idx
  on public.instant_composition_sessions (output_session_id);

alter table public.phrases enable row level security;
alter table public.users enable row level security;
alter table public.user_phrases enable row level security;
alter table public.output_sessions enable row level security;
alter table public.instant_composition_sessions enable row level security;
alter table public.composition_logs enable row level security;

revoke all privileges on table public.phrases from anon, authenticated;
revoke all privileges on table public.users from anon, authenticated;
revoke all privileges on table public.user_phrases from anon, authenticated;
revoke all privileges on table public.output_sessions from anon, authenticated;
revoke all privileges on table public.instant_composition_sessions from anon, authenticated;
revoke all privileges on table public.composition_logs from anon, authenticated;

grant select on table public.phrases to anon, authenticated;
grant insert on table public.phrases to authenticated;

grant select on table public.users to authenticated;
grant update (display_name) on table public.users to authenticated;

grant select, insert, delete on table public.user_phrases to authenticated;
grant select, insert, delete on table public.output_sessions to authenticated;
grant select, insert, delete on table public.instant_composition_sessions to authenticated;
grant select, insert, update, delete on table public.composition_logs to authenticated;

drop policy if exists phrases_are_readable on public.phrases;
create policy phrases_are_readable
on public.phrases
for select
to anon, authenticated
using (true);

drop policy if exists authenticated_users_can_insert_phrases on public.phrases;
create policy authenticated_users_can_insert_phrases
on public.phrases
for insert
to authenticated
with check (true);

drop policy if exists users_can_read_own_profile on public.users;
create policy users_can_read_own_profile
on public.users
for select
to authenticated
using ((select auth.uid()) = id);

drop policy if exists users_can_update_own_profile on public.users;
create policy users_can_update_own_profile
on public.users
for update
to authenticated
using ((select auth.uid()) = id)
with check ((select auth.uid()) = id);

drop policy if exists users_can_read_own_phrases on public.user_phrases;
create policy users_can_read_own_phrases
on public.user_phrases
for select
to authenticated
using ((select auth.uid()) = user_id);

drop policy if exists users_can_add_own_phrases on public.user_phrases;
create policy users_can_add_own_phrases
on public.user_phrases
for insert
to authenticated
with check ((select auth.uid()) = user_id);

drop policy if exists users_can_delete_own_phrases on public.user_phrases;
create policy users_can_delete_own_phrases
on public.user_phrases
for delete
to authenticated
using ((select auth.uid()) = user_id);

drop policy if exists users_can_read_own_output_sessions on public.output_sessions;
create policy users_can_read_own_output_sessions
on public.output_sessions
for select
to authenticated
using ((select auth.uid()) = user_id);

drop policy if exists users_can_create_own_output_sessions on public.output_sessions;
create policy users_can_create_own_output_sessions
on public.output_sessions
for insert
to authenticated
with check ((select auth.uid()) = user_id);

drop policy if exists users_can_delete_own_output_sessions on public.output_sessions;
create policy users_can_delete_own_output_sessions
on public.output_sessions
for delete
to authenticated
using ((select auth.uid()) = user_id);

drop policy if exists users_can_read_own_composition_sessions on public.instant_composition_sessions;
create policy users_can_read_own_composition_sessions
on public.instant_composition_sessions
for select
to authenticated
using (
  exists (
    select 1
    from public.output_sessions
    where output_sessions.id = instant_composition_sessions.output_session_id
      and output_sessions.user_id = (select auth.uid())
  )
);

drop policy if exists users_can_create_own_composition_sessions on public.instant_composition_sessions;
create policy users_can_create_own_composition_sessions
on public.instant_composition_sessions
for insert
to authenticated
with check (
  exists (
    select 1
    from public.output_sessions
    where output_sessions.id = instant_composition_sessions.output_session_id
      and output_sessions.user_id = (select auth.uid())
  )
);

drop policy if exists users_can_delete_own_composition_sessions on public.instant_composition_sessions;
create policy users_can_delete_own_composition_sessions
on public.instant_composition_sessions
for delete
to authenticated
using (
  exists (
    select 1
    from public.output_sessions
    where output_sessions.id = instant_composition_sessions.output_session_id
      and output_sessions.user_id = (select auth.uid())
  )
);

drop policy if exists users_can_read_own_composition_logs on public.composition_logs;
create policy users_can_read_own_composition_logs
on public.composition_logs
for select
to authenticated
using (
  exists (
    select 1
    from public.instant_composition_sessions
    join public.output_sessions
      on output_sessions.id = instant_composition_sessions.output_session_id
    where instant_composition_sessions.id = composition_logs.instant_composition_session_id
      and output_sessions.user_id = (select auth.uid())
  )
);

drop policy if exists users_can_create_own_composition_logs on public.composition_logs;
create policy users_can_create_own_composition_logs
on public.composition_logs
for insert
to authenticated
with check (
  exists (
    select 1
    from public.instant_composition_sessions
    join public.output_sessions
      on output_sessions.id = instant_composition_sessions.output_session_id
    where instant_composition_sessions.id = composition_logs.instant_composition_session_id
      and output_sessions.user_id = (select auth.uid())
  )
);

drop policy if exists users_can_update_own_composition_logs on public.composition_logs;
create policy users_can_update_own_composition_logs
on public.composition_logs
for update
to authenticated
using (
  exists (
    select 1
    from public.instant_composition_sessions
    join public.output_sessions
      on output_sessions.id = instant_composition_sessions.output_session_id
    where instant_composition_sessions.id = composition_logs.instant_composition_session_id
      and output_sessions.user_id = (select auth.uid())
  )
)
with check (
  exists (
    select 1
    from public.instant_composition_sessions
    join public.output_sessions
      on output_sessions.id = instant_composition_sessions.output_session_id
    where instant_composition_sessions.id = composition_logs.instant_composition_session_id
      and output_sessions.user_id = (select auth.uid())
  )
);

drop policy if exists users_can_delete_own_composition_logs on public.composition_logs;
create policy users_can_delete_own_composition_logs
on public.composition_logs
for delete
to authenticated
using (
  exists (
    select 1
    from public.instant_composition_sessions
    join public.output_sessions
      on output_sessions.id = instant_composition_sessions.output_session_id
    where instant_composition_sessions.id = composition_logs.instant_composition_session_id
      and output_sessions.user_id = (select auth.uid())
  )
);
