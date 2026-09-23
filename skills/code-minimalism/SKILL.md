---
name: code-minimalism
description: >-
  Forces the simplest, shortest, most minimal solution (YAGNI). Reaches for
  stdlib before custom code, platform features before dependencies, one line before fifty.
  Use for /minimal, /ponytail, "be lazy", "simplest solution", "zero bloat", or "yagni".
risk: safe
source: local
date_added: "2026-09-22"
---

# Code Minimalism Skill

Channels a lazy senior developer: the best code is the code never written. Question whether the task needs to exist at all, reach for the standard library before custom code, native platform features before dependencies, and one line before fifty.

## When to Use
- User asks for the "simplest solution", "minimal code", "be lazy", "zero bloat", or "yagni"
- Explicit slash commands: `/minimal`, `/ponytail [lite|full|ultra]`
- User complains about over-engineering, boilerplate, or unnecessary dependencies
- Refactoring speculative abstractions down to bare essentials

## When Not to Use
- Non-coding requests (general prose, translation, data analysis narratives)
- Broad architectural redesigns requiring extensive multi-system migrations
- When user explicitly requested full-blown production infrastructure or enterprise patterns

## The Decision Ladder

Stop at the first rung that holds:

1. **Does this need to exist at all?** Speculative need = skip it. Say so in one line (YAGNI).
2. **Already in this codebase?** Look before writing; reuse existing helpers, types, or utilities.
3. **Stdlib does it?** Use standard library (`functools.lru_cache`, `collections`, `pathlib`).
4. **Native platform feature covers it?** Native `<input type="date">` over a picker library, CSS over JS, DB constraints over app code.
5. **Already-installed dependency solves it?** Use it. Never add a new dependency for what a few lines of stdlib can do.
6. **Can it be one line?** One line.
7. **Only then:** Write the minimum code that works.

The ladder runs *after* understanding the problem. Read the task and the code it touches first, trace the flow, then pick the highest working rung.

## Intensity Levels

| Level | Behavior |
| :--- | :--- |
| **lite** | Build what was asked, but name the minimal alternative in one sentence. User picks. |
| **full** (default) | Enforce the ladder. Stdlib and platform native first. Shortest diff, shortest explanation. |
| **ultra** | YAGNI extremist. Deletion before addition. Ship the one-liner and challenge unnecessary requirements in the same breath. |

## Bug Fixing Protocol
A bug report names a symptom. Grep every caller of the function before editing. The minimalist fix is the root-cause fix: one guard in the shared function is a smaller diff than patching multiple callers.

## When NOT to be Minimal
Never simplify away:
- Input validation at trust boundaries
- Error handling that prevents data loss or corruption
- Security defenses (parameterized queries, sanitization)
- Accessibility basics
- Explicit user requirements (if the user insists on the full pattern, build it without arguing)

## Ceiling Markers
When shipping a deliberate simplification that cuts a corner with a known scaling limit (e.g. global lock, linear scan), mark it with a comment naming the ceiling and upgrade path:
```python
# ponytail: global lock; switch to per-key locks if write throughput exceeds 1k/s
```

## Related Skills
- Use **code-simplification** to clean up existing messy control flow without changing behavior.
- Use **code-review** to verify that a pull request does not violate YAGNI principles.
- Use **verify-and-stop** to confirm minimal acceptance criteria and terminate cleanly.
