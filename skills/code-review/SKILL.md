---
name: code-review
description: >-
  Review a code diff before merge: correctness, safety, performance, YAGNI, tests, public API.
  Not the first skill for implementing features. After findings, hand off fixes to the language skill.
risk: safe
source: local
date_added: "2026-09-11"
---

# Code Review Skill

Rigorous, constructive review of a concrete diff. Review the code, not the author. Zero comments is valid when the diff is good.

## When to Use
- Pull requests or local diffs
- Quality gate before merging behavior or public-API changes
- Looking for bugs, security issues, over-engineering, or missing tests
- Peer-review step for non-trivial subagent code deliverables (diff + contract only)

## When Not to Use
- No code change to review
- Pure design discussion without a diff (`doubt-driven-development` / `python-patterns`)
- Starting a feature from scratch (implement first via `python-pro` / `rust-pro`, then review)

After findings: implement fixes via the language skill. Do not refuse the repair loop.

## Related Skills
- Use **code-simplification** when the main issue is structural complexity or nesting in existing code.
- Use **code-minimalism** when diff contains bloat, unrequested abstractions, or premature dependencies.
- Use **deprecation-migration** when the diff (or review) surfaces a zombie API that should be sunset.
- Use **python-testing** or crate tests when behavior changed without tests.

Language style encyclopedias live in `python-pro`, `rust-pro`, and `rust-async-patterns`. This skill checks that they were applied.

## Review Principles
- Evidence-based, actionable comments
- Distinguish severity
- Explain *why*
- Teach when it is cheap

## Review Workflow & Gates
Execute automated and structural gates before manual semantic review:
1. **Automated Quality Pre-Flight Gate (Execute First)**:
   - If `.pre-commit-config.yaml` exists: run `pre-commit run` (or `make pre-commit-run`).
   - If test suite exists: run verification tests (`pytest -q` or `cargo test`).
   - If pre-commit or tests fail: halt deep review immediately. Report failures as a **Critical** blocker.
   - Never spend manual review effort on mechanical linting, formatting, or typing errors.
2. **Reviewability & Blast Radius Gate**:
   - **Reviewability Budget**: Diff exceeds 400 effective lines of code (excluding lockfiles/fixtures) -> **Important** (request splitting into modular stacked PRs).
   - **Separation of Concerns**: Diff mixes mechanical refactoring with business logic -> **Important** (request isolating refactors into dedicated commits).
   - **Public Surface**: Public function or API signature changed without backward compatibility or version bump -> **Critical**.
3. **Omission Checklist (Verify What Is Missing)**:
   - **Error Path Cleanup**: Are open resources (files, sockets, DB transactions) released in failure branches?
   - **Observability**: Are new error states logged with contextual parameters?
   - **Negative & Edge Tests**: Are boundary cases (empty collections, None inputs, timeouts) covered by tests?
   - **Documentation Sync**: Are `CHANGELOG.md`, `__all__`, or `README.md` updated for public changes?
4. **Semantic & Architectural Review**:
   - Once automated and structural checks pass, inspect the diff against the Universal Checklist.

## Severity (text only — no emoji)
- **Critical** — must fix before merge (bugs, security vulnerabilities, data loss, pre-commit/test failures, breaking API shifts)
- **Important** — should fix (maintainability, complexity violations, missing error handling, missing tests, diff size violations)
- **Suggestion** — nicer alternative with clear technical trade-off
- **Nit** — non-blocking style preference; limit to <= 2 items per review; never block a merge on nits

## Universal Checklist
**Correctness:** does what it claims; edge and error paths; no obvious races.

**Safety & Security:** inputs validated; no injection; no hardcoded secrets; errors do not leak secrets.

**Performance & Concurrency:** no extra work on hot paths; I/O/allocs reasonable; concurrency used correctly; no shared mutable state without locks.

**Maintainability & Complexity:** readable names; complex logic explained or simplified; public APIs intentional.
- Gate: Cyclomatic Complexity > 10, Cognitive Complexity > 15, or Nesting Depth >= 4 -> **Important** (must request simplification via `code-simplification`).
- Gate: Cyclomatic Complexity > 20 or Cognitive Complexity > 20 without architectural rationale -> **Critical**.
- Gate: Unjustified code duplication (> 15 identical lines or cloned logic blocks) -> **Important** (must extract to shared helper).

**Over-Engineering & YAGNI:** no unrequested abstractions; no interface with only one implementation; no factory for a single product; no new external dependencies when stdlib or existing libraries suffice; deliberate minimal simplifications note their ceiling (`# ponytail: <limit>`).

**Testing:** important paths and edges covered; tests assert behavior, not coverage theater.

## Language Pointers
- **Python:** `python-pro` + ruff; no mutable defaults; no bare `except:`; context managers; `pathlib`.
- **Rust:** `rust-pro`; no `.unwrap()` in non-test prod; `// SAFETY:` on unsafe; no locks across `.await` (`rust-async-patterns`).

## Output Format
1. **Summary** — 1–3 sentences stating diff scope, pre-flight gate status, and verdict.
2. **Findings** — Ordered by severity: Critical → Nit.
3. **Positive notes** — Highlight clean patterns or effective tests (if any).
4. **Questions** — Clarify ambiguous architectural assumptions (if any).

### Finding Format Invariant
Every Critical and Important finding MUST contain:
- **Location**: `path/to/file.py#L42-L46`
- **Failure Scenario**: Concrete input condition or race condition that triggers the defect.
- **Drop-in Fix**: Exact replacement code block ready to apply.
- **Rationale**: Operational impact, security vulnerability, or data loss risk.

## Tone
Direct, professional, constructive. Prefer “This causes…” over “You should…”. Zero comments is valid when the diff is clean.
