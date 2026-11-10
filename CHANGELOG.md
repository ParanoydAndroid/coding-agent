# Changelog

All notable changes to the `coding-agent` framework are documented in this file.
This repository adheres to [Semantic Versioning](https://semver.org/) paired with Calendar Versioning (CalVer).

---

## [1.2.0] / [2026.11.10.1] - Anti-Slop Communication Invariants, Portable Doc Consistency Auditor, and Unified Shell Standards (2026-11-10)

### Added
- **Portable Communication & Anti-Slop Rule (`communication-and-style.md`)**: Created canonical `.agents/rules/communication-and-style.md` (`trigger: always_on`) codifying:
  - Persona & Tone: Direct, objective, concise, zero sycophancy, zero empty praise, zero apologies.
  - Interaction Invariants: Zero throat-clearing/preambles, zero bookends/sign-offs, zero prompt echoing, no unprompted code narration.
  - Banned Lexical Corpus: Hard ban on promotional puffery (`seamless`, `robust`, `cutting-edge`, `revolutionary`, `production-grade`, `battle-tested`), synthetic connectors (`delve into`, `tapestry`, `beacon`, `testament`, `crucial`, `pivotal`, `furthermore`, `moreover`), binary contrast hooks, and decorative emojis in technical artifacts.
  - Comment Intentionality: Explain *why*, never *what*; zero syntactic restatement; zero fabricated metrics.
- **Portable Documentation Consistency Auditor Skill**: Ported and adapted `.agents/skills/doc-consistency-auditor/SKILL.md` to provide automated frontmatter verification, internal relative link audits, factual grounding against disk state, cross-document propagation checks, and regex anti-slop scans against the canonical banned vocabulary.
- **Mechanical Anti-Slop Audit Gate in `manage.sh`**: Integrated automated prose anti-slop and promotional hyperbole detection into `./manage.sh audit`.

### Changed
- **Unified Shell Scripting Standards (`shell-scripting.md`)**: Consolidated `.agents/rules/shell-scripting.md` to incorporate cleanup traps (`trap ... EXIT INT TERM`) and comment intentionality referencing `communication-and-style.md`.
- **Frontmatter Glob Schema Alignment**: Fixed frontmatter schema in `.agents/rules/shell-scripting.md` and `.agents/rules/containers-and-env.md` from list sequences (`globs: [...]`) to Antigravity-compliant strings (`glob: "**/*.sh"` and `glob: "*compose*.{yml,yaml}"`).
- **Core Conventions Update**: Updated `AGENTS.md` Section 1 and Section 4 to index and enforce `.agents/rules/communication-and-style.md`.

---

## [1.1.0] / [2026.11.9.1] - Polyglot Language Invariants and Component Templates (2026-11-09)

### Added
- **Polyglot Coding Invariants in `AGENTS.md`**: Direct, always-on language guardrails for TypeScript/TSX, Python (3.12+ baseline), and Go integrated into Section 4 of `AGENTS.md`:
  - **TypeScript**: Strict typing (`noImplicitAny`, zero `any`), runtime boundary validation using existing libraries or native type guards without adding unvetted dependencies, pure ESM, and floating promise prevention with `AbortSignal`.
  - **Python (3.12+ Baseline)**: Modern typing (PEP 695 type parameter syntax, PEP 604 unions), standard `pathlib.Path` and `logging`, zero mutable defaults, explicit exception chaining (`raise ... from err`), and `asyncio.TaskGroup` structured concurrency.
  - **Go**: Immediate error checking and contextual wrapping (`%w`), `context.Context` propagation as first parameter, leak-free goroutine termination, consumer-defined interfaces, and table-driven tests.
- **Polyglot Idioms and Reference Templates**: Created `.agents/skills/component-authoring/references/polyglot-idioms.md` with complete code templates for TypeScript type guard assertions and timeout handling, Python 3.12+ `TaskGroup` workers and frozen dataclasses, and Go table-driven parallel unit tests.
- **Automated Polyglot Invariant Tests**: Added `test_polyglot_conventions_presence` and `test_modular_rules_syntax` to `.harness/test-runner.sh` asserting convention integrity.

### Changed
- **Rule Architecture Alignment**: Consolidated language standards directly into `AGENTS.md` following Antigravity's consolidated rule architecture, eliminating pseudo-globbed `.agents/rules/*.md` files to prevent context bloat and token waste.
- **Component Authoring Runbook**: Updated `.agents/skills/component-authoring/SKILL.md` to reference polyglot idiom templates for module scaffolding.
- **Documentation & Guardrails**: Updated `README.md` Core Guardrails to index polyglot language invariants.

---

## [1.0.0] / [2026.11.4.1] - Initial Release of Universal Coding Agent Framework (2026-11-04)

### Added
- **Mozilla Public License 2.0 (`LICENSE`)**: File-level copyleft license ensuring harness improvements remain open-source while permitting unencumbered use on managed codebases.
- **Prose Modesty & Anti-Hyperbole Rules**: Explicit behavioral and documentation constraints in `AGENTS.md` barring promotional buzzwords and self-aggrandizing hype in favor of direct, understated language.
- **Core Agent Conventions & Persona**: Universal instruction set in `AGENTS.md` and `.agents/rules/project-conventions.md` defining objective persona, analytical posture, no unverified assumptions, and mandatory user review checkpoints.
- **Citizen Developer Onboarding & Prompt Recipes**: Restructured `README.md` with 3-minute quickstarts, collaborative pair-programming flow breakdown, everyday `./manage.sh` cheatsheet, and copy-paste prompt recipes.
- **Persistent Memory Bank (`.agents/memory/`)**: Triad of agent-maintained files (`activeContext.md`, `systemPatterns.md`, `progress.md`) eliminating cross-session task amnesia.
- **Negative Constraints & Anti-Pattern Defenses**: Strict rules in `AGENTS.md` prohibiting phantom refactoring, comment deletion, unvetted external dependencies, and unbounded tool usage.
- **Glob-Scoped Modular Rules**: Extracted targeted rules for shell scripting (`shell-scripting.md`) and container manifests (`containers-and-env.md`).
- **Agile Trunk Tagging Governance**: Formalized three-tier tagging cadence, PEP 440 CalVer rules, SemVer feature resets, and pre-tagging human proposal packets.
- **Git Staging Hygiene**: Mandatory `git status -s` pre-commit inspection and atomic conventional commits explaining architectural rationale.
- **Universal Multi-Agent Entrypoints**: Drop-in symlinks for Anthropic Claude Code (`CLAUDE.md`), Google Antigravity / Gemini CLI (`GEMINI.md`), and Cursor IDE (`.cursorrules`).
- **Operational Management CLI (`manage.sh`)**: Central entrypoint orchestrating idempotent setup (`setup`), test execution (`test`), and codebase security/drift auditing (`audit`).
- **Invocable Subagent Prompts (`.agents/subagents/`)**: Specialized system prompt definitions for adversarial architecture critique (`architect-critic.md`) and compliance auditing (`code-auditor.md`).
- **Artifact Lifecycle Specification**: Comprehensive lifecycle policy distinguishing persistent specifications from branch-bound ephemeral plans in `.agents/artifacts/README.md`.
- **Progressive Disclosure References**: Added comprehensive reference checklists for component lifecycles (`touchpoints-checklist.md`) and codebase audits (`audit-rules.md`).
- **Pragmatic State Convergence Standards**: Guidelines for single idempotent setup/convergence entrypoints, container self-healing, native systemd/cron periodic jobs, and boot convergence.
- **Pre-Execution Script Review Rule**: Mandatory operational overview before requesting execution permission for ad-hoc or temporary scripts.
- **Modular Skills Suite (`.agents/skills/`)**:
  - `start-project`: Interactive orientation, needs assessment, architecture matrix, and adaptation planning.
  - `feature-initiation`: Branch creation, architectural plan drafting, opinionated "grill-me" design critique, plan commit, and mandatory user pause.
  - `feature-completion`: Regression test verification, stop-on-failure, systematic doc audit, roll-up changelog drafting, merge, and dual-tagging.
  - `component-authoring`: Module encapsulation, canonical key order, strict environment variable assertions, and least-privilege security model.
  - `component-lifecycle`: 6-touchpoint coordination for adding or decommissioning services cleanly.
  - `test-authoring`: Automated test suite organization, assertion helpers, test inviolability, and reproduction-first bugfix testing.
  - `codebase-audit`: Systematic drift detection across runtimes, image digests, environment variables, permissions, and network ports.
  - `system-diagnostics`: Multi-layer triage flowchart isolating routing, process health, sockets, DNS, and database layers.
  - `data-safety`: Zero-downtime database staging, pre-mutation snapshots, and isolated sandbox restore drills.
- **Reference Catalogues**: Supporting guides for architecture matrices, platform adapters, component specifications, test suites, and disaster recovery.
- **Automated Test Runner**: Lightweight, zero-dependency bash test runner in `.harness/test-runner.sh` with TAP/xUnit-style reporting.
- **Template Architecture Specification**: Living architectural specification format in `.agents/artifacts/architecture.md`.
