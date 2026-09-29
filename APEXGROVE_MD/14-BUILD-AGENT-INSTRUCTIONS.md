# APEXGROVE — Build Agent Instructions

## Mission
Build the APEXGROVE prototype defined by the project markdown files in this directory.

## Priority order
1. Read all markdown specifications.
2. Resolve contradictions in favor of `00-PROJECT-CONTEXT.md` and `01-PRD.md`.
3. Implement the database and permission model before building large screens.
4. Connect UI actions to real server/database operations.
5. Implement the prototype journey end to end.
6. Add seed data.
7. Test the journey.

## Non-negotiable rules
- Do not turn APEXGROVE into a generic real-estate listing site.
- Do not implement the long-term roadmap as fake UI.
- Do not create fake verification.
- Do not expose private documents publicly.
- Do not hard-code secrets.
- Do not put core business logic in UI components.
- Do not create one giant component or one giant database table.
- Do not silently change major product decisions.
- If a requested feature is outside prototype scope, create a clean extension point or mark it as planned rather than faking it.

## Working style
After each milestone:
- run type checks
- run tests
- inspect the main user journey
- fix broken navigation/data flow before starting the next milestone

## First implementation milestone
Deliver:
- Next.js app shell
- Supabase connection
- migrations
- auth
- profiles/roles
- base dashboard

Only then proceed to land/GIS.
