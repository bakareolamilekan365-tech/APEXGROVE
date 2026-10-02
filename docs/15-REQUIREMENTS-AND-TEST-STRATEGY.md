# APEXGROVE - Requirements and Test Strategy

## Purpose

This document translates the prototype requirements into testable slices. Work should move from isolated business rules, to module integration, to separately tested user flows, and finally to the complete journey.

## Requirement Areas

| ID | Requirement area | Acceptance signal | Primary test level |
| --- | --- | --- | --- |
| REQ-01 | Authentication and onboarding | A user can register, select a role, sign in, persist a session, and recover a password through the planned flow. | Unit, integration, e2e |
| REQ-02 | Authorization | Server-side permission checks prevent users from reading or mutating data outside their role and organization. | Unit, integration |
| REQ-03 | Land discovery and GIS | A user can search demo parcels, filter results, switch list/map views, select a parcel, and view its detail. | Unit, integration, e2e |
| REQ-04 | Verification | A parcel has a verification lifecycle, checklist, reviewer notes, documents, and audit history without fake official status. | Unit, integration, e2e |
| REQ-05 | Documents | Private documents support metadata, controlled access, upload, and versioning. | Unit, integration, e2e |
| REQ-06 | Projects and professionals | A parcel can become a project and professionals can be added to its workspace. | Unit, integration, e2e |
| REQ-07 | Feasibility | Inputs produce deterministic cost, revenue, margin, and break-even outputs, with scenario comparison. | Unit, integration |
| REQ-08 | Administration | Authorized administrators can manage core demo records and review audit events. | Integration, e2e |
| REQ-09 | Quality and safety | The application handles loading, error, empty, responsive, accessible, and secret-management cases. | Integration, e2e, manual |

All demo records must display **DEMO DATA / NOT OFFICIAL**. Planned features must not expose controls that imply they are implemented.

## Test Layers

### 1. Unit tests: isolated business rules

Location: `tests/unit/`

Test pure logic without Next.js, Supabase, the network, or a browser. Cover feasibility calculations, verification transitions, permission decisions, validation, and GIS helpers.

### 2. Integration tests: module boundaries

Location: `tests/integration/`

Test one module across its service, database, storage, or API boundary using isolated fixtures. Cover auth/profile creation, land search, verification and audit persistence, private document access, project creation, and professional membership.

Integration tests must clean up fixtures and must not depend on execution order.

### 3. E2E tests: separately tested user flows

Location: `tests/e2e/`

Use Playwright for critical browser flows: registration/onboarding, land discovery, verification/document upload, and project creation/workspace navigation. Keep this layer focused rather than duplicating every unit case.

### 4. Journey integration gate

The final release gate combines the modules in this order:

1. Register and select a role.
2. Sign in and load the role-aware dashboard.
3. Discover and open a demo parcel.
4. Start verification and attach a document.
5. Create a project from the parcel.
6. Add a professional and upload a project document.
7. Enter feasibility assumptions and compare scenarios.
8. Navigate the workspace without dead ends.

This gate uses real application boundaries and seeded demo data. It fails on fake success states, unauthorized access, missing persistence, broken navigation, or unlabeled synthetic data.

## Commands

```bash
npm run test:unit
npm run test:integration
npm run test:e2e
npm test
```

`npm test` runs unit, integration, and E2E tests in that order. A failing earlier layer blocks the later layer.

## Definition of Ready

- The requirement has an acceptance signal.
- The owning module and data boundary are identified.
- Fixtures and test data are explicitly synthetic.
- Authorization and error cases are named.

## Definition of Done

- Unit tests cover business rules and edge cases.
- Integration tests cover persistence and authorization boundaries.
- Critical user flows have Playwright coverage.
- The journey integration gate passes against the real prototype services.
- Typecheck, lint, and tests pass in CI.
- No secrets or private documents are committed.