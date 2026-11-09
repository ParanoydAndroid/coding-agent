---
trigger: glob
globs:
  - "*.ts"
  - "*.tsx"
  - "*.mts"
  - "*.cts"
  - "tsconfig*.json"
---

# TypeScript Coding Standards and Conventions

This rule applies automatically whenever authoring, refactoring, or reviewing TypeScript and TSX source files.

## 1. Strict Typing Invariants & Anti-Patterns
- Assume `strict: true` and `noImplicitAny: true` across all projects.
- **Zero `any`**: Never use `any`. Use `unknown` for unchecked external data and narrow via explicit type guards, Discriminated Unions, or schema assertion functions.
- **Runtime Boundary Validation**:
  - Never blind-cast external I/O payloads (`const user = await res.json() as User`).
  - If a schema validation library (Zod, ArkType, Valibot) is already present in `package.json`, use it.
  - If no validation library is installed, enforce boundaries using native assertion functions (`assertIsUser(data): asserts data is User`) or type guards (`typeof`, `instanceof`, `'key' in obj`). Do not install new third-party dependencies solely for validation.
- **Immutability by Default**: Mark object properties and array parameters as `readonly` when mutation is not strictly required.

## 2. Standard Library & Platform Primacy
- Strictly prioritize native runtime primitives (Node.js 18+ / Web standard APIs) over third-party micro-libraries:
  - Native `fetch()` over `axios` or `node-fetch`.
  - Native `node:crypto` (`randomUUID()`) over `uuid`.
  - Native `node:fs/promises` over `fs-extra`.
  - Built-in array and object methods (`map`, `filter`, `reduce`, `Object.fromEntries`) over `lodash` or `underscore`.
  - Built-in `node:test` and `node:assert` where a full testing framework is not already established.

## 3. Module System & Runtime Coherence
- Use modern ECMAScript Modules (`import` / `export`) exclusively.
- Never mix CommonJS (`require()`, `module.exports`) and ESM in the same codebase.
- Explicitly supply relative `.js` file extensions in import paths when required by NodeNext/Node16 module resolution.

## 4. Asynchronous Hygiene & Cancellation
- **No Floating Promises**: Every promise must be explicitly `await`ed, returned, or prefixed with `void` accompanied by a `.catch(...)` handler.
- **Deterministic Cancellation**: All network requests and long-running asynchronous workflows must accept an optional `AbortSignal` to propagate cancellations and enforce request timeouts.
- **Settled Collections**: Prefer `Promise.allSettled()` over `Promise.all()` when partial failure of concurrent subtasks is recoverable or requires independent error reporting.
