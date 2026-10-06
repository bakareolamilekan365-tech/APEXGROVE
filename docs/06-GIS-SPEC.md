# APEXGROVE — GIS Specification

## Purpose
GIS is a core capability of APEXGROVE. The prototype should prove that parcels and development information are spatially connected.

GIS is a representation and analysis capability, not a promise that APEXGROVE is a cadastral registry. Every geometry must preserve its source, update date, jurisdiction and verification/authority state.

## Stack
- PostGIS for spatial persistence and querying
- MapLibre GL JS for interactive web maps
- GeoJSON for initial demo imports

## Initial layers
- Demo land parcels
- Roads
- Administrative/context boundaries
- Selected points of interest where available

## Parcel behavior
A user can:
- View all demo parcels
- Pan/zoom the map
- Click a parcel
- See parcel reference and summary
- Open parcel detail
- Highlight the selected geometry

The map must label the confidence and authority of the displayed geometry. A polygon inside APEXGROVE is not automatically a legal land boundary.

## Boundary and authority distinction

Keep these layers separate in data, copy and UI:

1. **Visual/platform GIS** — a map representation used for discovery, context and interaction.
2. **Survey information** — measurements or plans supplied/reviewed by a survey professional.
3. **Cadastral information** — authoritative parcel/boundary data where a recognized source provides it.
4. **Official/statutory boundaries** — records confirmed by the relevant authority or legal system.

APEXGROVE internal review or a third-party dataset must not be presented as official/statutory confirmation. Conflicting sources should remain visible with source, dates, jurisdiction, reviewer and uncertainty; do not silently choose a legally consequential answer.

## Data model
`land_parcels.geometry` is the source of truth for parcel spatial representation.

## Spatial operations to support initially
- Bounding-box retrieval for map viewport
- Point-in-area/context lookup where useful
- Distance to nearby roads/POIs where demo data allows
- Geometry display and selection

Viewport queries should use bounded pagination/lazy loading. Use spatial indexes and avoid fetching all geometry for an entire map when only the visible viewport is needed. Geometry simplification and clustering may be used for display, but the stored source geometry and coordinate/reference-system metadata must remain traceable.

## Performance and scale (Future)

The prototype can use GeoJSON for small demo layers. As data grows, plan for PostGIS spatial indexes, viewport-based loading, pagination, caching, vector tiles or another tile adapter, connection management and avoidance of N+1 spatial queries. Do not over-engineer the current map before actual load requires it.

## Data provenance
Every GIS dataset should carry:
- source
- source type/authority
- supplied or imported by
- collection/import date
- last updated date
- jurisdiction
- verification state
- data_as_of

Coordinate reference system, units and transformation assumptions must be explicit. Data that is stale, incomplete, estimated or synthetic should be labelled accordingly.

## Future GIS integrations
- OpenStreetMap
- authoritative planning datasets
- satellite imagery
- survey data
- flood/environmental data
- remote sensing

Future map, tile, survey and authority-data providers should sit behind replaceable adapters where practical. Provider-specific SDKs must not leak into parcel or project domain models. Professional or official confirmation remains a distinct workflow above a visual map layer.

Never represent third-party or demo spatial data as official cadastral or government records unless authoritative provenance is actually available.
