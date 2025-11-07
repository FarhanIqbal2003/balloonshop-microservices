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

Browser
↓
legacy-modernized UI (ASP.NET Web Forms) legacy UI (unchanged)
↓
HTTP → CatalogService (.NET 8 Web API)
↓
SQL Server (existing BalloonShop database)


- The API is **read-only** for this phase.
- `/shared` contains DTOs (ProductDto, CategoryDto) used by both API and the modernized clone.
- Authentication for phase 2 can be simple (local dev: none or API key). Later phases will replace with a proper Identity service.

---

## API contract (initial endpoints)

### GET /api/categories
Returns: `List<CategoryDto>`

CategoryDto
```json
{
  "categoryId": 1,
  "departmentId": 1,
  "name": "Balloons",
  "description": "All types of balloons"
}

---
# Legacy to DTO Field Mapping
## Table: Product

| Legacy Column       | DTO Field          | Notes |
|---------------------|-------------------|-------|
| ProductID           | ProductDto.Id     | Renamed for consistency with DTO naming conventions |
| Name                | ProductDto.Name   | Same meaning |
| Description         | ProductDto.Description | Same meaning |
| Price               | ProductDto.Price  | Converted from `money` to `decimal` |
| Thumbnail           | ProductDto.ThumbnailUrl | Renamed for clarity |
| Image               | ProductDto.ImageUrl | Renamed for clarity |
| PromoFront          | ProductDto.IsFeatured | Converted from bit to bool |
| PromoDept           | ProductDto.IsDepartmentFeatured | Converted from bit to bool |

---

## ✅ Phase 2 Summary
- All CRUD endpoints for Products, Categories, and Departments are implemented and tested.
- Database schema upgraded with CategoryId, Category, and Department tables.
- Verified via Swagger on local runtime.
- Ready for Dockerization and API exposure (Phase 3).
