# System Patterns & Architecture Idioms

## Architectural Invariants
- **Declarative Configuration**: All configurations declared in versioned manifests; runtime defaults isolated in `.env.example`.
- **Universal Idempotency**: Running `setup` or any migration script N times safely converges on the target state without duplicating resources.
- **Inviolable Testing**: Existing test assertions are never arbitrarily loosened to force a pass; bugs must be accompanied by reproducing test cases.
- **Golden Path & Happy Path Priority**: Strictly prioritize standard interfaces, official framework primitives, standard library mechanics, and established protocols over bespoke wrappers or hand-rolled reinventions.
- **Subagent Model Tiering**: Tasks routed to models by cognitive requirements (`pro` for architecture and audit, `flash_lite` for high-volume text/diff search, `flash`/`inherit` for standard tasks).
- **Memory Bank Lifecycle Synchronization**: Sessions must begin by reading memory bank files; task initiation updates `activeContext.md`; completion updates `activeContext.md` and `progress.md`.
- **Protected Mainline**: Direct commits and pushes to `main` are guarded by git hooks and CI; feature branches permit unrestricted intermediate commits.

## Repository Patterns
- **Multi-Agent Entrypoint Aliasing**: `AGENTS.md` is the canonical root file; `CLAUDE.md`, `GEMINI.md`, `.cursorrules`, and `agent.md` symlink to it.
- **Portable Rule Modularization**: Universal persona, brevity invariants, anti-slop vocabulary, and code comment intentionality are decoupled into portable `.agents/rules/communication-and-style.md` (`trigger: always_on`), designed for direct 1:1 synchronization across repositories.
- **Rule Frontmatter Schema Standard**: Glob-scoped rules must specify `glob: "<pattern>"` as a singular string (e.g. `glob: "**/*.sh"`) to comply with Antigravity YAML unmarshaling requirements.
- **Consolidated Polyglot Rule Architecture**: Core language invariants (TypeScript, Python 3.12+, Go) codified directly in `AGENTS.md` for unbreakable, zero-latency enforcement across all turns without rule fragmentation; extensive implementation templates and test patterns offloaded to `component-authoring` references via progressive disclosure.
- **Operational Dispatcher**: `./manage.sh` orchestrates `setup`, `test`, `audit`, and `hook` with zero external dependencies.
- **Progressive Disclosure**: Skills maintain concise operational runbooks in `SKILL.md` while offloading detailed catalogs, tables, and schemas to `references/`.
- **Agile Trunk Dual-Tagging**: Semantic versioning (`vMAJOR.MINOR.PATCH`) for functional milestones paired with Calendar Versioning (`YYYY.M.D.N`) for continuous trunk deployments.
