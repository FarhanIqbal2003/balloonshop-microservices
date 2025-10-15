# BalloonShop Microservices Migration Plan
### Detailed phase-by-phase technical roadmap

This document expands on the top-level roadmap in the README and defines **technical steps, goals, and deliverables** for each migration phase.

---

## Phase 0 — Baseline Setup (Monolith Reference)
**Goal:** Establish a working baseline of the original BalloonShop for reference and testing.

### Tasks
- Import the original ASP.NET Web Forms BalloonShop project into `/legacy/balloonshop`.
- Restore the original SQL Server database schema and seed data.
- Confirm that the application runs locally (IIS Express or full IIS).
- Create a GitHub repository and enable CI for .NET Framework builds.
- Document dependencies, environment variables, and connection strings.

### Deliverables
- Verified, runnable legacy solution.
- SQL scripts and test data in `/legacy/database/`.
- CI build passing for legacy solution.

---

## Phase 1 — Modularize the Monolith
**Goal:** Introduce logical boundaries inside the legacy codebase.

### Tasks
- Refactor code into separate namespaces (e.g., `BalloonShop.Catalog`, `BalloonShop.Orders`, `BalloonShop.Identity`).
- Extract shared utilities and constants into a `BalloonShop.Core` project.
- Introduce interfaces for data access (e.g., `IProductRepository`, `IOrderRepository`).
- Add dependency injection using Unity or SimpleInjector to prepare for decoupling.
- Write initial unit tests for each module.

### Deliverables
- Logical separation of bounded contexts in code.
- Dependency injection container integrated.
- Unit test suite for existing logic.

---

## Phase 2 — Introduce API Façade
**Goal:** Create a thin ASP.NET Core API that wraps the legacy code to expose functionality over HTTP.

### Tasks
- Add a new `.NET 8` project `BalloonShop.Api` within the same solution.
- Expose endpoints such as `/api/products`, `/api/categories`, and `/api/orders` by calling legacy methods/classes internally.
- Configure CORS, logging, and Swagger documentation.
- Introduce versioning for the new API.
- Add integration tests for API endpoints.

### Deliverables
- Running API façade exposing read-only product data.
- Swagger documentation for available endpoints.
- API deployed alongside legacy WebForms site.

---

## Phase 3 — Extract Catalog Service
**Goal:** Move the Catalog context out of the monolith as a standalone microservice.

### Tasks
- Create new `.NET 8` Web API project `CatalogService` in `/services/catalog-service`.
- Copy catalog models, DTOs, and data access logic from legacy project.
- Connect to the **same legacy database schema** (shared DB) for now.
- Replace direct calls in the monolith with HTTP calls to the new CatalogService.
- Use the new API façade as fallback for other modules.

### Deliverables
- CatalogService containerized and running independently.
- Monolith calling the CatalogService for product listings.
- Shared DB confirmed working without data conflicts.

---

## Phase 4 — Introduce API Gateway
**Goal:** Centralize routing and authentication for both the monolith and new services.

### Tasks
- Add YARP or Ocelot project `/gateway/api-gateway`.
- Route `/catalog/*` requests to the new CatalogService.
- Route other endpoints to the legacy monolith (for now).
- Add JWT validation logic to the gateway (stub implementation).
- Introduce central logging and request tracing via Serilog/Seq.

### Deliverables
- Gateway routing requests between systems.
- All external calls now go through the gateway URL.

---

## Phase 5 — Split the Catalog Database
**Goal:** Migrate catalog tables to a dedicated database owned by CatalogService.

### Tasks
- Create new database schema (e.g., `CatalogDb`).
- Use EF Core migrations to generate schema from models.
- Export and import catalog data from legacy DB.
- Update CatalogService connection string to new DB.
- Remove catalog DB access from legacy code; use API instead.

### Deliverables
- Independent Catalog database.
- Monolith fully dependent on API for catalog data.
- Data migration scripts stored in `/migration/sql-scripts/`.

---

## Phase 6 — Extract Identity / Authentication
**Goal:** Replace legacy login with modern authentication via JWT tokens.

### Tasks
- Create new `.NET 8` project `/services/identity-service` using ASP.NET Core Identity.
- Migrate user tables or create a mapping strategy.
- Expose `/api/auth/register`, `/api/auth/login`, and `/api/auth/refresh` endpoints.
- Issue JWTs for authenticated users.
- Integrate gateway for auth validation.
- Modify legacy WebForms login to call the IdentityService API.

### Deliverables
- Standalone IdentityService with JWT authentication.
- Legacy app integrated via API login.
- Gateway enforcing token validation.

---

## Phase 7 — Extract Orders & Cart Services
**Goal:** Migrate ordering and cart functionality to dedicated services with async events.

### Tasks
- Create `OrdersService` and `CartService` as separate .NET 8 projects.
- Introduce RabbitMQ as a message broker.
- Publish/subscribe to `OrderPlaced`, `OrderPaid`, and `OrderShipped` events.
- Decouple legacy checkout process to use the new services via API or events.
- Refactor shared DB dependencies (split `Orders`, `OrderItems`, `Carts` tables).

### Deliverables
- Orders and Cart services operational.
- Order flow supported via HTTP or async events.
- Monolith no longer writes directly to orders tables.

---

## Phase 8 — Replace the Frontend (WebForms Sunset)
**Goal:** Replace legacy WebForms pages with a modern SPA or Blazor frontend.

### Tasks
- Create new `/frontend/storefront` using React (TypeScript) or Blazor WebAssembly.
- Consume APIs via the gateway (catalog, cart, identity, orders).
- Gradually disable legacy `.aspx` pages.
- Add admin panel for product management.

### Deliverables
- New frontend operational through the gateway.
- WebForms interface deprecated.

---

## Phase 9 — Retire the Monolith
**Goal:** Remove remaining dependencies and finalize microservice architecture.

### Tasks
- Remove unused WebForms code and projects.
- Decommission legacy database tables not owned by any service.
- Run integration and load tests on new microservice stack.
- Deploy to cloud (e.g., Azure Container Apps, AKS, or Render).
- Archive the legacy solution for reference.

### Deliverables
- Fully decomposed, containerized system.
- Legacy code archived.
- Final documentation and diagrams updated.

---

## Optional Extensions
- Introduce event sourcing for Orders.
- Add ElasticSearch for Catalog search.
- Add distributed caching (Redis).
- Add CI/CD deployment pipelines per service.

---

## Final Outcome
At the end of this migration, the **BalloonShop** system will consist of:
- Independent microservices communicating via REST and events.
- Separate databases per bounded context.
- Unified gateway and modern SPA frontend.
- Continuous delivery pipelines and observability.
