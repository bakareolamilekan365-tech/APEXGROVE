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

## 5. Acceptance principle
A new user must be able to complete the prototype journey without encountering fake buttons, broken navigation, or disconnected data.
