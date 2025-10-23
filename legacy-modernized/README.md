# 🪴 Legacy Modernized (Strangler Integration Clone)

This folder contains a **safe clone** of the original BalloonShop ASP.NET Web Forms application.
It is used to demonstrate the **Strangler Fig pattern** — where new .NET 8 microservices gradually replace
the internal logic of the legacy system without breaking it.

---

## 🎯 Purpose

- Preserve the original legacy app (`/legacy/balloonshop/`) as a **baseline**.
- Create a **working copy** that integrates with newly developed APIs (starting with `/services/catalog/`).
- Demonstrate how legacy code can delegate functionality to new microservices via HTTP calls.
- Showcase gradual modernization while the old system remains functional.

---

## 🧩 Relationship to the Strangler Fig Pattern

In this pattern:
> “The new system grows around the old one, replacing it piece by piece.”

This clone represents the **first step** in that evolution — a bridge between the old monolith and the new distributed architecture.

---

## ⚙️ Implementation Plan

| Step | Description | Example |
|------|--------------|----------|
| **1** | Copy legacy BalloonShop source into `/legacy-modernized/balloonshop/` | Manual file copy from `/legacy/balloonshop` |
| **2** | Configure different local port (e.g., `5001`) in IIS Express | Edit `.vs\config\applicationhost.config` |
| **3** | Modify selected `.aspx.cs` files to call new APIs | Replace `CatalogAccess.GetProducts()` with `HttpClient` call to `CatalogService` |
| **4** | Keep new integration logic isolated | Create folder `/App_Code/Integration/` for all API calls |
| **5** | Document each refactor in `/docs/migration/phase-2-api-facade.md` | One row per replaced function |

---

## 🧱 Folder Notes

| Path | Description |
|------|--------------|
| `/legacy/balloonshop/` | Original untouched legacy app |
| `/legacy-modernized/balloonshop/` | Working clone for gradual modernization |
| `/services/catalog/` | .NET 8 API façade (first microservice replacing DB access) |
| `/shared/` | Shared DTOs and models used by both apps |

---

## 🧾 Commit & Tag Guidelines

| Action | Suggested Tag | Notes |
|---------|----------------|-------|
| Clone created | `v0.4` | Baseline copy created for Strangler integration |
| Catalog API wired up | `v0.5` | Product list now fetched from CatalogService |
| Additional services integrated | `v0.6+` | Each service integration tagged incrementally |

---

## 🚀 Future Direction

Once all `.aspx.cs` pages delegate to APIs:
- The legacy UI becomes a **frontend shell only**.
- Legacy DAL classes can be safely retired.
- Eventually, a new frontend (MVC/Blazor/React) can replace the Web Forms layer entirely.

---

_Current status: Clone ready for Strangler Fig integration (Phase 2 start)._
