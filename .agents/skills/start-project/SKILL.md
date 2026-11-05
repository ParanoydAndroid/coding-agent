---
name: start-project
description: >-
  Interactive onboarding and scaffolding runbook for developers instantiating,
  customizing, or orienting to a software project. Guides project orientation,
  requirements assessment, platform/environment adaptation, adaptation planning,
  secrets scaffolding, and verified initial execution.
---

# Project Interactive Onboarding & Adaptation Runbook

This skill guides an agent and developer through orienting to, customizing, and bootstrapping a fresh codebase or adapting an existing repository to new requirements.

## When to Use This Skill
- Initial setup on a newly cloned repository or fresh workspace.
- Establishing initial project direction when orienting a new developer or agent.
- Adapting an existing codebase to fit different hardware, container, cloud, or OS platform constraints.

## Prerequisites
- Working directory is the project root.
- Basic runtime toolchains installed (e.g. Docker, Node.js, Python, Rust, Go, or Bash).
- Reference supporting guides:
  - [Component & Architecture Matrix](./references/architecture-matrix.md)
  - [Environment & Platform Adapters](./references/environment-adapters.md)

---

## Onboarding Procedure

### Step 1: Project & Architectural Briefing
Orient the developer to the core architectural invariants of this repository:
1. **Repository Layout**:
   - Source modules and services.
   - Declarative configuration files and manifests.
   - Central agent framework in `.agents/` and `.skills/`.
2. **Environment & Secrets Architecture**:
   - Single Source of Truth: All runtime configuration defaults are declared in `.env.example`.
   - Deployment manifests enforce required assertions: `${VAR:?Error: VAR must be set. See .env.example.}`.
   - Setup automation initializes local `.env` and generates cryptographic keys without committing secrets.
3. **Testing Standards**:
   - Automated smoke and regression test harness.
   - Mandatory test checks for any architectural modification.
4. **State Convergence & Self-Healing**:
   - A single idempotent convergence command (`setup` / `converge`) safely brings the system to the desired state.
   - Native container restart policies (`restart: unless-stopped`) and health probes (`healthcheck:`) for runtime recovery.

---

### Step 2: Needs Assessment & Requirements Discovery
Engage the user interactively (e.g. via `ask_question` or targeted dialogue) to establish project scope and workload needs:
1. **Core Workloads & Features**:
   - What are the required services, modules, or API endpoints?
   - What data persistence models (relational, document, embedded, object store) are required?
2. **Component Classification**:
   - **Keep (Immediate)**: Included in the initial deployment and verified right away.
   - **Defer**: Retain configuration/code templates, but mark disabled or excluded from initial test runs.
   - **Omit / Prune**: Remove unnecessary modules to eliminate bloat and maintenance overhead.

---

### Step 3: Platform, Runtime & Environment Discovery
Inspect host resources, platform capabilities, and constraints:
```bash
# Check CPU, memory, and disk resources
uname -a
nproc
free -m
df -h
```
- **Local Native vs Containerized Execution**: Identify whether services should run inside Docker/Podman or natively via system package managers.
- **Storage Topology**: Standardize persistent data roots (`DATA_DIR`).
- **Resource Sizing**: Tune memory limits, worker pool sizes, and cache allocations to match available hardware.

---

### Step 4: Author the Adaptation Plan Artifact
Before executing file modifications, deletions, or provisioning credentials, document the agreed-upon design in `.agents/artifacts/plan_<instance-name>.md`:
1. Selected components and modules (Immediate, Deferred, Omitted).
2. Data storage paths and runtime configurations.
3. Platform-specific adapters or workarounds.
4. Review the plan with the user and obtain confirmation before modifying system state.

---

### Step 5: Execution & Scaffolding
1. **Initialize Configuration**:
   - Copy `.env.example` to `.env` if not present:
     ```bash
     cp -n .env.example .env
     ```
   - Guide developer to populate required external secrets and tokens.
2. **Provision Storage Directories**:
   - Create required persistent data directories with proper permissions.
3. **Verify Dependencies**:
   - Install required dependencies or pull runtime containers.

---

### Step 6: Verified Initial Execution & Adaptive Test Loop
1. **Start Services**:
   - Launch application services in dependency order.
2. **Execute Automated Smoke Tests**:
   - Run the project test suite:
     ```bash
     ./.harness/test-runner.sh all
     ```
   - Assert 100% PASS across all active components.
3. **Post-Deployment Verification**:
   - Verify interface endpoints and application logs report healthy runtime status.
