# Architectural Plan: Polyglot Language Coding Invariants (TypeScript, Python, Go)

## 1. Problem Statement & Scope Boundaries

### Problem Statement
The `coding-agent` harness currently provides robust guardrails for systems architecture, containerization manifests (`containers-and-env.md`), and Bash shell scripting (`shell-scripting.md`). However, it lacks dedicated language-level conventions and idiomatic constraints for application development in TypeScript, Python, and Go. When an AI agent authors application code without structured language guardrails, it frequently introduces recurring anti-patterns:
- Dependency sprawl (e.g. pulling in `axios`, `lodash`, `requests` instead of native runtime/stdlib primitives).
- Loose type assertions and boundary escapes (`any` casts, untyped `dict` bags, empty `interface{}`).
- Missing or improper error handling (swallowing exceptions, discarding error returns with `_ =`, missing error wrapping with `%w`).
- Concurrency and resource hazards (floating promises, event loop blocking, goroutine leaks, unpropagated context cancellations).

### Scope Boundaries
- **In Scope**:
  - Consolidating core negative constraints and language invariants directly into `AGENTS.md` Section 4 for always-on enforcement without pseudo-globbing.
  - Offloading comprehensive implementation boilerplate, type guard examples, and test templates to `.agents/skills/component-authoring/references/polyglot-idioms.md` via progressive disclosure.
  - Enforcing strict dependency gating for TypeScript (use in-repo validator or native type guards; no automatic new deps).
  - Target modern Python 3.12+ runtime (trailing 12 months from annual release; no legacy <3.12 compatibility).
  - Enforcing Go explicit error wrapping (`%w`), context propagation, and leak-free goroutines.
  - Updating the automated test harness (`.harness/test-runner.sh`) to assert polyglot conventions in `AGENTS.md` and the presence of reference templates.
  - Synchronizing persistent memory bank files (`activeContext.md`, `systemPatterns.md`).
- **Out of Scope**:
  - Fragmented `.agents/rules/*.md` files for TypeScript, Python, and Go (avoids fake globbing and respects Antigravity's consolidated rule architecture).
  - Backward compatibility for Python < 3.12.
  - Delegating routine coding to a separate subagent (avoids multi-turn latency and context loss).

---

## 2. Targeted State Mutations

### New Files
1. `.agents/skills/component-authoring/references/polyglot-idioms.md`
   - Content: Deep implementation templates for TypeScript runtime type guards / `AbortController`, Python 3.12+ `TaskGroup` / frozen dataclass models, and Go error wrapping / table-driven test patterns.

### Modified Files
1. `AGENTS.md`
   - Update Section 2 (Project Context and Onboarding Entrypoint).
   - Update Section 4 (Code Style and Documentation Standards) with comprehensive, always-on Polyglot Language Invariants (TypeScript, Python 3.12+, Go).
2. `.agents/skills/component-authoring/SKILL.md`
   - Add reference link to `references/polyglot-idioms.md`.
3. `.harness/test-runner.sh`
   - Add `test_polyglot_conventions_presence` asserting that `AGENTS.md` codifies TypeScript, Python (3.12+), and Go invariants and that the polyglot reference idioms template is present.
4. `.agents/memory/activeContext.md`
   - Update with live feature status, decisions, and immediate next steps.
5. `.agents/memory/systemPatterns.md`
   - Document the Consolidated Polyglot Rule Architecture pattern.

---

## 3. Verification Steps

1. **Automated Test Harness Execution**:
   - Run the baseline test suite via `manage.sh`:
     ```bash
     ./manage.sh test conventions
     ./manage.sh test all
     ```
   - All tests must pass (100% pass rate).
2. **Repository Audit**:
   - Verify permissions and symlink resolution:
     ```bash
     ./manage.sh audit
     ```
3. **Git Tree Inspection**:
   - Ensure clean staging with no untracked scratch files:
     ```bash
     git status -s
     ```

---

## 4. Rollback & Recovery Runbook

If any part of the implementation fails or introduces unintended regressions:
1. Revert uncommitted changes on the feature branch:
   ```bash
   git reset --hard HEAD
   git clean -fd
   ```
2. If discarding the feature entirely:
   ```bash
   git checkout main
   git branch -D feature/polyglot-coding-rulesets
   ```
