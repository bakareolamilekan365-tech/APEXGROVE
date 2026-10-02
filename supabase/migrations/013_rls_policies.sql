create or replace function public.is_admin()
returns boolean
language sql
stable
security definer set search_path = public
as $$
	select exists (
		select 1 from public.profiles
		where user_id = auth.uid() and account_type = 'admin'
	);
$$;

create or replace function public.is_organization_member(target_organization_id uuid)
returns boolean
language sql
stable
security definer set search_path = public
as $$
	select exists (
		select 1 from public.organization_members
		where organization_id = target_organization_id and user_id = auth.uid()
	);
$$;

create or replace function public.is_organization_admin(target_organization_id uuid)
returns boolean
language sql
stable
security definer set search_path = public
as $$
	select exists (
		select 1 from public.organization_members
		where organization_id = target_organization_id
			and user_id = auth.uid()
			and role in ('owner', 'admin')
	);
$$;

alter table public.profiles enable row level security;
alter table public.organizations enable row level security;
alter table public.organization_members enable row level security;
alter table public.audit_logs enable row level security;

drop policy if exists "Users can view their own profile" on public.profiles;
create policy "Users can view their own profile"
	on public.profiles for select
	using (user_id = auth.uid() or public.is_admin());

drop policy if exists "Users can update their own profile" on public.profiles;
create policy "Users can update their own profile"
	on public.profiles for update
	using (user_id = auth.uid())
	with check (user_id = auth.uid());

drop policy if exists "Members can view their organizations" on public.organizations;
create policy "Members can view their organizations"
	on public.organizations for select
	using (created_by = auth.uid() or public.is_organization_member(id) or public.is_admin());

drop policy if exists "Authenticated users can create organizations" on public.organizations;
create policy "Authenticated users can create organizations"
	on public.organizations for insert
	to authenticated
	with check (true);

drop policy if exists "Members can view organization memberships" on public.organization_members;
create policy "Members can view organization memberships"
	on public.organization_members for select
	using (user_id = auth.uid() or public.is_organization_member(organization_id) or public.is_admin());

drop policy if exists "Organization owners and admins can manage memberships" on public.organization_members;
create policy "Organization owners and admins can manage memberships"
	on public.organization_members for all
	using (public.is_admin() or public.is_organization_admin(organization_id))
	with check (public.is_admin() or public.is_organization_admin(organization_id));

drop policy if exists "Admins can view audit logs" on public.audit_logs;
create policy "Admins can view audit logs"
	on public.audit_logs for select
	using (public.is_admin());