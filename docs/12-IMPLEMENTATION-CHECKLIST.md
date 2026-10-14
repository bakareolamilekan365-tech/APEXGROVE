# Atexgrove — Implementation Checklist

Use this as an engineering gate, not a list of screens. Every item should be marked **NOT STARTED**, **IN PROGRESS**, **IMPLEMENTED** or **VERIFIED** based on repository evidence. Documentation alone never earns IMPLEMENTED or VERIFIED.

## Status definitions

- **NOT STARTED** — no working implementation or accepted design evidence.
- **IN PROGRESS** — partial implementation exists; important paths remain incomplete.
- **IMPLEMENTED** — real behavior is connected to its intended persistence/security boundary.
- **VERIFIED** — implementation passes relevant tests/review, including failure and authorization cases.

## Current evidence snapshot — 2026-10-14

On `main` after PR #9:

- **DEPLOYED/CONFIGURATION VERIFIED:** hosted migration history contains `001`-`017`; the `documents` bucket is private; user-scoped SELECT/INSERT/UPDATE/DELETE storage policies exist; RLS is enabled on `profiles`, `organizations`, `organization_members` and `audit_logs`.
- **IMPLEMENTED IN CODE:** password recovery request, PKCE callback, safe internal redirects, authenticated password update, profile onboarding fields, role-aware dashboard copy, server authorization helpers, synthetic fixture tooling, membership-owner protection, security guardrails, pgTAP suites, and Docker-backed database-test CI.
- **PREVIOUSLY VERIFIED LOCALLY:** lint, typecheck, security guardrails, focused unit/integration tests and production build passed on the security branch before merge.
- **NOT YET VERIFIED/RECORDED:** pgTAP execution against a fresh stack, credential-dependent integration tests, hosted email confirmation/recovery, complete E2E journey and a green database-test workflow result for the final merged commit.
- **OPEN HOSTED FINDINGS:** `spatial_ref_sys` RLS, security-definer API reachability, PostGIS placement/functions, leaked-password protection, three unindexed foreign keys and four RLS policy performance findings.

Migration deployment is complete, but the foundation is not fully **VERIFIED** until behavioral and operational evidence closes the remaining gates.

## Foundation

- [ ] **NOT STARTED / IN PROGRESS / IMPLEMENTED / VERIFIED** — requirements, prototype journey, design tokens and current-vs-future labels are approved.
- [ ] **NOT STARTED / IN PROGRESS / IMPLEMENTED / VERIFIED** — environment validation, GitHub workflow and Supabase connection work without committed secrets.
- [ ] **NOT STARTED / IN PROGRESS / IMPLEMENTED / VERIFIED** — modular-monolith domain boundaries and provider adapter seams are documented and respected.

## Database

- [ ] Migrations apply cleanly and match the current schema contract.
- [ ] Foreign keys, constraints, timestamps and jurisdiction/provenance fields are deliberate.
- [ ] Seed/demo data is reproducible and labelled DEMO DATA / NOT OFFICIAL.
- [ ] Indexes, pagination-friendly queries and spatial indexes exist where actual access patterns require them.

## Auth and authorization

- [ ] Supabase sign-up, login, session handling and route protection work against the real service.
- [ ] Profile/onboarding behavior persists real data.
- [ ] Ownership, organization membership, project membership, permissions and scope are checked server-side.
- [ ] Platform role, discipline, organization/project role, subscription and entitlement remain distinct.
- [ ] Separated administrative responsibilities prevent unrestricted “God Admin” access.

## RLS and security

- [ ] RLS policies cover each protected table and are tested for allow/deny cases.
- [ ] The RLS guardrail check fails when an application-owned public table is introduced without RLS; system-managed Supabase schemas are intentionally excluded.
- [ ] New protected tables include explicit grants, per-operation policies and database allow/deny tests in the same change.
- [ ] BOLA/IDOR, privilege escalation and alternate endpoint/download paths are blocked.
- [ ] Service-role credentials remain server-only; secrets are absent from source control.
- [ ] Sensitive mutations, verification decisions, document access and admin actions are auditable.
- [ ] Rate limits, secure sessions, validation, safe errors, headers/configuration and monitoring are reviewed proportionally.

## Land and GIS

- [ ] Real persistence supports parcel discovery, filtering, detail and map selection.
- [ ] Geometry uses explicit coordinate/reference-system metadata and source/update/jurisdiction provenance.
- [ ] Visual GIS, survey, cadastral and official/statutory boundaries are distinct in data and UI.
- [ ] Viewport loading, pagination/lazy loading and spatial performance are adequate for the current dataset.

## Verification and documents

- [ ] Verification records have explicit type, status, evidence, source, reviewer, authority and dates.
- [ ] Authority hierarchy is visible; internal review is not represented as official certification.
- [ ] Documents use private storage, authorization before retrieval, validation and controlled access.
- [ ] Version lineage is preserved; important evidence is not silently overwritten.
- [ ] Draft/Submitted/Under Review/Approved/Rejected/Archived transitions are validated and audited.

## Projects and professionals

- [ ] Project creation from a parcel persists real records.
- [ ] Project membership/roles and organization scope are enforced.
- [ ] Professionals can be associated with projects without turning discipline into permission.
- [ ] Project documents and activity use the same access and audit rules.

## Feasibility

- [ ] Inputs are validated and assumptions are explicit.
- [ ] Calculations are deterministic, reproducible and scenario-comparable.
- [ ] Outputs are labelled estimates, not guaranteed financial or regulatory outcomes.
- [ ] Source/provenance is retained for future external cost/market/regulatory data.

## Admin

- [ ] Admin screens expose only granted responsibility/scope.
- [ ] Verification, operations, compliance, support and future billing responsibilities remain separable.
- [ ] Sensitive changes require audit records and appropriate review/approval separation.

## Testing

- [ ] Unit tests cover validation, permission decisions, verification transitions and feasibility calculations.
- [ ] Integration tests cover persistence, RLS, storage privacy, API boundaries and provider failures.
- [ ] E2E tests cover the critical prototype journey and permission-denied/error states.
- [ ] Security regression cases cover unauthorized users, wrong owner/organization/project, privilege escalation, invalid uploads and malicious/untrusted input.

## Observability and release readiness

- [ ] Errors, provider outages, timeouts and retry behavior are observable without leaking sensitive data.
- [ ] Backups/recovery, credential rotation and incident-response ownership are planned before production use.
- [ ] Accessibility, responsive behavior, loading/empty/error states and synthetic-data labels are reviewed.
- [ ] Typecheck, lint, build and relevant tests pass in CI.

## Foundation gate evidence

Track these items from implementation evidence, not documentation alone:

- **Password recovery/email confirmation:** recovery request, PKCE callback, safe internal redirect and authenticated password update.
- **Profile onboarding/dashboard:** full name, phone, location and bio persist for the authenticated user; dashboard copy reflects the selected platform role without implying future modules exist.
- **Organization security:** creator spoofing, self-verification, admin escalation, owner transfer/removal and last-owner loss are denied by database policy/trigger behavior.
- **Private storage:** the foundation `documents` bucket is private and object paths are scoped to `documents/<user-id>/...`.
- **Synthetic fixtures:** demo users/organizations are reproducible, synthetic and labelled `DEMO DATA / NOT OFFICIAL`.
- **Requirement-specific tests:** behavior, persistence, denial paths and recovery states are covered; smoke/source-text checks do not substitute for them.

Current gate state:

| Gate | Status | Evidence / remaining work |
| --- | --- | --- |
| Migrations `015`-`017` deployed | **IMPLEMENTED** | Present in hosted migration history. |
| Application foundation RLS enabled | **IMPLEMENTED** | Read-only hosted inspection confirms RLS on four application tables. |
| Private documents bucket/policies | **IMPLEMENTED** | Bucket is private and four per-operation policies exist; cross-user behavior test evidence remains pending. |
| Organization/profile hardening | **IMPLEMENTED** | Policies/triggers are deployed; pgTAP ALLOW/DENY execution remains pending. |
| Recovery and email confirmation | **IN PROGRESS** | Code exists; hosted email, redirect, expiry and error behavior remain unverified. |
| Database security tests | **IN PROGRESS** | pgTAP files and CI workflow exist; a final green execution result has not been recorded. |
| Synthetic fixtures | **IMPLEMENTED** | Deterministic tooling exists; use only synthetic identities and non-sensitive files. |
| Production readiness | **NOT STARTED** | Security findings, operations, monitoring, recovery and complete journeys remain open. |

## Definition of done

```text
Feature works
AND authorization works
AND persistence works
AND tests cover important paths
AND failure behavior is understood
AND security boundaries are preserved
```

Do not require unrealistic 100% coverage. Require evidence for the paths that can expose data, change trust state, affect money in the future or mislead a user about authority.
