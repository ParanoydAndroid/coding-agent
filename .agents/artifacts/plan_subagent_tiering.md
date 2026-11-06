# Plan: Subagent Model Tiering & Unified Golden-Path Reviewer

## Problem & Motivation
1. Currently, subagent prompts in `.agents/subagents/` have no explicit model tiering. Heavy tasks and light parallel tasks run on whatever model the parent agent uses, which is inefficient for high-volume searches and under-specified for deep architecture reviews.
2. The existing reviewer personas (`architect-critic` and `code-auditor`) duplicate core concerns (declarative configuration, least privilege, simplicity). Consolidating them into a single `principal-reviewer` eliminates duplication while providing end-to-end review continuity from design to audit.
3. The unified reviewer requires an explicit mandate for **Golden Path / Happy Path thinking**: strictly prioritizing standard interfaces, native runtime features, and established protocols to ensure frictionless integration and maintainability.
4. Adding `grep-worker` and `diff-worker` bound to `flash_lite` enables cheap, high-throughput parallel search operations without polluting parent context.

## Proposed Changes
1. **Unified Reviewer (`.agents/subagents/principal-reviewer.md`)**:
   - Model: `pro`.
   - Role: Principal Architect & Systems Reviewer.
   - Core Biases: Strong Golden Path / Happy Path preference (native platform primitives, intended mechanics, zero bespoke reinvention).
   - Modes: Design Review ("Grill-Me") and Operational Audit (Drift & Compliance).
   - Replaces: `architect-critic.md` and `code-auditor.md`.
2. **Lightweight Search Workers**:
   - `.agents/subagents/grep-worker.md` (`flash_lite`): Fast read-only pattern, regex, and symbol matching.
   - `.agents/subagents/diff-worker.md` (`flash_lite`): Fast read-only structural diff and tree comparison.
3. **Subagent Delegation Protocol (`AGENTS.md`)**:
   - Define model tiers (`pro` for architecture/audit, `flash_lite` for grep/diff/cataloging, `flash`/`inherit` for standard tasks).
   - Codify Golden Path / Happy Path design principles.
4. **Reference & Documentation Updates**:
   - Update `README.md` Section 6 repository layout.
   - Update `.agents/skills/feature-initiation/` references.
   - Update `.agents/memory/` (activeContext, systemPatterns, progress).
5. **Verification**:
   - `./manage.sh test all` (10/10 assertions green).
   - `./manage.sh audit` (zero drift, clean permissions).
