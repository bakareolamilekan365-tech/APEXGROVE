# APEXGROVE — API Architecture

## Principles
- Consistent JSON response shapes
- Typed request/response schemas
- Authentication and authorization on every protected mutation
- Validation before database writes
- Domain errors mapped to safe HTTP responses
- No direct client access to privileged operations

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

## Integration interfaces
Future external providers should be accessed through adapters, for example:
- `PaymentProvider`
- `MapTileProvider`
- `AIProvider`
- `VerificationProvider`
- `NotificationProvider`

The prototype may implement only the internal/default adapter.
