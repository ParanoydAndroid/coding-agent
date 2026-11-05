# Active Context

## Current Focus
Harness operational enhancements: GitHub Actions CI workflow, git hooks guarding `main` branch, find depth fixes (maxdepth 6), and memory bank synchronization discipline.

## Recent Changes
- Fixed audit and permission normalization find traversal to `-maxdepth 6` in `manage.sh`.
- Added GitHub Actions CI workflow (`.github/workflows/ci.yml`) for automated test and audit validation on push/PR.
- Implemented `manage.sh hook install` generating `pre-commit` and `pre-push` hooks that guard `main` while leaving feature branch commits unconstrained.
- Mandated Memory Bank reading and updating lifecycle in `AGENTS.md`, `feature-initiation`, and `feature-completion`.
- Added automated test assertion in `.harness/test-runner.sh` verifying memory bank non-emptiness and CI workflow presence.
- Removed arbitrary question count limits from Grill-Me review guidelines across skills, subagents, and README.

## Active Decisions
- Adopting lightweight 3-file Memory Bank (`activeContext.md`, `systemPatterns.md`, `progress.md`) with explicit lifecycle synchronization requirements.
- Git hooks enforce checks exclusively on `main` branch operations (merges, commits on main, pushes to main); feature branch commits remain unhindered.
- Agile Trunk Dual-Tagging model (SemVer + CalVer) with mandatory human review gates before releases.

## Immediate Next Steps
1. Verify automated tests (10/10 assertions) and drift audit (`./manage.sh audit`).
2. Review feature branch diff and pause at Mandatory Review Gate.
3. Merge `feature/harness-enhancements` into `main` and push to remote origin.
