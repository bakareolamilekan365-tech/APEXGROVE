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

The hosted Supabase project received the first fourteen database changes. Those changes created the early profile, organization, membership, and audit foundations.

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

## Current branch and PR

PR #9 contains the security foundation work. It is intentionally not being squash-merged until the audit and checks are complete. The hosted Supabase project still has migrations `001`–`014`; migrations `015`–`017` have not been deployed there.

The project now uses GitHub Actions as the database-test environment because the current development computer cannot run Docker comfortably. This avoids making the local machine a blocker.

## Product direction changed

The original plan leaned toward land discovery and maps as the next major feature. The roadmap was later reorganized around a more controlled first commercial service:

> A customer requests land verification and development-feasibility work for an Abuja site, submits private evidence, staff review the case, and Atexgrove delivers a reviewed Land & Development Report.

Public land discovery and mapping now come after this controlled case workflow has been proven.

## Brand preparation

The project name is Atexgrove. Supplied logo images have been preserved and converted into practical web formats for later use. The current logo source is photographic/raster artwork; a true editable vector should still be requested from the original designer before large-format printing.

## Where the project stands

The groundwork is now sufficient to begin the first real product feature after PR #9 passes its final checks. The next milestone is not another general audit or another collection of placeholder screens. It is a working verification case with private evidence and a staff work queue.

