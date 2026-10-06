# APEXGROVE — Prototype PRD

## 1. Objective
Build a credible, usable first version that demonstrates how land discovery can flow into verification and then into a structured development project.

## 2. Target users for prototype
- Land buyers/investors
- Landowners
- Developers
- Professionals
- Administrators

Other future roles may exist in the schema but do not need full workflows yet.

## Product model and access principles

The PRD keeps these concepts separate:

- platform/user role: a broad relationship to APEXGROVE
- professional discipline: for example surveying, architecture, planning or construction
- organization type: the kind of company, institution or practice
- project role: a person’s responsibility on one project
- permissions: actions a user is allowed to perform, within a scope
- subscription/entitlement: future commercial access, not an authorization role

The prototype can expose a small role-aware experience, but it must not create one technical role for every profession or reduce every authorization decision to a single role check. Long-term authorization must consider ownership, organization membership, project membership, administrative permissions, scope, least privilege, server-side checks and database Row Level Security (RLS).

## Administrative responsibilities

APEXGROVE must not depend on one unrestricted “God Admin”. The future administration model should support separated responsibilities and scopes, such as Super Admin, Operations Admin, Verification Admin, Compliance Admin, Finance/Billing Admin and Support Admin. These are conceptual examples rather than a final role catalogue. Administrative actions require auditable actor, action, target, scope and time information.

## 3. Core modules
### Authentication
- Sign up
- Sign in
- Sign out
- Session persistence
- Password reset architecture

### Onboarding
- Role selection
- Basic profile data
- Progressive role-specific fields

### Dashboard
Show role-specific summary cards, recent activity, active projects and useful actions.

### Land discovery
- Search
- Basic filters
- List/map toggle
- Parcel cards
- Parcel detail page

### Maps
- Interactive map
- Demo parcels
- Selectable parcel geometry
- Basic contextual layers
- Fit map to selected parcel

### Verification
- Verification record per parcel
- Status lifecycle
- Checklist items
- Supporting documents
- Reviewer notes
- Audit trail

Verification is a structured trust system, not one generic badge. Future verification types may include identity, organization, professional, land/document, survey-related, title/ownership and planning-related verification. A verification record should be able to capture status, evidence, reviewer, source, date, expiry and confidence.

The product must distinguish the authority of information: user-submitted information, automated checks, APEXGROVE internal review, professional review, authoritative third-party confirmation and official/statutory confirmation. APEXGROVE’s internal review must never be presented as equivalent to government certification.

Statuses:
- Unverified
- Submitted
- Under Review
- Partially Verified
- Verified
- Professional Review Required
- Rejected
- Expired

### Projects
A land parcel can be converted into a development project.

Project sections:
- Overview
- Land
- Planning (planned placeholder only)
- Documents
- Professionals
- Feasibility

### Professionals
- Professional directory
- Discipline
- Location
- Services
- Experience
- Verification state
- Portfolio summary
- Add professional to project

### Documents
- Upload
- Metadata
- Version number
- Access control
- Project/land association
- Download through controlled access

Documents are sensitive assets. The intended lifecycle is upload → validation/security checks → private storage → metadata → versioning → controlled access → review → audit → retention/deletion. Sensitive documents must not be exposed through public URLs. The prototype may demonstrate only a subset of this lifecycle, and any missing controls must be labelled as planned.

### Feasibility
Inputs:
- Land area
- Land cost
- Development type
- Estimated construction cost
- Professional fees
- Infrastructure cost
- Finance cost
- Taxes/charges
- Marketing cost
- Contingency
- Expected revenue

Outputs:
- Total estimated development cost
- Estimated revenue/GDV
- Estimated gross profit
- Estimated margin
- Break-even revenue
- Scenario comparison

All outputs are estimates, not professional or investment advice.

### Admin
Admin users can manage:
- Users
- Organizations
- Land parcels
- Professionals
- Projects
- Verification records
- Demo documents

Management actions must be auditable and scoped. Realistic multi-user workflows include owners and organization members, project members and invited professionals, reviewers with assigned verification work, and support or operations staff who should not automatically receive unrestricted access.

## Provenance and data trust

Important land, GIS, document and verification information should eventually retain source, source type, supplied by, collection/import date, verification date, reviewer, last updated time, jurisdiction, confidence and verification state. GIS geometry is a spatial representation; it is not automatically a legally authoritative cadastral boundary. Product copy and UI labels must preserve that distinction.

## 4. Non-functional requirements
- TypeScript strict mode
- Server-side authorization checks
- Input validation
- Database migrations
- Error handling
- Audit logging for important mutations
- Responsive UI
- Accessible form labels and keyboard navigation
- No secrets committed to source control
- Authorization must be enforced server-side and supported by RLS; client-side visibility is not a security boundary.
- Important mutations and administrative actions must be auditable.
- External providers must be replaceable through adapters/interfaces rather than leaking provider details into domain requirements.
- Long-running work should have an asynchronous extension point for future AI document analysis, GIS processing, report generation, bulk imports, notifications and analytics.

## 5. Acceptance principle
A new user must be able to complete the prototype journey without encountering fake buttons, broken navigation, or disconnected data.

## 6. Future product considerations (not prototype scope)

- A mobile client should share the backend, authentication, authorization, business logic, APIs and document/data model with the web client; construction field operations are an important future use case.
- Field workflows may eventually support local capture → offline work → synchronization → conflict handling. Offline support is not implemented by this prototype.
- AI is an assistive capability, not an official authority. It must distinguish facts from estimates, communicate uncertainty, avoid inventing missing information, treat uploaded content as untrusted input, and defer to qualified professionals or official authorities where required.
- Payments and subscriptions are out of scope. Future plans, subscriptions, entitlements, transactions, invoices, payment events, refunds, disputes, webhook verification and idempotency belong to a separate commercial domain. Role ≠ subscription ≠ entitlement.
- The long-term product must remain conscious of Nigerian data protection/privacy, personal-data lifecycle, third-party processors, international transfers where relevant, consumer protection, payment regulation, land administration, planning, building regulation, professional regulation and jurisdiction-specific rules. This is not legal advice.
