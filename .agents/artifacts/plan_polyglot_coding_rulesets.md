# Architectural Plan: Polyglot Language Coding Rulesets (TypeScript, Python, Go)

## 1. Problem Statement & Scope Boundaries

### Problem Statement
The `coding-agent` harness currently provides robust guardrails for system architecture, containerization manifests (`containers-and-env.md`), and Bash shell scripting (`shell-scripting.md`). However, it lacks dedicated language-level conventions and idiomatic constraints for application development in TypeScript, Python, and Go. When an AI agent authors application code without structured language guardrails, it frequently introduces recurring anti-patterns:
- Dependency sprawl (e.g. pulling in `axios`, `lodash`, `requests` instead of native runtime/stdlib primitives).
- Loose type assertions and boundary escapes (`any` casts, untyped `dict` bags, empty `interface{}`).
- Missing or improper error handling (swallowing exceptions, discarding error returns with `_ =`, missing error wrapping with `%w`).
- Concurrency and resource hazards (floating promises, event loop blocking, goroutine leaks, unpropagated context cancellations).

### Scope Boundaries
- **In Scope**:
  - Authoring modular, glob-triggered rule definitions for TypeScript, Python, and Go under `.agents/rules/`.
  - Keeping each rule file under ~120 lines, focusing strictly on negative constraints, contract boundaries, and canonical idioms.
  - Specifying strict dependency gating for TypeScript (use in-repo validator or native type guards; no automatic new deps).
  - Target modern Python 3.12+ runtime (trailing 12 months from annual release; no legacy <3.12 compatibility).
  - Updating `AGENTS.md` (and by extension symlinked `CLAUDE.md`, `GEMINI.md`, `.cursorrules`, `agent.md`) to integrate language-specific rule references.
  - Updating the automated test harness (`.harness/test-runner.sh`) with both presence and frontmatter syntax validation (`test_modular_rules_syntax`).
  - Synchronizing persistent memory bank files (`activeContext.md`, `systemPatterns.md`).
- **Out of Scope**:
  - Additional `.cursor/rules/` symlinks (relying solely on existing `.cursorrules -> AGENTS.md`).
  - Backward compatibility for Python < 3.12.
  - Modifying existing container or shell scripting rules.

---

## 2. Targeted State Mutations

### New Files
1. `.agents/rules/typescript.md`
   - Glob triggers: `*.ts`, `*.tsx`, `*.mts`, `*.cts`, `tsconfig*.json`, `package.json`
   - Content: Strict typing (`no-any`, native type guards / existing schema validators), native runtime preference (`fetch`, `node:crypto`), async hygiene, and ESM coherence.
2. `.agents/rules/python.md`
   - Glob triggers: `*.py`, `pyproject.toml`, `requirements*.txt`, `Pipfile`
   - Content: Python 3.12+ modern typing (PEP 695 type statements, PEP 604 unions), `pathlib.Path` standard, mutable default ban, explicit exception chaining (`raise from`), structured concurrency (`asyncio.TaskGroup`).
3. `.agents/rules/go.md`
   - Glob triggers: `*.go`, `go.mod`, `go.sum`, `go.work`
   - Content: Explicit error handling and `%w` wrapping, `context.Context` propagation as first parameter, goroutine termination invariants, interface simplicity, table-driven tests.

### Modified Files
1. `AGENTS.md`
   - Update Section 2 (Project Context and Onboarding Entrypoint) to index `.agents/rules/typescript.md`, `python.md`, and `go.md`.
   - Update Section 4 (Code Style and Documentation Standards) with cross-cutting language invariants.
2. `.harness/test-runner.sh`
   - Extend `test_modular_rules_presence` to assert presence of `typescript.md`, `python.md`, and `go.md`.
   - Add `test_modular_rules_syntax` asserting valid YAML frontmatter (`trigger:` and `globs:` or `always_on`) across all rules in `.agents/rules/`.
3. `.agents/memory/activeContext.md`
   - Update with live feature status, decisions, and immediate next steps.
4. `.agents/memory/systemPatterns.md`
   - Document polyglot modular rule trigger architecture.

---

## 3. Verification Steps

1. **Rule File Integrity**:
   - Verify all files under `.agents/rules/*.md` parse cleanly with valid frontmatter headers:
     ```bash
     head -n 10 .agents/rules/*.md
     ```
2. **Automated Test Harness Execution**:
   - Run the baseline test suite via `manage.sh`:
     ```bash
     ./manage.sh test conventions
     ./manage.sh test all
     ```
   - All tests must pass (100% pass rate).
3. **Repository Audit**:
   - Verify permissions and symlink resolution:
     ```bash
     ./manage.sh audit
     ```
4. **Git Tree Inspection**:
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
