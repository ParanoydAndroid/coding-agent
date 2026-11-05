# SemVer and CalVer Release Guidelines

## Versioning Model Overview

The repository tracks changes using a hybrid dual-versioning scheme:
1. **Semantic Versioning (SemVer)**: `vMAJOR.MINOR.PATCH` (e.g. `v1.2.0`)
   - Identifies functional and architectural milestones.
   - Used for primary software releases, major capability introductions, and breaking changes.
2. **Calendar Versioning (CalVer)**: `YYYY.M.D.N` (e.g. `2026.11.4.1`)
   - Identifies chronological snapshots, routine backups, and configuration commits on `main`.

---

## Release Versioning Tiers

When completing work on a branch, classify the change into one of the following tiers:

1. **Semantic Major (`semver-major`)**:
   - Breaking changes to public interfaces, repository layout, data schemas, or incompatible CLI/API redesigns.
   - Requires user confirmation, full test suite pass, and curated `CHANGELOG.md` entry.

2. **Semantic Minor (`semver-minor`)**:
   - Substantive feature completions automatically qualify for a minor version bump (e.g., adding a new service, integrating a major module, adding an automated subsystem).
   - Critical or major security remediations that alter access models or introduce significant defense-in-depth layers.
   - Requires curated `CHANGELOG.md` entry.

3. **Semantic Patch / CalVer-Only (`semver-patch` / CalVer)**:
   - Routine bug fixes, minor documentation corrections, micro-patches, and syntax tweaks.
   - These do **NOT** generate standalone semantic minor bumps or individual changelog entries.
   - Merged to `main` under CalVer tracking.

4. **Tier Ambiguity**:
   - If the agent cannot confidently determine whether changes qualify for major, minor, or patch, it must present its analysis, recommend a version tier, and explicitly ask the user for confirmation before updating the changelog or tagging.

---

## Roll-Up Release Synthesis

Each `CHANGELOG.md` entry must provide a high-level overview of **ALL** changes across the codebase since the previous changelog entry.

Because multiple routine patches, bug fixes, and CalVer commits may accumulate on `main` between minor feature releases:
- The changelog entry for a new SemVer release must roll up and synthesize those intermediate commits alongside the new feature.
- Aggregate changes into curated, meaningful bullet points categorized under `Added`, `Changed`, `Fixed`, and `Security`.
- **Deployer-Focused Brevity & Scope**:
  - Write entries strictly from the perspective of users, consumers, and maintainers.
  - Highlight user-facing operational impacts, breaking contracts, service additions/removals, API/CLI updates, and security postures.
  - Avoid purely internal development minutiae: omit lines-of-code metrics, internal test assertion counts/pass rates, internal loop constructs, and issue tracker ticket noise.
- Omit trivial commits, typos, or negligible micro-edits.

---

## Changelog Entry Format Example

```markdown
## [1.2.0] / [2026.11.4.1] - Dedicated Background Worker & Event Queue (2026-11-04)

### Added
- Dedicated event queue consumer service with automated backoff retry and dead-letter queue.
- Automated health check probes and contract assertion test suite.

### Changed
- Standardized environment variable missing parameter assertions across all service manifests.
- Migrated default connection pool timeouts from 30s to 10s to prevent socket starvation.

### Fixed
- Remediated memory leak in websocket event dispatcher during client reconnection storms.

### Security
- Enforced non-root execution container profiles with dropped capabilities (`cap_drop: [ALL]`).
```
