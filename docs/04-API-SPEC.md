# APEXGROVE — API Architecture

## Principles
- Consistent JSON response shapes
- Typed request/response schemas
- Authentication and authorization on every protected read and mutation
- Validation before database writes
- Domain errors mapped to safe HTTP responses
- No direct client access to privileged operations
- API routes/server actions remain inside the modular monolith; they are not a commitment to microservices.

## Prototype boundary

The API areas below describe logical boundaries for the current web prototype. They are not a claim that every route is implemented. Current UI and server code plus the database migrations are the implementation source of truth. Future planning, approvals, construction, billing, advanced GIS and AI endpoints remain planned until implemented and tested.

## Request security pipeline

For every protected request:

1. Establish the Supabase Auth identity and session.
2. Validate the request body, query parameters, path identifiers and content type.
3. Authorize ownership, organization membership, project membership, permissions and jurisdiction/scope before business logic.
4. Perform an object-level check against the requested record to prevent BOLA/IDOR; never trust an identifier supplied by the browser.
5. Execute the domain operation and database transaction.
6. Write an audit event for sensitive reads, downloads, reviews, administrative actions and mutations.

Frontend route guards and hidden controls are not authorization. Server-side checks and database RLS must remain the security boundary.

## API areas
/api/auth
/api/profile
/api/organizations
/api/land
/api/land/[id]
/api/land/[id]/verification
/api/properties
/api/projects
/api/projects/[id]
/api/projects/[id]/documents
/api/projects/[id]/professionals
/api/professionals
/api/feasibility
/api/documents
/api/notifications
/api/admin

## Example
### POST /api/projects
Request:
```json
{
  "name": "Sample Residential Development",
  "project_type": "residential",
  "parcel_id": "uuid",
  "description": "Demo project"
}
```

Response:
```json
{
  "data": {
    "id": "uuid",
    "name": "Sample Residential Development"
  },
  "error": null
}
```

## Errors
Use a consistent structure:
```json
{
  "data": null,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "One or more fields are invalid.",
    "details": {}
  }
}
```

Do not leak internal database or provider errors to end users.

## Query and operation behavior

- Collection endpoints should support explicit pagination (cursor or bounded page/limit), stable sorting and validated filtering.
- Default limits must protect the database; clients must not request unbounded lists or full document bodies in normal list responses.
- Use request correlation IDs and safe error codes without exposing secrets, SQL, storage paths or provider internals.
- Apply rate limits to authentication, uploads, search, exports and expensive calculations. Return a retry hint only when safe.
- Timeouts are failure boundaries, not a substitute for performance work. Provider calls should fail gracefully and surface an actionable error state.
- Retries must be bounded and use backoff where appropriate. Mutations that can be repeated need idempotency keys or equivalent deduplication; never blindly retry future financial operations.

## Long-running work

AI document analysis, large GIS processing, report generation, bulk imports, notifications and analytics may become asynchronous jobs. A future job API should expose queued/running/succeeded/failed/cancelled state, safe retry metadata and idempotency without making the current prototype depend on a job platform.

## Sensitive resources

Document endpoints must authorize the related user, organization, project or verification record before retrieval. Use private storage and short-lived signed/controlled access; never return guessable public URLs. Verification and administrative operations should include reviewer/actor context and audit metadata.

## Integration interfaces
Future external providers should be accessed through adapters, for example:
- `PaymentProvider`
- `MapTileProvider`
- `AIProvider`
- `VerificationProvider`
- `NotificationProvider`

The prototype may implement only the internal/default adapter. Provider-specific SDK types, webhook payloads and failure semantics must not leak into core domain models. A future mobile client should call the same server API/business rules as the web client.

Payment remains out of prototype scope. When introduced, payment routes must sit behind a `PaymentProvider` adapter and separate plans, subscriptions, entitlements, transactions, invoices, refunds, disputes, webhook verification and idempotency from identity/authorization.
