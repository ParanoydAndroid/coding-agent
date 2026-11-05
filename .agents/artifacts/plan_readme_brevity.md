# Plan: Streamline README.md Brevity

## Problem & Scope
The current `README.md` includes sections detailing common industry norms (such as two-tier `.env` vs `.env.example` handling and idempotency expectations) and contains redundant expansions in the repository tree that duplicate the skills catalog.

## Proposed Changes
1. **Remove Two-Tier Environment Section**: Delete the bullet point explaining `.env` vs `.env.example`, as this is a standard developer convention.
2. **Trim Common Norms in Guardrails (Section 5)**: Remove redundant declarations of standard behaviors (e.g., standard automation idempotency) and focus exclusively on agent-specific governance:
   - Mandatory human review gate before merges.
   - Negative constraints (no phantom refactoring, no comment pruning, strict dependency gate).
   - Persistent memory bank (`.agents/memory/`).
   - Reproduction-first bugfixes and test inviolability.
   - Agile trunk dual-tagging cadence.
3. **De-duplicate Repository Tree (Section 6)**: Collapse individual skill directories in the ASCII tree down to `skills/ # Operational runbooks (see catalog below)`, removing 15+ lines that duplicate Section 7.
4. **Verification**: Run `./manage.sh test all` and `./manage.sh audit` to confirm 100% compliance.
