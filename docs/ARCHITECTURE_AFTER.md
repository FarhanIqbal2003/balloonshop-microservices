# Architecture After Migration
### Target Microservices Architecture (Modernized BalloonShop)

This document describes the **target state** after completing all migration phases.

---

## 🧱 System Overview

The modernized BalloonShop is a **cloud-ready microservices system** composed of multiple independent .NET 8 services.  
Each service owns its **data, logic, and APIs**. Services communicate via REST or asynchronous events.

---

## 🧩 Microservices Overview

| Service | Responsibilities | Data Ownership |
|----------|------------------|----------------|
| **CatalogService** | Manages products, categories, departments, and attributes. Provides read APIs for storefront. | `CatalogDb` |
| **IdentityService** | Manages authentication, registration, and JWT issuance. | `IdentityDb` |
| **CartService** | Stores user carts, handles cart operations, and communicates with Orders. | `CartDb` |
| **OrdersService** | Handles checkout, order creation, payment orchestration, and shipping updates. | `OrdersDb` |
| **PaymentsService** | Processes or simulates payments, issues payment events. | `PaymentsDb` |
| **RecommendationService** (optional) | Suggests related products based on purchase history. | Read-only access |
| **Gateway (YARP/Ocelot)** | Central API gateway for routing, auth enforcement, and rate limiting. | - |
| **Frontend (SPA)** | React or Blazor UI consuming APIs through gateway. | - |

---

## 🗄️ Databases

Each microservice owns its **dedicated SQL Server database**. No direct cross-service queries are allowed.  
Shared data is exchanged via APIs or domain events.

---

## 🔁 Communication Patterns

| Type | Used For | Technology |
|------|-----------|-------------|
| **Synchronous** | Read/write API requests | REST / HTTP over gateway |
| **Asynchronous** | Events like `OrderPlaced`, `PaymentSucceeded` | RabbitMQ |
| **Authentication** | User tokens | JWT + IdentityService |

---

## ⚙️ Infrastructure Components

| Component | Purpose |
|------------|----------|
| **API Gateway (YARP/Ocelot)** | Unified routing and authentication |
| **RabbitMQ** | Event-driven communication between services |
| **Docker Compose / Kubernetes** | Local orchestration & deployment |
| **GitHub Actions** | CI/CD build, test, deploy pipelines |
| **Serilog + OpenTelemetry** | Logging, tracing, and metrics collection |
| **Redis (optional)** | Distributed caching |

---

## 🔐 Security & Auth Flow

1. User authenticates via `IdentityService` (`/api/auth/login`).
2. JWT token issued and stored by frontend.
3. All requests routed through API Gateway which validates the token.
4. Gateway forwards to internal microservices securely.

---

## 📦 Deployment Topology

```
+-------------------------------+
|        API Gateway            |
+---------------+---------------+
                |
  +-------------+-------------+
  |                           |
Catalog   Orders   Identity   Payments   Cart
Service   Service  Service    Service    Service
  |         |         |          |         |
CatalogDb OrdersDb IdentityDb PaymentsDb CartDb

Frontend SPA (React/Blazor)
RabbitMQ (events)
```

---

## ✅ Key Improvements

| Category | Legacy | Modernized |
|-----------|---------|-------------|
| Architecture | Monolith | Microservices |
| Scalability | Vertical | Horizontal (per service) |
| Deployment | Manual | Automated via CI/CD |
| Auth | Forms / Session | Token-based JWT |
| Database | Shared | Per service |
| Observability | Minimal | Centralized logs + tracing |
| Extensibility | Difficult | Plug-and-play services |

---

## 🧭 Summary

At the end of migration, BalloonShop will become a **modular, observable, and deployable-by-design** system — ideal for demonstrating modern .NET microservice patterns, DevOps practices, and domain-driven architecture.
