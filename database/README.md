# 📂 Database Scripts

This folder contains **runnable SQL scripts and schema files** for the BalloonShop modernization project.  
It is distinct from `/docs/migration`, which focuses on **architectural phases** of the overall system migration.

---

## 🧩 Purpose

- Provide **database setup scripts** for both the legacy ASP.NET Web Forms BalloonShop site and upcoming .NET 8 microservices.  
- Ensure consistent local and CI/CD database initialization.  
- Keep all SQL assets version-controlled and evolution-ready.

---

## 🏗️ Folder Structure

database/
├─ legacy/ → SQL for original BalloonShop
│ ├─ BalloonShopMembership.sql
│ ├─ CreateAdminUser.sql
│ └─ SeedData_Catalog.sql
│
├─ catalog/ → (Phase 2+) schema for CatalogService
├─ orders/ → (Phase 3+) schema for OrdersService
├─ users/ → (Phase 3+) schema for UsersService
├─ payments/ → (Phase 4+) schema for PaymentsService
└─ README.md

---

## ⚙️ Execution Order (Legacy Setup)

1. Run **`BalloonShopMembership.sql`**  
   - Creates ASP.NET Membership tables.  
   - Adds default application and roles.

2. Run **`CreateAdminUser.sql`**  
   - Seeds an initial admin account (`admin` / `password`).  
   - Uses `IF NOT EXISTS` for idempotency.

3. *(Optional)* Run **`SeedData_Catalog.sql`**  
   - Inserts sample categories and products for testing.

---

## 🧱 Best Practices

| Rule | Description |
|------|--------------|
| ✅ Version Control | Commit all `.sql` scripts — never local-only. |
| ⚙️ Idempotent Scripts | Use `IF NOT EXISTS` to make re-runs safe. |
| 🧩 Service Boundaries | As services split, create subfolders (`/catalog`, `/orders`, etc.) |
| 🧾 Document Changes | Record major schema updates in `/docs/migration/phase-x.md`. |

---

## 🚀 Relationship to `/docs/migration`

| Folder | Purpose | Contents |
|---------|----------|-----------|
| `/database/` | Executable SQL files | `.sql` scripts, schema, seed data |
| `/docs/migration/` | Architectural documentation | `.md` files describing modernization phases |

In short:  
> **`/database` runs on SQL Server — `/docs/migration` runs in your mind.**

---

_Current phase: Legacy BalloonShop schema complete (Phase 0 – Baseline)._
