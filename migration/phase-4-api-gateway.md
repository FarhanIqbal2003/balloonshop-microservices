# Migration Phase 4 — Introduce API Gateway

## 🎯 Goal
Centralize all routing and authentication through YARP or Ocelot gateway.

## 🧩 Scope
- Route `/catalog/*` → CatalogService
- Route `/orders/*` → Monolith
- Add JWT auth and logging middleware.
- Tag as `v0.4-api-gateway`.
