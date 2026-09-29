# APEXGROVE — Authentication, Authorization & Security

## Authentication
Use Supabase Auth for the prototype.

Support:
- email/password sign-up
- sign-in
- sign-out
- session persistence
- password reset architecture

## Authorization
Implement role-based access control plus ownership/membership checks.

Initial roles:
- buyer
- landowner
- developer
- professional
- admin

Future roles can be added without rewriting the permission system.

## Rules
- Users can edit only data they own or are explicitly permitted to manage.
- Project members can access project resources according to project role.
- Admin actions require explicit admin permission.
- Private documents are never exposed through unrestricted public storage URLs.
- Service-role credentials remain server-side only.
- Never commit secrets to git.

## Security controls
- Input validation
- Output encoding where appropriate
- Rate limiting architecture
- Audit logs
- Secure cookie/session handling
- Least privilege
- RLS for database protection
- Controlled storage access

## Verification trust
A verification badge must correspond to an actual verification record and workflow. Do not invent verified states for convenience.
