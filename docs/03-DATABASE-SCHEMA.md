# APEXGROVE — Database Schema

## Database

PostgreSQL with PostGIS.

## Schema status and implementation boundary

This document describes the current prototype’s domain contract and the reserved shape of the future architecture; it is not a claim that every table listed below exists in the live database. In the repository, the foundational migrations currently create `profiles`, `organizations`, `organization_members` and `audit_logs`; several later domain migrations are explicit placeholders. Do not infer production behavior from this documentation alone, and do not add migrations as part of this documentation update.

## Conventions

- UUID primary keys
- `created_at`, `updated_at` on mutable entities
- `created_by` / `updated_by` where appropriate
- Foreign keys with explicit delete behavior
- Check constraints for controlled statuses
- Timestamps stored consistently in UTC
- Geometry columns use an explicitly documented spatial reference system

## Core tables

The core table list preserves the prototype concepts while leaving room for more granular future authorization, verification and provenance. Where a future concept is not mature enough to have a confirmed table design, it is described as a reserved concept rather than an invented production schema.

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

Verification is a structured trust record. Future representations should distinguish verification type (identity, organization, professional, land/document, survey-related, title/ownership or planning-related), status, evidence, reviewer, source, submitted/reviewed dates, expiry and confidence. The authority of a record must be explicit: user-submitted, automated, APEXGROVE internal, professional, authoritative third-party or official/statutory.

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

### feasibility_scenarios

- id
- project_id
- name
- development_type
- land_area_sqm
- land_cost
- construction_cost
- professional_fees
- infrastructure_cost
- finance_cost
- taxes_charges
- marketing_cost
- contingency
- expected_revenue
- currency
- created_at
- updated_at

### notifications

- id
- user_id
- type
- title
- body
- read_at nullable
- created_at

### audit_logs

- id
- actor_user_id
- action
- entity_type
- entity_id
- metadata jsonb
- created_at

Audit records are required for important mutations, verification decisions, document access/review, administrative actions and permission-sensitive changes. They should preserve actor, action, target, scope, time and relevant metadata without turning the audit log into an unbounded dump of sensitive document contents.

## Jurisdiction model

Reserve these tables from the start:

- countries
- regions
- local_authorities
- planning_jurisdictions
- planning_schemes

The prototype can seed Abuja/FCT data without encoding Abuja-specific rules into application-wide business logic.

## Security

Use row-level security policies where appropriate. Private document metadata and storage paths must respect the permissions of the related land/project/entity.

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

Important land, GIS, document and verification records should eventually be able to retain source, source type, supplied by, collection/import date, verification date, reviewer, last updated time, jurisdiction, confidence and verification state. Source/authority records should preserve the distinction between user-submitted data, automated checks, internal review, professional review, authoritative third-party confirmation and official/statutory confirmation. APEXGROVE internal review must never be stored or presented as government certification.

## Future document controls (reserved)

Document metadata should support a lifecycle of upload → validation/security checks → private storage → metadata → versioning → controlled access → review → audit → retention/deletion. Exact retention and deletion rules remain jurisdiction- and policy-dependent. Public buckets and unscoped download URLs are not acceptable for sensitive documents.

## Future billing and background-job boundaries (reserved)

Payments and subscriptions are outside the current prototype. If added later, keep plans, subscriptions, entitlements, transactions, invoices, payment events, refunds, disputes, webhook verification and idempotency in a separate commercial domain. Role ≠ subscription ≠ entitlement.

Long-running work may eventually need durable job state for AI document analysis, large GIS processing, report generation, bulk imports, notifications and analytics. The job model should support queued/running/succeeded/failed/cancelled states, retries and idempotency without coupling the current prototype to a background-processing platform.

## Scalability and jurisdiction notes

Future schema work should plan for indexes, pagination-friendly queries, query optimization, connection management, caching, spatial indexes and viewport-based GIS loading while avoiding N+1 access patterns. Horizontal scaling is a later operational decision. Jurisdiction identifiers should remain explicit so Nigerian and future African markets do not inherit Abuja-specific rules accidentally. Privacy, retention, third-party processors and international transfers must be handled with appropriate domain and legal review; this documentation is not legal advice.
