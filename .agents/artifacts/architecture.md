# System Architecture, Scope, and Design Philosophy

## 1. Project Purpose and Scope

This document serves as the authoritative, living reference for the architecture, service boundaries, and operational invariants of the application platform.

The system encompasses:
- **Core Application Services & Modules**: Declarative component definitions, business logic engines, background workers, and persistent data stores.
- **Tracked Configurations & Assets**: Configuration templates, infrastructure manifests, reverse proxy rules, and process orchestration definitions.
- **Lifecycle, Testing, and Automation**: Idempotent CLI automation for environment initialization, secrets propagation, automated smoke/regression testing, and disaster recovery.

---

## 2. Core Architectural Principles

### 2.1 Declarative Convergence and Idempotency
- All setup, configuration, and provisioning routines are idempotent and safe to run repeatedly across both fresh environments and routine updates.
- Automation converges directly on the target state without leaving orphaned resources or half-applied mutations.

### 2.2 Boundary Isolation and Least Privilege
- Components communicate across well-defined network boundaries and API contracts.
- Internal services are isolated from public ingress interfaces.
- Processes execute under dedicated non-root service identities, with dropped system privileges and minimal required filesystem access.

### 2.3 Two-Tier Environment and Secret Separation
- Zero credentials, API keys, or private certificates are committed to version control.
- Configuration parameters follow a two-tier model:
  1. **`.env.example`**: Committed template declaring all environment variables, public parameters, and sensible local defaults.
  2. **`.env`**: Untracked runtime file populated with real credentials during deployment.
- Configuration manifests strictly assert required runtime variables (e.g. `${VAR:?Error message}`).

---

## 3. Standardized Repository & Directory Layout

```text
.
├── .agents/
│   ├── artifacts/
│   │   └── architecture.md
│   ├── rules/
│   │   └── project-conventions.md
│   └── skills/
├── .harness/
│   └── test-runner.sh
├── .env.example
├── .gitignore
├── .skills -> .agents/skills
├── AGENTS.md -> .agents/rules/project-conventions.md
├── CHANGELOG.md
└── README.md
```

---

## 4. Privilege, Identity, and Security Model

| Component / Layer | Execution Identity | Security Constraints | Storage Ownership |
| :--- | :--- | :--- | :--- |
| **Ingress / Gateway** | Non-root proxy user | TLS termination, security headers, rate limiting | Read-only configuration |
| **Application Services**| Dedicated non-root (`1000:100`) | `no-new-privileges: true`, dropped capabilities | Service-owned data root |
| **Databases** | Engine-specific user (e.g. `postgres`) | Private network binding, password authentication | Dedicated engine volume |
| **Background Workers** | Dedicated non-root worker | Read-only access to application assets | Ephemeral scratch directory |
