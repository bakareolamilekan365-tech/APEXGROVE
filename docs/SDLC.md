# Software development lifecycle (SDLC)

Status: Proposed 2026-10-11. Confirm with the founder. Review whenever the team or product changes.

## Model
Iterative and incremental. Work is delivered in thin vertical slices, each with a security gate.
Light up-front design is done only for high-risk areas (roles and permissions, trust labels, case data model, anything with legal weight).

## Why
- Requirements will keep changing (blueprint, palette, legal questions).
- The team is small, so ceremony stays minimal.
- The product is trust- and security-sensitive, so some decisions come before code.

## Cadence
One slice per 1-2 weeks. A founder review at the end of each slice.

## Loop for each slice
1. Define: one outcome, the user, what "done" means.
2. Design: one-page spec (user, screens and states, roles, data, risks).
3. Build: branch, migration, tests written with the code.
4. Verify: automated tests, RLS allow/deny tests, clean Supabase advisor run.
5. Review: short founder demo; decisions recorded.
6. Close: update CHANGELOG, DECISIONS.md and the audit doc; merge.

## Change control
- New requests go to the backlog, not into the slice in progress.
- Exceptions: security issues and blockers.
- Log each change: who asked, why, date.
- Record open questions instead of guessing (see OPEN-QUESTIONS-FOUNDER.md).

## Decide before building
- Role and permission model
- Trust-label set
- Case and evidence data model
- Payments, report wording and other legal items

## Fixed rules
- A feature is not done because a screen or folder exists. Use the Definition of Done below.
- Every new table has row-level security from day one.
- AI-generated code is reviewed and understood by a human before it merges.
- Demo data is always labelled "DEMO DATA / NOT OFFICIAL".
- Nothing is described as working unless it was verified.

## Definition of Done (per feature)
Intended user and purpose; inputs and outputs; valid and invalid states; authorised roles;
data storage and access rules; error handling; audit and notification needs;
automated and manual tests; security considerations; acceptance criteria.
(Adapted from the founder's Master Product Blueprint v1.0, section 31.)
