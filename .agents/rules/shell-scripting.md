---
trigger: glob
glob: "**/*.sh"
---

# Shell Scripting & System Automation Standards

All authored administrative shell scripts must adhere to strict engineering standards:

## 1. Strict Error Handling & Shell Standards
- Use `#!/usr/bin/env bash` as the interpreter directive.
- Enforce strict error boundaries at the top of every script:
  ```bash
  set -euo pipefail
  ```
- Always quote variable expansions (`"${VAR}"`) to prevent word splitting and globbing defects.
- Avoid invalid scoping outside functions; check preconditions explicitly before mutating system state.

## 2. Idempotency & Convergence
- All operations must be safely re-runnable without unintended side effects ($f(f(x)) = f(x)$).
- Setup and teardown scripts must verify current state before mutating.
- Creating directories must use `mkdir -p`.
- Symlinking must use `ln -sf`.
- File edits must verify existing contents or atomic backups before modifying.

## 3. Mandatory Documentation & Comment Intentionality
- **Comment Intentionality**: Adhere strictly to [`.agents/rules/communication-and-style.md`](./communication-and-style.md). Comments must explain *why* (hardware quirks, safety constraints, non-obvious algorithm trade-offs), never *what* (syntactic translation).
- **Script Header**: Every script must begin with a comprehensive header documenting purpose, architecture/context, usage syntax, subcommands, preconditions, and operational behavior.
- **Function Docstrings**: Every function must be preceded by a longform docstring defining:
  - `Description`: Clear explanation of purpose and mechanism.
  - `Arguments`: `$1`, `$2`, etc.
  - `Globals`: Read and written environment or script-level variables.
  - `Side Effects`: Files created/deleted, packages modified, services restarted.
  - `Exit Codes`: Explicit non-zero exit codes mapped to failure conditions.

## 4. Cleanup Traps & Resource Safety
- Always implement `trap` handlers on `EXIT`, `INT`, and `TERM` to clean temporary files, release lock files, or unmount loop/temporary devices safely.
