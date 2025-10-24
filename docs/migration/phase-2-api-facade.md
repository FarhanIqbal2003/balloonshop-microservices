# Phase 2 — API Façade (Catalog Service)

**Goal:**  
Introduce the first .NET 8 Web API (`CatalogService`) that serves product and category data from the existing BalloonShop database. This phase demonstrates the Strangler Fig pattern by routing data reads from a *modern API* while leaving the legacy app intact. A safe clone (`/legacy-modernized/balloonshop`) will be used to validate integration before any changes touch the original legacy site.

---

## Scope (what this phase covers)
- Implement a lightweight, read-first `CatalogService` (.NET 8 Web API).
- Expose endpoints for product listings, product details, and categories.
- Use the existing legacy database (shared DB) for reads; no schema migration.
- Provide a small `/shared` DTO contract for both API and the `legacy-modernized` UI clone.
- Wire up the `legacy-modernized` clone to consume the `CatalogService` endpoints (one or two sample pages).
- Add tests, a simple CI job, and documentation. Tag milestone as `v0.3-api-facade`.

**Out of scope:** writing data back through the new API (Orders, Cart, Payments), splitting DB, or refactoring legacy code beyond the `legacy-modernized` clone.

---

## Success criteria
- `CatalogService` runs on localhost (Kestrel) and returns valid JSON for:
  - `GET /api/products`
  - `GET /api/products/{id}`
  - `GET /api/categories`
- `legacy-modernized` product listing page uses the service and displays matching product data.
- No changes to `/legacy/balloonshop` are required to demonstrate the flow.
- Unit and integration tests for the API exist and pass.
- Repo tagged: `v0.3-api-facade`.

---

## High-level design

