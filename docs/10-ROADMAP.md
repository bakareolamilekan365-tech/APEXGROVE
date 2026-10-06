# APEXGROVE — Roadmap

The roadmap separates the working prototype from future architecture. A phase is not complete because a screen exists: the relevant persistence, authorization, failure handling, tests and trust boundaries must work together.

## Phase 0 — Architecture / Design Lock

- Confirm the prototype journey, domain boundaries and role/discipline/organization/project-role separation.
- Lock the modular-monolith approach, provider-adapter seams, provenance model and document security lifecycle.
- Define requirement IDs, acceptance signals, RLS/authorization rules, synthetic-data policy and test layers.
- Identify jurisdiction, privacy and regulatory questions requiring domain or legal input.

**Gate:** every must-work capability has an owner, data/permission contract, current-vs-future label and test plan.

## Phase 1 — Foundation

- Repository, environments, Supabase project, migrations and seed process.
- Supabase Auth, profile/onboarding flow, sessions and initial role-aware dashboard.
- Core UI system, server-side business boundaries, RLS and audit-log foundation.

**Gate:** a signed-in user can complete the foundation flow against real persistence; secrets remain outside source control.

## Phase 2 — Land + GIS

- Synthetic land discovery, filters, list/map views, parcel detail and PostGIS/GeoJSON integration.
- Source, jurisdiction, data-as-of and visual-versus-authoritative GIS labels.
- Spatial indexes and viewport loading where needed for real data volume.

**Gate:** users can discover and open clearly labelled DEMO / NOT OFFICIAL parcels without implying cadastral authority.

## Phase 3 — Verification + Documents

- Verification records, checklist/status workflow, reviewer notes and structured evidence.
- Private document storage, metadata, versioning, controlled access and audit events.
- Distinct identity, organization, professional, land/document, title, survey and planning verification concepts as the architecture evolves.

**Gate:** evidence access is authorized and traceable; internal review is never represented as government certification.

## Phase 4 — Projects + Professionals

- Create projects from parcels, project membership/roles, professional directory and project documents.
- Preserve organization/project scope and professional responsibility boundaries.

**Gate:** a parcel becomes a persisted, permission-checked project workspace with no disconnected UI states.

## Phase 5 — Feasibility + Admin

- Deterministic feasibility inputs, calculations and scenario comparison.
- Scoped administration, separated responsibilities and audit review.
- Explicit failure/uncertainty handling for assumptions and demo data.

**Gate:** results are reproducible and labelled as planning estimates; administrators can perform only their granted scope.

## Phase 6 — Integration + Release Confidence

- Replace placeholder tests with meaningful unit, integration, RLS/authorization and E2E coverage.
- Responsive/accessibility review, error/empty/loading states, observability and deployment preview.
- Verify backup/recovery, rate limits, private storage controls and release documentation as operational work matures.

**Gate:** feature behavior, persistence, authorization, tests, failure behavior and security boundaries all pass review.

## Future Product Expansion

Reserved domains, not current prototype scope:

- planning intelligence and jurisdiction rules
- approval workflows
- construction management, BOQ, tendering and procurement/suppliers
- property management
- education and professional networking
- analytics
- finance and payments
- mobile/offline field workflows

## Future Ecosystem Expansion

- External authority and professional-registry integrations
- GIS, survey, environmental and market-data providers
- Notifications, email and monitoring services
- Multi-country and jurisdiction-specific expansion

Providers remain behind replaceable adapters. External data must retain provenance and authority distinctions.

## Future Intelligence Platform

- AI-assisted document/data analysis
- Advanced GIS and urban intelligence
- Aggregated/anonymized development datasets
- Background processing for large GIS, reports, imports, notifications and analytics

AI remains advisory, uncertain where appropriate and subordinate to qualified professionals and official authorities.

## Cost and quality rules

- Start with free/low-cost services and synthetic/local data; pay for external providers only when the use case, privacy, quota and operational value justify it.
- Add quality, security, privacy and compliance gates to every phase; progress is not feature count alone.
- Payments/subscriptions remain future. When added, keep role, subscription and entitlement separate and require verified webhooks and idempotency.
- Do not prematurely split the modular monolith into microservices; extract bounded services only when scale or ownership requires it.
