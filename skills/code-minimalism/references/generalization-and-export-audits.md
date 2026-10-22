# Generalization, Dialect Copy, and Export Consolidation Audits

Load this reference when auditing a package for ad-hoc dialect copies, regex/lexer duplication, or vocabulary and `__all__` export consolidation.

## 1. Classify Mechanisms vs. Accretion

1. **Inspect Live Call Paths & Changelog First**: Check the working tree, `CHANGELOG.md`, and the production entry point before classifying rules. Same-named helpers in sibling packages or different pipeline stages are not automatically duplicates. If a path is active in production, require a paired ablation before proposing removal.
2. **Three-Bucket Taxonomy**: Separate **general mechanisms**, **recurring domain heuristics**, and **entity-specific exceptions**. Moving hardcoded exceptions into JSON or a generic rule engine is not generalization—it only relocates the maintenance burden.
3. **Measure Hotspots with `ast`**: Parse modules with `ast` (not `pygount` or filename heuristics). Flag functions > 40 LOC or > 12 branch nodes (`If`, `BoolOp`, `IfExp`), and count duplicate keyword sets, regex singletons, and decision sites across the package.
4. **Verify Production Wiring**: Grep the public entry point for the stage runner call. An exported stage class imported only by unit tests while production `parse()` runs a private method tuple is a false generalization.

## 2. Collapsing Duplicate Dialect & Regex Logic Safely

1. **Lock Live Outputs First**: Before collapsing duplicate branches or regex ladders, probe the public entry point on representative inputs and lock the returned public fields (never assert private stage names that the refactor will delete).
2. **Share the Decision Function, Parameterize Context Flags**: Two classification ladders that look similar often search different text slices or allow different fallback branches. Pass caller context flags explicitly rather than merging the flag computation.
3. **Preserve Original Span Offsets**: Slice the original input string using match offsets; slicing a normalized/cleaned string drops punctuation, comma segments, and original casing.
4. **Separate Copy Elimination from Reordering**: Collapsing duplicate code onto a shared helper and changing stage execution order are two separate changes. Land copy elimination first; gate any stage reordering behind its own benchmark replay.
5. **Respect Anchor Differences**: Never merge two same-named regex patterns whose anchors differ (`^...$` exact match vs. word-boundary span). Rename the span pattern so callers keep their exact contract.
6. **Audit Implicit Regex Compiles**: A zero `re.compile` count outside the lexer module is not proof if raw metacharacter strings are passed to `str.contains` or concatenated into a grammar builder. Walk AST assignments and trace pattern strings to their consumers.

## 3. Vocabulary & `__all__` Export Consolidation

1. **Search Sibling Importers Before Declaring Dead**: A constant or helper absent from internal callers in its defining package is often the cross-package source of truth for a sibling repository. Grep across all connected/sibling packages first.
2. **Group Exports by Purpose**:
   - **Closed word lists duplicating a knowledge-base table**: Derive from or merge into the canonical table; keep only true spelling/city aliases as a small residue map.
   - **Compiled patterns, lexers, and pure derivations**: Keep in code in the owning domain module.
   - **Module-local pattern builders**: Make private (`_name`) and remove from `__all__`.
   - **Re-export shims**: A module that only re-exports another module's names (including private `_` names) is overlap, not a boundary—retarget callers to the owner module and remove the shim, while preserving the top-level package `__init__.py` facade.
3. **Keep Commit Slices Import- and Typecheck-Consistent**: Dropping a re-export surface and retargeting all consumers (including transitive importers in validators, cleaners, and sibling packages) must happen in the **same commit** so `pre-commit` and `pyright`/`ty` pass on every intermediate commit.
4. **Refresh Complexity / Size Ratchets Cleanly**: When extracting shared helpers triggers a zero-slack module function-count or complexity snapshot hook, run the typechecker first, refresh the snapshot baseline in the same commit, and never bypass hooks with `--no-verify`.
