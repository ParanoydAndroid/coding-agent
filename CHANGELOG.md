# Changelog

All notable changes to the `coding-agent` framework are documented in this file.
This repository adheres to [Semantic Versioning](https://semver.org/) paired with Calendar Versioning (CalVer).

---

## [1.0.0] / [2026.11.4.1] - Initial Release of Universal Coding Agent Framework (2026-11-04)

### Added
- **Core Agent Conventions & Persona**: Universal instruction set in `AGENTS.md` and `.agents/rules/project-conventions.md` defining objective persona, analytical posture, no unverified assumptions, and mandatory user review checkpoints.
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
