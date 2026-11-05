# Coding Agent

`coding-agent` is a small harness of rules, tests, and workflows for working with AI coding assistants (such as Google Antigravity `agy`, Claude Code, Cursor, OpenAI Codex, ChatGPT, or GitHub Copilot).

Whether you are building your first small project or managing existing services, this harness provides basic guardrails, sanity testing, and structured workflows to help keep the code organized and reproducible.

---

## 1. Quickstart

### Start a New Project
```bash
git clone <repo-url> my-project
cd my-project
./manage.sh setup
./manage.sh test all
```

### Add to an Existing Project
```bash
cp -r /path/to/coding-agent/{AGENTS.md,manage.sh,.agents/,.harness/,.skills,CLAUDE.md,GEMINI.md,.cursorrules,agent.md} ./
./manage.sh setup
./manage.sh test all
```

Then open your project in your AI coding assistant (Antigravity, Cursor, Claude Code, or VS Code) and start building.

---

## 2. How Pair Programming Works with This Harness

When working with an AI assistant in this repository, you aren't just getting raw code dumped into files. The AI is bound by **four collaborative steps**:

```text
1. The "Grill-Me" Plan   ───>   2. Implementation & Tests   ───>   3. The Review Gate (STOP)   ───>   4. Verified Release
   (AI interviews you to          (AI writes code & tests,            (AI pauses & asks for your          (AI updates changelog,
    simplify the design)           commits to feature branch)          approval before merging)            merges, and tags)
```

1. **The "Grill-Me" Design Interview**: When you ask for a new feature, the agent will *not* immediately write code. It drafts a plan in `.agents/artifacts/` and interviews you with substantive questions to simplify the design, identify edge cases, and resolve ambiguities before implementation.
2. **Implementation with Automated Tests**: Once you approve the plan, the agent creates a feature branch (`feature/<name>`), writes the code, and writes automated tests to prove it works.
3. **The Mandatory Review Gate (Safety Stop)**: The agent **must pause** after coding. It will present what was done, show you the test results, and wait for your input. Nothing touches your main branch without your explicit say-so.
4. **Verified Release**: Once you approve, the agent updates `CHANGELOG.md`, merges the code into `main`, and creates a version tag (e.g. `v1.1.0`).

---

## 3. Copy-Paste Prompt Recipes (What to Say to Your AI)

You don't need to memorize complex technical commands. Copy and paste these prompt templates into your chat:

### Starting a New Project
> *"I want to build a [web app / automation script / API service] that does [describe your idea]. Please follow the `start-project` skill to walk me through the architecture and set it up step-by-step."*

### Adding a New Feature
> *"I want to add [describe feature, e.g. user authentication / database export / a new dashboard widget]. Please follow `feature-initiation`, author a plan, and grill me on the design choices before writing code."*

### Approving and Releasing a Completed Feature
> *"The changes look great and the tests pass. Please proceed with `feature-completion` to update the changelog, clean up temporary plans, merge to main, and tag the release."*

### Troubleshooting an Error or Bug
> *"I ran into this error: [paste error message or unexpected behavior]. Please use the `system-diagnostics` skill to isolate the root cause, write a reproducing test, and apply a fix."*

### Auditing Your Codebase for Security and Drift
> *"Please run a `codebase-audit` to check if our files, environment variables, permissions, and services match our documented standards."*

---

## 4. Everyday Operator Cheatsheet (`./manage.sh`)

The `./manage.sh` script is your primary control center for running the project:

| Command | What It Does | When to Run It |
| :--- | :--- | :--- |
| **`./manage.sh setup`** | Idempotently sets up `.env` from template, creates required directories, and normalizes file permissions. | After cloning, after `git pull`, or whenever environment state feels out of sync. |
| **`./manage.sh test all`** | Runs the automated test runner to prove that all features, contracts, and invariants are green. | Before and after making any code changes. |
| **`./manage.sh audit`** | Scans for world-writable files, exposed secrets, missing `.env` keys, and broken symlinks. | Before releases or during periodic health checks. |
| **`./manage.sh hook install`** | Installs git hooks protecting `main` while leaving feature branch commits unconstrained. | After cloning or setting up a local development repository. |
| **`./manage.sh help`** | Displays available commands and options. | Whenever you need a quick reminder. |

---

## 5. Core Guardrails

The harness enforces key operating invariants defined in [AGENTS.md](AGENTS.md):

- **Mandatory Review Gate**: The agent pauses after drafting plans and writing code; nothing is merged to `main` without human approval.
- **Negative Constraints**: Strictly no phantom refactoring outside task scope, no pruning existing code comments or docstrings, and no new unvetted external dependencies.
- **Persistent Session Memory**: Session focus, idioms, and milestones are tracked in `.agents/memory/` across chats and compactions.
- **Reproduction-First Bugfixes**: Defect fixes must include a reproducing test before or alongside implementation.
- **Agile Trunk Dual-Tagging**: Substantive features receive SemVer tags (`vMAJOR.MINOR.PATCH`) paired with CalVer release tags (`YYYY.M.D.N`) on `main`.

---

## 6. Repository Layout & Tool Compatibility

Multi-agent entrypoints map to canonical conventions via root symlinks:

```text
coding-agent/
├── AGENTS.md                                            # Canonical conventions entrypoint
├── CLAUDE.md -> AGENTS.md                               # Anthropic Claude Code entrypoint
├── GEMINI.md -> AGENTS.md                               # Google Antigravity / Gemini CLI entrypoint
├── .cursorrules -> AGENTS.md                            # Cursor IDE entrypoint
├── agent.md -> AGENTS.md                                # Tooling compatibility alias
├── .skills -> .agents/skills                            # Skills directory symlink
├── manage.sh                                            # Operational CLI (setup, test, audit)
├── .agents/
│   ├── memory/                                          # Persistent session memory bank
│   ├── rules/                                           # Glob-scoped rules (*.sh, compose.yml)
│   ├── subagents/                                       # Multi-agent role prompts (architect, auditor)
│   ├── skills/                                          # Operational runbooks (see catalog below)
│   └── artifacts/                                       # Architecture specs and plans
├── .harness/
│   └── test-runner.sh                                   # TAP/xUnit test harness
├── .env.example                                         # Configuration template
├── .gitignore                                           # Standard ignore rules
├── CHANGELOG.md                                         # Release history
├── LICENSE                                              # Mozilla Public License 2.0
└── README.md                                            # Project overview
```

---

## 7. Modular Skills Catalog

All operational runbooks adhere to **progressive disclosure** under `.agents/skills/<name>/SKILL.md`:

| Skill | Purpose & Workflow Trigger |
| :--- | :--- |
| **`start-project`** | Onboards new developers or agents, explores hardware/platform constraints, assesses service needs, and scaffolds initial configuration. |
| **`feature-initiation`** | Mainline synchronization, branch checkout (`feature/<name>`), architectural plan drafting, opinionated "grill-me" critique cycle, and mandatory review pause. |
| **`feature-completion`** | Sequential test verification, stop-on-failure enforcement, systematic documentation audit, roll-up changelog drafting, merge, and dual SemVer/CalVer tagging. |
| **`component-authoring`** | Procedural guide for authoring modules and services: parameter expansion assertions, canonical key order, and least-privilege non-root execution. |
| **`component-lifecycle`** | Coordinates adding or decommissioning components across the 6 architectural touchpoints (spec, env, ingress, observability, persistence, tests). |
| **`test-authoring`** | Systematic patterns for smoke, contract, interconnect, and negative security tests; enforces reproducing tests before bug fixes. |
| **`codebase-audit`** | Detects drift between declarative source code and live runtime state, including container digests, env skew, permissions, and port exposure. |
| **`system-diagnostics`** | Step-by-step diagnostic triage flowchart for troubleshooting ingress routing, process runtime health, network/DNS, and database locks. |
| **`data-safety`** | Runbook for pre-mutation safety snapshots, zero-downtime online database dumps, and isolated sandbox disaster recovery drills. |

---

## 8. License

This project is licensed under the Mozilla Public License 2.0 (MPL-2.0). See [LICENSE](LICENSE) for details.
