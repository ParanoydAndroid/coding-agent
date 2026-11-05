# Plan: Harness Operational Enhancements

## Problem & Scope
This plan introduces four concrete enhancements:
1. **GitHub Actions CI Workflow**: Continuous integration pipeline validating tests, setup convergence, and codebase drift on push/PR.
2. **Memory Bank Governance & Auto-Synchronization**: Mandating agent reading and updating of `.agents/memory/` across task lifecycles (initiation and completion), and bringing memory files up to date.
3. **Main-Guarding Git Hooks**: Local git hook integration (`pre-commit` and `pre-push`) that enforces tests and audits exclusively on `main` branch operations, leaving feature branch commits unconstrained.
4. **Automated Memory Invariant Assertions**: Test assertion verifying memory bank files exist, are readable, and non-empty.

## Changes by Component
- `.github/workflows/ci.yml`: Workflow file running `./manage.sh setup`, `./manage.sh test all`, and `./manage.sh audit`.
- `manage.sh`: Add `cmd_hook` (`./manage.sh hook install`) and converge hooks in `cmd_setup`.
- `AGENTS.md`: Add Memory Bank Discipline & Synchronization rules.
- `.agents/skills/feature-initiation/SKILL.md`: Add step to update `activeContext.md`.
- `.agents/skills/feature-completion/SKILL.md`: Add step to update `activeContext.md` and `progress.md`.
- `.harness/test-runner.sh`: Add test verifying memory bank structure and freshness.
- `.agents/memory/`: Update `activeContext.md`, `systemPatterns.md`, and `progress.md`.

## Verification Strategy
- Run `./manage.sh hook install` and test behavior on `feature` vs `main`.
- Run `./manage.sh test all` to verify all test suites pass.
- Run `./manage.sh audit` to confirm zero drift and clean permissions.
