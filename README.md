# Atexgrove

Atexgrove is a Next.js prototype for a trusted digital ecosystem for land development in Africa.

## Current status (verified on main and hosted Supabase as of 2026-10-14)
| Area | Status |
|---|---|
| Registration, login, role selection, session-protected dashboard | Implemented |
| Database foundation: profiles, organizations, memberships, audit logs, RLS | Implemented; migrations `001`-`017` are recorded on hosted Supabase |
| Security hardening (migrations `015`-`017`, Auth additions) | Merged through PR #9 and deployed; private bucket/policies verified, database behavior tests and hosted Auth email flows still require evidence |
| Land, verification, documents, projects, professionals, feasibility | Placeholder only |
| Tailwind | Documented, not installed |
| Map / GIS UI, 3D, payments, AI | Not started |
| CI on main | Application validation and a Docker-backed Supabase database-test workflow are configured; latest database-test run must still be recorded |

The live Supabase security advisor still reports unresolved findings. Deployment of a migration is not the same as proof that every policy and workflow behaves correctly; see the latest addendum in `docs/17-PROJECT-AUDIT.md`.

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
