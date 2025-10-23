# Shared Library (Transitional)

This folder contains **shared models, DTOs, and utility code** used by both
the legacy BalloonShop application and the new .NET 8 microservices during
the modernization process.

### Purpose
- Enable a smooth transition while both systems coexist.
- Avoid duplicate definitions for core types (e.g., ProductDto, OrderDto).
- Centralize cross-cutting concerns such as logging or constants.

### Notes
- This folder exists **temporarily** during Phases 1–3.
- Once all services are independent, shared code will be migrated into
  dedicated NuGet packages or replaced with API contracts.

### Planned Structure
