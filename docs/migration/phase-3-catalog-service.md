# Migration Phase 3 — Extract Catalog Service

## 🎯 Goal
Isolate the catalog domain into a new service without breaking the monolith.

## 🧩 Scope
- Create `CatalogService` in `/services/catalog-service/`.
- Migrate catalog logic and models.
- Connect to the same database (shared DB phase).
- Replace monolith calls with HTTP requests.

## 🚀 Deliverables
- CatalogService containerized and reachable.
- Legacy UI consuming it via API.
- Tag as `v0.3-catalog-service`.
