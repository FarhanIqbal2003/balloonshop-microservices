# 🎈 BalloonShop Modernization Journey  
### From ASP.NET Web Forms → .NET 8 Microservices (Strangler Fig Pattern)

---

## 🧭 Overview

This repository documents the complete modernization journey of the **BalloonShop e-commerce** application — originally built with **ASP.NET Web Forms and SQL Server** — into a modern, cloud-ready **.NET 8 microservices architecture**.

The project follows the **Strangler Fig pattern**, ensuring that the legacy system remains fully functional while new microservices are introduced gradually.  
Each modernization phase is version-tagged, documented, and designed to demonstrate safe, incremental evolution.

---

## 🗂️ Repository Structure


```
balloonshop-microservices/
│
├─ legacy/ # Original ASP.NET Web Forms site (untouched)
│ └─ balloonshop/
│
├─ legacy-modernized/ # Safe clone used for Strangler integration testing
│ └─ balloonshop/
│
├─ services/ # .NET 8 microservices
│ ├─ catalog/
│ ├─ orders/
│ ├─ users/
│ ├─ cart/
│ └─ payments/
│
├─ shared/ # Shared DTOs, contracts, helpers
│
├─ database/ # Database scripts and future EF migrations
│
└─ docs/
├─ migration/ # Phase-by-phase technical documentation
└─ journey_overview.md # Migration roadmap and milestone tracking
```

---

## 🧩 Modernization Phases

| Phase | Title | Description |
|:--|:--|:--|:--|
| **0. Baseline Setup** | Import and document the original legacy BalloonShop application. | ✅ Working ASP.NET Web Forms app compiled and verified locally, with baseline documentation and initial repository setup (`v0.1-baseline`). |
| **1. Structure Setup** | Create repository structure for legacy, services, shared, and docs folders. Preserve baseline; no code refactoring yet. | ✅ Established multi-project folder structure (`/legacy`, `/legacy-modernized`, `/services`, `/shared`, `/docs`) with corresponding documentation and cloned `legacy-modernized` app (`v0.2-structure-setup`). |
| **2. API Façade (Catalog Service)** | Introduce .NET 8 Catalog Service exposing product and category endpoints from the legacy DB. Connect it to the `legacy-modernized` clone for Strangler integration. | First .NET 8 API operational and accessible (`v0.3-api-facade`). |
| **3. Legacy Modernized Clone** | Integrate the cloned Web Forms site with new APIs. Demonstrate the Strangler Fig pattern without touching original legacy code. | Legacy clone successfully consuming CatalogService (`v0.4-modernized-clone`). |
| **4. Service Expansion** | Add additional microservices (Orders, Users, Cart, Payments). Share DTOs and contracts through `/shared/`. | Multi-service environment functional (`v0.5-services-expansion`). |
| **5. Database Refactor & Migrations** | Transition from shared DB to per-service databases using EF Core migrations. | Split databases and schema alignment (`v0.6-database-refactor`). |
| **6. Identity & Auth Modernization** | Introduce centralized identity service (JWT-based). Replace legacy membership provider. | Secure, tokenized authentication (`v0.7-identity-service`). |
| **7. Frontend Modernization** | Optionally replace Web Forms UI with Blazor or MVC frontend consuming APIs. | Fully decoupled frontend (`v0.8-frontend`). |
| **8. Legacy Sunset** | Retire the original Web Forms app once all functionality has been modernized. | Complete transition to microservices (`v1.0-release`). |

---

## 🪴 Architectural Approach

**Pattern:** Strangler Fig  
**Principle:** “Let the new system grow around the old, one feature at a time.”

- 🧱 The legacy site stays fully functional.  
- 🌿 New .NET 8 APIs (Catalog, Orders, etc.) replace internal logic incrementally.  
- 🔁 Shared DTOs ensure data consistency between legacy and new APIs.  
- 🚀 Gradual replacement avoids downtime and enables continuous progress.

---

## 🧰 Tech Stack

| Area | Technology |
|------|-------------|
| **Legacy** | ASP.NET 4.x, Web Forms, ADO.NET, SQL Server |
| **New Services** | .NET 8 Web API, EF Core, REST, Docker |
| **Communication** | HTTP (initial), RabbitMQ (later) |
| **Gateway** | YARP / Ocelot |
| **Frontend** | React (TypeScript) or Blazor |
| **Auth** | ASP.NET Core Identity + JWT |
| **Data** | Separate SQL Server databases (per service) |
| **Infra / CI** | Docker Compose, GitHub Actions, GHCR |
| **Observability** | Serilog, OpenTelemetry (tracing, metrics) |

---

## ⚙️ Local Development

1. **Phase 0:** Run `/legacy/balloonshop` using Visual Studio (ASP.NET Framework).  
2. **Phase 1+:** Use Docker Compose to bring up hybrid environment:  
   ```bash
   docker-compose up
   ```
   This will eventually run the new .NET services, gateway, database, and message broker.

---

## 🚀 Continuous Integration

GitHub Actions workflow (`.github/workflows/ci.yml`) will:
1. Build legacy solution (.NET Framework).  
2. Build and test .NET 8 microservices.  
3. Build Docker images and push to GitHub Container Registry.  
4. Optionally deploy hybrid stack to staging.

---

## 📖 Documentation

| File | Purpose |
|------|----------|
| `/docs/ARCHITECTURE_BEFORE.md` | Original BalloonShop architecture overview |
| `/docs/ARCHITECTURE_AFTER.md` | Target microservices architecture diagram |
| `/docs/MIGRATION_PLAN.md` | Detailed phase tasks, risks, and rollback notes |
| `/migration/phase-x.md` | Implementation notes and commits per phase |

---

## 🧾 Version Tags

| Tag | Description |
|------|-------------|
| `v0.1-baseline` | Initial legacy import and repository setup |
| `v0.2-structure-setup` | Repository structure for microservice migration established |
| `v0.3-api-facade` | First .NET 8 CatalogService implemented |
| `v0.4-modernized-clone` | Legacy clone integrated with CatalogService |
| `v0.5-services-expansion` | Orders, Cart, Payments microservices added |
| `v0.6-database-refactor` | Per-service databases and EF migrations |
| `v0.7-identity-service` | Centralized identity and authentication implemented |
| `v0.8-frontend` | Modern frontend (Blazor/MVC/React) |
| `v1.0-release` | Legacy fully retired, microservices in production |

---

## 🧠 Learning Highlights

- Practical application of **Strangler-Fig pattern**
- Managing **hybrid monolith + microservices** during migration
- Introducing **REST APIs** in legacy systems
- Designing **bounded contexts** for e-commerce domains
- Setting up **CI/CD pipelines** for both .NET Framework and .NET 8
- Implementing **JWT authentication** and secure routing
- Building a **containerized hybrid environment**

---

## 🗣️ Project Status

| Phase | Progress |
|:--|:--|
| 0. Baseline Setup | 🟢 Complete |
| 1. Structure Setup | 🟢 Complete |
| 2. API Façade (Catalog Service) | 🟡 In Progress |
| 3. Legacy Modernized Clone | ⬜ Planned |
| 4. Service Expansion (Orders, Cart, Payments) | ⬜ Planned |
| 5. Database Refactor & Migrations | ⬜ Pending |
| 6. Identity & Auth Modernization | ⬜ Pending |
| 7. Frontend Modernization | ⬜ Pending |
| 8. Legacy Sunset | ⬜ Future |

---

## 📘 Documentation Index

| File | Description |
|------|--------------|
| `/docs/journey_overview.md` | End-to-end roadmap of all modernization phases |
| `/docs/migration/phase-0-baseline-setup.md` | Import of original BalloonShop legacy app |
| `/docs/migration/phase-1-structure-setup.md` | Repository structure and preparation |
| `/docs/migration/phase-2-api-facade.md` | First .NET 8 API façade (CatalogService) |
| `/legacy-modernized/balloonshop/README.md` | Integration clone for Strangler Fig demonstration |

---

## 🧠 Key Learning Themes

| Topic | Description |
|-------|--------------|
| **Strangler Fig Pattern** | Incremental modernization around a live legacy app |
| **Microservice Architecture** | Isolated services for catalog, orders, cart, identity, and payments |
| **Repository Design** | Shared contracts and DTOs enabling compatibility |
| **Continuous Integration** | Build, test, and tag pipeline for each phase |
| **Gradual Decomposition** | Moving from monolith → modular → distributed microservices |

---

## 🤝 Contributing

This repo is primarily for demonstration and learning.  
If you'd like to suggest improvements, open an issue or PR.

---

## 📜 License

MIT License © [FarhanIqbal2003]

---

> **About this project**  
> The BalloonShop Microservices Migration project is a self-directed modernization effort to demonstrate practical experience with **gradual decomposition, .NET Core microservices, and enterprise system transformation**.
