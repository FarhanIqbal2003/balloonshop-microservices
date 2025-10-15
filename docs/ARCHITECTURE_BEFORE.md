# Architecture Before Migration
### Original BalloonShop (Monolithic Architecture)

This document describes the **pre-migration state** of the BalloonShop application as delivered in the legacy ASP.NET Web Forms project.

---

## 🧱 System Overview

The legacy BalloonShop is a **monolithic e-commerce web application** built using:
- ASP.NET Web Forms (C#)
- ADO.NET for data access
- SQL Server as the single relational database
- Session-based authentication and cart management
- Server-side rendering for all pages

---

## 🧩 Layers and Responsibilities

| Layer | Description |
|-------|--------------|
| **Presentation Layer** | ASPX pages and code-behind files handling UI rendering, form submissions, and postbacks. |
| **Business Logic Layer** | C# classes (e.g., `Catalog`, `Orders`, `ShoppingCart`) implementing product retrieval, order validation, and checkout workflows. |
| **Data Access Layer** | ADO.NET `SqlCommand` and `SqlDataReader` for CRUD operations on SQL tables. |
| **Database Layer** | A single SQL Server database containing all entities (Catalog, Orders, Users, etc.). |

---

## 🗄️ Database Overview

All domain tables reside in one schema (`BalloonShopDB`). Example tables include:

- `Departments`
- `Categories`
- `Products`
- `Customers`
- `Orders`
- `OrderDetails`
- `ShoppingCart`
- `Users`

There are numerous **foreign key dependencies** across domains (tight coupling).

---

## 🔁 Communication & Flow

1. User browses catalog (`Default.aspx` → `Catalog.aspx`)
2. Product data fetched directly via SQL queries
3. User adds items to cart (session-based)
4. Checkout writes directly to `Orders` and `OrderDetails`
5. Order confirmation displayed synchronously

No asynchronous processing, caching, or API layers exist.

---

## ⚠️ Identified Limitations

| Issue | Impact |
|-------|--------|
| **Tight coupling** | Hard to change or scale individual modules |
| **Single DB** | Schema changes risky and slow |
| **UI and logic mixed** | Poor separation of concerns |
| **No API layer** | Integration with modern apps impossible |
| **No CI/CD pipeline** | Manual deployments |
| **No observability** | Difficult to diagnose production issues |

---

## 🧭 Summary

The legacy BalloonShop is a **typical ASP.NET monolith** — suitable for its time, but inflexible for modern cloud-native development.  
The modernization goal is to progressively separate **bounded contexts** (Catalog, Orders, Identity, etc.) into independently deployable .NET microservices.
