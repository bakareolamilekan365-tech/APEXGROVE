# Current progress

## Working or previously verified

- Project repository and documentation structure.
- Account registration and login foundation.
- Profile onboarding and basic role-aware dashboard behavior.
- Protected routes and server-side account checks.
- Hosted Supabase database migrations `001`-`017`.
- Local code-quality checks, unit tests, non-database integration tests, and production builds.
- Successful [general CI](https://github.com/bakareolamilekan365-tech/ATEXGROVE/actions/runs/38276873401) and [temporary Supabase database-security](https://github.com/bakareolamilekan365-tech/ATEXGROVE/actions/runs/38276873408) workflow runs for PR #9 head commit `c259db0`.

## Merged through PR #9

- Password-recovery request and callback handling.
- Safer internal redirects.
- Stronger profile, organization, membership, owner, and administrator protections.
- Private `documents` storage rules.
- Database behavior tests.
- Security guardrails.
- Synthetic demonstration-data tooling.
- Migrations `015`–`017`.

## Current verification boundary

PR #9 is merged and the hosted migration list is current through `017`. The private bucket, user-scoped storage policies and foundation-table RLS configuration were confirmed on 2026-10-14. The pgTAP database allow/deny tests also passed in GitHub Actions using a temporary Supabase environment.

Still missing are hosted email-confirmation/password-recovery evidence, a realistic hosted cross-user document-access test, resolution or explicit acceptance of the live Supabase advisor findings, and a forward migration/test removing anonymous execute access from `organization_actor_role`. A successful temporary CI database does not prove the hosted environment or complete application journey. Deployed does not mean fully verified.

## Not built yet

- Verification-case records and customer submission journey.
- Private evidence workflow connected to a real case.
- Staff queue, assignment, handover, and review notes.
- Feasibility calculation workflow.
- Land & Development Report creation and delivery.
- Land discovery and working GIS experience.
- Project workspaces and professional participation.
- Payments, mobile/offline work, and AI-assisted analysis. AI processing of real pilot documents is expressly excluded.

## Known accepted or deferred items

- PostGIS is installed in the public database area and produces advisor warnings. Changing the extension location is disruptive and is deferred.
- Supabase-managed tables must not be altered by Atexgrove migrations.
- The prototype remains on Supabase Free. The dashboard must confirm whether leaked-password protection requires a paid plan before the finding is formally accepted as a plan limitation.
- Previously reported index and policy-performance findings must be checked against the current live advisors before their exact number or priority is treated as confirmed.
- The existing logo assets under `public/brand/` are accepted for the application, and the interface now uses Figtree to match the approved dashboard references. A true vector master is still desirable for professional print/large-format work.

## Simple status

The project has a stronger deployed foundation but not yet a complete commercial journey or production-ready security posture. The controlled Abuja/FCT pilot direction is approved, including its six stages, customer/staff-assisted entry, human-led assignment, specialist second review, trust labels, no-payment rule and real-document policy gate. First close the remaining foundation evidence; the next product proof is then a customer submitting a synthetic/redacted verification case and authorized staff processing it securely.

