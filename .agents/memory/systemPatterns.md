# System Patterns & Architecture Idioms

## Architectural Invariants
- **Declarative Configuration**: All configurations declared in versioned manifests; runtime defaults isolated in `.env.example`.
- **Universal Idempotency**: Running `setup` or any migration script N times must safely converge on the desired state without duplicating resources or failing on existing entities.
- **Two-Tier Secret Separation**: Templates committed to git (`.env.example`); real secrets remain untracked in `.env`.
- **Inviolable Testing**: Existing test assertions are never arbitrarily loosened or deleted to force a pass; bugs must be accompanied by reproducing test cases.

## Repository Patterns
- **Multi-Agent Entrypoint Aliasing**: `AGENTS.md` is the canonical root file; `CLAUDE.md`, `GEMINI.md`, `.cursorrules`, and `agent.md` symlink to it.
- **Operational Dispatcher**: `./manage.sh` orchestrates `setup`, `test`, and `audit` with zero external dependencies.
- **Progressive Disclosure**: Skills maintain concise operational runbooks in `SKILL.md` while offloading deep catalogs, tables, and schemas to `references/`.
- **Agile Trunk Dual-Tagging**: Semantic versioning (`vMAJOR.MINOR.PATCH`) for API/functional milestones paired with Calendar Versioning (`YYYY.M.D.N`) for continuous trunk deployments.
