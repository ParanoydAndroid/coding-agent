# Active Context

## Current Focus
Anti-Slop Communication Invariants & Portable Document Audit: Adding canonical `.agents/rules/communication-and-style.md`, porting `doc-consistency-auditor` skill, updating `AGENTS.md`, and adding mechanical anti-slop audit gate to `manage.sh`.

## Active Branch
`feature/anti-slop-communication-rules`

## Recent Changes
- Initialized branch `feature/anti-slop-communication-rules` from `main`.
- Plan approved for upstream harness update and downstream homelab synchronization.

## Active Decisions
- Codify unified persona, anti-slop communication invariants, banned lexical corpus, and code comment intentionality in portable `.agents/rules/communication-and-style.md` (`trigger: always_on`).
- Port `doc-consistency-auditor` skill from `home-config` to `coding-agent` as a generalized documentation auditor referencing the unified anti-slop registry.
- Add deterministic regex anti-slop check to `manage.sh audit`.

## Immediate Next Steps
1. Create `.agents/rules/communication-and-style.md`.
2. Port and adapt `.agents/skills/doc-consistency-auditor/SKILL.md`.
3. Update `AGENTS.md` and `manage.sh`.
4. Validate with `./manage.sh test all` and `./manage.sh audit`.
