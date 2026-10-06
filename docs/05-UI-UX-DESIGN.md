# APEXGROVE — UI/UX Specification

## Design character
Corporate, architectural, technical, trustworthy and modern.

## Palette direction
- Deep navy
- Near-black
- White
- Cool blue accents used sparingly

Avoid excessive gradients, gaming aesthetics, oversized illustrations, childish colors and generic real-estate template layouts.

## Layout
- Desktop-first information density with excellent tablet/mobile adaptation
- Clear page hierarchy
- Persistent global navigation
- Contextual secondary navigation inside projects
- Generous spacing
- Strong typography
- Functional cards and tables
- Maps used where spatial context matters

## Primary navigation
- Overview
- Land
- Map
- Projects
- Professionals
- Properties
- Documents
- AI (planned/future state unless implemented)

Admin navigation appears only for authorized users and should expose only the responsibilities and scope granted to that administrator. Do not build one unrestricted admin interface.

## Dashboard behavior
The dashboard content should depend on role. Do not show identical dashboards to all account types.

## Project workspace
Use a persistent project header and tabs:
Overview | Land | Planning | Documents | Professionals | Feasibility

Planning should show a clearly marked “planned module” state until implemented.

## States every important screen needs
- Loading
- Empty
- Error
- Success
- Permission denied
- Not found

Never leave the user with a dead screen after an action.

## Trust-oriented information design

The interface must make the authority of information visible. For land, GIS, documents and verification records, show where relevant:

- verification type and status, rather than one generic “Verified” badge
- verification level/authority: user-submitted, automated, APEXGROVE review, professional review, authoritative third party or official/statutory confirmation
- source, jurisdiction, collection/update date and provenance
- confidence, uncertainty, limitations and reviewer/date where available
- whether a capability is **Current Prototype**, **Planned** or **Future**

APEXGROVE review must not look like government certification. A map polygon must not be labelled as a legal cadastral boundary without authoritative supporting records. Professional responsibility and APEXGROVE platform responsibility should be distinct in copy, labels and assignment states.

## Authorization-aware UX

Document, project, organization and administrative screens should request data only after the server-side authorization decision. Permission-denied, expired-session, not-found and unavailable states must not reveal whether a protected object exists. Display controls according to granted permission for usability, but never treat the UI as the security boundary.

## Documents and private data

Document upload/download views should communicate status, version, reviewer and access scope. Use controlled retrieval for private files, do not display public-looking storage URLs, and make rejection, archive and retention states understandable without implying legal validity.

## AI surfaces (Future)

AI interfaces must clearly say when output is advisory. They should distinguish facts from estimates, show uncertainty, identify the source material considered, warn that uploaded content is untrusted, and direct consequential decisions to qualified professionals or official authorities. AI must not appear to approve land, title, planning or safety matters.

## Future mobile and field use

The future mobile client should share the web backend, authentication, authorization and business rules. Construction field workflows may add GPS, photos, document capture and local drafts. Offline capture → synchronization → conflict handling is future architecture, not current prototype behavior; mobile layouts should still preserve the same trust labels and permission boundaries.

## Accessibility
- Semantic HTML
- Form labels
- Keyboard support
- Visible focus states
- Sufficient contrast
- Helpful validation errors
