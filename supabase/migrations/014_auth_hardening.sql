create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  insert into public.profiles (user_id, full_name, account_type)
  values (new.id, nullif(new.raw_user_meta_data ->> 'full_name', ''), 'buyer');
  return new;
end;
$$;

create or replace function public.prevent_profile_role_escalation()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  if new.account_type = 'admin'
    and old.account_type <> 'admin'
    and not public.is_admin() then
    raise exception 'Only an existing administrator can assign the admin role';
  end if;
  return new;
end;
$$;

drop trigger if exists profiles_prevent_role_escalation on public.profiles;
create trigger profiles_prevent_role_escalation
  before update on public.profiles
  for each row execute procedure public.prevent_profile_role_escalation();