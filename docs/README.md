# Atexgrove

Atexgrove is a prototype specification for a trusted digital ecosystem for land development in Africa. The initial demonstration geography is Abuja, Nigeria.

This folder contains the focused markdown specifications required to build the first end-to-end prototype.

For founder, partner, and non-engineering explanations, start with [`non-technical/README.md`](non-technical/README.md). The plain-language library summarizes the project story, product, security approach, roadmap, current progress, decisions, and working method without replacing these detailed specifications.

## Current delivery journey

The current proposed delivery order puts the verification service before a land-discovery marketplace. It remains subject to the founder decisions recorded in `OPEN-QUESTIONS-FOUNDER.md` and `DECISIONS.md`.

1. Register, choose a role, and sign in.
2. Start a land-verification and development-feasibility case.
3. Identify the Abuja site and submit private supporting documents.
4. Route the case through assignment, evidence review, notes, status changes, and audit events.
5. Produce a reviewed Land & Development Report with explicit source and authority labels.
6. Add land discovery, mapping, projects, professionals, and wider development workflows only after the case workflow is proven.

All synthetic records must be clearly labelled **DEMO DATA / NOT OFFICIAL**.

## Reading order

1. `00-PROJECT-CONTEXT.md`
2. `01-PRD.md`
3. `02-SYSTEM-ARCHITECTURE.md`
4. `03-DATABASE-SCHEMA.md`
5. `04-API-SPEC.md`
6. `05-UI-UX-DESIGN.md`
7. `06-GIS-SPEC.md`
8. `07-AUTH-SECURITY.md`
9. `08-DOCUMENTS-SPEC.md`
10. `09-FEASIBILITY-SPEC.md`
11. `10-ROADMAP.md`
12. `11-FOLDER-STRUCTURE.md`
13. `12-IMPLEMENTATION-CHECKLIST.md`
14. `13-DEMO-DATA-GUIDE.md`
15. `14-BUILD-AGENT-INSTRUCTIONS.md`
16. `15-REQUIREMENTS-AND-TEST-STRATEGY.md`
17. `16-DESIGN-AND-INTEGRATION-PLAN.md`
18. `17-PROJECT-AUDIT.md`
19. `18-PROTOTYPE-FLOW-AND-DELIVERY-MAP.md`

## Important

These documents intentionally separate the huge long-term Atexgrove vision from the smaller prototype implementation.

The original master prompt can remain as a product-vision document. These files are the operational build specification.

## Status

As of 2026-10-14, PR #9 is merged into `main` and the hosted Supabase migration history contains `001` through `017`. Read-only verification confirms the private `documents` bucket, its SELECT/INSERT/UPDATE/DELETE policies, and RLS on `profiles`, `organizations`, `organization_members`, and `audit_logs`. The pgTAP suites, hosted Auth confirmation/recovery flow, and complete user journeys still need recorded execution evidence. The live security advisor also retains unresolved findings documented in the latest audit addendum. Land verification, reports, GIS, projects, professionals, and feasibility remain planned rather than implemented.

Historical sections in `17-PROJECT-AUDIT.md` retain the status that was true on their stated dates. Use the latest dated audit addendum and the implementation itself for current status.
