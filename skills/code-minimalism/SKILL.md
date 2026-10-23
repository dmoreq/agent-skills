---
name: code-minimalism
description: >-
  Forces the simplest, shortest, most minimal solution (YAGNI). Reaches for
  stdlib before custom code, platform features before dependencies, one line before fifty.
  Use for /minimal, /ponytail, "be lazy", "simplest solution", "zero bloat", "yagni",
  or auditing generalized mechanisms versus ad-hoc copies.
risk: safe
source: local
date_added: "2026-09-22"
---

# Code Minimalism Skill

Channels a pragmatic senior engineer: the best code is the code never written. Question whether a speculative abstraction needs to exist, reach for the standard library before custom code, native platform features before dependencies, and one clear line before fifty.

- Load `references/generalization-and-export-audits.md` when auditing a codebase for ad-hoc dialect copies, regex/lexer duplication, or vocabulary/export consolidation.
- Load `references/gitignore-optimization.md` when pruning or auditing `.gitignore` and exclusion rules.

## When to Use
- User asks for the "simplest solution", "minimal code", "be lazy", "zero bloat", or "yagni"
- Explicit slash commands: `/minimal`, `/ponytail [lite|full|ultra]`
- User complains about over-engineering, boilerplate, or unnecessary dependencies
- Refactoring speculative abstractions down to bare essentials
- Auditing generalized mechanisms versus domain heuristics and ad-hoc edge-case rules

## When Not to Use
- Non-coding requests (general prose, translation, stakeholder narratives)
- Broad architectural redesigns requiring multi-system migrations (`deprecation-migration`)
- When the user explicitly requests full enterprise scaffolding

## Related Skills
- Use **code-simplification** to clean up messy control flow in existing code without changing behavior.
- Use **code-review** to verify that a pull request respects YAGNI and complexity budgets.
- Use **verify-and-stop** to confirm minimal acceptance criteria and terminate cleanly.

## 1. The YAGNI Decision Ladder

Read the task and trace the code path first, then stop at the first rung that holds:

1. **Does this need to exist at all?** Speculative need = skip it and state why in one sentence (YAGNI).
2. **Already in this codebase?** Reuse existing helpers, types, or utilities—provided their extra transforms are true no-ops on your inputs. If a shared helper also mutates whitespace or expands stems unintentionally, keep the narrower operation or extract only the exact shared core.
3. **Stdlib does it?** Use the standard library (`functools.lru_cache`, `collections`, `pathlib`, `itertools`, `sqlite3`).
4. **Native platform feature covers it?** Use native HTML/CSS (`<input type="date">`), SQL/DB constraints (`UNIQUE`, `CHECK`), or OS primitives before application code.
5. **Already-installed dependency solves it?** Reuse installed packages (`polars`, `pydantic`, `pytest`) rather than adding a new dependency for a 5-line operation.
6. **Can it be one clear function/expression?** Prefer a direct function over a single-implementation interface, factory, or strategy class.
7. **Only then:** Write the minimum working diff.

## 2. Generalization & Bloat Audit Principles

When auditing an existing module for bloat, duplicate dialect branches, or export sprawl (see `references/generalization-and-export-audits.md` for the full 10-step protocol):
1. **Verify Live Execution Paths First**: Grep the production entry point before calling a class "the architecture" or "dead". Exported stage classes used only by tests are false generalizations; symbols imported by sibling packages are live contracts even if omitted from `__all__`.
2. **Separate General Mechanisms, Domain Heuristics, and Entity Exceptions**: Do not equate moving hardcoded rules into a JSON file or a generic rules engine with generalization—a rules framework only relocates exceptions without validating their assumptions.
3. **Measure Hotspots Programmatically with `ast`**: Flag functions > 40 LOC or > 12 branch nodes (`If`, `BoolOp`, `IfExp`), and count duplicate regex/keyword decision sites across the package rather than guessing ad-hoc percentages from filenames.
4. **Lock Public Outputs Before Collapsing Copies**: Run the production entry point on representative inputs and lock public return fields before merging duplicate branches or deleting shims. Separate copy elimination from control-flow reordering into distinct commits.
5. **Keep Commit Slices Import- and Typecheck-Clean**: Dropping a re-export shim and retargeting its callers must land in the same commit so `pre-commit` / `pyright` never sees a broken intermediate tree.

## 3. Intensity Levels

| Level | Behavior |
| :--- | :--- |
| **lite** | Build what was requested, and note the simpler stdlib/minimal alternative in one sentence. |
| **full** (default) | Enforce the YAGNI ladder. Stdlib and platform native first; shortest working diff and explanation. |
| **ultra** | YAGNI extremist. Deletion before addition; challenge unnecessary abstractions immediately. |

## 4. Bug Fixing & Ceiling Markers
- **Root-Cause Minimalism**: Grep every caller of the target function before editing. One guard at the root cause is a smaller, safer diff than patching five callers.
- **Ceiling Markers**: When shipping a deliberate simplification with a known scaling threshold (e.g., in-memory dict, global lock, linear scan), document the ceiling inline:
  ```python
  # ponytail: linear scan over <=500 rules; switch to Aho-Corasick trie if rule count exceeds 5,000
  ```

## 5. What Never to Simplify Away
- Input validation at external trust boundaries
- Error handling that prevents silent data corruption or resource leaks
- Security defenses (parameterized queries, secret hygiene)
- Explicit user requirements

## Final Checklist
- [ ] Stopped at the highest applicable rung of the YAGNI Decision Ladder
- [ ] Zero single-implementation interfaces, speculative configs, or unrequested dependencies
- [ ] Public outputs locked before collapsing duplicate branches or exports
- [ ] Deliberate scaling shortcuts annotated with `# ponytail:` ceiling markers
