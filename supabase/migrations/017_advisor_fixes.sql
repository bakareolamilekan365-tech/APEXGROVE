-- Security pass 2, part 2: fixes for the Supabase security advisor findings (2026-10-11).
-- Idempotent. Apply AFTER 015 and 016 have passed locally. Not yet executed anywhere.

-- 1) PostGIS reference table is exposed with RLS off. Enable RLS and keep it readable,
--    because PostGIS functions such as ST_Transform read it. Write access stays blocked.
alter table public.spatial_ref_sys enable row level security;

drop policy if exists "Spatial reference data is readable" on public.spatial_ref_sys;
create policy "Spatial reference data is readable"
  on public.spatial_ref_sys for select
  to anon, authenticated
  using (true);

-- 2) SECURITY DEFINER functions must not be callable through the public API (RPC).
-- Trigger functions: nothing needs EXECUTE on them at runtime (it is only checked at CREATE TRIGGER).
revoke execute on function public.add_organization_owner() from public, anon, authenticated;
revoke execute on function public.handle_new_user() from public, anon, authenticated;
revoke execute on function public.prevent_profile_role_escalation() from public, anon, authenticated;

-- RLS helper functions: signed-in users need them (policies call them), anonymous users do not.
revoke execute on function public.is_admin() from public, anon;
revoke execute on function public.is_organization_admin(uuid) from public, anon;
revoke execute on function public.is_organization_member(uuid) from public, anon;
grant execute on function public.is_admin() to authenticated, service_role;
grant execute on function public.is_organization_admin(uuid) to authenticated, service_role;
grant execute on function public.is_organization_member(uuid) to authenticated, service_role;

-- 3) Pin the search_path on the updated_at trigger function.
alter function public.set_updated_at() set search_path = public;

-- Not handled here: PostGIS st_estimatedextent() functions (owned by the extension, so revoking may
-- need a higher-privileged role) and the PostGIS-in-public warning (moving it is disruptive).
