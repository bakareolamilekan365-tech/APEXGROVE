# Trust, security, and documents

## The central promise

Atexgrove should help people understand what is known, who supplied it, who reviewed it, and what remains uncertain. It must not turn an unverified claim into an official-looking fact.

## Different kinds of trust

Information may be:

- supplied by a customer;
- observed by Atexgrove staff;
- reviewed by a professional;
- obtained from an external source;
- confirmed by an official authority;
- estimated from assumptions;
- unresolved or disputed.

These labels must remain visible throughout the case and report.

## Access rules

A person should only see or change information allowed by their relationship to it. Examples include:

- a customer accessing their own case;
- an organization member accessing the organization's permitted work;
- assigned staff processing a case;
- an administrator performing only the duties granted to that administrator.

Being called an administrator must not automatically give unlimited access to everything.

## Organization protection

The security work prevents common abuses such as:

- creating an organization already marked as verified;
- creating an organization in another person's name;
- promoting oneself to platform administrator;
- allowing an organization administrator to silently remove or demote an owner;
- leaving an organization without any owner.

## Private documents

The hosted `documents` bucket is private and currently has user-scoped rules for reading, uploading, updating and deleting objects. This proves the configuration exists; it does not yet prove every allowed and forbidden action. The database tests must still demonstrate that one user cannot reach another user's objects. The completed document product must also check permission before preview/download, preserve versions and create application audit events.

## Current security boundary

Migrations `001`-`017` are deployed, but Supabase still reports open findings involving a PostGIS-managed table/functions, security-definer function reachability and leaked-password protection. These are recorded risks, not hidden failures and not evidence of production readiness.

## Audit history

Sensitive actions should leave a useful history: who acted, what changed, when it happened, and which record was affected. The project will not attach custom database triggers to Supabase's managed Storage table. Document-related audit records will be created through the Atexgrove application workflow.

## Free-plan limitation

The first prototype remains on Supabase Free. Supabase's leaked-password protection requires Pro, so that warning is documented as an accepted prototype limitation. Any future feature that requires a paid plan must be clearly labelled before it becomes a commitment.

## Real documents

The team must decide whether the first prototype will store real customer documents. If it will, privacy, retention, deletion, staff access, legal terms, and incident responsibilities must be agreed before those documents are accepted.

