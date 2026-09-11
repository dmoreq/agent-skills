---
name: python-pro
description: >-
  Implement or modernize Python modules with typing, uv, ruff, pyright, and pyproject.toml.
  Not for framework choice, concurrency model, runtime profiling, or PR review.
risk: safe
source: local
date_added: "2026-02-27"
---

# Modern Python Skill

Write clean, typed, idiomatic Python. Prefer Python 3.12+ when the runtime allows.

## When to Use
- Writing or modernizing Python modules
- Setting up a Python project (`uv`, `ruff`, `pyright`, `pyproject.toml`)
- Production libraries, APIs, or tooling implementation

## When Not to Use
- Choosing FastAPI vs Django vs layout (`python-patterns`)
- Choosing asyncio vs threads vs processes (`python-concurrency`)
- Profiling latency/CPU/memory (`python-performance`)
- Reviewing a diff (`code-review`)
- Non-Python stacks
- Basic syntax-only questions

## Related Skills
- Use **python-patterns** when architecture (framework/layout/ADR) is still open.
- Use **python-testing** to protect behavior.
- Before merge: **code-review**.

## Version Handling
Confirm the target Python version first.

### Python 3.12+ (Preferred)
Use modern syntax: `type` aliases (PEP 695), native generics, enhanced f-strings, `@override` (`from typing import override`).

### Python 3.10–3.11 (Constrained)
Stay compatible with the runtime. Use `typing_extensions` where the project already allows it (`Protocol`, `ParamSpec`, `TypeGuard`). Avoid 3.12-only syntax. Note upgrade benefits when relevant.

### Python ≤3.9
Unsupported for new work unless the repo MSRV is already pinned there. State the constraint and keep changes minimal.

## Core Principles
- Prefer the newest features the target version allows.
- Functions and data over gratuitous OOP. Prefer `dataclass(slots=True)` or Pydantic at boundaries.
- Structural subtyping: `typing.Protocol` over deep `abc.ABC` trees.
- Explicit public surface: `__all__`; `_name` for internals.
- Rule of Three before shared abstractions.
- End-to-end type hints targeting strict `pyright` or `mypy`.
- Tests: DAMP over aggressive DRY (`python-testing`).
- Tooling: `uv`, `ruff`, `pyright`/`mypy`, `pyproject.toml`.
- Stdlib first; justify new dependencies.
- Zero import-time I/O or heavy compute.

## Recommended Defaults (adapt to version)
- Package & environment: `uv` (or the repo's existing venv)
- Lint + format: `ruff`
- Types: `pyright` (strict where viable) or `mypy`
- Tests: `pytest`
- Config: `pyproject.toml`
- Models: `dataclasses` + `slots=True` internally; Pydantic v2 at I/O boundaries
- HTTP: FastAPI only if `python-patterns` already chose it
- CLI: `typer` or `click`

## Working Approach
1. Confirm Python version, runtime, and project constraints.
2. Define module boundaries, `__all__`, and data contracts.
3. Implement with types, no import-time side effects, explicit errors.
4. Add isolated tests (`python-testing`).
5. Run `ruff` and `pyright`/`mypy`.
6. Profile only when there is a measured hotspot (`python-performance`).

## Output Expectations
- Code compatible with the confirmed Python version
- Type hints on signatures and data definitions
- Minimal public surface
- Protocols for swappable dependencies
- Justified third-party deps

## Final Checklist
- [ ] Target Python version confirmed
- [ ] Functions/dataclasses where classes are unnecessary
- [ ] Public vs private surface explicit
- [ ] Dependencies abstracted via Protocol or injection
- [ ] No import-time I/O
- [ ] Types complete for the target version
- [ ] No bare `except:`
- [ ] Older-runtime limitations noted when applicable
