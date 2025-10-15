# Migration Phase X — [Phase Title]
*(Use this template for documenting each migration phase)*

---

## 🎯 Goal
Describe the purpose of this phase, e.g.:
> Extract CatalogService as an independent .NET 8 API while keeping monolith functional.

---

## 🧩 Scope
List what will change in this phase:
- Modules to be refactored or extracted
- Databases impacted
- Services to be introduced or modified

---

## 🧱 Technical Tasks
- [ ] Identify code dependencies in legacy project
- [ ] Create new .NET service project
- [ ] Expose API endpoints
- [ ] Adjust monolith calls to use HTTP API
- [ ] Add CI build for new service
- [ ] Update docker-compose and environment variables

---

## ⚙️ Implementation Details
Provide short technical notes (commands, setup, configuration).
```bash
dotnet new webapi -n CatalogService
dotnet ef migrations add InitialCreate
dotnet run
```
Add config changes, connection strings, or DB migrations here.

---

## 🧪 Testing
- [ ] Unit tests for new service logic
- [ ] Integration tests between monolith and service
- [ ] Manual verification of feature parity

---

## 🚀 Deliverables
- Running hybrid system with feature working via new service
- Updated documentation (`MIGRATION_PLAN.md`, diagrams)
- Phase tagged (e.g., `v0.3-catalog-service`)

---

## 🧩 Next Phase
Describe what will happen next (e.g., split DB, extract OrdersService).

---

> **Tip:** Copy this template for each migration step and replace `[Phase Title]` and specific details.
