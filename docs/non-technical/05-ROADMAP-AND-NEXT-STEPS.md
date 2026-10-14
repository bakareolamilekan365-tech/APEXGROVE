# Roadmap and next steps

## The delivery order

The roadmap has been reorganized around a verification-first service:

### Phase 0 — Agree the direction

Confirm the first journey, responsibilities, trust labels, important decisions, and evidence required to call a feature complete.

### Phase 1 — Foundation

Accounts, profiles, organizations, database protection, private-storage rules, tests, and a basic dashboard.

This phase is near completion. PR #9 is merged and migrations `001`-`017` are deployed, but database permission tests, hosted account-email flows and remaining Supabase advisor findings still require closure or an explicit risk decision.

### Phase 2 — Verification case and private evidence

Build the first real business journey:

- customer request form;
- Abuja site details;
- private evidence upload;
- case submission;
- staff work queue;
- assignment and handover;
- status history and review notes;
- permission checks and audit history.

This is the next implementation phase.

### Phase 3 — Feasibility and report

Add clear assumptions, repeatable calculations, review, approval, and delivery of the Land & Development Report.

### Phase 4 — Controlled land discovery and maps

Add clearly labelled demonstration parcels, filters, map views, and source information after the controlled case workflow works.

### Phase 5 — Projects and professionals

Allow completed cases or parcels to become controlled project workspaces with scoped participation.

### Phase 6 — Release confidence

Complete full user-journey testing, accessibility, failure states, operational checks, and a deployable preview.

## What happens immediately

1. Record a green GitHub Actions database-security test run for the merged implementation.
2. Test real email confirmation and password recovery, including invalid/expired links.
3. Review the remaining Supabase security and performance findings and either fix or explicitly accept each one.
4. Confirm no exposed service-role secret remains in use and rotate any credential that was shared outside secure storage.
5. Agree the minimum founder decisions needed for Phase 2.
6. Design and build the Phase 2 journey from database rules to a simple working interface.

## What should not happen next

- another open-ended foundation rewrite;
- polished disconnected screens;
- public land marketplace work before the case workflow;
- payments;
- Kubernetes or complex infrastructure;
- claims that planned features already work.

