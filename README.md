# BalloonShop Microservices Migration
### A real-world monolith → microservices modernization journey using .NET

This project demonstrates how to **gradually decompose the classic _BalloonShop_ ASP.NET Web Forms application** into a set of **independent, containerized microservices** built with modern .NET technologies.

Rather than rewriting everything from scratch, this repo follows the **Strangler-Fig pattern** — migrating one bounded context at a time while keeping the legacy system functional throughout.

---

## 🎯 Project Objective

> Transform the original BalloonShop e-commerce monolith (ASP.NET Web Forms + ADO.NET + SQL Server) into a modular, service-oriented architecture based on .NET 8, REST APIs, and asynchronous communication — **without a big-bang rewrite**.

---

## 🧭 Migration Strategy Overview

### Key principles
- **Gradual extraction** — decompose functionality phase by phase.
- **Maintain functionality** — the store remains operational during migration.
- **Shared DB → API Boundary → Independent DB** — isolate ownership over time.
- **Incremental replacement** — slowly replace Web Forms UI with a modern frontend.
- **Automation** — CI/CD builds and tests both legacy and new services.

---

## 🗂️ Repository Structure

```
/legacy/balloonshop/           ← Original ASP.NET Web Forms app
/services/                     ← New .NET 8 microservices
  /catalog-service/
  /identity-service/
  /orders-service/
  /cart-service/
  /payments-service/
/gateway/                      ← API Gateway (YARP / Ocelot)
/frontend/                     ← New SPA or Blazor storefront
/docs/                         ← Architecture and migration documentation
/migration/                    ← Phase-by-phase notes
/infra/                        ← Docker Compose, DB, and broker config
/.github/workflows/            ← CI/CD pipelines
```

---

## 🧱 Migration Phases (Top Level Roadmap)

| Phase | Objective | Result |
|:------|:-----------|:--------|
| **0. Baseline Setup** | Import original BalloonShop code, DB, and get it running. Add CI to build legacy app. | Working monolith baseline. |
| **1. Modularize Monolith** | Refactor code into clear namespaces (Catalog, Orders, Identity). Introduce service/repository interfaces. | Logical boundaries identified. |
| **2. Add API Façade** | Create new ASP.NET Core Web API layer exposing selected Catalog endpoints using existing code. | `/api/products` available, still uses shared DB. |
| **3. Extract Catalog Service** | Move Catalog logic into standalone .NET 8 project. Reuse legacy DB initially. | CatalogService runs separately; WebForms calls it over HTTP. |
| **4. Introduce API Gateway** | Add YARP/Ocelot to route between monolith and new service. | Unified access point for hybrid system. |
| **5. Split Catalog Database** | Migrate catalog tables to new schema; legacy now calls via API. | Catalog data isolated and owned by CatalogService. |
| **6. Extract Identity / Auth** | Implement new IdentityService with ASP.NET Core Identity + JWT. Integrate with legacy login page. | Unified authentication system. |
| **7. Extract Orders & Cart** | Move order/cart logic into services. Introduce message broker (RabbitMQ). | Async order processing. |
| **8. Replace Web UI** | Build a modern frontend (React or Blazor) using APIs only. Phase out Web Forms pages. | New UI replaces legacy views. |
| **9. Retire Monolith** | Remove remaining dependencies and shared DB tables. | Fully microservice-based architecture. |

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

## 🧾 Version Tags (for demo tracking)

Each stable migration phase will be tagged:
```
v0.1-baseline
v0.2-api-facade
v0.3-catalog-service
v0.4-split-db
v0.5-identity-service
v0.6-orders-cart
v0.7-frontend
v1.0-final-microservices
```

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
|-------|-----------|
| 0. Baseline setup | 🟢 Complete |
| 1. Modularization | ⬜ Planned |
| 2. API Façade | ⬜ Planned |
| 3. Catalog extraction | ⬜ Pending |
| 4. Gateway integration | ⬜ Pending |
| 5. DB split | ⬜ Pending |
| 6. Identity extraction | ⬜ Pending |
| 7. Orders & Cart | ⬜ Pending |
| 8. Frontend migration | ⬜ Pending |
| 9. Legacy sunset | ⬜ Future |

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
