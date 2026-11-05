# Coding Agent: Universal Agentic Engineering Framework

`coding-agent` is a production-grade, modular framework for building software with AI coding assistants (such as Google Antigravity `agy`, Claude Code, Cursor, OpenAI Codex, ChatGPT, and GitHub Copilot).

Whether you are a **citizen developer** building your first internal tool or an **experienced systems architect** managing complex services, this harness provides the guardrails, automated testing, and disciplined workflows to keep your project clean, secure, and reproducible.

---

## 1. Quickstart (3 Minutes)

### Option A: Start a Brand-New Project
```bash
# 1. Clone or copy this framework into your new project directory
git clone <repo-url> my-project
cd my-project

# 2. Run the one-command setup (creates .env, builds directories, sets permissions)
./manage.sh setup

# 3. Verify that all baseline safety checks pass
./manage.sh test all
```

### Option B: Add to an Existing Project
```bash
# Copy the core harness files into your existing project root:
cp -r /path/to/coding-agent/{AGENTS.md,manage.sh,.agents/,.harness/,.skills,CLAUDE.md,GEMINI.md,.cursorrules,agent.md} ./

# Run setup to converge your environment:
./manage.sh setup
./manage.sh test all
```

Now open your project in your AI coding assistant (Antigravity, Cursor, Claude Code, or VS Code) and start building!

---

## 2. How Pair Programming Works with This Harness

When working with an AI assistant in this repository, you aren't just getting raw code dumped into files. The AI is bound by **four collaborative steps**:

```text
1. The "Grill-Me" Plan   ───>   2. Implementation & Tests   ───>   3. The Review Gate (STOP)   ───>   4. Verified Release
   (AI interviews you to          (AI writes code & tests,            (AI pauses & asks for your          (AI updates changelog,
    simplify the design)           commits to feature branch)          approval before merging)            merges, and tags)
```

1. **The "Grill-Me" Design Interview**: When you ask for a new feature, the agent will *not* immediately write code. It drafts a plan in `.agents/artifacts/` and asks you 2–4 targeted questions to simplify the design, prevent over-engineering, and agree on data formats.
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
| **`./manage.sh help`** | Displays available commands and options. | Whenever you need a quick reminder. |

---

## 5. Core Engineering Principles & Guardrails

For engineers, maintainers, and autonomous agents, the harness enforces non-negotiable architectural standards:

- **Objective, Matter-of-Fact Persona**: Direct, concise, and uncomplimentary. Zero conversational fluff or sycophancy.
- **Negative Constraints & Anti-Pattern Defenses**:
  - *No Phantom Refactoring*: Never modify or re-style code outside the approved feature plan.
  - *Preserve Documentation Integrity*: Never delete or prune unrelated comments, docstrings, or licenses.
  - *Strict Dependency Gate*: Never import new third-party libraries without explicit user justification and approval.
  - *Tool & Token Economy*: Avoid unbounded recursive shell commands (`ls -R`, unconstrained search).
- **Persistent Session Memory Bank**: Agent-maintained state in `.agents/memory/` (`activeContext.md`, `systemPatterns.md`, `progress.md`) prevents task amnesia across long sessions and chat compactions.
- **Two-Tier Secret & Configuration Model**: Committed `.env.example` templates define all variables with strict assertion syntax (`${VAR:?error}`); real secrets remain untracked in `.env`.
- **Inviolability of Existing Tests**: Tests are never weakened or removed to force a passing build. Bug fixes must be paired with reproducing regression tests.
- **Declarative & Idempotent Automation**: All setup and provisioning routines must produce the exact same desired target state when run repeatedly.
- **Agile Trunk Tagging Governance**: Curated SemVer releases (`vMAJOR.MINOR.PATCH`) for substantive features paired with daily CalVer snapshots (`YYYY.M.D.N`) on `main` following strict human approval gates.

---

## 6. Repository Layout & Multi-Agent Compatibility

The framework provides out-of-the-box entrypoints for all major AI coding assistants through root symlinks:

```text
coding-agent/
├── AGENTS.md                                            # Canonical root entrypoint (Universal standard)
├── CLAUDE.md -> AGENTS.md                               # Anthropic Claude Code entrypoint
├── GEMINI.md -> AGENTS.md                               # Google Antigravity / Gemini CLI entrypoint
├── .cursorrules -> AGENTS.md                            # Cursor IDE entrypoint
├── agent.md -> AGENTS.md                                # Tooling compatibility alias
├── .skills -> .agents/skills                            # Skills directory symlink
├── manage.sh                                            # Central operational CLI (setup, test, audit)
├── .agents/
│   ├── memory/                                          # Persistent session memory bank
│   │   ├── activeContext.md                             # Current task focus, decisions, next steps
│   │   ├── systemPatterns.md                            # Architecture patterns & idioms
│   │   └── progress.md                                  # Milestones & verification status
│   ├── rules/
│   │   ├── project-conventions.md -> ../../AGENTS.md    # Universal rules discovery symlink
│   │   ├── shell-scripting.md                           # Glob-scoped rules (*.sh)
│   │   └── containers-and-env.md                        # Glob-scoped rules (compose.yml, .env)
│   ├── subagents/                                       # Multi-agent role prompt definitions
│   │   ├── architect-critic.md                          # Adversarial "grill-me" reviewer
│   │   └── code-auditor.md                              # Drift & compliance auditor
│   ├── skills/                                          # Progressive-disclosure operational runbooks
│   │   ├── start-project/                               # Interactive onboarding & adaptation
│   │   ├── feature-initiation/                          # Branching, plan drafting, "grill-me"
│   │   ├── feature-completion/                          # Test verification, doc audit, changelog, merge
│   │   ├── component-authoring/                         # Canonical component structure & security
│   │   ├── component-lifecycle/                         # 6-touchpoint provisioning & decommissioning
│   │   ├── test-authoring/                              # Test suites, assertions, regression tests
│   │   ├── codebase-audit/                              # Drift detection, env skew, permissions
│   │   ├── system-diagnostics/                          # Multi-layer triage flowchart & isolation
│   │   └── data-safety/                                 # Zero-downtime backups, drills, snapshots
│   └── artifacts/
│       ├── README.md                                    # Artifact lifecycle & retention rules
│       └── architecture.md                              # Living system architecture specification
├── .harness/
│   └── test-runner.sh                                   # Lightweight TAP/xUnit test harness
├── .env.example                                         # Configuration template
├── .gitignore                                           # Standard ignore rules
├── CHANGELOG.md                                         # Release history
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
