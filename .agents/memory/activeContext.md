# Active Context

## Current Focus
Polyglot Language Coding Invariants: Codifying unbreakable coding standards for TypeScript, Python (3.12+), and Go directly in canonical `AGENTS.md`, and providing deep scaffolding idioms in `component-authoring` references.

## Active Branch
`feature/polyglot-coding-rulesets`

## Recent Changes
- Branch isolated from latest `main`.
- Plan refined to adhere to Antigravity's consolidated rule architecture, eliminating pseudo-globbed `.agents/rules/*.md` files to avoid fragmentation and context bloat.
- Codified always-on polyglot language invariants directly into `AGENTS.md` (Section 4):
  - **TypeScript**: Strict typing (`noImplicitAny`, zero `any`), runtime boundary validation using existing project libraries or native type guards (zero unnecessary external deps), pure ESM, and floating promise prevention with `AbortSignal`.
  - **Python (3.12+ Baseline)**: Modern typing (PEP 695 generics, PEP 604 unions), standard `pathlib.Path` and `logging`, zero mutable defaults, explicit exception chaining (`raise ... from err`), and `asyncio.TaskGroup` structured concurrency.
  - **Go**: Immediate error checking and contextual wrapping (`%w`), `context.Context` propagation as first parameter, leak-free goroutine termination, small consumer-defined interfaces, and table-driven tests.
- Created `.agents/skills/component-authoring/references/polyglot-idioms.md` with complete code templates (runtime type guards, `AbortController` timeouts, Python 3.12+ `TaskGroup` workers, Go table-driven tests).
- Updated `component-authoring/SKILL.md` to reference `polyglot-idioms.md`.
- Updated `.harness/test-runner.sh` with `test_polyglot_conventions_presence` and `test_modular_rules_syntax`.
- Updated `.agents/memory/systemPatterns.md` documenting the Consolidated Polyglot Rule Architecture pattern.
- Verified all 12 test assertions passing (`./manage.sh test all`) and clean codebase audit (`./manage.sh audit`).

## Verification Status
- Automated Test Suite: 12/12 passing (`./manage.sh test all`).
- Codebase & Permission Audit: Clean (`./manage.sh audit`).
- Git working tree: Clean on `feature/polyglot-coding-rulesets`.

## Immediate Next Steps (Pending User Review)
- Pause at Mandatory Review Checkpoint.
- Await user inspection, testing, and explicit approval before initiating `feature-completion` (updating manifests/CHANGELOG, merging to `main`, and presenting the release tagging packet).
