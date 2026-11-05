# System Patterns & Architecture Idioms

## Architectural Invariants
- **Declarative Configuration**: All configurations declared in versioned manifests; runtime defaults isolated in `.env.example`.
- **Universal Idempotency**: Running `setup` or any migration script N times safely converges on the target state without duplicating resources.
- **Inviolable Testing**: Existing test assertions are never arbitrarily loosened to force a pass; bugs must be accompanied by reproducing test cases.
- **Memory Bank Lifecycle Synchronization**: Sessions must begin by reading memory bank files; task initiation updates `activeContext.md`; completion updates `activeContext.md` and `progress.md`.
- **Protected Mainline**: Direct commits and pushes to `main` are guarded by git hooks and CI; feature branches permit unrestricted intermediate commits.

## Repository Patterns
- **Multi-Agent Entrypoint Aliasing**: `AGENTS.md` is the canonical root file; `CLAUDE.md`, `GEMINI.md`, `.cursorrules`, and `agent.md` symlink to it.
- **Operational Dispatcher**: `./manage.sh` orchestrates `setup`, `test`, `audit`, and `hook` with zero external dependencies.
- **Progressive Disclosure**: Skills maintain concise operational runbooks in `SKILL.md` while offloading deep catalogs, tables, and schemas to `references/`.
- **Agile Trunk Dual-Tagging**: Semantic versioning (`vMAJOR.MINOR.PATCH`) for functional milestones paired with Calendar Versioning (`YYYY.M.D.N`) for continuous trunk deployments.
