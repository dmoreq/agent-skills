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
- Lint + format: `ruff` (enforce complexity: `C901` max-complexity = 10, `PLR0912` max-branches = 12, `PLR0915` max-statements = 50)
- Cognitive Complexity audit: `complexipy` (target score <= 15 per function)
- Types: `pyright` (strict where viable) or `mypy`
- Quality gates: `pre-commit` (ruff-check, ruff-format, pyright, bandit, complexipy ratchet, vulture, pip-audit)
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
5. Run `ruff` (with `C901` complexity checks) and `pyright`/`mypy`.
6. Provision or verify pre-commit quality gates before declaring setup complete.
7. Profile only when there is a measured hotspot (`python-performance`).

## Pre-commit & Repository Quality Gate Setup

When creating or modernizing a Python project, verify if `.pre-commit-config.yaml` exists. If missing or incomplete, provision the standard configuration:

### 1. Canonical `.pre-commit-config.yaml`
```yaml
repos:
  # Standard hygiene and file guards
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.6.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
        exclude: ^complexipy-snapshot\.json$  # complexipy writes without trailing newline
      - id: check-yaml
      - id: check-added-large-files
        args: ['--maxkb=4000']
      - id: check-json
      - id: check-toml
      - id: check-merge-conflict
      - id: debug-statements
      - id: mixed-line-ending
      - id: check-docstring-first
      - id: check-case-conflict
      - id: detect-private-key

  # Ruff - Fast Python linter and formatter
  - repo: https://github.com/astral-sh/ruff-pre-commit
    rev: v0.16.10
    hooks:
      - id: ruff-check
        args: [--fix, --exit-non-zero-on-fix]
      - id: ruff-format

  # Type checking with Pyright (uses local python environment with installed packages)
  - repo: local
    hooks:
      - id: pyright
        name: pyright
        entry: pyright
        language: system
        types: [python]
        pass_filenames: false

  # Security checks with Bandit
  - repo: https://github.com/PyCQA/bandit
    rev: 1.7.10
    hooks:
      - id: bandit
        args: ["-c", "pyproject.toml"]
        additional_dependencies: ["bandit[toml]"]
        exclude: ^(tests/|eval/)

  # Cognitive complexity ratchet (freezes legacy hotspots in snapshot)
  - repo: https://github.com/rohaquinlop/complexipy-pre-commit
    rev: v8.0.1
    hooks:
      - id: complexipy
        args: [--max-complexity-allowed=15, <target_packages>]
        pass_filenames: false

  # Dead code detection (high-confidence cross-module findings)
  - repo: https://github.com/jendrikseipp/vulture
    rev: v2.16
    hooks:
      - id: vulture
        args: [--min-confidence=80, <target_packages>]
        pass_filenames: false

  # Validate pyproject.toml structure
  - repo: https://github.com/abravalheri/validate-pyproject
    rev: v0.22
    hooks:
      - id: validate-pyproject

  # Dependency security scanning via PyPA pip-audit
  - repo: https://github.com/pypa/pip-audit
    rev: v2.7.3
    hooks:
      - id: pip-audit
        args: ["-r", "requirements.txt"]
        files: ^(requirements\.txt|pyproject\.toml)$
```

### 2. Standard Makefile Integration
Always configure standard pre-commit targets in `Makefile`:
```makefile
pre-commit-install:
	pre-commit install

pre-commit-run:
	pre-commit run --all-files
```

### 3. Provisioning & Verification Protocol
1. Add `pre-commit` to `[project.optional-dependencies] dev` in `pyproject.toml`.
2. Write `.pre-commit-config.yaml` with the project package directories in `complexipy` and `vulture`.
3. If legacy functions exceed cognitive complexity 15, initialize the watermark baseline:
   `complexipy <packages> --max-complexity-allowed 15 --snapshot-create`
4. Run `pre-commit install && pre-commit run --all-files` to verify all hooks pass cleanly.

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
- [ ] Complexity within limits (Cyclomatic <= 10, Cognitive <= 15, Nesting <= 3)
- [ ] Pre-commit quality gates provisioned and passing cleanly
- [ ] No bare `except:`
- [ ] Older-runtime limitations noted when applicable
