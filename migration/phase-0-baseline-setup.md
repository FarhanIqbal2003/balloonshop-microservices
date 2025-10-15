# Migration Phase 0 — Baseline Setup (Monolith Reference)

## 🎯 Goal
Import the original BalloonShop Web Forms project, configure the database, and ensure the legacy monolith runs successfully as the migration baseline.

## 🧩 Scope
- Restore the original database schema and seed data.
- Confirm local IIS or IIS Express configuration.
- Validate that all catalog and order pages load correctly.
- Set up a GitHub repository for version control.

## 🧱 Technical Tasks
- [ ] Clone or extract original BalloonShop project.
- [ ] Configure `web.config` connection string.
- [ ] Create `BalloonShopDB` database and run SQL scripts.
- [ ] Verify monolith runs locally.
- [ ] Tag as `v0.1-baseline`.

## 🚀 Deliverables
- Verified, running legacy solution.
- Database scripts stored in `/legacy/database/`.
- CI build pipeline for legacy code.

## 🧩 Next Steps
Start modularizing the monolith (Phase 1).
