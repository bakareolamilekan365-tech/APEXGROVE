create table if not exists public.organizations (
	id uuid primary key default gen_random_uuid(),
	created_by uuid not null default auth.uid() references auth.users(id) on delete restrict,
	name text not null,
	organization_type text not null,
	registration_number text,
	description text,
	location_text text,
	verification_status text not null default 'unverified' check (verification_status in ('unverified', 'pending', 'verified', 'rejected')),
	created_at timestamptz not null default now(),
	updated_at timestamptz not null default now()
);

create table if not exists public.organization_members (
	organization_id uuid not null references public.organizations(id) on delete cascade,
	user_id uuid not null references auth.users(id) on delete cascade,
	role text not null default 'member' check (role in ('owner', 'admin', 'member')),
	created_at timestamptz not null default now(),
	primary key (organization_id, user_id)
);

create or replace function public.add_organization_owner()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
	insert into public.organization_members (organization_id, user_id, role)
	values (new.id, new.created_by, 'owner');
	return new;
end;
$$;

drop trigger if exists organization_owner_on_create on public.organizations;
create trigger organization_owner_on_create
	after insert on public.organizations
	for each row execute procedure public.add_organization_owner();

drop trigger if exists organizations_set_updated_at on public.organizations;
create trigger organizations_set_updated_at
	before update on public.organizations
	for each row execute procedure public.set_updated_at();