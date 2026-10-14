# How work is carried out

## Build complete journeys, not isolated screens

Each feature should be delivered as a small end-to-end journey:

1. Agree what the feature must do.
2. Decide what information it stores.
3. Decide who is allowed to act.
4. Write checks for success and misuse.
5. Build the database and server behavior.
6. Build a simple usable interface.
7. Test the whole journey, including failure and permission-denied cases.

## Meaning of complete

A feature is complete only when:

```text
it works
and saves the correct information
and enforces access rules
and has meaningful tests
and handles important failures
and does not mislead users about trust or authority
```

## Demonstration information

Synthetic information must be clearly marked `DEMO DATA / NOT OFFICIAL`. Real names, titles, certificates, land claims, or confidential documents must not be invented in ways that look official.

The controlled pilot begins with synthetic or properly redacted evidence. Real documents must not be accepted until the approved privacy, terms, consent, access, retention/deletion and incident-response gate is complete and appropriately reviewed.

## Review and assignment discipline

- A customer may start a case, or authorized staff may assist with recorded consent and actor history.
- A human lead confirms assignments; automation may recommend but must not silently assign or approve work.
- An assignee may decline when overloaded and records the reason.
- Consequential conclusions require a genuinely separate, discipline-appropriate reviewer.
- Official/statutory evidence remains separate from Atexgrove and professional review.
- Unsupported matters remain inconclusive or awaiting confirmation.

## Testing approach

Different checks answer different questions:

- Small tests check calculations and decision rules.
- Connected tests check that application parts work together.
- Database-security tests prove allowed and forbidden access.
- Full journey tests imitate a person using the application.
- Docker provides a temporary local Supabase environment when available; GitHub Actions can provide the same kind of Docker-capable environment automatically.

Tests must not be weakened simply to create a green result.

The PR #9 database-security workflow passed in a temporary environment on 2026-10-14. This is automated database evidence, not a substitute for testing real hosted users, email links, storage access and operational settings.

## Cost discipline

The prototype stays free-first:

- Supabase Free for accounts, database, and private storage;
- GitHub Actions for database testing;
- no payment provider yet;
- no AI processing of real pilot documents;
- no Kubernetes;
- no unnecessary external services;
- no paid map or data provider until a real requirement justifies it.

Features requiring a paid plan must be labelled before implementation and approved as a separate cost decision.

## Audit discipline

The audit is updated after evidence exists, not before. GitHub checks, working journeys, hosted settings, and real permission behavior should be recorded with dates. Historical audit sections may remain for context, but the newest status must clearly state which earlier direction has been replaced.

