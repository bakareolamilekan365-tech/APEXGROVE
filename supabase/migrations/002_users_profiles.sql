create table if not exists public.profiles (
	id uuid primary key default gen_random_uuid(),
	user_id uuid not null unique references auth.users(id) on delete cascade,
	full_name text,
	phone text,
	avatar_url text,
	account_type text not null default 'buyer' check (account_type in ('buyer', 'landowner', 'developer', 'professional', 'admin')),
	location_text text,
	bio text,
	created_at timestamptz not null default now(),
	updated_at timestamptz not null default now()
);

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
	insert into public.profiles (user_id, full_name, account_type)
	values (
		new.id,
		nullif(new.raw_user_meta_data ->> 'full_name', ''),
		'buyer'
	);
	return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
	after insert on auth.users
	for each row execute procedure public.handle_new_user();

create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
	new.updated_at = now();
	return new;
end;
$$;

drop trigger if exists profiles_set_updated_at on public.profiles;
create trigger profiles_set_updated_at
	before update on public.profiles
	for each row execute procedure public.set_updated_at();