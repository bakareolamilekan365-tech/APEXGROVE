-- Foundation security hardening. This migration is intentionally forward-only.

-- Keep profile role selection self-service for non-admin roles, but never let
-- account_type become a trust, ownership, verification, or admin shortcut.
create or replace function public.prevent_profile_role_escalation()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  if new.account_type = 'admin'
    and old.account_type <> 'admin'
    and auth.role() <> 'service_role'
    and not public.is_admin() then
    raise exception 'Only an existing administrator or trusted database operator can assign the admin role';
  end if;

  if new.account_type not in ('buyer', 'landowner', 'developer', 'professional', 'admin') then
    raise exception 'Unsupported account type';
  end if;

  return new;
end;
$$;

drop trigger if exists profiles_prevent_role_escalation on public.profiles;
create trigger profiles_prevent_role_escalation
  before update on public.profiles
  for each row execute procedure public.prevent_profile_role_escalation();

-- A normal Data API caller can only create an unverified organization for themself.
drop policy if exists "Authenticated users can create organizations" on public.organizations;
create policy "Authenticated users can create unverified organizations"
  on public.organizations for insert
  to authenticated
  with check (
    created_by = (select auth.uid())
    and verification_status = 'unverified'
  );

create policy "Administrators can update organization security fields"
  on public.organizations for update
  to authenticated
  using (public.is_admin())
  with check (public.is_admin());

-- Only an administrator or trusted database operator may change security-sensitive
-- organization fields. Ordinary members can still update non-security details
-- through a future scoped workflow.
create or replace function public.prevent_organization_security_field_changes()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  if (new.created_by is distinct from old.created_by
      or new.verification_status is distinct from old.verification_status)
     and auth.role() <> 'service_role'
     and not public.is_admin() then
    raise exception 'Organization security fields require an authorized administrative workflow';
  end if;
  return new;
end;
$$;

drop trigger if exists organizations_prevent_security_field_changes on public.organizations;
create trigger organizations_prevent_security_field_changes
  before update on public.organizations
  for each row execute procedure public.prevent_organization_security_field_changes();

drop policy if exists "Organization owners and admins can manage memberships" on public.organization_members;
drop policy if exists "Organization members can insert memberships" on public.organization_members;
drop policy if exists "Organization owners and admins can update memberships" on public.organization_members;
drop policy if exists "Organization owners and admins can delete memberships" on public.organization_members;

create or replace function public.organization_actor_role(target_organization_id uuid)
returns text
language sql
stable
security definer set search_path = public
as $$
  select role
  from public.organization_members
  where organization_id = target_organization_id
    and user_id = (select auth.uid())
  limit 1;
$$;

revoke execute on function public.organization_actor_role(uuid) from public;
grant execute on function public.organization_actor_role(uuid) to authenticated, service_role;

create policy "Organization owners and admins can insert memberships"
  on public.organization_members for insert
  to authenticated
  with check (
    (public.is_admin() or public.organization_actor_role(organization_id) in ('owner', 'admin'))
    and (
      role <> 'owner'
      or public.is_admin()
      or public.organization_actor_role(organization_id) = 'owner'
    )
  );

create policy "Organization owners and admins can update memberships"
  on public.organization_members for update
  to authenticated
  using (
    public.is_admin()
    or public.organization_actor_role(organization_id) in ('owner', 'admin')
  )
  with check (
    (public.is_admin() or public.organization_actor_role(organization_id) in ('owner', 'admin'))
    and (
      role <> 'owner'
      or public.is_admin()
      or public.organization_actor_role(organization_id) = 'owner'
    )
  );

create policy "Organization owners and admins can delete memberships"
  on public.organization_members for delete
  to authenticated
  using (
    (public.is_admin() or public.organization_actor_role(organization_id) in ('owner', 'admin'))
    and (
      role <> 'owner'
      or public.is_admin()
      or public.organization_actor_role(organization_id) = 'owner'
    )
  );

create or replace function public.prevent_organization_last_owner_removal()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  if old.role = 'owner'
     and not exists (
       select 1 from public.organization_members remaining
       where remaining.organization_id = old.organization_id
         and remaining.user_id <> old.user_id
         and remaining.role = 'owner'
     ) then
    raise exception 'An organization must retain at least one owner';
  end if;
  return old;
end;
$$;

drop trigger if exists organization_members_prevent_last_owner_delete on public.organization_members;
create trigger organization_members_prevent_last_owner_delete
  before delete on public.organization_members
  for each row execute procedure public.prevent_organization_last_owner_removal();

create or replace function public.prevent_organization_last_owner_demotion()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  if old.role = 'owner' and new.role <> 'owner'
     and not exists (
       select 1 from public.organization_members remaining
       where remaining.organization_id = old.organization_id
         and remaining.user_id <> old.user_id
         and remaining.role = 'owner'
     ) then
    raise exception 'An organization must retain at least one owner';
  end if;
  return new;
end;
$$;

drop trigger if exists organization_members_prevent_last_owner_demotion on public.organization_members;
create trigger organization_members_prevent_last_owner_demotion
  before update on public.organization_members
  for each row execute procedure public.prevent_organization_last_owner_demotion();

create or replace function public.prevent_membership_identity_changes()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  if (new.organization_id is distinct from old.organization_id
      or new.user_id is distinct from old.user_id)
     and auth.role() <> 'service_role'
     and not public.is_admin() then
    raise exception 'Organization membership identity is immutable';
  end if;
  return new;
end;
$$;

drop trigger if exists organization_members_prevent_identity_changes on public.organization_members;
create trigger organization_members_prevent_identity_changes
  before update on public.organization_members
  for each row execute procedure public.prevent_membership_identity_changes();

-- Sensitive changes are recorded without copying document contents, secrets, or tokens.
create or replace function public.audit_foundation_security_change()
returns trigger
language plpgsql
security definer set search_path = public
as $$
declare
  entity_id uuid;
begin
  if tg_table_name = 'organization_members' then
    entity_id := case when tg_op = 'DELETE' then old.organization_id else new.organization_id end;
  else
    entity_id := case when tg_op = 'DELETE' then old.id else new.id end;
  end if;

  insert into public.audit_logs (actor_user_id, action, entity_type, entity_id, metadata)
  values (
    auth.uid(),
    tg_op,
    tg_table_name,
    entity_id,
    jsonb_build_object('source', 'database-trigger', 'table', tg_table_name)
  );
  if tg_op = 'DELETE' then
    return old;
  end if;
  return new;
end;
$$;

drop trigger if exists profiles_audit_security_changes on public.profiles;
create trigger profiles_audit_security_changes
  after update on public.profiles
  for each row
  when (old.account_type is distinct from new.account_type)
  execute procedure public.audit_foundation_security_change();

drop trigger if exists organizations_audit_security_changes on public.organizations;
create trigger organizations_audit_security_changes
  after update on public.organizations
  for each row
  when (old.created_by is distinct from new.created_by
        or old.verification_status is distinct from new.verification_status)
  execute procedure public.audit_foundation_security_change();

drop trigger if exists organization_members_audit_security_changes on public.organization_members;
create trigger organization_members_audit_security_changes
  after insert or update or delete on public.organization_members
  for each row execute procedure public.audit_foundation_security_change();

drop trigger if exists storage_objects_audit_document_changes on storage.objects;
create trigger storage_objects_audit_document_changes
  after insert or update on storage.objects
  for each row
  when (new.bucket_id = 'documents')
  execute procedure public.audit_foundation_security_change();

drop trigger if exists storage_objects_audit_document_deletes on storage.objects;
create trigger storage_objects_audit_document_deletes
  after delete on storage.objects
  for each row
  when (old.bucket_id = 'documents')
  execute procedure public.audit_foundation_security_change();

-- Foundation document storage is private and user-scoped. Future organization/project
-- policies can extend this boundary; they must not weaken it.
alter table public.profiles enable row level security;
alter table public.organizations enable row level security;
alter table public.organization_members enable row level security;
alter table public.audit_logs enable row level security;
insert into storage.buckets (id, name, public)
values ('documents', 'documents', false)
on conflict (id) do update set public = false;

alter table storage.objects enable row level security;

drop policy if exists "Users can read their private documents" on storage.objects;
create policy "Users can read their private documents"
  on storage.objects for select
  to authenticated
  using (
    bucket_id = 'documents'
    and (storage.foldername(name))[1] = 'documents'
    and (storage.foldername(name))[2] = (select auth.uid()::text)
  );

drop policy if exists "Users can upload their private documents" on storage.objects;
create policy "Users can upload their private documents"
  on storage.objects for insert
  to authenticated
  with check (
    bucket_id = 'documents'
    and (storage.foldername(name))[1] = 'documents'
    and (storage.foldername(name))[2] = (select auth.uid()::text)
  );

drop policy if exists "Users can update their private documents" on storage.objects;
create policy "Users can update their private documents"
  on storage.objects for update
  to authenticated
  using (
    bucket_id = 'documents'
    and owner_id = (select auth.uid()::text)
  )
  with check (
    bucket_id = 'documents'
    and (storage.foldername(name))[1] = 'documents'
    and (storage.foldername(name))[2] = (select auth.uid()::text)
  );

drop policy if exists "Users can delete their private documents" on storage.objects;
create policy "Users can delete their private documents"
  on storage.objects for delete
  to authenticated
  using (
    bucket_id = 'documents'
    and owner_id = (select auth.uid()::text)
  );

revoke all on table public.profiles from anon;
revoke all on table public.organizations from anon;
revoke all on table public.organization_members from anon;
revoke all on table public.audit_logs from anon;
grant select, insert, update on table public.profiles to authenticated;
grant select, insert, update on table public.organizations to authenticated;
grant select, insert, update, delete on table public.organization_members to authenticated;
grant select on table public.audit_logs to authenticated;

-- Trigger-only SECURITY DEFINER functions are not an RPC surface. Keep policy
-- helper functions callable only where policy evaluation requires them.
revoke execute on function public.add_organization_owner() from public, anon, authenticated;
revoke execute on function public.handle_new_user() from public, anon, authenticated;
revoke execute on function public.prevent_profile_role_escalation() from public, anon, authenticated;
revoke execute on function public.prevent_organization_security_field_changes() from public, anon, authenticated;
revoke execute on function public.prevent_organization_last_owner_removal() from public, anon, authenticated;
revoke execute on function public.prevent_organization_last_owner_demotion() from public, anon, authenticated;
revoke execute on function public.prevent_membership_identity_changes() from public, anon, authenticated;
revoke execute on function public.audit_foundation_security_change() from public, anon, authenticated;
revoke execute on function public.is_admin() from anon;
revoke execute on function public.is_organization_member(uuid) from anon;
revoke execute on function public.is_organization_admin(uuid) from anon;
alter function public.set_updated_at() set search_path = public;
