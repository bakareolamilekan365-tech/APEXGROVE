# Atexgrove — Database Schema

## Database

PostgreSQL with PostGIS.

## Schema status and implementation boundary

This document describes the current prototype's domain contract and the reserved shape of the future architecture; it is not a claim that every table listed below exists in the live database. Migrations `001`-`014` create and harden the foundation around `profiles`, `organizations`, `organization_members` and `audit_logs`; migrations `004`-`011` remain domain placeholders rather than proof that their named modules exist. Migrations `015`-`017` add foundation security, private document storage, membership-owner protection and advisor-oriented permission fixes. As of 2026-10-16, all seventeen migrations are recorded on hosted Supabase. Read-only inspection confirms RLS on the four application foundation tables and a private `documents` bucket with per-operation policies. pgTAP ALLOW/DENY tests have passed in a temporary Supabase environment through GitHub Actions; hosted cross-user authorization and remaining live advisor findings are still open.

## Conventions

- UUID primary keys
- `created_at`, `updated_at` on mutable entities
- `created_by` / `updated_by` where appropriate
- Foreign keys with explicit delete behavior
- Check constraints for controlled statuses
- Timestamps stored consistently in UTC
- Geometry columns use an explicitly documented spatial reference system

## Current live application tables

The current live application tables are `profiles`, `organizations`, `organization_members` and `audit_logs`. The hosted private `documents` bucket and Storage policies are configuration, not a completed document metadata schema.

### profiles

- id
- user_id
- full_name
- phone
- avatar_url
- account_type
- location_text
- bio
- created_at
- updated_at

### organizations

- id
- name
- organization_type
- registration_number
- description
- location_text
- verification_status
- created_at
- updated_at

### organization_members

- organization_id
- user_id
- role
- created_at

`organization_members.role` is an organization-scoped relationship, not a platform role or a profession. Future permissions should be evaluated from the user’s ownership, organization membership, project membership, administrative permissions and scope, with least privilege and RLS rather than one global role check.

### audit_logs

- id
- actor_user_id
- action
- entity_type
- entity_id
- metadata jsonb
- created_at

Audit records are required for important mutations, verification decisions, document access/review, administrative actions and permission-sensitive changes. They should preserve actor, action, target, scope, time and relevant metadata without turning the audit log into an unbounded dump of sensitive document contents.

## Target Phase 2/3 case-first schema (Planned)

The first commercial workflow starts with a verification case, not a marketplace listing. A case may be created from site/request details before any `land_parcels` record exists. Any later parcel/listing link must be optional and follow-on.

The names below are conceptual table boundaries for design and migration planning. They are **TARGET SCHEMA / NOT IMPLEMENTED** and may be refined before forward migrations are written.

### verification_cases

- id
- customer_user_id
- created_by_user_id
- creation_channel (`customer` or authorized staff-assisted channel)
- assisted_by_user_id nullable
- consent record/reference nullable
- jurisdiction
- site description and structured location fields
- site_geometry nullable, contextual only
- current_stage (Request received, Documents in, Document checks, Site and map, Development options, Report)
- workflow_status
- assigned_lead_user_id nullable
- created_at
- updated_at

The customer, staff actor, channel and consent/audit context must be retained for assisted creation. `current_stage` is journey progress; it must not be overloaded as verification authority or legal status.

### case_assignments

- id
- verification_case_id
- assignee_user_id
- assigned_by_user_id
- assignment role/scope
- status
- accepted_at nullable
- declined_at nullable
- decline_reason nullable
- handover/predecessor reference nullable
- created_at / updated_at

A human lead confirms assignment or handover. Automated recommendations may be retained separately but must not silently assign or approve work. Capacity decline and handover history must remain auditable.

### case_evidence

- id
- verification_case_id
- document/evidence reference
- evidence_type
- source
- source_type
- supplied_by_user_id nullable
- version / version-lineage reference
- jurisdiction
- received_at
- current_review_state
- created_at / updated_at

Evidence storage remains private. A case-evidence record refers to the exact document/evidence version considered; it does not turn receipt into authentication or official confirmation.

### case_evidence_reviews or case_findings

- id
- verification_case_id
- case_evidence_id nullable
- reviewer_user_id
- review_state
- authority_level
- result
- notes
- limitations
- reviewed_at

Source, review state and authority level are separate. Authority levels must preserve user-submitted, automated check, Atexgrove review, professional review, authoritative-third-party confirmation and official/statutory confirmation.

### case_status_events / case_history

- id
- verification_case_id
- actor_user_id
- from_stage/status nullable
- to_stage/status
- reason
- created_at

Status history is append-oriented and auditable. It should not silently erase an earlier assignment, decision or unresolved state.

### feasibility_scenarios (Phase 3 target)

- id
- verification_case_id
- project_id nullable for later follow-on use
- name
- deterministic inputs and outputs
- assumptions
- calculation_version
- currency
- created_at / updated_at

The Phase 3 relationship is case-first. A later project link may be supported, but a project must not be required to calculate or explain the controlled pilot scenario.

### reports

- id
- verification_case_id
- status
- version
- prepared_by_user_id
- delivered_at nullable
- limitations
- unresolved_matters
- exact evidence/version lineage used
- created_at / updated_at

### report_reviews

- id
- report_id
- reviewer_user_id
- discipline
- decision
- comments
- reviewed_at

Consequential conclusions require a genuinely separate discipline-appropriate review. A review row must not imply official/statutory confirmation unless that distinct authority and source evidence actually exist.

## Later-phase domain tables (Planned/Reserved)

The remaining table concepts support Phase 4 GIS and Phase 5 projects/professionals or the longer-term ecosystem. They are not prerequisites for creating a Phase 2 verification case and are not implemented merely because placeholder migrations exist.

### professionals

- id
- profile_id
- discipline
- experience_years
- company_id nullable
- services
- areas_served
- verification_status
- portfolio_summary
- created_at
- updated_at

### land_parcels

- id
- reference_code
- title
- jurisdiction_id
- area_sqm
- land_use
- zoning
- price
- currency
- location_text
- latitude/longitude only when useful for display; geometry remains authoritative for GIS
- geometry
- access_description
- infrastructure_summary
- development_notes
- data_source
- data_as_of
- verification_status
- is_demo_data
- created_at
- updated_at

### land_listings

- id
- parcel_id
- owner_profile_id nullable
- listing_status
- asking_price
- currency
- description
- created_at
- updated_at

### land_documents

- id
- parcel_id
- document_type
- storage_path
- file_name
- version
- uploaded_by
- verification_status
- uploaded_at

The future document model must also account for validation/security-check results, private storage, controlled access, retention/deletion, audit history and version lineage. Storage paths must not become public URLs for sensitive documents.

### land_verifications

- id
- parcel_id
- status
- submitted_by
- assigned_reviewer nullable
- notes
- submitted_at
- reviewed_at nullable
- expires_at nullable

Verification is a structured trust record. Future representations should distinguish verification type (identity, organization, professional, land/document, survey-related, title/ownership or planning-related), status, evidence, reviewer, source, submitted/reviewed dates, expiry and confidence. The authority of a record must be explicit: user-submitted, automated, Atexgrove internal, professional, authoritative third-party or official/statutory.

### land_verification_items

- id
- verification_id
- category
- result
- notes
- evidence_document_id nullable

Evidence items should be traceable to their source and review event. A spatial polygon remains a visual/spatial representation unless backed by survey, authoritative cadastral or official/legal records.

### properties

- id
- parcel_id nullable
- property_type
- title
- description
- geometry nullable
- address_text
- price nullable
- currency nullable
- verification_status
- is_demo_data
- created_at
- updated_at

### projects

- id
- name
- project_type
- status
- parcel_id nullable
- location_text
- site_geometry nullable
- land_area_sqm nullable
- description
- owner_id
- organization_id nullable
- created_at
- updated_at

### project_members

- project_id
- user_id
- role
- invited_by
- created_at

### project_documents

- id
- project_id
- document_type
- storage_path
- file_name
- version
- status
- uploaded_by
- created_at

### professional_services

- id
- professional_id
- service_name
- description
- active

### project_professionals

- project_id
- professional_id
- role_on_project
- status
- added_by
- created_at

### notifications

- id
- user_id
- type
- title
- body
- read_at nullable
- created_at

## Jurisdiction model

Reserve these tables from the start:

- countries
- regions
- local_authorities
- planning_jurisdictions
- planning_schemes

The prototype can seed Abuja/FCT data without encoding Abuja-specific rules into application-wide business logic.

## Security

Use row-level security policies on every protected application table. Phase 2 policies must treat the verification case as the primary resource scope and combine authenticated identity, customer relationship, assigned responsibility and explicit administrative permission. Private evidence metadata and storage paths must respect the related case authorization. Later land/project policies extend this model rather than becoming prerequisites for it.

## Future authorization concepts (reserved, not new tables in this task)

The long-term schema may need separate representations for:

- platform/user roles
- professional disciplines
- organization types and organization-scoped roles
- project roles and project membership
- permission grants and administrative scopes
- jurisdictional scope

These concepts must remain distinct. A professional discipline must not become a technical permission role, and a future subscription or entitlement must not grant authorization by itself. Multiple administrative responsibilities (for example operations, verification, compliance, finance/billing and support) should be modelled as scoped permissions with auditable actions rather than one unrestricted administrator flag.

## Provenance and source authority (reserved)

Important land, GIS, document and verification records should eventually be able to retain source, source type, supplied by, collection/import date, verification date, reviewer, last updated time, jurisdiction, confidence and verification state. Source/authority records should preserve the distinction between user-submitted data, automated checks, internal review, professional review, authoritative third-party confirmation and official/statutory confirmation. Atexgrove internal review must never be stored or presented as government certification.

## Future document controls (reserved)

Document metadata should support a lifecycle of upload → validation/security checks → private storage → metadata → versioning → controlled access → review → audit → retention/deletion. Exact retention and deletion rules remain jurisdiction- and policy-dependent. Public buckets and unscoped download URLs are not acceptable for sensitive documents.

## Future billing and background-job boundaries (reserved)

Payments and subscriptions are outside the current prototype. If added later, keep plans, subscriptions, entitlements, transactions, invoices, payment events, refunds, disputes, webhook verification and idempotency in a separate commercial domain. Role ≠ subscription ≠ entitlement.

Long-running work may eventually need durable job state for AI document analysis, large GIS processing, report generation, bulk imports, notifications and analytics. The job model should support queued/running/succeeded/failed/cancelled states, retries and idempotency without coupling the current prototype to a background-processing platform.

## Scalability and jurisdiction notes

Future schema work should plan for indexes, pagination-friendly queries, query optimization, connection management, caching, spatial indexes and viewport-based GIS loading while avoiding N+1 access patterns. Horizontal scaling is a later operational decision. Jurisdiction identifiers should remain explicit so Nigerian and future African markets do not inherit Abuja-specific rules accidentally. Privacy, retention, third-party processors and international transfers must be handled with appropriate domain and legal review; this documentation is not legal advice.
