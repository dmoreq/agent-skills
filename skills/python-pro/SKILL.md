---
name: python-pro
description: "Master modern Python (3.12+) with typing, Protocol-driven architecture, uv, ruff, pyright, and production practices. Adapts to target runtime constraints."
risk: safe
source: local
date_added: "2026-02-27"
---

# Modern Python Skill

Expert guidance for writing clean, typed, idiomatic, and production-ready Python code, with strong preference for Python 3.12+ practices when possible.

## When to Use
- Writing or reviewing Python code or module architecture
- Setting up or modernizing a Python project
- Implementing async workflows, data processing, or performance-sensitive code
- Designing production services, internal libraries, APIs, or tooling in Python

## When Not to Use
- Non-Python stacks
- Basic syntax questions only

## Related Skills
- Use **python-patterns** for framework, domain modeling, and distributed system decisions.
- Use **python-concurrency** for async, multiprocessing, or thread execution choices.
- Use **python-testing** to protect behavior with test suites.
- Use **context7-mcp** for current library/API documentation.
- Use **code-review** before merge.

## Version Handling
Always confirm the target Python version first.

### Python 3.12+ (Preferred)
- Use modern syntax freely: `type` statements (PEP 695), native generics syntax, enhanced f-strings, override decorators (`@typing.override`).

### Python 3.8–3.11 (Legacy / Constrained)
- Stay strictly compatible with the target version runtime.
- Apply modern practices supported via `typing_extensions` where acceptable (`Protocol`, `ParamSpec`, `TypeGuard`).
- Avoid version-locked syntax and builtins.
- Note limitations and potential benefits of a future upgrade when relevant.

## Core Principles
- **Newest features allowed**: Prefer the newest Python features permitted by the target version.
- **Functions and data over gratuitous OOP**: Avoid single-method classes or classes that act solely as namespaces. Prefer module-level functions and immutable/typed data structures (`dataclass(slots=True)`, Pydantic models).
- **Loose coupling via structural subtyping**: Prefer `typing.Protocol` (duck typing) for dependency inversion over rigid `abc.ABC` inheritance trees.
- **Clear API boundaries**: Define explicit public interfaces via `__all__` in modules and packages; use a leading underscore (`_name`) for internal implementation details.
- **Avoid premature abstraction**: Follow the Rule of Three before introducing shared helpers or base protocols; accidental duplication is cheaper than the wrong abstraction.
- **Strong static typing**: Enforce end-to-end type hints (`typing`, `collections.abc`) targeting strict static analysis (`pyright` or `mypy`).
- **Practical test discipline**: Favor DAMP (Descriptive And Meaningful Phrases) over aggressive DRY in test suites; prioritize test isolation and readability.
- **Modern tooling defaults**: Prefer modern, high-performance tooling (`uv`, `ruff`, `pyright`/`mypy`).
- **Default to `pyproject.toml`**: Maintain centralized project metadata and tool configs.
- **Standard library first**: Use the standard library when sufficient; introduce dependencies only with clear justification.
- **Zero side effects on import**: Modules must never perform heavy I/O, database connections, or compute during import.

## Recommended Defaults (adapt to version)
- **Package & environment**: `uv` (if supported) or compatible virtualenv workflow
- **Lint + format**: `ruff`
- **Type checking**: `pyright` (strict mode where viable) or `mypy`
- **Testing**: `pytest`
- **Configuration & metadata**: `pyproject.toml`
- **Data structures & validation**: `dataclasses` with `slots=True` for light internal models; `pydantic` v2 for serialization, validation, or boundary I/O
- **API**: `FastAPI` for HTTP services; `typer` or `click` for CLI tools
- **Dependency contracts**: `typing.Protocol` for swappable interfaces and test doubles

## Working Approach
1. Confirm Python version, target runtime environment, and project constraints.
2. Define module boundaries, public interfaces (`__all__`), and data contracts (`dataclasses`/`pydantic`/`Protocol`).
3. Choose patterns and dependencies suitable for the target version, favoring flat, functional structures over deep class hierarchies.
4. Implement core logic with clear type hints, zero import-time side effects, and explicit error handling.
5. Add isolated, descriptive tests using `pytest` (prioritizing DAMP assertions).
6. Run formatting, linting (`ruff`), and static type checks (`pyright`/`mypy`).
7. Profile and optimize only when backed by measurement.

## Output Expectations
- Code fully compatible with the specified Python version
- Explicit type hints across all function signatures and data definitions
- Minimal, clean module surface with explicit `__all__` where appropriate
- Protocols for external dependencies to facilitate easy testing and loose coupling
- Descriptive tests or test-writing guidance (DAMP approach)
- Minimal, justified external dependencies

## Final Checklist
- [ ] Target Python version is confirmed and respected
- [ ] Module uses functions/dataclasses where classes are unnecessary
- [ ] Public entry points are explicit (`__all__` defined, private helpers prefixed with `_`)
- [ ] External dependencies are abstracted via `Protocol` or passed in explicitly (DIP)
- [ ] No heavy computation or network/disk I/O happens during module import
- [ ] Type hints are complete and compatible with the target version
- [ ] Tooling recommendations match the environment (`uv`, `ruff`, `pyproject.toml`)
- [ ] Error handling is explicit (no bare `except:`)
- [ ] Tests prioritize clarity and isolation over premature DRY test helpers
- [ ] Limitations due to older Python versions are explicitly noted when applicable
