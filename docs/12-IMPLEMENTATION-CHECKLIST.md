# APEXGROVE — Implementation Checklist

Use this as an engineering gate, not a list of screens. Every item should be marked **NOT STARTED**, **IN PROGRESS**, **IMPLEMENTED** or **VERIFIED** based on repository evidence. Documentation alone never earns IMPLEMENTED or VERIFIED.

## Status definitions

- **NOT STARTED** — no working implementation or accepted design evidence.
- **IN PROGRESS** — partial implementation exists; important paths remain incomplete.
- **IMPLEMENTED** — real behavior is connected to its intended persistence/security boundary.
- **VERIFIED** — implementation passes relevant tests/review, including failure and authorization cases.

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
