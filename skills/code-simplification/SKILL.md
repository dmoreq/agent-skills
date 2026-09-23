---
name: code-simplification
description: >-
  Simplify working code without changing behavior (nesting, names, accidental complexity).
  Not for redesign, performance rewrites, or untested risky edits.
risk: safe
source: local
date_added: "2026-08-23"
---

# Code Simplification Skill

Simplify code for clarity and maintainability without changing behavior. Focus on existing working code.

## When to Use
- Code works but is harder to read, maintain, or extend than it should be
- After a feature/fix when implementation feels heavier than needed
- During review when complexity, nesting, duplication, or unclear naming is flagged
- When cleaning recently modified code

## When Not to Use
- Code is already clear enough
- You do not yet understand the code
- Performance-critical path where simpler form is measurably worse
- Broad redesign or rewrite is the real goal
- No tests and behavior is risky to change without characterization first

## Core Principles
1. **Preserve behavior exactly** — same outputs, errors, side effects, and edge cases.
2. **Clarity over cleverness** — explicit readable code beats dense one-liners.
3. **Follow project conventions** — simplify toward local style, not personal taste.
4. **Scope tightly** — default to recently changed code; avoid drive-by refactors.
5. **Simplify incrementally** — one change at a time; keep tests green.

## Process
1. Understand responsibility, callers, edge cases, and existing tests.
2. Identify opportunities:
   - deep nesting → guard clauses / early returns / helpers
   - long functions → split by single responsibility
   - nested ternaries / conditional chains → clear branching or dispatch
   - weak names (`data`, `temp`, `result`) → domain-specific names
   - duplication → shared canonical helper when stable
   - dead code → remove only when confirmed unused
3. Apply one simplification at a time.
4. Verify tests/build still pass.
5. Stop when a new teammate would understand it faster.

## Do Not
- Change behavior to make code "nicer"
- Remove error handling, logging, or guards that encode intent
- Optimize solely for fewer lines of code
- Mix simplification with feature work in the same change/commit
- Over-inline helpers that give useful conceptual names

## Related Skills
- Triggered from **code-review** when structural complexity is flagged.
- Use **code-minimalism** if the primary problem is speculative over-engineering or unnecessary libraries.
- Use **python-testing** (or crate tests) to lock behavior before simplifying.
- Before merge: **code-review**.

## Final Checklist
- [ ] Behavior preserved exactly (inputs, outputs, exceptions, side-effects)
- [ ] Scope limited strictly to intended code (no drive-by refactors)
- [ ] Tests still pass without rewriting assertions to fit new behavior
- [ ] Naming, control flow, and structure are genuinely clearer
- [ ] Diff is reviewable, atomic, and free of unrelated changes
