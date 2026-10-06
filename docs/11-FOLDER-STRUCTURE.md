# APEXGROVE — Repository Structure

This map reflects the current repository. Empty `.gitkeep` directories are extension points, not implemented modules.

```text
APEXGROVE/
├── src/
│   ├── app/                 # Next.js App Router pages, layouts and route boundaries
│   ├── components/          # Reusable UI components grouped by current domain
│   ├── features/            # Domain/service extension points; many are placeholders today
│   ├── config/              # Roles, permissions, navigation and environment configuration
│   ├── lib/                 # Shared infrastructure, including Supabase clients/middleware
│   ├── types/               # Domain and database TypeScript types
│   ├── middleware.ts        # Request/session middleware boundary
│   └── app/globals.css      # Global styling
├── supabase/
│   ├── migrations/          # Database migrations and RLS/storage contracts
│   ├── functions/           # Supabase Edge Functions
│   ├── seed.sql
│   └── config.toml
├── tests/
│   ├── unit/
│   ├── integration/
│   └── e2e/
├── data/
│   ├── geojson/             # Synthetic spatial fixtures/import guidance
│   └── seed/                # Seed-data guidance/fixtures
├── public/                  # Public, non-sensitive assets only
├── scripts/                 # Type generation, imports, validation and seed helpers
├── docs/                    # Product, architecture, security and delivery documents
├── .github/                 # Repository automation/workflows
├── package.json
├── package-lock.json
├── next.config.ts
├── tsconfig.json
├── tailwind.config.ts
├── playwright.config.ts
├── vitest.config.ts
└── .env.example
```

## Organization rules

- Keep routing and request composition in `src/app/`; keep business rules in feature/service modules rather than presentation components.
- Reusable visual primitives belong in `src/components/`; trust labels, permission-denied states and private-data controls should remain reusable.
- Place domain behavior and future bounded capabilities in `src/features/` (identity/access, land, GIS, verification, documents, projects, professionals, feasibility, administration and notifications). A directory is not evidence that the capability is implemented.
- Keep shared Supabase/storage/auth infrastructure in `src/lib/` and cross-cutting configuration/types in `src/config/` and `src/types/`.
- Keep migrations, RLS and storage contracts in `supabase/`; application code must not silently replace database authorization.
- Tests should follow the current unit/integration/E2E boundaries and use synthetic fixtures.
- Public assets must never contain private documents, secrets or user exports.

## Future extension points

Provider adapters, background jobs and mobile-facing API contracts should be added within the existing modular-monolith boundaries when needed, without creating speculative folders for every future domain. If scale or ownership later requires extraction, bounded service boundaries can be moved behind stable interfaces; do not prematurely turn the prototype into microservices.
