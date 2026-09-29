# APEXGROVE — Document Management Specification

## Supported prototype types
- PDF
- PNG/JPG
- XLSX
- DOCX

## Document metadata
- file name
- document type
- related entity
- version
- status
- uploaded by
- upload date
- verification state
- description

## Versioning
Uploading a revised document creates a new version. Existing versions remain auditable.

## Security
Storage paths should be private. Generate authorized access only after server-side permission checks.

## Prototype document states
- Draft
- Submitted
- Under Review
- Approved
- Rejected
- Archived

## AI document analysis
Not required for the first working prototype. Reserve the interface so a future AI service can consume document text/extractions without changing the document domain model.
