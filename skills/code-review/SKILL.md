---
name: code-review
description: >-
  Review code diffs, audit public APIs, or inspect unpacked repo snapshots for correctness, safety, performance, YAGNI, and test coverage.
  Not the first skill for implementing features from scratch.
risk: safe
source: local
date_added: "2026-09-11"
---

# Code Review Skill

Review concrete diffs or an explicitly scoped existing API surface. Review the code, not the author. Zero findings is valid when evidence supports it.

- Load `references/public-api-audits.md` when auditing all exports, contracts, and consumers of an existing package.
- Load `references/repo-snapshot-review.md` when reviewing an unpacked archive, fresh clone, or colleague handoff with no PR diff.

## When to Use
- Pull requests or local git diffs
- Quality gate before merging behavior or public-API changes
- Looking for bugs, security issues, over-engineering, or missing tests
- Auditing public API exports, contracts, actual consumers, and algorithm suitability
- Reviewing a repo snapshot against its own README claims
- Peer-review step for non-trivial subagent code deliverables (diff + contract only)

## When Not to Use
- No concrete code surface or change to inspect
- Pure design discussion without concrete code (`doubt-driven-development` / `python-patterns`)
- Starting a feature from scratch (implement first via `python-pro` / `rust-pro`, then review)

Keep review-only requests read-only. Implement fixes through the language skill only when requested; an audit backlog is not implementation authorization.

## Related Skills
- Use **code-simplification** when the main issue is structural complexity or nesting in existing code.
- Use **code-minimalism** when the diff contains bloat, unrequested abstractions, or premature dependencies.
- Use **deprecation-migration** when the diff or review surfaces a legacy API that should be sunset.
- Use **python-testing** or crate tests when behavior changed without tests.
- Use **technical-reporting** when saving a formal audit handoff document.

## Review Workflow & Gates

Select the review mode first: diff review (below), package export audit (`references/public-api-audits.md`), or repo snapshot review (`references/repo-snapshot-review.md`).

For all modes:
- Capture git revision and dirty-tree scope; recheck before finalizing if concurrent edits occur.
- Separate static observations, independently executed failures, and proposed fixes. Never present an untested correction as a validated patch.
- Reproduce important delegated findings through the actual consumer when possible.
- Resolve every method and class a README or spec advertises against the built artifact; a documented API absent from the code is a **Critical** finding.
- When reviewing a refactor or deletion plan, verify that old and new paths were executed on identical inputs with matching observable outputs.

For diff reviews, execute automated and structural gates before manual semantic review:
1. **Automated Quality Pre-Flight Gate (Targeted & Deduplicated)**:
   - **Skip Gate for Non-Executable Changes**: If the diff contains only documentation, markdown, or static non-code assets, skip pre-commit and test execution entirely.
   - **Reuse Verified Proof**: If the authoring agent or subagent already provided passing test and lint outputs for this exact diff, do not re-run them.
   - **Targeted Pre-commit Only**: Run only against modified files: `pre-commit run --files <changed_files>` or fast direct checks (`ruff check <files>`, `pyright <files>`). Never run `--all-files` during routine diff reviews.
   - **Targeted Tests**: Run only tests relevant to the modified modules (`pytest -n 4 path/to/changed_test.py` or `cargo test <module>`).
   - If pre-commit or tests fail: halt deep review immediately and report failures as a **Critical** blocker.
2. **Reviewability & Blast Radius Gate**:
   - **Reviewability Budget**: Diff exceeds 400 effective LOC (excluding lockfiles/fixtures) → **Important** (request splitting into stacked PRs).
   - **Separation of Concerns**: Diff mixes mechanical refactoring with behavioral logic → **Important** (request isolating refactors).
   - **Public Surface**: Public signature changed without backward compatibility or version bump → **Critical**.
3. **Omission Checklist (Verify What Is Missing)**:
   - **Error Path Cleanup**: Are open resources (files, sockets, DB transactions) released in failure branches?
   - **Callers of Deleted Symbols**: Did a repo-wide grep confirm every importer (including sibling scripts) was retargeted in the same commit?
   - **Observability**: Are new error states logged with contextual parameters?
   - **Negative & Edge Tests**: Are empty collections, `None` inputs, and timeouts tested?
   - **Documentation Sync**: Are `CHANGELOG.md`, `__all__`, or `README.md` updated for public changes?
4. **Semantic & Architectural Review**:
   - **Correctness**: Does what it claims; edge and error paths; no obvious race conditions.
   - **Safety & Security**: Inputs validated; parameterized queries; no hardcoded or leaked secrets.
   - **Performance & Concurrency**: No extra work on hot paths; no shared mutable state across async tasks/threads without locks.
   - **Maintainability & Complexity**:
     - Cyclomatic Complexity > 10, Cognitive Complexity > 15, or Nesting Depth >= 4 → **Important** (hand off to `code-simplification`).
     - Cyclomatic Complexity > 20 or Cognitive Complexity > 20 without justification → **Critical**.
     - Unjustified code duplication (> 15 identical lines) → **Important**.
   - **Over-Engineering & YAGNI**: No single-implementation interfaces, unrequested dependencies, or speculative abstractions; deliberate shortcuts annotated with `# ponytail: <limit>`.

## Severity Levels (Text Only — No Emoji)
- **Critical** — must fix before merge (bugs, security flaws, data loss, test/lint failures, breaking API shifts)
- **Important** — should fix (complexity violations, missing error handling/tests, diff > 400 LOC)
- **Suggestion** — cleaner alternative with clear technical trade-off
- **Nit** — non-blocking style preference (<= 2 per review; never block merge)

## Output Format
1. **Summary** — 1–3 sentences stating diff scope, pre-flight gate status, and overall verdict.
2. **Findings** — Ordered by severity (`Critical` → `Nit`). Every `Critical` and `Important` finding MUST include:
   - **Location**: `path/to/file.py#L42-L46`
   - **Failure Scenario**: Concrete input or race condition that triggers the defect.
   - **Correction & Acceptance**: Smallest fix direction, drop-in replacement diff when helpful, and regression test criteria.
   - **Rationale**: Operational, security, or data integrity impact.
3. **Positive Notes** — Highlight clean patterns or effective tests (if any).
4. **Questions** — Clarify ambiguous architectural assumptions (if any).
