# APEXGROVE — GIS Specification

## Purpose
GIS is a core capability of APEXGROVE. The prototype should prove that parcels and development information are spatially connected.

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

## Data model
`land_parcels.geometry` is the source of truth for parcel spatial representation.

## Spatial operations to support initially
- Bounding-box retrieval for map viewport
- Point-in-area/context lookup where useful
- Distance to nearby roads/POIs where demo data allows
- Geometry display and selection

## Data provenance
Every GIS dataset should carry:
- source
- collection/import date
- jurisdiction
- verification state
- data_as_of

## Future GIS integrations
- OpenStreetMap
- authoritative planning datasets
- satellite imagery
- survey data
- flood/environmental data
- remote sensing

Never represent third-party or demo spatial data as official cadastral or government records unless authoritative provenance is actually available.
