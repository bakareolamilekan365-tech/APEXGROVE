# APEXGROVE — Project Context

## Product
APEXGROVE

## Positioning
> The trusted digital ecosystem for land development in Africa.

## Prototype purpose
This repository is the first serious working prototype of APEXGROVE. It must demonstrate a coherent end-to-end land-development workflow rather than a collection of disconnected mock screens.

APEXGROVE is not simply a real-estate listing platform. Its long-term purpose is to help people and organizations move through a trustworthy land-development ecosystem:

```text
LAND → VERIFICATION → PLANNING → DESIGN → APPROVAL → CONSTRUCTION → PROPERTY → URBAN INTELLIGENCE
```

The current prototype proves only the beginning of this journey. The later stages are architectural direction, not claims about functionality already implemented in this repository.

## Prototype journey
1. User registers and selects a role.
2. User signs in and sees a role-aware dashboard.
3. User discovers demo land parcels through list and map views.
4. User opens a parcel and reviews its available information.
5. User starts a land-verification workflow and uploads supporting documents.
6. User creates a development project from a parcel.
7. User adds professionals to the project.
8. User uploads and versions project documents.
9. User enters basic development assumptions and compares feasibility scenarios.
10. User can move through the project workspace without dead ends.

## Prototype scope
### Must work
- Authentication
- Role-aware onboarding
- Role-aware dashboard
- Land discovery
- Interactive map
- Land parcel detail
- Basic verification workflow
- Document upload/versioning
- Project creation and workspace
- Professional profiles
- Adding professionals to projects
- Basic feasibility calculations
- Admin management of core demo data
- Database/API integration

### Architect but do not fake
- Planning intelligence
- Approval management
- Construction management
- Tendering
- Procurement
- Property management
- Finance integrations
- Education
- Professional networking
- Advanced AI
- Urban intelligence
- Multi-country expansion
- Offline construction workflows

If a feature is not implemented, label it as planned/pending. Never create controls that imply functionality that does not exist.

## Product principles

### Trust and provenance
Important land, GIS, document, professional and verification information should eventually retain where it came from, who supplied it, when it was collected or last updated, who reviewed it, the relevant jurisdiction, confidence, and verification state. A record presented by APEXGROVE must not silently appear more authoritative than its source.

### Distinct concepts
Platform/user role, professional discipline, organization type, project role, permissions, and subscription/entitlement are separate concepts. A profession is not a permission, an organization membership is not a platform administrator role, and a subscription is not an authorization grant. The prototype may use simpler fields, but the long-term model must not collapse these concepts into one technical role per profession.

### Authority boundaries
APEXGROVE must distinguish user-submitted information, automated checks, internal review, professional review, authoritative third-party confirmation and official/statutory confirmation. Internal review is not government certification. A GIS polygon is a visual/spatial representation unless backed by survey or authoritative cadastral records.

### Professional involvement and jurisdiction
Land development involves qualified professionals and jurisdiction-specific rules. The product should make professional review and jurisdiction visible where relevant, while avoiding legal, planning, surveying, investment or regulatory claims that the product cannot substantiate.

### Security and privacy
Documents and personal data are sensitive. The long-term design requires private storage, controlled access, auditability, retention/deletion rules and awareness of Nigerian data protection/privacy obligations, third-party processors, international transfers and sector-specific regulation. This documentation is architectural guidance, not legal advice.

### Planned versus implemented
The repository contains a modular prototype, placeholder migrations and future-facing domain documentation. Current UI and database behavior are the implementation source of truth. Planned, reserved and future architecture must be labelled as such and must not be represented as working functionality.

## Initial geography
Nigeria, with Abuja as the primary demonstration geography. The architecture must remain jurisdiction-aware so Lagos and other African markets can be added later.

## Data rule
All demo/synthetic data must be explicitly labelled as DEMO DATA / NOT OFFICIAL. The application must never imply that fictional records are government-verified or authoritative.

## Product principle
The prototype should prove the beginning of the wider land-development chain while preserving trust, provenance, authority boundaries, jurisdiction awareness and security/privacy as first-class architectural concerns.
