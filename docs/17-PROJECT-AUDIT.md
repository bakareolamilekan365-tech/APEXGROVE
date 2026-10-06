# APEXGROVE - Project Audit

**Audit date:** 2026-10-02  
**Repository:** `bakareolamilekan365-tech/APEXGROVE`  
**Branch:** `main`  
**Audit type:** Internal development progress audit

## Executive Summary

APEXGROVE has completed its repository, product-definition, design-planning, dependency, testing, security-ignore, and initial Supabase foundation setup. The first authentication and onboarding slice is now implemented locally, and the foundation migrations have been applied to the hosted Supabase project.

The application is **not yet feature-complete**. Many routes and modules are intentional scaffolds, and no claim of production readiness or official land verification should be made at this stage.

## Completed Work

### Repository and documentation

- Created the full Next.js/Supabase repository structure.
- Moved the original specification set into `docs/`.
- Added the requirements and staged testing strategy.
- Added the design gate and free-first integration plan.
- Added this audit record.
- Configured GitHub Actions, issue templates, VS Code recommendations, README files, and licensing placeholder.

### Development foundation

- Configured Next.js, React, TypeScript, ESLint, Tailwind, Vitest, and Playwright.
- Added `@supabase/supabase-js`, `@supabase/ssr`, and `zod`.
- Added separate test commands:
  - `npm run test:unit`
  - `npm run test:integration`
  - `npm run test:e2e`
  - `npm test`
- Added a lockfile so dependency installation is reproducible.

### Security foundation

- Added environment, credential, private-key, certificate, and deployment-state ignore rules.
- Confirmed `.env.local` is not committed.
- Added environment variable documentation without storing secret values in the repository.

### Supabase foundation

- Wired the browser Supabase client.
- Wired the server Supabase client with cookie handling.
- Added session-refresh middleware.
- Added migration support for:
  - PostgreSQL extensions and PostGIS
  - Profiles and automatic profile creation after signup
  - Organizations and memberships
  - Organization ownership
  - Audit logs
  - Initial row-level security policies
- Applied the 14 local migrations to the hosted Supabase project with `supabase db push`.
- Applied `014_auth_hardening.sql` to the hosted project after the security review.

### Authentication slice

- Added registration with safe default role provisioning.
- Added email/password login.
- Added role selection and profile update.
- Added protected dashboard routing and profile lookup.
- Added shared role validation.

### Manual verification

- Confirmed registration works against the hosted Supabase project.
- Confirmed login works with the created demo account.
- Confirmed role selection updates the profile.
- Confirmed the dashboard loads the authenticated profile and role.

### Validation completed

- TypeScript typecheck passes.
- ESLint passes with a non-blocking TypeScript-version compatibility warning.
- Unit suites pass: 4 test files, 5 tests.
- Integration suites pass: 5 test files, 8 tests.
- Playwright discovers the four planned E2E flows; they are explicitly skipped until their application features exist.
- Production build passes and generates 36 routes; the authenticated dashboard is dynamic.
- Known non-blocking warnings: Next ESLint plugin is not detected by the native flat config, TypeScript 5.9 is newer than the current typescript-eslint support range, and Vite reports a deprecated CJS API.
- `npm audit --omit=dev` reports transitive PostCSS vulnerabilities; npm proposes a breaking Next 16 upgrade.
- Manual registration, login, role selection, and dashboard verification passed.

## Commit Record

| Commit    | Purpose                                               |
| --------- | ----------------------------------------------------- |
| `dc89ae3` | Initial specification repository                      |
| `e32718e` | Place specifications in the visible project folder    |
| `d748b23` | Scaffold the application structure                    |
| `dbf2ac8` | Align dependencies and lint setup                     |
| `a1cda5f` | Protect secrets with Git ignore rules                 |
| `c9b1fd7` | Define requirements and staged testing                |
| `551efee` | Add design gate and free-first integrations plan      |
| `88978c9` | Checkpoint current scaffold progress                  |
| `38c10fe` | Install Supabase foundation dependencies              |
| `a6d2c41` | Add Supabase clients, middleware, and auth foundation |
| `71369ab` | Ignore Supabase CLI temporary state                   |
| `c1f387e` | Implement authentication foundation flow              |
| `a21a62f` | Record hosted Supabase foundation deployment          |
| `934dc53` | Harden auth roles and complete project audit          |
| `78a6ff4` | Record successful auth flow verification              |
| `95ecd74` | Map prototype flow and delivery phases                |

## Current Status by Area

| Area                   | Status                      | Evidence or limitation                                                                              |
| ---------------------- | --------------------------- | --------------------------------------------------------------------------------------------------- |
| Product requirements   | Complete baseline           | Requirements are documented and mapped to test layers.                                              |
| UX/design planning     | Ready for implementation    | Design gate and flow checklist exist; polished wireframes are still needed.                         |
| Repository setup       | Complete                    | GitHub `main` is clean and synchronized.                                                            |
| Environment setup      | Local configuration present | `.env.local` exists locally and is ignored; values are never stored in Git.                         |
| Supabase clients       | Foundation complete         | Browser/server clients and middleware are wired.                                                    |
| Database schema        | Foundation partial          | Auth/profile/organization/audit migrations are real; later domain migrations remain placeholders.   |
| Hosted database        | Foundation deployed         | All 14 local migrations were applied successfully with `supabase db push`.                          |
| Authentication UI      | Foundation verified         | Registration, login, role selection, and protected dashboard were manually verified; reset pending. |
| Dashboard              | Foundation partial          | Authenticated profile lookup works; role-specific dashboard modules remain pending.                 |
| Land/GIS               | Not started                 | Demo GeoJSON and map provider are not connected.                                                    |
| Documents              | Not started                 | Storage buckets, upload, access checks, and versioning are not implemented.                         |
| Projects/professionals | Not started                 | Workspace and membership workflows are placeholders.                                                |
| Feasibility            | Not started                 | Calculation domain logic and persistence are not implemented.                                       |
| E2E coverage           | Reserved                    | Four named flows exist but are skipped until features are connected.                                |
| Production build       | Passing                     | 36 routes build successfully; Next ESLint plugin detection remains a warning.                       |
| Dependency security    | Review required             | PostCSS advisories are transitive through Next 15; fixing requires a major Next upgrade.            |

## Foundation Exit Checklist

The prototype foundation is ready to move into land implementation when these remaining gates are complete:

- [x] GitHub repository, branch, ignore rules, and reproducible dependencies
- [x] Requirements, design plan, prototype flow, and delivery gates documented
- [x] Supabase project linked and 14 migrations deployed
- [x] Browser/server clients and session middleware wired
- [x] Registration, login, role selection, and protected dashboard manually verified
- [x] Typecheck, lint, unit tests, integration tests, and production build pass
- [ ] Password reset and email-confirmation recovery flow
- [ ] Profile onboarding details beyond role selection
- [ ] Real database tests for RLS, profile provisioning, and organization membership
- [ ] Private document storage bucket and access policies
- [ ] Synthetic seed fixtures for users, organizations, and initial dashboard data
- [ ] Replace foundation smoke tests with requirement-specific tests
- [ ] Update the audit after all remaining gates pass

Until the unchecked items are complete, feature work should remain limited to foundation support. The first post-foundation implementation slice is Land Discovery and GIS.

## Open Risks and Required Follow-up

1. Add migration tests for RLS and profile provisioning against a real database.
2. Finish password reset and onboarding profile details.
3. Replace remaining smoke tests with requirement-specific unit and integration tests.
4. Implement the role-aware dashboard modules.
5. Decide whether to keep the stable Next 15/PostCSS risk or schedule a tested Next 16 upgrade.
6. Add synthetic seed data and clearly label it as `DEMO DATA / NOT OFFICIAL`.
7. Only then begin the land and GIS workflow.

## Audit Boundary

This is an internal engineering progress record, not a security certification, legal review, data-provenance certification, or production-readiness approval. It should be updated after each foundation milestone and before each major implementation phase.

## Audit Update — 2026-10-06

**Update type:** Documentation architecture consolidation checkpoint
**Baseline preserved:** The 2026-10-02 audit above remains unchanged and historical.

### Executive summary

Since the baseline audit, the V2 documentation architecture has been consolidated and merged into `main` through three documentation-only pull requests:

- PR #2 — foundation context, PRD, system architecture and database schema
- PR #3 — authentication/security and document trust model
- PR #4 — remaining API, UI/UX, GIS, feasibility, roadmap, repository, checklist, demo-data, build-agent, testing, integration and delivery documents

These changes clarify the intended architecture without claiming that future capabilities are implemented. No application code, Supabase migrations, dependencies, package configuration or tests were changed by those documentation passes.

### Architectural decisions now recorded

- The current application remains a modular monolith; future service extraction is conditional on scale and ownership.
- Identity, platform role, professional discipline, organization membership, project role, permission, subscription and entitlement remain separate.
- Administrative responsibility is least-privilege and separable; there is no intended unrestricted “God Admin”.
- Authorization requires ownership, organization/project membership, permissions, scope, server-side checks and RLS.
- Verification is structured and authority-aware; APEXGROVE internal review is not government or statutory certification.
- Provenance is required for important land, GIS, document and verification information.
- GIS geometry is not automatically a legally authoritative cadastral boundary.
- Sensitive documents follow private storage, controlled access, metadata, versioning, review, audit and retention/deletion principles.
- External services belong behind replaceable provider adapters; long-running work has a future background-processing extension point.
- AI is advisory and untrusted-input-aware, not an official, legal or professional authority.
- Payments/subscriptions remain outside prototype scope and must be a separate future commercial domain.
- Mobile/offline field workflows, privacy/regulatory work and operational resilience remain future architecture or follow-up work.

### Current implementation status after documentation consolidation

The implementation status remains materially the same as the baseline audit because this consolidation changed documentation only:

| Area | Current status | Update |
| --- | --- | --- |
| Product/architecture documentation | **Implemented as documentation** | V2 boundaries and current-vs-future language are now aligned across the foundation and remaining specifications. |
| Repository and Supabase foundation | **Foundation complete/partial** | Existing Auth, profile, organization, audit and RLS foundation remains the implementation source of truth. |
| Authentication | **Foundation verified / follow-up pending** | Registration, login, role selection and protected dashboard remain the verified slice; recovery/MFA/session administration still require completion or explicit verification. |
| Authorization/RLS | **Foundation partial** | Architecture is documented; comprehensive object-level, membership, admin-scope and RLS tests remain required. |
| Land/GIS | **Not started or scaffolded** | The next implementation slice remains Land Discovery + GIS; visual, survey, cadastral and official boundaries must stay distinct. |
| Verification/documents | **Planned/partial** | Structured trust and private-document requirements are documented; complete storage policies, access checks, version lineage and review workflows require implementation evidence. |
| Projects/professionals | **Not started or scaffolded** | Project membership, professional participation and controlled workspace flows remain future implementation work. |
| Feasibility | **Not started or scaffolded** | Deterministic, transparent calculations and persistence remain future implementation work. |
| Payments/subscriptions | **Out of scope** | No checkout, payment provider or entitlement implementation is part of the prototype. |
| Production readiness/compliance | **Not complete** | Privacy, retention, monitoring, recovery, threat controls and professional/legal review remain follow-up work. |

### Next implementation phase

After the outstanding foundation gates are satisfied, implementation should proceed with the vertical Land Discovery + GIS slice:

1. Confirm parcel data, ownership and RLS contracts.
2. Add reproducible synthetic Abuja/demo fixtures labelled `DEMO DATA / NOT OFFICIAL`.
3. Implement bounded search/filter, list/map views, parcel detail and viewport-aware spatial queries.
4. Preserve source, jurisdiction, update date and authority/provenance labels.
5. Add unit, integration, RLS/authorization and E2E coverage before expanding into verification/documents.

### Outstanding gates and risks

- Password-reset and account-recovery behavior still requires completion or verification.
- Profile onboarding details and role-aware dashboard modules remain incomplete.
- Real database tests for RLS, profile provisioning and organization/project membership are required.
- Private document buckets, access policies, version/audit behavior and retention rules require implementation evidence.
- Synthetic seed fixtures and failure/rejection edge cases are still needed.
- Dependency advisories and any framework upgrade must be handled as a separate tested change.
- This update does not certify legal compliance, official land status, security readiness or production readiness.

### Audit boundary for this update

This addendum records the documentation milestone and the next implementation direction. It does not replace the 2026-10-02 baseline, change application behavior or authorize future features to be represented as implemented. The audit should receive another dated update after the Land + GIS milestone and before the next major phase.

## Rename note — 2026-10-11

The product display name changed from APEXGROVE to Atexgrove (code identifier `atexgrove`). Existing lines above were left unchanged as a historical record. The GitHub repository name and the hosted Supabase project's dashboard name and the local `supabase/config.toml` `project_id` have not yet been renamed. Logo files under `public/logo/apexgrove-*.svg`, `LICENSE`, applied Supabase migrations, seed, functions, environment variables, cookie/storage keys and repository URLs were intentionally left unchanged.

## Audit Update — 2026-10-11

### Executive summary

This update records a read-only check of the hosted Supabase project, a review of the unmerged `fix/foundation-security-and-quality-gates` branch, a correction to the baseline audit, and a proposed change to the next implementation phase following the founder's Master Product Blueprint v1.0. It does not change application behavior. Nothing in this update has been executed against the database beyond read-only queries.

### Correction to the baseline audit

The baseline states that Tailwind was configured. On `main` as reviewed on 2026-10-08, `package.json` has no Tailwind dependency, `postcss.config.mjs` has no plugins, `tailwind.config.ts` is a stub, and `src/app/globals.css` is plain CSS. **Corrected status: Tailwind is documented as the intended styling direction but is not installed.** Installing it is a tracked change that requires lint, typecheck, test, build and visual verification.

### Live Supabase verification (read-only)

| Check | Result |
| --- | --- |
| Project | `apexgrove`, eu-north-1, Postgres 17. It had been paused and was restored for this check. |
| Applied migrations | **001 to 014 applied.** Migrations 015 and above are not applied. |
| Application tables with RLS enabled | `profiles`, `organizations`, `organization_members`, `audit_logs`. All showed 0 rows. |
| Placeholder migrations | 004 to 011 created no tables; land, verification, properties, projects, professionals, documents, feasibility and notifications do not exist yet. |

### Security advisor findings (live project)

| Finding | Level | Planned fix | Status |
| --- | --- | --- | --- |
| `public.spatial_ref_sys` has RLS disabled | ERROR | Migration 017: enable RLS and add a read-only policy | **Not applied** |
| Six SECURITY DEFINER functions executable through the API by `anon` and `authenticated` | WARN | Migration 017: revoke execute | **Not applied** |
| `set_updated_at` has a mutable `search_path` | WARN | Migration 017 | **Not applied** |
| PostGIS extension installed in `public` | WARN | Accepted for now; revisit when map features are built | **Accepted** |
| PostGIS `st_estimatedextent` functions executable by `anon` and `authenticated` | WARN | Accepted for now; extension-owned | **Accepted** |
| Leaked-password protection disabled | WARN | Dashboard setting; may require a paid plan | **Open** |

### Known issues in the fix branch (not merged)

- An organization admin could demote an owner, because the membership UPDATE policy checks the new row but not the old row. Planned fix: migration 016.
- `safeInternalPath` could be bypassed with `/\host` and control characters. Planned fix: corrected helper with tests.
- The Supabase allow/deny integration tests are skipped in CI without credentials, and the pgTAP file checks that policies exist rather than how they behave. Planned fix: a database-tests CI job running `supabase test db`, and behavioral membership tests.
- Migration 015 has not been proven to apply cleanly, especially the `storage.objects` triggers and policies.
- `account_type` is self-selected; a separate verification state is required before any trust-sensitive feature relies on it.
- `requireOwnedRow` accepts a table name and should be limited to an allow-list in trusted server code.
- Middleware treats `/api/` as public, so each API route must perform its own authentication and authorization.

### Proposed revision to the next implementation phase

The 2026-10-06 update names Land Discovery + GIS as the next slice. The founder's Master Product Blueprint v1.0 (shared 2026-10-11) makes **Land Verification and Development Feasibility in Abuja** the first commercial product, delivered as a Land & Development Report. **Proposed, pending founder confirmation:** after the outstanding foundation gates, build the verification case workflow first (request, document submission, internal work queue, assignment and handover, evidence recording, report review, audit trail), and treat the map as a way to locate a site within a case. Land Discovery follows.

This also requires decisions before implementation: the role and department model, a single set of trust labels based on the blueprint's information-source types, and the case and evidence data model. Planning standards must not be hard-coded until the Development Control and FHA manuals have been reviewed.

### Outstanding gates

- Apply and verify migrations 015, 016 and 017 locally, then re-run the security advisors.
- Run the behavioral RLS tests and keep them in CI.
- Set Supabase Auth password length, email confirmation and leaked-password protection, and verify.
- Install Tailwind as a separate tested change.
- Obtain the founder's answers to the open scope, naming, palette, legal and data-source questions.
- Record decisions in `docs/DECISIONS.md` and the development process in `docs/SDLC.md`.

### Audit boundary for this update

This update does not certify legal compliance, official land status, security readiness or production readiness. It does not replace the 2026-10-02 baseline or the 2026-10-06 update, except for the Tailwind correction above, and it does not authorize any planned feature to be represented as implemented. The audit should receive another dated update after the foundation gates are closed.
## Audit Update — 2026-10-06 Foundation Hardening Checkpoint

**Update type:** Implementation checkpoint on `fix/foundation-security-and-quality-gates`.
**Historical boundary:** The 2026-10-02 audit and the earlier 2026-10-06 documentation checkpoint above remain unchanged.

### Evidence completed on this branch

- Password recovery now has a generic request state, Supabase PKCE callback exchange, safe internal redirects and an authenticated update-password page.
- Registration confirmation now targets the existing callback route; profile onboarding persists full name, phone, location and bio; the dashboard uses persisted platform role data and labels future modules as planned.
- Migration `015_foundation_security_hardening.sql` adds constrained organization creation, security-field immutability, membership/owner invariants, trigger audit records, account-type escalation protection and a private user-scoped `documents` bucket with storage policies.
- Reusable server authorization helpers and a fail-closed production middleware configuration path are present.
- Synthetic fixture seeding is reproducible and uses `.invalid` demo identities; no real credentials or sensitive documents are included.
- CI now uses `npm ci`, runs lint/typecheck/unit/integration/build and runs a permanent application-table RLS/private-storage guardrail check.
- Local evidence on this branch: lint, typecheck, unit tests, integration tests (configured external Supabase security suite skipped without test credentials), guardrail check and production build pass.

### Foundation gates still requiring deployment or environment evidence

- Apply migration 015 to the hosted project through the normal reviewed migration workflow and run the real Supabase database/RLS test suite with isolated test credentials.
- Confirm the configured Supabase Auth Site URL/redirect allowlist includes the callback and recovery paths, then manually verify confirmation and recovery emails end to end.
- Run the integration security suite against a disposable/isolated database to verify allow/deny behavior for profiles, organizations, memberships and private storage.
- Review Supabase security advisors after migration deployment; existing system-managed `spatial_ref_sys` and PostGIS advisories remain intentionally outside the application-table RLS guardrail and should be handled as a separate database-posture decision.

### Known risks and boundaries

This checkpoint does not claim production readiness, legal compliance, official land status, or completion of Land/GIS, Projects, Professionals, Feasibility, Payments or AI. The existing dependency advisory state remains a separate tested upgrade decision; no framework major upgrade was included. A feature is not foundation-complete until deployment evidence, authorization behavior, persistence, tests and failure handling are verified together.
