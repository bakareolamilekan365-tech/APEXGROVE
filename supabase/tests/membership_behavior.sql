-- Behavioural allow/deny tests for organizations, memberships and profiles.
-- Run with `supabase test db` (needs a local Supabase stack with all migrations applied).
-- NOTE: written against migrations 001-016 but not yet executed; expect to adjust on first run.
begin;
select plan(19);

-- fixtures (run as the database owner): 1 owner1, 2 owner2, 3 org admin, 4 member, 5 outsider, 6 spare
insert into auth.users (id, aud, role, email, raw_user_meta_data) values
  ('11111111-1111-1111-1111-111111111111', 'authenticated', 'authenticated', 'owner1@test.invalid', '{}'),
  ('22222222-2222-2222-2222-222222222222', 'authenticated', 'authenticated', 'owner2@test.invalid', '{}'),
  ('33333333-3333-3333-3333-333333333333', 'authenticated', 'authenticated', 'admin@test.invalid', '{}'),
  ('44444444-4444-4444-4444-444444444444', 'authenticated', 'authenticated', 'member@test.invalid', '{}'),
  ('55555555-5555-5555-5555-555555555555', 'authenticated', 'authenticated', 'outsider@test.invalid', '{}'),
  ('66666666-6666-6666-6666-666666666666', 'authenticated', 'authenticated', 'spare@test.invalid', '{}');

-- the owner trigger adds owner1 as 'owner'
insert into public.organizations (id, created_by, name, organization_type)
values ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '11111111-1111-1111-1111-111111111111', 'Test Org', 'developer');

insert into public.organization_members (organization_id, user_id, role) values
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '22222222-2222-2222-2222-222222222222', 'owner'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '33333333-3333-3333-3333-333333333333', 'admin'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '44444444-4444-4444-4444-444444444444', 'member');

-- ---------- org ADMIN ----------
select set_config('request.jwt.claims', '{"sub":"33333333-3333-3333-3333-333333333333","role":"authenticated"}', true);
set local role authenticated;
update public.organization_members set role = 'member' where organization_id = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa' and user_id = '22222222-2222-2222-2222-222222222222';
reset role;
select is((select role from public.organization_members where organization_id = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa' and user_id = '22222222-2222-2222-2222-222222222222'), 'owner', 'org admin cannot demote another owner');

select set_config('request.jwt.claims', '{"sub":"33333333-3333-3333-3333-333333333333","role":"authenticated"}', true);
set local role authenticated;
select throws_ok($$insert into public.organization_members (organization_id, user_id, role) values ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '66666666-6666-6666-6666-666666666666', 'owner')$$, '42501', null, 'org admin cannot add an owner');
select throws_ok($$update public.organization_members set role = 'owner' where organization_id = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa' and user_id = '44444444-4444-4444-4444-444444444444'$$, '42501', null, 'org admin cannot promote a member to owner');
delete from public.organization_members where organization_id = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa' and user_id = '22222222-2222-2222-2222-222222222222';
reset role;
select is((select count(*)::int from public.organization_members where organization_id = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa' and user_id = '22222222-2222-2222-2222-222222222222'), 1, 'org admin cannot remove an owner');

select set_config('request.jwt.claims', '{"sub":"33333333-3333-3333-3333-333333333333","role":"authenticated"}', true);
set local role authenticated;
select lives_ok($$insert into public.organization_members (organization_id, user_id, role) values ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '66666666-6666-6666-6666-666666666666', 'member')$$, 'org admin can add a plain member');
reset role;

-- ---------- plain MEMBER ----------
select set_config('request.jwt.claims', '{"sub":"44444444-4444-4444-4444-444444444444","role":"authenticated"}', true);
set local role authenticated;
update public.organization_members set role = 'admin' where organization_id = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa' and user_id = '44444444-4444-4444-4444-444444444444';
delete from public.organization_members where organization_id = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa' and user_id = '33333333-3333-3333-3333-333333333333';
reset role;
select is((select role from public.organization_members where organization_id = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa' and user_id = '44444444-4444-4444-4444-444444444444'), 'member', 'member cannot promote themselves');
select is((select count(*)::int from public.organization_members where organization_id = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa' and user_id = '33333333-3333-3333-3333-333333333333'), 1, 'member cannot remove an admin');

-- ---------- OUTSIDER ----------
select set_config('request.jwt.claims', '{"sub":"55555555-5555-5555-5555-555555555555","role":"authenticated"}', true);
set local role authenticated;
select is((select count(*)::int from public.organization_members where organization_id = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'), 0, 'outsider cannot read another organization''s memberships');
select throws_ok($$insert into public.organizations (name, organization_type, verification_status) values ('Fake Registry', 'agency', 'verified')$$, '42501', null, 'user cannot create a self-verified organization');
select throws_ok($$insert into public.organizations (created_by, name, organization_type) values ('11111111-1111-1111-1111-111111111111', 'Impersonation', 'agency')$$, '42501', null, 'user cannot create an organization on behalf of someone else');
select lives_ok($$insert into public.organizations (id, name, organization_type) values ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'My Org', 'developer')$$, 'user can create their own unverified organization');
select is((select role from public.organization_members where organization_id = 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb' and user_id = '55555555-5555-5555-5555-555555555555'), 'owner', 'creator becomes owner of their new organization');
select throws_ok($$update public.profiles set account_type = 'admin' where user_id = '55555555-5555-5555-5555-555555555555'$$, 'P0001', 'Only an existing administrator or trusted database operator can assign the admin role', 'user cannot assign themselves admin');
select lives_ok($$update public.profiles set account_type = 'professional' where user_id = '55555555-5555-5555-5555-555555555555'$$, 'user can still pick a non-admin account type (account_type is NOT verification)');
reset role;

-- ---------- OWNER: last-owner protection ----------
select set_config('request.jwt.claims', '{"sub":"11111111-1111-1111-1111-111111111111","role":"authenticated"}', true);
set local role authenticated;
update public.organization_members set role = 'admin' where organization_id = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa' and user_id = '22222222-2222-2222-2222-222222222222';
reset role;
select is((select role from public.organization_members where organization_id = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa' and user_id = '22222222-2222-2222-2222-222222222222'), 'admin', 'an owner can demote another owner while one owner remains');

select set_config('request.jwt.claims', '{"sub":"11111111-1111-1111-1111-111111111111","role":"authenticated"}', true);
set local role authenticated;
select throws_ok($$update public.organization_members set role = 'admin' where organization_id = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa' and user_id = '11111111-1111-1111-1111-111111111111'$$, 'P0001', 'An organization must retain at least one owner', 'the last owner cannot be demoted');
select throws_ok($$delete from public.organization_members where organization_id = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa' and user_id = '11111111-1111-1111-1111-111111111111'$$, 'P0001', 'An organization must retain at least one owner', 'the last owner cannot be removed');
reset role;

-- ---------- ANONYMOUS ----------
set local role anon;
select throws_ok($$select count(*) from public.profiles$$, '42501', null, 'anonymous role has no access to profiles');
select throws_ok($$select count(*) from public.organization_members$$, '42501', null, 'anonymous role has no access to memberships');
reset role;

select * from finish();
rollback;
