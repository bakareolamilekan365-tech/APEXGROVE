# APEXGROVE - Design and Integration Plan

## Purpose

Design decisions should be settled before feature implementation. This plan defines the design deliverables, the external accounts required for the prototype, and the free-first integration boundary.

Free tiers are suitable for development and demonstration when quotas, attribution, privacy, and rate limits are respected. The application must keep providers behind adapters so changing a provider does not require rewriting domain logic.

## Integration inventory

### Current / near-term

- **GitHub** — source control, reviews and CI.
- **Supabase** — PostgreSQL/PostGIS, Auth, RLS and private Storage.
- **Map stack** — MapLibre and a replaceable tile/data provider when map implementation needs it.
- **Vercel** — future preview/deployment target when the local journey is ready.
- **Email provider** — later; begin with Supabase Auth email for development.
- **Monitoring/observability** — later, after privacy/consent and event boundaries are defined.

The prototype does not require every future API domain, external authority feed or paid provider.

## Design Gate Before Implementation

### 1. Product and requirements baseline

- Confirm the prototype journey in `00-PROJECT-CONTEXT.md`.
- Confirm must-work features versus planned features in `01-PRD.md`.
- Assign each requirement an owner, acceptance signal, and test layer in `15-REQUIREMENTS-AND-TEST-STRATEGY.md`.

### 2. Domain and data design

- Confirm ownership and membership rules for every domain.
- Confirm the parcel-to-verification-to-project relationship.
- Confirm document metadata, versioning, private storage, and audit records.
- Confirm jurisdiction, provenance, and `DEMO DATA / NOT OFFICIAL` fields for synthetic data.
- Review migrations and RLS policies before building large screens.

### 3. Experience design

Create low-fidelity flows before polished implementation for:

- Registration, role selection, and onboarding
- Role-aware dashboard
- Land list, filters, map, and parcel detail
- Verification checklist and document upload
- Project creation and workspace navigation
- Professional search and project membership
- Feasibility scenario entry and comparison
- Admin management and audit review

For each flow, specify loading, empty, error, permission-denied, not-found, and success states. Planning and other future modules must show an honest planned state rather than an interactive fake.

### 4. Visual system

- Confirm typography, color tokens, spacing, forms, tables, cards, tabs, dialogs, and map states.
- Use accessible semantic controls, visible focus, keyboard navigation, and sufficient contrast.
- Keep information density appropriate for repeated operational work rather than a marketing landing page.
- Produce responsive wireframes for desktop, tablet, and mobile before implementation.

### 5. Technical contracts

Before implementing a module, define:

- Server action/API input and output types
- Validation schema and error shape
- Permission checks and ownership rules
- Database/storage operations
- Audit events
- Unit, integration, and E2E acceptance cases

## Accounts Required

### Required now

| Service           | Use                                        | Free-first decision                                                                                                                                       | Signup timing             |
| ----------------- | ------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------- |
| GitHub            | Source control and GitHub Actions          | Already configured. Public repository Actions are suitable for CI.                                                                                        | Complete                  |
| Supabase          | PostgreSQL, PostGIS, Auth, private Storage | Use the free project for development/demo. Keep service-role keys server-side.                                                                            | Phase 0                   |
| Map tile provider | Basemap/vector tiles for MapLibre          | Use a free developer tier such as MapTiler Cloud, or a compliant no-signup public provider for local development. Keep the provider behind a map adapter. | Before map implementation |

### Useful later, not required for the first design or database work

| Service                           | Use                                             | Free-first decision                                                                                 |
| --------------------------------- | ----------------------------------------------- | --------------------------------------------------------------------------------------------------- |
| Vercel                            | Next.js preview/production deployment           | Use the free tier when the app shell is ready. Local development does not require an account.       |
| Resend or Supabase email provider | Transactional email and password-reset delivery | Start with Supabase Auth email for development; add a provider only when real delivery is required. |
| Sentry                            | Error monitoring                                | Add the free tier after the first deployed prototype. Do not block local work on it.                |
| PostHog                           | Product analytics                               | Optional and deferred until privacy, consent, and event definitions are approved.                   |

### Do not sign up for yet

Do not add Stripe, Google Maps, Auth0, Cloudinary, OpenAI, paid GIS datasets, or a separate file-upload vendor for the prototype foundation. Supabase covers the initial database, authentication, and private document storage; MapLibre keeps the map rendering layer open.

### Payment decision

Payments are out of scope for the prototype. No payment provider account is required until APEXGROVE has a defined paid transaction, subscription, professional fee, or marketplace workflow. Keep a future `PaymentProvider` adapter in the architecture, but do not add payment credentials or checkout UI now.

When payments eventually arrive, preserve this boundary:

```text
user → APEXGROVE server → payment provider → verified webhook
→ subscription state → entitlement
```

The future commercial domain should include provider abstraction, verified webhook signatures, idempotency, transaction/invoice/payment-event records, refunds, disputes and fraud controls. Never store raw card data. Role, subscription and entitlement remain separate.

## Future adapter inventory

Keep these behind interfaces/adapters and out of core domain models:

- payment providers
- verification providers
- government/authority data
- GIS/tile/data providers
- AI providers
- notification/email providers
- professional registry sources
- external market and cost data

Provider outages, timeouts, retry/backoff rules and source/provenance metadata must remain visible at the boundary. Long-running provider work should use future background jobs rather than blocking ordinary request paths.

## Privacy, transfers and operations

Before adding third-party processors, review data minimization, access control, retention/deletion, international transfers, consent and applicable Nigerian privacy/regulatory obligations. Add monitoring and alerting without putting sensitive document contents or secrets into logs. This plan is architectural guidance, not legal advice.

## Development Extensions

These improve the workflow and do not require external service accounts:

- ESLint
- Tailwind CSS IntelliSense
- Playwright Test for VS Code
- GitHub Pull Requests and Issues (optional)

The extension list is convenience tooling, not part of the runtime architecture. A developer must still be able to run the project from the documented npm commands.

## Environment Boundary

Only provider configuration belongs in environment variables. Start from `.env.example` and never commit `.env.local` or provider secrets.

Expected future variables include:

```text
NEXT_PUBLIC_SUPABASE_URL
NEXT_PUBLIC_SUPABASE_ANON_KEY
SUPABASE_SERVICE_ROLE_KEY
NEXT_PUBLIC_MAP_STYLE_URL
NEXT_PUBLIC_MAPTILER_KEY
```

Public map keys still need domain restrictions and quota monitoring. Server-only credentials must never be exposed to browser code.

## Free-Tier Quality Rules

- Use adapters for maps, email, monitoring, and future AI providers.
- Cache or import stable demo GeoJSON instead of geocoding every page load.
- Add attribution and respect each provider's terms and rate limits.
- Do not use public services for private documents or sensitive user data.
- Track quota failures as explicit error states.
- Keep provider-specific types out of domain entities.
- Record the data source, jurisdiction, collection date, and verification state for spatial data.

## Recommended Order

1. Approve the requirements and flow/wireframe set.
2. Create the Supabase project and local environment variables.
3. Define migrations, RLS, storage buckets, and seed fixtures.
4. Implement the design tokens and application shell.
5. Implement auth and permissions with unit/integration tests.
6. Add land and GIS using the map adapter.
7. Add verification, documents, projects, professionals, and feasibility one module at a time.
8. Replace reserved test placeholders with requirement-specific tests.
9. Connect preview deployment and monitoring only after the local journey works.
