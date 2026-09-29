# APEXGROVE — Initial Implementation Checklist

## Step 1 — Bootstrap
- [ ] Create Next.js TypeScript application
- [ ] Configure linting/formatting
- [ ] Initialize git
- [ ] Create GitHub repository
- [ ] Create `.env.example`
- [ ] Configure Supabase

## Step 2 — Database
- [ ] Create migrations
- [ ] Enable PostGIS
- [ ] Create core tables
- [ ] Add foreign keys and constraints
- [ ] Add RLS policies
- [ ] Create audit logging
- [ ] Add seed/demo data

## Step 3 — Identity
- [ ] Auth flows
- [ ] Profile creation
- [ ] Role selection
- [ ] Route protection
- [ ] Role-aware dashboard

## Step 4 — Land + GIS
- [ ] Parcel data model
- [ ] Import demo GeoJSON
- [ ] Map page
- [ ] Parcel selection
- [ ] Search/filter
- [ ] Parcel detail page

## Step 5 — Verification + documents
- [ ] Verification record creation
- [ ] Checklist UI
- [ ] Status changes
- [ ] Private file storage
- [ ] Upload/versioning
- [ ] Audit records

## Step 6 — Projects
- [ ] Create project from parcel
- [ ] Project workspace
- [ ] Project members
- [ ] Professionals directory
- [ ] Add professional to project
- [ ] Project documents

## Step 7 — Feasibility
- [ ] Scenario form
- [ ] Calculations
- [ ] Scenario persistence
- [ ] Comparison view

## Step 8 — Admin
- [ ] User management
- [ ] Parcel management
- [ ] Verification management
- [ ] Professional management
- [ ] Project overview

## Step 9 — Quality
- [ ] Unit tests for calculations and permission rules
- [ ] End-to-end test of main journey
- [ ] Loading/error/empty states
- [ ] Responsive testing
- [ ] Accessibility pass
- [ ] Security review

## Definition of done
The complete prototype journey works against the real database and storage, with no fake success states or disconnected mock interactions.
