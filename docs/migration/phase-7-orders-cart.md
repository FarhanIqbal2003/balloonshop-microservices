# Migration Phase 7 — Extract Orders & Cart Services

## 🎯 Goal
Separate Orders and Cart logic into independent services with async event handling.

## 🧩 Scope
- Introduce RabbitMQ for event-driven communication.
- Split Orders and Cart database tables.
- Update checkout flow.
- Tag as `v0.7-orders-cart`.
