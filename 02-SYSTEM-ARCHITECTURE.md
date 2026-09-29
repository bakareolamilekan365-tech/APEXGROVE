# APEXGROVE — System Architecture

## Architecture style
Use a modular monolith for the prototype. Keep domain boundaries clean so modules can later become independently deployable services if scale requires it.

## Recommended stack
### Frontend / application
- Next.js
- React
- TypeScript
- Tailwind CSS
- shadcn/ui or equivalent accessible component primitives

### Backend
- Next.js server actions/API routes where appropriate
- Supabase for PostgreSQL, authentication and storage
- PostGIS for geospatial data

### Maps
- MapLibre GL JS
- GeoJSON for initial demo layers
- External vector-tile/style provider for the prototype

### Validation
- Zod or equivalent schema validation

### Testing
- Vitest for unit tests
- Playwright for key end-to-end flows

## High-level flow
Browser
→ Next.js application
→ server-side application logic
→ Supabase Auth / PostgreSQL / PostGIS / Storage

External integrations should be isolated behind adapters/interfaces.

## Domain boundaries
- Identity & access
- Profiles & organizations
- Land
- Verification
- GIS
- Projects
- Professionals
- Documents
- Feasibility
- Notifications
- Administration

## Future boundaries
Planning, approvals, construction, procurement, finance, property management, education, analytics and urban intelligence should have reserved domain boundaries but should not be implemented as fake modules in the prototype.

## Core design principle
Business rules should live in domain/service layers, not inside large UI components.
