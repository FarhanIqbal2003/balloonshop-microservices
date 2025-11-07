# 📘 Documentation

All project documentation and migration plans live here.

| Path | Description |
|------|--------------|
| `/docs/migration/phase-0-baseline.md` | Details of restoring and verifying legacy BalloonShop |
| `/docs/migration/phase-1-structure.md` | Steps and rationale for repository structure setup |
| `/docs/migration/phase-2-api-facade.md` | Implements Catalog API (Products, Categories, Departments) and EF Core integration |
| `/docs/migration/phase-3-catalog-service.md` | Extracts Catalog Service as an isolated microservice, containerized and exposed via HTTP |

---

## 📄 Phase Status

| Phase | Status | Tag | Summary |
|-------|---------|-----|----------|
| Phase 0 | ✅ Completed | `v0.0-baseline` | Legacy BalloonShop restored and validated |
| Phase 1 | ✅ Completed | `v0.1-structure` | Solution structure and shared libraries established |
| Phase 2 | ✅ Completed | `v0.2-api-facade` | Catalog API implemented and tested (Products, Categories, Departments) |
| Phase 3 | 🚧 In Progress | `v0.3-catalog-service` | Preparing containerization and service extraction |

---

## 📚 Notes

Future phases will include:
- Design docs for each microservice  
- Integration and deployment diagrams  
- Monitoring & logging setup  
