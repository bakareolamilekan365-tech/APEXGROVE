-- Security pass 2: an organization admin must not be able to modify an owner's membership row.
-- 015's UPDATE policy checked the NEW row (WITH CHECK) but not the OLD row (USING),
-- so an admin could demote a co-owner. The last-owner trigger only covered the zero-owner case.
-- If 015 has never been applied anywhere, you may fold this policy into 015 instead.

drop policy if exists "Organization owners and admins can update memberships" on public.organization_members;

create policy "Organization owners and admins can update memberships"
  on public.organization_members for update
  to authenticated
  using (
    (public.is_admin() or public.organization_actor_role(organization_id) in ('owner', 'admin'))
    and (
      role <> 'owner'
      or public.is_admin()
      or public.organization_actor_role(organization_id) = 'owner'
    )
  )
  with check (
    (public.is_admin() or public.organization_actor_role(organization_id) in ('owner', 'admin'))
    and (
      role <> 'owner'
      or public.is_admin()
      or public.organization_actor_role(organization_id) = 'owner'
    )
  );
