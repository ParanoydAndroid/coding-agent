# Project Artifacts Directory

This directory houses agent-generated architectural specifications, design documents, and feature implementation plans.

---

## 1. Artifact Classification & Lifecycle

Artifacts in this directory fall into two distinct lifecycle tiers:

### Tier 1: Persistent Architectural Specifications (Committed & Preserved)
- **Examples**: `architecture.md`, `adr_*.md` (Architectural Decision Records), migration guides.
- **Purpose**: Canonical source of truth for high-level system topology, module boundaries, data storage models, and security postures.
- **Lifecycle**: Maintained across the entire life of the project. Updated during feature completion audits. **Never purged**.

### Tier 2: Ephemeral Feature Plans (Branch-Bound & Purged on Release)
- **Naming Pattern**: `plan_<feature-name>.md`
- **Purpose**: Step-by-step technical blueprints drafted during `feature-initiation`, refined through the interactive "grill-me" review cycle, and committed to the feature branch.
- **Lifecycle**:
  1. **Drafted & Refined**: On the feature branch (`feature/<name>`).
  2. **Executed**: During implementation.
  3. **Purged**: Automatically unlinked (`rm -f .agents/artifacts/plan_*.md`) during Step 4 of `feature-completion` after implementation and documentation audits are complete.

---

## 2. Authoring Standards

- Use standard GitHub Flavored Markdown (plain headings, lists, tables, code blocks).
- Do not use emojis, icons, or non-standard markdown extensions.
- When drafting plans, include:
  1. Problem statement and scope boundaries.
  2. Proposed component changes and interfaces.
  3. Environment variables and secrets requirements.
  4. Test verification plan and regression checks.
