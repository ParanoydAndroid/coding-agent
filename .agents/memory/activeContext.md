# Active Context

## Current Focus
Subagent Model Tiering & Unified Golden-Path Reviewer: consolidating reviewer personas into `principal-reviewer` (`Model: pro`), introducing `grep-worker` and `diff-worker` (`Model: flash_lite`), and codifying the Golden Path / Happy Path architectural principle.

## Recent Changes
- Consolidated `architect-critic` and `code-auditor` into unified `principal-reviewer.md` with explicit `Model: pro` and Golden Path / Happy Path preference.
- Created `grep-worker.md` and `diff-worker.md` with `Model: flash_lite` for high-speed, cost-effective search and diff workloads.
- Codified Subagent Model Tiering Protocol and Golden Path design bias in `AGENTS.md`.
- Updated test runner invariant assertions to verify presence and integrity of all model-tiered subagent specifications.

## Active Decisions
- Subagent model selection follows strict tiering: `pro` for architectural planning and audit; `flash_lite` for search, grep, and diffs; `inherit`/`flash` for standard tasks.
- Unified reviewer combines design-mode interrogation ("Grill-Me") with operational drift auditing under a shared Golden Path philosophy.

## Immediate Next Steps
- Stand by for new feature requests, diagnostics, or architecture reviews.
- When beginning a new task, follow `feature-initiation` and update this file with active focus.
