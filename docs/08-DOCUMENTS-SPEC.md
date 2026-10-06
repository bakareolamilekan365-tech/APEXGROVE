# APEXGROVE — Document Management Specification

## Scope and implementation boundary

Documents are sensitive assets connected to users, organizations, land parcels, verification records and projects. This specification keeps the current prototype model while defining the controls needed for the future architecture. It does not claim that every lifecycle stage is fully implemented today.

The current prototype supports document-oriented workflows and metadata such as type, related entity, uploader, version, status and verification state. Private storage enforcement, malware scanning, advanced retention policy, immutable audit infrastructure and automated analysis must be verified or delivered as **Planned/Future** work rather than inferred from this document.

## Supported prototype types

- PDF
- PNG/JPG
- XLSX
- DOCX

Additional formats require an explicit security and processing decision.

## Document lifecycle

Every important document should move through this conceptual lifecycle:

```text
UPLOAD
→ VALIDATE
→ SECURITY CHECK
→ PRIVATE STORAGE
→ METADATA RECORD
→ VERSION
→ ACCESS CONTROL
→ REVIEW
→ VERIFICATION STATUS
→ AUDIT
→ RETENTION/DELETION
```

The prototype may expose only a subset. Missing steps must be labelled as planned and must not be implied by a badge or button.

## Metadata

The document record should be capable of retaining:

| Field/concept | Purpose |
| --- | --- |
| Document ID | Stable identifier independent of a filename or storage URL. |
| Owner/entity | User, organization, land parcel, verification or project to which access is scoped. |
| Uploader | Authenticated actor that submitted the file. |
| Type | Controlled document type, such as title, survey, plan, identity or project record. |
| Filename and MIME type | Display and validation metadata; filenames are normalized before storage. |
| Size | Resource, quota and abuse-control checks. |
| Upload date / last updated | Lifecycle and provenance timestamps. |
| Status | Draft, Submitted, Under Review, Approved, Rejected or Archived. |
| Version | Human-readable version plus immutable version lineage. |
| Verification state | Structured trust state, not a claim of legal validity. |
| Reviewer / review timestamp | Who reviewed the record and when. |
| Source/provenance | Source, authority, supplied-by, collection/import date, jurisdiction, method and confidence where relevant. |
| Storage reference | Private bucket/path or object identifier; never a public secret-bearing URL. |

Metadata should not contain unnecessary copies of sensitive document content. Access and review events belong in the audit trail.

## Versioning

- Important evidence versions are immutable after submission.
- A revised upload creates a new version where appropriate; it does not silently replace historical evidence.
- Version lineage should identify the predecessor, uploader, timestamp and reason for replacement/supersession.
- Review and verification decisions must point to the version reviewed, not only to the logical document ID.
- Archived versions remain discoverable to authorized reviewers subject to retention policy.

## Security and private storage

- Use private buckets/storage paths by default.
- Authorize the related user, organization, land, verification or project before every retrieval, download, preview or export.
- Return only short-lived signed or otherwise controlled access; do not expose guessable public document URLs.
- Validate MIME/type, size, extension and content expectations at upload. Normalize filenames and prevent path traversal or unsafe object names.
- Treat macros, embedded scripts, malformed files and polyglot files as malicious-file considerations.
- Malware scanning, content disarm/reconstruction and quarantine are **Future** integrations where risk requires them.
- Store service-role credentials only on the server and never in client bundles or committed environment files.
- Access, review, rejection, approval, version changes and deletion should be auditable without dumping full sensitive contents into logs.

## Prototype document states

- **Draft** — uploaded or being prepared; not submitted for a decision.
- **Submitted** — explicitly submitted for review.
- **Under Review** — assigned review is in progress.
- **Approved** — approved within the stated APEXGROVE workflow and scope.
- **Rejected** — review found a problem or insufficient evidence; reason should be recorded where appropriate.
- **Archived** — retained for history but not active in the current workflow.

Document status is not the same as legal validity, statutory registration, ownership, professional certification or government approval. APEXGROVE internal approval must not be represented as official confirmation.

## Provenance and authority

Important verification documents should be able to record:

- source and source type
- authority or issuing body
- supplied by / uploader
- reviewer and review date
- collection/import date and last updated date
- jurisdiction
- verification method and state
- confidence or limitations where applicable

The authority hierarchy is:

```text
user-submitted information
→ automated checks
→ APEXGROVE internal review
→ professional review
→ authoritative third-party confirmation
→ official/statutory confirmation
```

Storing a document does not make it legally authoritative. GIS or scanned boundary material is not automatically an authoritative cadastral boundary; the source and legal/official status must remain visible.

## Sensitive information

Document access follows minimum-necessary principles. The architecture should support scoped organization/project access, reviewer assignment, explicit download permission, retention/deletion decisions and auditability. Retention periods, deletion exceptions and legal holds are jurisdiction- and policy-dependent and require appropriate domain/legal input.

## AI document analysis (Future)

AI extraction or analysis is not required for the current prototype. If added, it should run asynchronously through a background job and an `AIProvider` adapter. Uploaded files and extracted text are untrusted input. AI output is advisory, must include confidence/uncertainty, must not invent missing facts or impersonate legal/professional/official authority, and requires human or professional review before consequential status changes.

## Scalability and resilience (Future)

The document subsystem should leave room for object storage, large files and metadata queries without loading full documents into normal request paths. Plan for:

- pagination and indexes on owner/entity, status, version and timestamps
- asynchronous scanning, extraction, report generation and bulk processing
- bounded retries with backoff for provider/storage operations
- idempotent upload/job handling and safe recovery after timeouts
- graceful failure when a storage or analysis provider is unavailable
- avoiding N+1 metadata and permission queries

Long-running work should expose durable states such as queued, running, succeeded, failed and cancelled, with retry/error metadata, without forcing a background-processing platform into the current prototype.

## Current prototype boundary

The prototype scope is the existing web workflow, supported types, basic metadata/version/status concepts and connected application/database behavior that is actually present in the repository. Private retrieval policy, complete RLS coverage, malware scanning, immutable audit guarantees, jurisdiction-specific retention, background processing and AI analysis are architectural requirements or future work unless independently verified in the implementation. No database migration or application code change is implied by this documentation update.
