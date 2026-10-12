# How Atexgrove works

## The simple picture

People use Atexgrove through a web browser. The web application handles what they see and checks what they are trying to do. Supabase provides account management, the database, and private file storage.

```text
User → Atexgrove website → permission checks → database/private storage
```

## Accounts and identity

Supabase confirms who is signed in. Atexgrove then uses its own records to decide what that person is allowed to see or change.

Choosing an account type such as “professional” is only a user claim. It does not prove identity, professional registration, authority, or verification status.

## Information storage

The database currently has real foundations for:

- user profiles;
- organizations;
- organization membership;
- audit records.

Many future areas—land cases, evidence, reports, projects, professionals, and feasibility scenarios—are described in the plans but are not yet complete working database features.

## Private files

Supporting documents will be stored privately. A signed-in customer should only reach files inside that customer's permitted area. Staff access must depend on their assigned responsibility, not simply on knowing a file address.

## Maps

Maps are planned for locating and understanding a site. A map image or boundary is not automatically an official survey, title record, cadastral boundary, or planning confirmation. The product must always show the source, date, location, and authority level of map information.

## Feasibility calculations

Development-feasibility results will come from visible inputs and repeatable calculations. They must show assumptions and limitations. They are estimates, not guarantees of profit, approval, cost, or development rights.

## Why everything stays in one application for now

The first prototype is deliberately one organized application instead of many separate services. This keeps cost and complexity low. Separate services should only be introduced later when scale or team ownership provides a real reason.

