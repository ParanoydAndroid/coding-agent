# Coding Agent: Universal Agentic Engineering Framework

`coding-agent` is a production-grade, modular framework for agentic software engineering, architecture, and lifecycle operations. Extracted from real-world infrastructure orchestration, it equips AI coding assistants (such as Antigravity `agy`, Claude Code, OpenAI Codex, ChatGPT, and GitHub Copilot) with disciplined workflows, rigorous quality standards, and deep technical guidelines.

---

## 1. Core Engineering Principles

- **Objective, Matter-of-Fact Persona**: Concise, direct, and uncomplimentary. Zero sycophancy or conversational filler.
- **Adversarial "Grill-Me" Design Review**: Challenges assumptions, critiques premature optimization, and eliminates bespoke glue code in favor of declarative, standard solutions.
- **Mandatory User Review Gate**: After executing a plan and making intermediate implementation commits, agents must pause and solicit explicit user review and approval before touching release notes, merging, or tagging.
- **Pre-Execution Script Overviews**: Authoring or executing ad-hoc scripts requires providing a concise operational summary of commands, state mutations, and behavioral impact before execution.
- **Two-Tier Secret & Configuration Model**: Committed `.env.example` templates define all variables with strict assertion syntax (`${VAR:?...}`); real secrets remain untracked in `.env`.
- **Inviolability of Existing Tests**: Tests are never weakened or removed to make a broken build pass. Bug fixes must be accompanied by reproducing regression tests.
- **Curated Changelog Roll-Ups**: User- and deployer-focused release notes synthesizing intermediate commits into clear milestone summaries under SemVer and CalVer.

---

## 2. Repository Layout

```text
coding-agent/
├── AGENTS.md -> .agents/rules/project-conventions.md   # Universal entrypoint
├── agent.md -> AGENTS.md                                # Compatibility symlink
├── .skills -> .agents/skills                            # Skills directory symlink
├── .agents/
│   ├── rules/
│   │   └── project-conventions.md                       # Canonical rules & persona
│   ├── skills/                                          # Modular operational runbooks
│   │   ├── start-project/                               # Interactive onboarding & adaptation
│   │   ├── feature-initiation/                          # Branching, plan drafting, "grill-me"
│   │   ├── feature-completion/                          # Test verification, doc audit, changelog, merge
│   │   ├── component-authoring/                         # Canonical component structure & security
│   │   ├── component-lifecycle/                         # 6-touchpoint provisioning & decommissioning
│   │   ├── test-authoring/                              # Test suites, assertions, regression tests
│   │   ├── codebase-audit/                              # Drift detection, env skew, permissions
│   │   ├── system-diagnostics/                          # Multi-layer triage flowchart & isolation
│   │   └── data-safety/                                 # Zero-downtime backups, drills, snapshots
│   └── artifacts/
│       └── architecture.md                              # Living system architecture specification
├── .harness/
│   └── test-runner.sh                                   # Lightweight TAP/xUnit test harness
├── .env.example                                         # Configuration template
├── .gitignore                                           # Standard ignore rules
├── CHANGELOG.md                                         # Release history
└── README.md                                            # Project overview
```

---

## 3. Skills Catalog

All operational playbooks and diagnostic algorithms follow **progressive disclosure** under `.agents/skills/<name>/SKILL.md`:

| Skill | Description & Key Trigger |
| :--- | :--- |
| **`start-project`** | Onboards new developers or agents, explores hardware/platform constraints, assesses service needs, and scaffolds initial configuration. |
| **`feature-initiation`** | Mainline synchronization, branch checkout (`feature/<name>`), architectural plan drafting, opinionated "grill-me" critique cycle, and mandatory review pause. |
| **`feature-completion`** | Sequential test verification, stop-on-failure enforcement, systematic documentation audit, roll-up changelog drafting, merge, and dual SemVer/CalVer tagging. |
| **`component-authoring`** | Procedural guide for authoring modules and services: parameter expansion assertions, canonical key order, and least-privilege non-root execution. |
| **`component-lifecycle`** | Coordinates adding or decommissioning components across the 6 architectural touchpoints (spec, env, ingress, observability, persistence, tests). |
| **`test-authoring`** | Systematic patterns for smoke, contract, interconnect, and negative security tests; enforces reproducing tests before bug fixes. |
| **`codebase-audit`** | Detects drift between declarative source code and live runtime state, including container digests, env skew, permissions, and port exposure. |
| **`system-diagnostics`** | Step-by-step diagnostic triage flowchart for troubleshooting ingress routing, process runtime health, network/DNS, and database locks. |
| **`data-safety`** | Runbook for pre-mutation safety snapshots, zero-downtime online database dumps, and isolated sandbox disaster recovery drills. |

---

## 4. Feature Development Lifecycle

```text
1. Mainline Sync & Branching:
   git checkout main && git pull origin main
   git checkout -b feature/<feature-name>

2. Architectural Drafting:
   Author .agents/artifacts/plan_<feature-name>.md

3. "Grill-Me" Critique Cycle:
   Adversarial design review interrogating simplicity, declarative state,
   maintainability, and security hardening. Converge and commit plan.

4. Implementation & Intermediate Commit:
   Code, configure, and add test checks.
   git add -A && git commit -m "feat(<feature>): implement changes"

5. MANDATORY PAUSE & USER REVIEW GATE:
   Agent stops, presents current state and test results, and solicits
   explicit user approval before proceeding.

6. Feature Completion & Release:
   Run full test suite (stop on failure) -> Audit docs -> Update CHANGELOG.md
   -> Clean up plan artifacts -> Merge to main -> Dual-tag (SemVer + CalVer).
```

---

## 5. Adopting in Any Repository

To adopt this agentic setup in any existing or new project:
1. Copy `.agents/`, `.harness/`, `AGENTS.md`, and `.skills` into the target repository root.
2. Adapt `.agents/artifacts/architecture.md` to reflect your project's specific components and boundaries.
3. Define your project's environment variables in `.env.example`.
4. Ensure your agent is configured to read `AGENTS.md` as its primary instruction set.
