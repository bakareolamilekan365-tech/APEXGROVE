# Current progress

## Working or previously verified

- Project repository and documentation structure.
- Account registration and login foundation.
- Profile onboarding and basic role-aware dashboard behavior.
- Protected routes and server-side account checks.
- Hosted Supabase database migrations `001`-`017`.
- Local code-quality checks, unit tests, non-database integration tests, and production builds.
- GitHub workflow capable of starting a temporary Supabase environment and running database tests.

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

PR #9 is merged and the hosted migration list is current through `017`. The private bucket, user-scoped storage policies and foundation-table RLS configuration were confirmed on 2026-10-14.

Still missing are a recorded passing pgTAP/database-test run for the final implementation, hosted email-confirmation/password-recovery evidence, and resolution or explicit acceptance of the live Supabase advisor findings. Deployed does not mean fully verified.

## Not built yet

- Verification-case records and customer submission journey.
- Private evidence workflow connected to a real case.
- Staff queue, assignment, handover, and review notes.
- Feasibility calculation workflow.
- Land & Development Report creation and delivery.
- Land discovery and working GIS experience.
- Project workspaces and professional participation.
- Payments, mobile/offline work, and AI-assisted analysis.

## Known accepted or deferred items

- PostGIS is installed in the public database area and produces advisor warnings. Changing the extension location is disruptive and is deferred.
- Supabase-managed tables must not be altered by Atexgrove migrations.
- Leaked-password protection requires Supabase Pro; the prototype remains on Free.
- Three helpful database indexes and four policy-performance improvements can be added later without delaying Phase 2.
- The supplied logo is prepared for web use, but a true vector master is still needed for professional print work.

## Simple status

The project has a stronger deployed foundation but not yet a complete commercial journey or production-ready security posture. First close the remaining foundation evidence; the next product proof is then a customer submitting a synthetic demonstration verification case and authorized staff processing it securely.

