# Atexgrove

Atexgrove is a Next.js prototype for a trusted digital ecosystem for land development in Africa.

## Current status (verified on main as of 2026-10-11)
| Area | Status |
|---|---|
| Registration, login, role selection, session-protected dashboard | Implemented |
| Database foundation: profiles, organizations, memberships, audit logs, RLS, 14 migrations applied | Implemented |
| Security hardening (migrations 015-017, auth additions) | Implemented on `fix/security-pass-2`; code checks pass, database execution and merge pending |
| Land, verification, documents, projects, professionals, feasibility | Placeholder only |
| Tailwind | Documented, not installed |
| Map / GIS UI, 3D, payments, AI | Not started |
| CI on main | Lint and typecheck (fix branch adds tests, build, guardrails, and Supabase pgTAP CI) |

## How this was built
Built with AI assistants (OpenCode, Codex, Claude) under my review. The original product specifications were AI-generated and are being revised.
Demo data is labelled "DEMO DATA / NOT OFFICIAL".

## Project layout

- `docs/` contains the product and implementation specifications.
- `src/` contains the Next.js application, features, shared components, libraries, and types.
- `supabase/` contains database migrations, functions, and seed configuration.
- `data/` contains clearly labelled synthetic demo data.
- `tests/` contains unit, integration, and end-to-end test areas.

## Development

```bash
npm install
npm run dev
```

Demo records must be labelled **DEMO DATA / NOT OFFICIAL**. Unimplemented roadmap features should be marked as planned rather than represented as working functionality.
