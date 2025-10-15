# Migration Phase 5 — Split the Catalog Database

## 🎯 Goal
Create independent CatalogDB and migrate catalog tables.

## 🧩 Scope
- Create EF Core migrations in CatalogService.
- Export/import data from legacy DB.
- Remove catalog SQL access from monolith.
- Tag as `v0.5-split-db`.
