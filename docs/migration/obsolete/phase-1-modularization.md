# Migration Phase 1 — Modularize the Monolith

## 🎯 Goal
Introduce logical boundaries inside the monolith to prepare for gradual service extraction.

## 🧩 Scope
- Separate code into namespaces: `Catalog`, `Orders`, `Identity`.
- Introduce interfaces and dependency injection.
- Add initial unit tests.

## 🧱 Technical Tasks
- [ ] Move related classes into feature-specific folders/namespaces.
- [ ] Implement `IProductRepository`, `IOrderRepository`, etc.
- [ ] Introduce Unity or SimpleInjector DI container.
- [ ] Write unit tests.
- [ ] Tag as `v0.1.1-modularized`.

## 🚀 Deliverables
- Code organized by domain boundaries.
- Dependency injection implemented.
- Test project created.
