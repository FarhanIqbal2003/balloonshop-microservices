# Migration Phase 2 — Introduce API Façade

## 🎯 Goal
Add an ASP.NET Core Web API layer that wraps the monolith’s logic.

## 🧩 Scope
- Create a `.NET 8` project `BalloonShop.Api`.
- Expose endpoints: `/api/products`, `/api/orders`.
- Implement Swagger + versioning.

## 🧱 Technical Tasks
- [ ] Create new project in `/services/api-facade/`.
- [ ] Map controllers to legacy logic.
- [ ] Add Swagger UI.
- [ ] Tag as `v0.2-api-facade`.

## 🚀 Deliverables
- Working façade exposing REST endpoints.
