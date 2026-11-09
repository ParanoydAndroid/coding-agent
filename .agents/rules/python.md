---
trigger: glob
globs:
  - "*.py"
  - "pyproject.toml"
  - "requirements*.txt"
  - "Pipfile"
---

# Python Coding Standards and Conventions

This rule applies automatically whenever authoring, refactoring, or reviewing Python source files and project manifests.

## 1. Runtime Baseline & Modern Typing Standards
- **Baseline Version**: Target Python 3.12+ features exclusively (trailing 12 months from the annual release). Backwards compatibility with Python < 3.12 is not required.
- **Modern Type System**:
  - Use PEP 695 type parameter syntax for generics (`def first[T](items: list[T]) -> T:` and `type Coord = tuple[float, float]`).
  - Use PEP 604 pipe syntax for union and optional types (`str | int`, `Path | None`).
  - Use `typing.Self` for methods returning instances of their enclosing class.
  - Strict type annotations are mandatory on all public function signatures, parameters, and return types.
- **Structured Domain Modeling**:
  - Model structured data using `@dataclass(frozen=True)` or Pydantic models. Avoid passing untyped nested `dict` or `tuple` bags across module boundaries.

## 2. Standard Library Primacy & Clean APIs
- **Path Operations**: Always use `pathlib.Path` for filesystem path manipulation. Never use `os.path` concatenation or raw string formatting for paths.
- **Subprocess Safety**: Always invoke `subprocess.run(..., check=True)` passing arguments as a sequence (`list[str]`). Never set `shell=True` unless strictly required and arguments are safely quoted.
- **Structured Logging**: Use the standard `logging` module with structured formatting. Never use raw `print()` statements in application logic or service workflows.
- **Centralized Manifests**: Declare package dependencies, entry points, and toolchain configurations centrally in `pyproject.toml` (PEP 517/518/621).

## 3. Anti-Pattern Defenses & Error Propagation
- **Zero Mutable Defaults**: Never use mutable default arguments (`def fn(items=[])` or `def fn(config={})`). Always default to `None` and initialize defensively:
  ```python
  def fn(items: list[str] | None = None) -> list[str]:
      resolved_items = items if items is not None else []
  ```
- **Explicit Exception Boundaries**:
  - Never use bare `except:` or catch-all `except Exception: pass`.
  - Always catch the narrowest specific exception type possible.
  - Always preserve exception context when re-raising: `raise ServiceError("Failed to fetch") from err`.

## 4. Resource Safety & Concurrency
- **Deterministic Cleanup**: Always manage file descriptors, network connections, database sessions, and locks using `with` or `async with` context managers.
- **Structured Concurrency**: In asynchronous code, orchestrate concurrent coroutines using `asyncio.TaskGroup` instead of unconstrained background tasks (`asyncio.create_task`).
- **Zero Event-Loop Blocking**: Never execute blocking synchronous calls (`time.sleep`, `requests.get`, synchronous file I/O) within asynchronous coroutines; route blocking operations through `asyncio.to_thread()`.
