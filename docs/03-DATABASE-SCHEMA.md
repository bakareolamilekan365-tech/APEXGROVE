# APEXGROVE — Database Schema

## Database
PostgreSQL with PostGIS.

## Conventions
- UUID primary keys
- `created_at`, `updated_at` on mutable entities
- `created_by` / `updated_by` where appropriate
- Foreign keys with explicit delete behavior
- Check constraints for controlled statuses
- Timestamps stored consistently in UTC
- Geometry columns use an explicitly documented spatial reference system

## Core tables
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

### land_verification_items
- id
- verification_id
- category
- result
- notes
- evidence_document_id nullable

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
