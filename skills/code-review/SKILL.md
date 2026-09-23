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

## Severity (text only — no emoji)
- **Critical** — must fix before merge (bugs, security, data loss, undefined behavior)
- **Important** — should fix (quality, performance, maintainability, over-engineering)
- **Suggestion** — nicer alternative
- **Nit** — style; label as nit

## Universal Checklist
**Correctness:** does what it claims; edge and error paths; no obvious races.

**Safety & Security:** inputs validated; no injection; no hardcoded secrets; errors do not leak secrets.

**Performance:** no obvious extra work on hot paths; I/O/allocs reasonable; concurrency used correctly.

**Maintainability:** readable names; complex logic explained or simplified; public APIs intentional.

**Over-Engineering & YAGNI:** no unrequested abstractions; no interface with only one implementation; no factory for a single product; no new external dependencies when stdlib or existing libraries suffice; deliberate minimal simplifications note their ceiling (`# ponytail: <limit>`).

**Testing:** important paths and edges covered; tests assert behavior, not coverage theater.

## Language Pointers
- **Python:** `python-pro` + ruff; no mutable defaults; no bare `except:`; context managers; `pathlib`.
- **Rust:** `rust-pro`; no `.unwrap()` in non-test prod; `// SAFETY:` on unsafe; no locks across `.await` (`rust-async-patterns`).

## Output Format
1. **Summary** — 1–3 sentences
2. **Findings** — Critical → Nit
3. **Positive notes** — if any
4. **Questions** — if any

Each finding: severity, file:line, description, suggested fix, why it matters.

## Tone
Direct, professional, constructive. Prefer “This can cause…” over “You should…”.
