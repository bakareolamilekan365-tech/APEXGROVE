# The Atexgrove project story

## Why the project started

Atexgrove began as a broad idea for bringing land, construction, professionals, documents, projects, and development information into one trusted digital environment. The vision is large, but the first repository needed to prove one useful journey instead of showing many disconnected screens.

## The first foundation

The project was organized as a web application with a managed online database. The team created the repository, documented the product vision, prepared the first database structure, and added the basic account journey.

The first working user journey became:

1. Register an account.
2. Sign in.
3. Choose a basic account type.
4. Save profile information.
5. Reach a protected dashboard.

The hosted Supabase project first received fourteen database changes. On 2026-10-14, changes `015`-`017` were also recorded remotely, adding stronger organization/member protections and the private-document storage foundation.

## Why the audit became necessary

The early documentation described a much larger product than the code actually delivered. Some screens and database files were placeholders. The audit was introduced to separate:

- what genuinely works;
- what exists in code but still needs proof;
- what is only planned;
- what belongs to the long-term vision.

This was important because a professional-looking screen is not proof that permissions, private documents, database rules, and failure handling work correctly.

## The security work

The security branch strengthened the existing foundation. It added or improved:

- protection against users promoting themselves to administrator;
- restrictions on creating fake verified organizations;
- protection for organization owners and membership records;
- private document-storage rules;
- safer password-recovery redirects;
- tests for allowed and forbidden database actions;
- GitHub automation for testing database changes before they are merged.

Two database changes initially failed because they attempted to change tables owned by Supabase itself. Those statements were removed. Audit triggers were also removed from Supabase's managed Storage table; document audit events will instead be added in Atexgrove's application workflow when document uploading is built.

## Current repository and database state

PR #9 has been merged into `main`. The hosted Supabase project records migrations `001`-`017`. A read-only check confirms that the document bucket is private, user-path storage policies exist, and the main foundation tables use row-level security.

This does not mean all security work has passed. The database behavior tests still need a recorded green run, the real email-confirmation/password-recovery journey still needs testing, and Supabase continues to report security and performance findings. GitHub Actions is configured to create the temporary Docker-based database environment needed for the database tests.

## Product direction changed

The original plan leaned toward land discovery and maps as the next major feature. The roadmap was later reorganized around a more controlled first commercial service:

> A customer requests land verification and development-feasibility work for an Abuja site, submits private evidence, staff review the case, and Atexgrove delivers a reviewed Land & Development Report.

Public land discovery and mapping now come after this controlled case workflow has been proven.

## Brand preparation

The project name is Atexgrove. Supplied logo images have been preserved and converted into practical web formats for later use. The current logo source is photographic/raster artwork; a true editable vector should still be requested from the original designer before large-format printing.

## Where the project stands

The groundwork is stronger, but foundation verification is not completely closed. The immediate milestone is to record the database-test and Auth-flow evidence, address or accept the remaining advisor findings, and then begin a working verification case with private evidence and a staff work queue. It is not another collection of placeholder screens.

