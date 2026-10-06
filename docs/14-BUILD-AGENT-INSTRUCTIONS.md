# APEXGROVE — Build Agent Instructions

## Mission
Build the APEXGROVE prototype defined by the project markdown files in this directory.

## Priority order
1. Read the relevant markdown specifications before coding, including `00-03` and `07-08` as the current architecture authority.
2. Resolve contradictions in favor of the current foundation documents and the actual repository implementation.
3. Mark current prototype versus future/planned behavior explicitly before changing scope.
4. Implement the database and permission model before building dependent UI.
5. Connect UI actions to real server/database operations.
6. Implement the prototype journey end to end.
7. Add reproducible synthetic seed data.
8. Test the journey and its failure/security paths.

## Non-negotiable rules
- Do not turn APEXGROVE into a generic real-estate listing site.
- Do not implement the long-term roadmap as fake UI.
- Do not create fake verification.
- Do not expose private documents publicly.
- Enforce authorization server-side and with RLS; never rely on frontend visibility.
- Keep platform role, discipline, organization/project role, permission, subscription and entitlement separate.
- Preserve separated administrative responsibilities and audit sensitive actions.
- Preserve provenance and the distinction between user, automated, internal, professional, authoritative-third-party and official/statutory information.
- Treat GIS geometry as visual/spatial unless authoritative survey/cadastral/legal evidence says otherwise.
- Treat uploaded files, extracted text and prompts as untrusted input.
- Never present AI as official, legal or professional authority, and never invent missing facts.
- Do not hard-code secrets.
- Do not put core business logic in UI components.
- Do not create one giant component or one giant database table.
- Do not add payment implementation; future payment providers must use adapters, verified webhooks and idempotency.
- Do not add speculative microservices, dependencies or folders when a modular-monolith boundary is sufficient.
- Do not silently change major product decisions.
- If a requested feature is outside prototype scope, create a clean extension point or mark it as planned rather than faking it.

Generated code must not silently expand scope. If generated output introduces a new domain, provider, dependency, migration or user-facing capability, stop and document the assumption or obtain explicit direction before including it.

## Working style
After each milestone:
- run type checks
- run tests
- inspect the main user journey
- fix broken navigation/data flow before starting the next milestone
- review authorization, persistence, error states and auditability for the changed path

## First implementation milestone
Deliver:
- Next.js app shell
- Supabase connection
- migrations
- auth
- profiles/roles
- base dashboard

Only then proceed to land/GIS.

## Decision and cost discipline

Use free/low-cost services and local/synthetic data first. Keep external integrations behind replaceable adapters. Ask for clarification only when existing documentation and repository evidence cannot reasonably determine a safe decision; otherwise record assumptions and keep the change reversible.
