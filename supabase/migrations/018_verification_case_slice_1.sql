-- Phase 2, Slice 1: verification request -> work queue -> assignment -> status.
-- This migration is forward-only and intentionally excludes documents, handover,
-- reports, feasibility, GIS, payments, AI and notifications.

-- Close the remaining application-owned anonymous RPC exposure from migration 015.
revoke execute on function public.organization_actor_role(uuid) from public, anon;

create table if not exists public.staff_members (
  user_id uuid primary key references auth.users(id) on delete cascade,
  department text not null check (department in ('Verification', 'Feasibility', 'Operations')),
  is_lead boolean not null default false,
  active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create unique index if not exists staff_members_one_active_lead_per_department_idx
  on public.staff_members (department)
  where is_lead and active;

create table if not exists public.verification_cases (
  id uuid primary key default gen_random_uuid(),
  customer_user_id uuid not null references auth.users(id) on delete restrict,
  created_by_user_id uuid not null references auth.users(id) on delete restrict,
  creation_channel text not null default 'customer'
    check (creation_channel = 'customer'),
  jurisdiction text not null default 'Abuja/FCT'
    check (jurisdiction = 'Abuja/FCT'),
  department text not null default 'Verification'
    check (department in ('Verification', 'Feasibility', 'Operations')),
  site_description text not null
    check (char_length(btrim(site_description)) between 10 and 2000),
  area_lga text not null
    check (char_length(btrim(area_lga)) between 2 and 120),
  customer_notes text
    check (customer_notes is null or char_length(customer_notes) <= 4000),
  contact_preference text not null
    check (contact_preference in ('email', 'phone', 'whatsapp')),
  current_stage text not null default 'Request received'
    check (current_stage = 'Request received'),
  workflow_status text not null default 'submitted'
    check (workflow_status in ('draft', 'submitted', 'assigned', 'in_review', 'needs_customer_info', 'closed', 'cancelled')),
  assigned_lead_user_id uuid references public.staff_members(user_id) on delete set null,
  is_demo_data boolean not null default true check (is_demo_data),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists verification_cases_customer_user_id_idx
  on public.verification_cases (customer_user_id);
create index if not exists verification_cases_department_status_created_idx
  on public.verification_cases (department, workflow_status, created_at desc);
create index if not exists verification_cases_assigned_lead_user_id_idx
  on public.verification_cases (assigned_lead_user_id)
  where assigned_lead_user_id is not null;

create table if not exists public.case_assignments (
  id uuid primary key default gen_random_uuid(),
  verification_case_id uuid not null references public.verification_cases(id) on delete cascade,
  assignee_user_id uuid not null references public.staff_members(user_id) on delete restrict,
  assigned_by_user_id uuid not null references public.staff_members(user_id) on delete restrict,
  status text not null default 'active'
    check (status in ('active', 'completed', 'cancelled')),
  created_at timestamptz not null default now()
);

create index if not exists case_assignments_assignee_user_id_idx
  on public.case_assignments (assignee_user_id, status);
create index if not exists case_assignments_assigned_by_user_id_idx
  on public.case_assignments (assigned_by_user_id);
create index if not exists case_assignments_case_id_idx
  on public.case_assignments (verification_case_id);
create unique index if not exists case_assignments_one_active_per_case_idx
  on public.case_assignments (verification_case_id)
  where status = 'active';

create table if not exists public.case_status_events (
  id uuid primary key default gen_random_uuid(),
  verification_case_id uuid not null references public.verification_cases(id) on delete cascade,
  actor_user_id uuid not null references auth.users(id) on delete restrict,
  from_status text
    check (from_status is null or from_status in ('draft', 'submitted', 'assigned', 'in_review', 'needs_customer_info', 'closed', 'cancelled')),
  to_status text not null
    check (to_status in ('draft', 'submitted', 'assigned', 'in_review', 'needs_customer_info', 'closed', 'cancelled')),
  reason text not null check (char_length(btrim(reason)) between 2 and 2000),
  customer_visible boolean not null default false,
  created_at timestamptz not null default now()
);

create index if not exists case_status_events_case_created_idx
  on public.case_status_events (verification_case_id, created_at);
create index if not exists case_status_events_actor_user_id_idx
  on public.case_status_events (actor_user_id);

drop trigger if exists staff_members_set_updated_at on public.staff_members;
create trigger staff_members_set_updated_at
  before update on public.staff_members
  for each row execute procedure public.set_updated_at();

drop trigger if exists verification_cases_set_updated_at on public.verification_cases;
create trigger verification_cases_set_updated_at
  before update on public.verification_cases
  for each row execute procedure public.set_updated_at();

alter table public.staff_members enable row level security;
alter table public.verification_cases enable row level security;
alter table public.case_assignments enable row level security;
alter table public.case_status_events enable row level security;

-- RLS helpers are SECURITY DEFINER to avoid recursive policy evaluation. Each
-- helper checks the caller identity explicitly and uses a pinned empty search path.
create or replace function public.is_active_staff()
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select (select auth.uid()) is not null
    and exists (
      select 1
      from public.staff_members
      where user_id = (select auth.uid())
        and active
    );
$$;

create or replace function public.is_department_lead(target_department text)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select (select auth.uid()) is not null
    and exists (
      select 1
      from public.staff_members
      where user_id = (select auth.uid())
        and department = target_department
        and is_lead
        and active
    );
$$;

create or replace function public.staff_can_access_verification_case(target_case_id uuid)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select (select auth.uid()) is not null
    and exists (
      select 1
      from public.staff_members sm
      join public.verification_cases vc on vc.id = target_case_id
      where sm.user_id = (select auth.uid())
        and sm.active
        and (
          (sm.is_lead and sm.department = vc.department)
          or exists (
            select 1
            from public.case_assignments ca
            where ca.verification_case_id = vc.id
              and ca.assignee_user_id = sm.user_id
              and ca.status = 'active'
          )
        )
    );
$$;

drop policy if exists "Staff can read permitted staff directory rows" on public.staff_members;
create policy "Staff can read permitted staff directory rows"
  on public.staff_members for select
  to authenticated
  using (
    user_id = (select auth.uid())
    or (select public.is_department_lead(department))
  );

drop policy if exists "Customers and scoped staff can read verification cases" on public.verification_cases;
create policy "Customers and scoped staff can read verification cases"
  on public.verification_cases for select
  to authenticated
  using (
    customer_user_id = (select auth.uid())
    or (select public.staff_can_access_verification_case(id))
  );

drop policy if exists "Scoped staff can read case assignments" on public.case_assignments;
create policy "Scoped staff can read case assignments"
  on public.case_assignments for select
  to authenticated
  using ((select public.staff_can_access_verification_case(verification_case_id)));

drop policy if exists "Customers and scoped staff can read case status events" on public.case_status_events;
create policy "Customers and scoped staff can read case status events"
  on public.case_status_events for select
  to authenticated
  using (
    (select public.staff_can_access_verification_case(verification_case_id))
    or (
      customer_visible
      and exists (
        select 1
        from public.verification_cases vc
        where vc.id = verification_case_id
          and vc.customer_user_id = (select auth.uid())
      )
    )
  );

-- Customers create through this RPC so the first event and audit record are
-- committed atomically with the case. Slice 1 is customer-created only.
create or replace function public.create_verification_case(
  p_site_description text,
  p_area_lga text,
  p_customer_notes text,
  p_contact_preference text
)
returns uuid
language plpgsql
security definer
set search_path = ''
as $$
declare
  actor_id uuid := (select auth.uid());
  new_case_id uuid;
begin
  if actor_id is null then
    raise exception 'Authentication is required' using errcode = '42501';
  end if;

  if char_length(btrim(coalesce(p_site_description, ''))) not between 10 and 2000 then
    raise exception 'Plot description must be between 10 and 2000 characters' using errcode = '22023';
  end if;
  if char_length(btrim(coalesce(p_area_lga, ''))) not between 2 and 120 then
    raise exception 'Area/LGA must be between 2 and 120 characters' using errcode = '22023';
  end if;
  if p_contact_preference not in ('email', 'phone', 'whatsapp') then
    raise exception 'Unsupported contact preference' using errcode = '22023';
  end if;
  if char_length(coalesce(p_customer_notes, '')) > 4000 then
    raise exception 'Notes must not exceed 4000 characters' using errcode = '22023';
  end if;

  insert into public.verification_cases (
    customer_user_id,
    created_by_user_id,
    site_description,
    area_lga,
    customer_notes,
    contact_preference
  )
  values (
    actor_id,
    actor_id,
    btrim(p_site_description),
    btrim(p_area_lga),
    nullif(btrim(coalesce(p_customer_notes, '')), ''),
    p_contact_preference
  )
  returning id into new_case_id;

  insert into public.case_status_events (
    verification_case_id,
    actor_user_id,
    from_status,
    to_status,
    reason,
    customer_visible
  )
  values (
    new_case_id,
    actor_id,
    null,
    'submitted',
    'Request submitted by customer.',
    true
  );

  insert into public.audit_logs (actor_user_id, action, entity_type, entity_id, metadata)
  values (
    actor_id,
    'verification_case.created',
    'verification_case',
    new_case_id,
    jsonb_build_object('creation_channel', 'customer', 'jurisdiction', 'Abuja/FCT', 'is_demo_data', true)
  );

  return new_case_id;
end;
$$;

create or replace function public.assign_verification_case(
  p_case_id uuid,
  p_assignee_user_id uuid,
  p_note text,
  p_customer_visible boolean default false
)
returns uuid
language plpgsql
security definer
set search_path = ''
as $$
declare
  actor_id uuid := (select auth.uid());
  case_row public.verification_cases%rowtype;
  assignment_id uuid;
begin
  if actor_id is null then
    raise exception 'Authentication is required' using errcode = '42501';
  end if;
  if char_length(btrim(coalesce(p_note, ''))) not between 2 and 2000 then
    raise exception 'An assignment note is required' using errcode = '22023';
  end if;

  select * into case_row
  from public.verification_cases
  where id = p_case_id
  for update;

  if not found then
    raise exception 'Verification case not found' using errcode = 'P0002';
  end if;
  if not public.is_department_lead(case_row.department) then
    raise exception 'An active lead in the case department must assign this case' using errcode = '42501';
  end if;
  if case_row.workflow_status <> 'submitted' then
    raise exception 'Only submitted cases can be assigned' using errcode = '22023';
  end if;
  if not exists (
    select 1
    from public.staff_members
    where user_id = p_assignee_user_id
      and department = case_row.department
      and active
  ) then
    raise exception 'Assignee must be active in the case department' using errcode = '42501';
  end if;

  insert into public.case_assignments (
    verification_case_id,
    assignee_user_id,
    assigned_by_user_id,
    status
  )
  values (p_case_id, p_assignee_user_id, actor_id, 'active')
  returning id into assignment_id;

  update public.verification_cases
  set workflow_status = 'assigned',
      assigned_lead_user_id = actor_id
  where id = p_case_id;

  insert into public.case_status_events (
    verification_case_id,
    actor_user_id,
    from_status,
    to_status,
    reason,
    customer_visible
  )
  values (
    p_case_id,
    actor_id,
    'submitted',
    'assigned',
    btrim(p_note),
    p_customer_visible
  );

  insert into public.audit_logs (actor_user_id, action, entity_type, entity_id, metadata)
  values (
    actor_id,
    'verification_case.assigned',
    'verification_case',
    p_case_id,
    jsonb_build_object('assignment_id', assignment_id, 'assignee_user_id', p_assignee_user_id)
  );

  return assignment_id;
end;
$$;

create or replace function public.transition_verification_case(
  p_case_id uuid,
  p_to_status text,
  p_reason text,
  p_customer_visible boolean default true
)
returns uuid
language plpgsql
security definer
set search_path = ''
as $$
declare
  actor_id uuid := (select auth.uid());
  case_row public.verification_cases%rowtype;
  event_id uuid;
begin
  if actor_id is null then
    raise exception 'Authentication is required' using errcode = '42501';
  end if;
  if char_length(btrim(coalesce(p_reason, ''))) not between 2 and 2000 then
    raise exception 'A status note is required' using errcode = '22023';
  end if;

  select * into case_row
  from public.verification_cases
  where id = p_case_id
  for update;

  if not found then
    raise exception 'Verification case not found' using errcode = 'P0002';
  end if;
  if not exists (
    select 1
    from public.case_assignments
    where verification_case_id = p_case_id
      and assignee_user_id = actor_id
      and status = 'active'
  ) then
    raise exception 'Only the active assignee can move this case' using errcode = '42501';
  end if;

  if not (
    (case_row.workflow_status = 'assigned' and p_to_status = 'in_review')
    or (case_row.workflow_status = 'in_review' and p_to_status in ('needs_customer_info', 'closed', 'cancelled'))
    or (case_row.workflow_status = 'needs_customer_info' and p_to_status = 'in_review')
  ) then
    raise exception 'Invalid verification case status transition: % -> %', case_row.workflow_status, p_to_status
      using errcode = '22023';
  end if;

  update public.verification_cases
  set workflow_status = p_to_status
  where id = p_case_id;

  if p_to_status in ('closed', 'cancelled') then
    update public.case_assignments
    set status = case when p_to_status = 'closed' then 'completed' else 'cancelled' end
    where verification_case_id = p_case_id
      and assignee_user_id = actor_id
      and status = 'active';
  end if;

  insert into public.case_status_events (
    verification_case_id,
    actor_user_id,
    from_status,
    to_status,
    reason,
    customer_visible
  )
  values (
    p_case_id,
    actor_id,
    case_row.workflow_status,
    p_to_status,
    btrim(p_reason),
    p_customer_visible
  )
  returning id into event_id;

  insert into public.audit_logs (actor_user_id, action, entity_type, entity_id, metadata)
  values (
    actor_id,
    'verification_case.status_changed',
    'verification_case',
    p_case_id,
    jsonb_build_object('from_status', case_row.workflow_status, 'to_status', p_to_status, 'event_id', event_id)
  );

  return event_id;
end;
$$;

-- Public Data API access is explicit. Direct writes are intentionally absent;
-- all Slice 1 mutations go through the transaction-safe RPCs above.
revoke all on table public.staff_members from anon, authenticated;
revoke all on table public.verification_cases from anon, authenticated;
revoke all on table public.case_assignments from anon, authenticated;
revoke all on table public.case_status_events from anon, authenticated;
grant select on table public.staff_members to authenticated;
grant select on table public.verification_cases to authenticated;
grant select on table public.case_assignments to authenticated;
grant select on table public.case_status_events to authenticated;
grant all on table public.staff_members to service_role;
grant all on table public.verification_cases to service_role;
grant all on table public.case_assignments to service_role;
grant all on table public.case_status_events to service_role;

revoke execute on function public.is_active_staff() from public, anon;
revoke execute on function public.is_department_lead(text) from public, anon;
revoke execute on function public.staff_can_access_verification_case(uuid) from public, anon;
revoke execute on function public.create_verification_case(text, text, text, text) from public, anon;
revoke execute on function public.assign_verification_case(uuid, uuid, text, boolean) from public, anon;
revoke execute on function public.transition_verification_case(uuid, text, text, boolean) from public, anon;

grant execute on function public.is_active_staff() to authenticated;
grant execute on function public.is_department_lead(text) to authenticated;
grant execute on function public.staff_can_access_verification_case(uuid) to authenticated;
grant execute on function public.create_verification_case(text, text, text, text) to authenticated;
grant execute on function public.assign_verification_case(uuid, uuid, text, boolean) to authenticated;
grant execute on function public.transition_verification_case(uuid, text, text, boolean) to authenticated;

-- Service role/database operators provision staff rows directly. Authenticated
-- clients intentionally receive no INSERT/UPDATE/DELETE grant on staff_members.
