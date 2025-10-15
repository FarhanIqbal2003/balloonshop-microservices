# 🧭 Migration Journey Overview

This document chronicles the **step-by-step modernization** of the legacy *BalloonShop* ASP.NET WebForms monolith into a **.NET 8 microservices-based architecture** using gradual decomposition.

Each phase below links to its own documentation and the corresponding Git tag or release.

---

## 📅 Migration Phases Timeline

| Phase | Title | Git Tag | Description | Document |
|:------|:-------|:---------|:-------------|:-----------|
| 🧱 0 | **Baseline Setup (Monolith Reference)** | [`v0.1-baseline`](../../tree/v0.1-baseline) | Legacy BalloonShop monolith imported and running with SQL Server. | [phase-0-baseline-setup.md](./phase-0-baseline-setup.md) |
| 🧩 1 | **Modularize the Monolith** | [`v0.1.1-modularized`](../../tree/v0.1.1-modularized) | Code reorganized into domain modules and dependency injection added. | [phase-1-modularization.md](./phase-1-modularization.md) |
| ⚙️ 2 | **Introduce API Façade** | [`v0.2-api-facade`](../../tree/v0.2-api-facade) | .NET 8 API façade wraps legacy logic and exposes `/api/products`. | [phase-2-api-facade.md](./phase-2-api-facade.md) |
| 🪄 3 | **Extract Catalog Service** | [`v0.3-catalog-service`](../../tree/v0.3-catalog-service) | Catalog domain migrated to independent service (shared DB phase). | [phase-3-catalog-service.md](./phase-3-catalog-service.md) |
| 🔀 4 | **Introduce API Gateway** | [`v0.4-api-gateway`](../../tree/v0.4-api-gateway) | Unified routing via YARP/Ocelot gateway with JWT validation. | [phase-4-api-gateway.md](./phase-4-api-gateway.md) |
| 💾 5 | **Split Catalog Database** | [`v0.5-split-db`](../../tree/v0.5-split-db) | Catalog tables migrated to dedicated `CatalogDb`. | [phase-5-split-catalog-db.md](./phase-5-split-catalog-db.md) |
| 🔐 6 | **Extract Identity / Auth Service** | [`v0.6-identity-service`](../../tree/v0.6-identity-service) | JWT auth implemented through standalone IdentityService. | [phase-6-identity-service.md](./phase-6-identity-service.md) |
| 🛒 7 | **Extract Orders & Cart Services** | [`v0.7-orders-cart`](../../tree/v0.7-orders-cart) | Orders & Cart microservices created with RabbitMQ events. | [phase-7-orders-cart.md](./phase-7-orders-cart.md) |
| 🌐 8 | **Replace Frontend (WebForms Sunset)** | [`v0.8-frontend`](../../tree/v0.8-frontend) | React / Blazor SPA replaces legacy UI. | [phase-8-frontend.md](./phase-8-frontend.md) |
| 🧹 9 | **Retire the Monolith** | [`v1.0-final`](../../tree/v1.0-final) | Legacy app archived; microservices fully operational. | [phase-9-retire-monolith.md](./phase-9-retire-monolith.md) |

---

## 🎥 Demo Tracking

See [`DEMO_TRACKING.md`](./DEMO_TRACKING.md) for:
- Demo videos or screenshots  
- Git tags and commit hashes  
- Phase completion status  

---

## 🧩 Related Documentation

| File | Description |
|------|--------------|
| [`MIGRATION_PLAN.md`](../docs/MIGRATION_PLAN.md) | Full technical roadmap |
| [`ARCHITECTURE_BEFORE.md`](../docs/ARCHITECTURE_BEFORE.md) | Legacy monolithic design |
| [`ARCHITECTURE_AFTER.md`](../docs/ARCHITECTURE_AFTER.md) | Target microservices design |
| [`phase-x-template.md`](./phase-x-template.md) | Template for authoring phase docs |

---

## 🗂️ Folder Reference

balloonshop-microservices/
└── migration/
├── JOURNEY_OVERVIEW.md # <── this file
├── DEMO_TRACKING.md
├── phase-x-template.md
├── phase-0-baseline-setup.md
├── phase-1-modularization.md
├── ...
└── phase-9-retire-monolith.md

## 🧠 Portfolio Tip
Add this link to your main README.md under Project Documentation:
▶ [Migration Journey Overview](./migration/JOURNEY_OVERVIEW.md)
