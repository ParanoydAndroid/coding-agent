# Active Context

## Current Focus
Baseline Maintenance: Anti-slop communication invariants, portable doc consistency auditor, and unified shell standards completed, verified across test runner (12/12 passing) and security audit, released as `v1.2.0` / `2026.11.10.1`.

## Active Branch
`main`

## Recent Changes
- Codified canonical `.agents/rules/communication-and-style.md` (`trigger: always_on`) covering persona, anti-slop invariants, banned vocabulary, and comment intentionality.
- Ported and generalized `.agents/skills/doc-consistency-auditor/SKILL.md` for automated link, factual grounding, and anti-slop verification.
- Embedded automated prose anti-slop audit gate into `./manage.sh audit`.
- Unified `.agents/rules/shell-scripting.md` with mandatory cleanup traps, error boundaries, and comment intentionality.
- Fixed Antigravity rule frontmatter schema from list sequence (`globs: [...]`) to string (`glob: "**/*.sh"`).
- Updated `CHANGELOG.md` with release milestone `[1.2.0] / [2026.11.10.1]`.
- Synchronized memory bank files (`activeContext.md`, `systemPatterns.md`, `progress.md`).

## Active Decisions
- Universal persona and style standards decoupled into `.agents/rules/communication-and-style.md` for clean 1:1 cross-repo synchronization.
- Antigravity rule frontmatter requires `glob: "<pattern>"` as a string; list sequences trigger unmarshaling failures.
- Comments must strictly explain *why*, never *what*.

## Immediate Next Steps
- Stand by for new feature requests, diagnostics, or architecture reviews.
- When beginning a new task, follow `feature-initiation` and update this file with active focus.
