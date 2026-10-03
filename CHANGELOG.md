# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased] - (v1.5.0)

### Added
- `code-review`: Automated quality pre-flight gate running `pre-commit run` and test suite before semantic review.
- `code-review`: Reviewability budget (diff <= 400 LOC) and blast radius public surface gates.
- `code-review`: Omission checklist (resource cleanup in error paths, observability/logging, negative/edge tests, docs synchronization).
- `code-review`: Performance & Concurrency review gate guarding shared mutable state across async tasks and worker threads.
- `code-review`: Mandatory drop-in code fix diff and failure scenario for all Critical and Important findings.
- `python-testing`: Property-based testing with `hypothesis` for invariant and parser verification.
- `python-testing`: Determinism and flaky-test guards (`PYTHONHASHSEED=random`, `time-machine` for time freezing).
- `python-testing`: Strict pytest configuration (`addopts = "--strict-markers --strict-config -ra"`).
- `python-pro`: PEP 561 `py.typed` packaging invariant for typed Python libraries.
- `python-pro`: PEP 695 native type aliases (`type`) and generic functions (`def fn[T]()`).
- `python-pro`: Boundary distinction between Pydantic v2 (external I/O) and `@dataclass(slots=True)` (internal hot loops).
- `python-concurrency`: Modern `asyncio.TaskGroup` structured concurrency with `except*` composite exception handling (PEP 654).
- `python-concurrency`: Cancellation hygiene prohibiting swallowing `asyncio.CancelledError`, and `asyncio.shield()` for critical cleanup.
- `python-patterns`: Standard `src/` layout recommendation for production Python libraries.
- `python-patterns`: Three-Tier Model separation (Domain `dataclass(slots=True)` vs API Pydantic vs Persistence Entity).
- `python-patterns`: Boundary configuration pattern using `pydantic-settings`.
- `python-performance`: SOTA memory profiler `memray` (Bloomberg) tracking native C and Python heap allocations.
- `python-performance`: Drop-in SIMD and C-extension accelerator catalog (`orjson`, `stringzilla`, `rapidfuzz`, `polars`).
- `python-performance`: Zero-copy buffer slicing via `memoryview`.
- `pyo3-maturin`: PyO3 0.21+ `Bound<'py, T>` smart pointer idioms enforcing compile-time GIL lifetime checks.
- `pyo3-maturin`: Zero-copy memory buffer exchange via Python buffer protocol (`PyBuffer`) and `numpy` array slices.
- `pyo3-maturin`: Native Polars expression plugin pattern via `pyo3-polars`.

## [1.4.0] - 2026-10-03

### Added
- `python-pro`: Canonical `.pre-commit-config.yaml` template with Ruff, Pyright, Bandit, Complexipy ratchet, Vulture, and Pip-audit.
- `python-pro` & `code-review`: Automated code clone and duplication detection via `jscpd` (target threshold <= 3%).
- `python-pro`: Standard Makefile targets (`pre-commit-install`, `pre-commit-run`, `duplication-check`).

## [1.3.0] - 2026-10-02

### Added
- `rules/AGENTS.md`: Quantitative structural complexity thresholds (Nesting Depth <= 3, Cyclomatic Complexity <= 10, Cognitive Complexity <= 15, Function Length <= 50 LOC).
- `code-simplification`: Refactoring recipes for complexity (Invert & Guard, Dispatch Table, Pipeline and Decomposition).
- `code-review`: Complexity review gates (Important for CC > 10, Critical for CC > 20).
- `python-pro`: Ruff complexity rules (`C901`, `PLR0912`, `PLR0915`).
- `rust-pro`: Clippy cognitive complexity thresholds.

## [1.2.0] - 2026-09-23

### Added
- `rules/AGENTS.md`: Micro-kernel rule architecture with YAGNI code generation ladder.
- `verify-and-stop`: Disciplined execution and termination protocol preventing runaway loops.
- `setup.sh`: Selective Rust installation (`--with-rust` flag, skipping Rust skills by default).

## [1.1.0] - 2026-09-15

### Added
- `rules/AGENTS.md`: Subagent parallel planning and independent peer-review protocol.
- `rules/AGENTS.md`: Simplified Technical English (ASD-STE100) and token discipline standards.

## [1.0.0] - 2026-09-14

### Added
- Initial portable multi-agent customization suite (`setup.sh`, `package.sh`).
- Portable `~/.agents/skills` architecture shared across Antigravity, Cursor, Pi, and Grok.
- 16 core skills for Python, Rust, data science, visualization, and code review.
