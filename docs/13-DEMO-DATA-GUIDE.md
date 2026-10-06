# APEXGROVE — Demo Data Guide

## Purpose
Provide enough realistic-looking but explicitly synthetic data for demonstrations without implying legal or governmental authenticity.

Demo data is for development, tests and demonstrations only. Never use real sensitive personal information, real identity documents, real payment details or unredacted third-party records.

## Seed entities
### Users
- Demo buyer
- Demo landowner
- Demo developer
- Demo architect
- Demo surveyor
- Demo administrator

Keep platform/user role, professional discipline, organization membership, project role and administrative permission distinct in fixtures. A demo administrator must not imply unrestricted production access.

### Land parcels
Create 8–15 sample parcels across selected Abuja areas. Every parcel must contain `is_demo_data = true`.

### Professionals
Create several professionals across architecture, surveying, planning and engineering.

### Projects
Create at least 2 projects:
- One planning-stage residential project
- One early-stage mixed-use project

### Documents
Use synthetic example PDFs/images/spreadsheets with clear DEMO/SAMPLE markings.

## GIS demo data
Use small GeoJSON files for:
- sample parcel polygons
- simple roads/context
- selected boundaries

Label every map layer and parcel **DEMO DATA / NOT OFFICIAL**. A synthetic polygon is a visual GIS example, not a cadastral or statutory boundary.

## Data provenance
Every demo dataset must identify its source as synthetic/demo in the UI or metadata and should include a stable seed/version, generation date and jurisdiction label. Do not invent an authority, survey confirmation or government source.

## Verification examples

Include examples at more than one trust level without collapsing them into one badge:

- user-submitted evidence awaiting review
- automated check with a clear method/result
- APEXGROVE internal review
- professional review example
- authoritative/official status only when a real permitted fixture explicitly represents that authority

Include approved, rejected, expired, conflicting-source and incomplete-evidence examples. Internal review must never be described as statutory confirmation.

## Reproducibility and safety

- Seed scripts should be repeatable and deterministic where practical; document reset/cleanup behavior.
- Use clearly fake credentials and email addresses that cannot be mistaken for real accounts.
- Keep synthetic files marked DEMO/SAMPLE and test private-storage access with non-sensitive content.
- Include edge cases: missing geometry, stale source date, duplicate upload, invalid file type/size, unauthorized owner/organization/project access and failed verification.
- Never commit `.env.local`, service-role keys, real credentials or private documents.
