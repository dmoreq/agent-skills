# Public API and export audits

Use this procedure when reviewing every export of an existing package, including purpose, actual usage, contracts, and algorithm suitability.

## 1. Define the surface before counting it

1. Read the package facade, domain modules, repository instructions, and dependency manifest.
2. Parse Python files with `ast.parse`; collect explicit `__all__`, public definitions, and relative re-exports separately.
3. For modules without `__all__`, inventory implicit bindings rather than reporting zero exports.
4. Include actively imported names omitted from `__all__`; explicit imports remain compatible APIs even when wildcard exports omit them.
5. Record rows keyed by `(module, binding)` with definition location, export category, and consumer references. Save CSV/JSON and verify uniqueness/counts programmatically.
6. Resolve explicit exports in a controlled local import only after checking import-time effects. Check missing attributes and duplicate `__all__` names.

Report facade entries, explicit export entries, and broad bindings as different quantities. Count re-exports explicitly; they are not distinct implementations. Do not describe imported support names as deliberate public APIs without evidence.

## 1a. Audit against the changelog, not against your memory of the code

For a "what legacy is still here" audit of a live package, the changelog is the contract to diff the tree against, and it is the cheapest source of high-value findings:

1. Read the changelog's `Removed` / `Deprecated` / `Planned` entries and turn each into a claim about the current tree. A changelog that promises removal "at the next major" and lists names still present is not a bug — but it pins which removals are breaking and which are settled.
2. Count each documented set at runtime and compare to the frozen guard. `len(pkg._DEPRECATED_NAMES)` beside the test's `FROZEN_*_COUNT` and the `__all__` list catches aliases added without a test edit, and aliases quietly dropped without a changelog entry.
3. A name marked removed from the facade may still bind in its submodule. Report facade status and submodule status as two columns; "removed" against a still-importable path is the mismatch the reader needs.
4. Diff documentation against the tree. Architecture diagrams and READMEs naming a symbol that only survives as a legacy alias are a live source of user confusion, so record them as findings even when the code itself is correct.
5. Read any existing cleanup plan in the repo before proposing removals. A prior plan usually already holds executed evidence (ablation results, deletion batches, rejected proposals with reasons). Restating its conclusions as new findings wastes the review; extending it with what it missed is the contribution.

## 1b. Separate names that collide by label

A user complaint about one mechanism often names a family of same-labelled mechanisms with different owners and different verdicts. Enumerate the distinct implementations behind the label before evaluating any of them, and verdict each separately:

| What shares the label | How to tell them apart |
|---|---|
| Retrieval-stage merge | Runs in the decoder/parser, merges raw hits before scoring |
| Ranking-stage merge | Runs after scoring, absorbs or replaces scored candidates |
| Shared helper inside the same module | Same module, no call site outside it — genuinely dead |
| Domain representation | Parent–child identity, not a duplicate suppression at all |

Do not let a removal upstream in one package mark an active path in another package as legacy. Prove the active path with a paired replay before proposing its removal: current routing against the candidate rule disabled, on identical frozen inputs. A large hit-rate drop is evidence the code is load-bearing, and the finding becomes "rename or document this as active" rather than "delete". State the measured deltas, and label an unfinished replay as unfinished rather than quoting it as a completed result.

## 1c. Verify deadness by executing, never by grepping alone

Grep establishes a candidate; execution establishes the verdict. Finish an audit with real probes, and structure the output so each verdict is falsifiable:

- For a symbol: `grep -rn <name> .` counting hits *outside* its own definition, then the alias/`__all__` registry, then sibling packages. Zero outside the registry is "no internal caller"; it is not "no consumer".
- For an object's constructor: pass a nonsense keyword and a superseded keyword, print the resulting fields, and record whether it raised. A `**kwargs` catch-all that never raises is a silent-data-loss finding, not a style nit.
- For a parameter: `inspect.getsource` and check the name appears outside the docstring.
- For a bool/config default: `is` not `==` (`bool(...) is True`, not `bool(...) == True`) — `==` passes on `1`.
- For a shared constant: compare identity (`alias is impl`) in one probe, not per-site inspection.
- For a test that claims parity: assert the two sides are not the same object, or the green result proves nothing.

Run the probes in one batch, print a compact verdict line per item, and carry those verdicts into the report. A table of `path:line`, mechanism, verdict, and the exact probe that produced it is the deliverable.

When the audit surfaces a silent-failure class (a catch-all kwargs tail, a self-comparing test), rank it above the cosmetic dead names. Order the findings by what breaks a caller versus what merely confuses a reader, and say which one you would fix first and why.

## 2. Trace actual consumers

- Resolve relative imports using package context, for example `importlib.util.resolve_name`, and track aliases plus module-attribute references.
- Separate internal composition, runtime consumers, tests, and compatibility re-exports. An import is evidence of a reference, not proof of runtime execution.
- Manually inspect dynamic lookup and facade paths before declaring a symbol unused; static analysis cannot establish their absence.
- Before declaring a binding unused, search sibling packages that import the library, not only the defining package tree. A constant moved into a shared module is often the cross-package source of truth. A sibling `from package.module import name` succeeds on a module-level binding even when `__all__` omits the name; deleting that binding breaks the sibling.
- A name that appears only as the source of a compiled pattern is not unused. Callers import the pattern.
- For each domain, record purpose, input representation, output/capture semantics, callers, tests, and suitability verdict.
- Delegate by disjoint domain modules when broad context warrants it. Keep integration review and cross-domain invariants with the parent.

Do not stop at an inventory and claim a deep review is complete. Inventory establishes coverage; consumer inspection establishes semantic findings.

## 3. Probe contracts at their boundaries

Prioritize a small counterexample matrix over broad speculative rewrites:

| Contract | Probe |
|---|---|
| Token boundaries | Full words, embedded substrings, punctuation-ending abbreviations, compact versus spaced identifiers |
| Normalization | Raw versus folded text, NFC/NFD, repeated whitespace, case, punctuation |
| Capture offsets | Assert `source[start:end] == group` for full and subgroup spans, including empty captures |
| Search positions | Negative, zero, valid positive, and beyond-end positions; compare with the promised adapter semantics |
| Canonical identity | Equivalent aliases must produce equal canonical names, regardless of insertion order |
| Code set versus name map | A code set equal to a table is not proof the name map is that table. Strip display prefixes, count alias residue, and do not treat a reused code in another generation table as the live resolver result until that resolver is executed |
| Extraction versus predicates | Beginning/middle/end positions; suffix extraction must not stand in for keyword presence |
| Contextual numbers | Prevent a later street/door number from becoming evidence for an earlier administrative or hamlet identifier |
| Limits and precedence | Zero/negative limits, duplicate payloads, overlapping types, stable match ordering |
| Overlapping correction tables | Apply the whole string under longest match. The first short pattern that matches is not the table's result |

Trace the counterexample through a real parser, scorer, cleaner, or classifier. Preserve the qualification when only the low-level API fails. A misleading confidence or ranking score can be more consequential than a missed token.

Keep source coordinates separate from normalized-text coordinates. Do not repair whitespace or Unicode handling by losing the ability to slice the original source.

## 4. Verify without masking regressions

1. Run relevant existing tests once and retain exact command/output scope.
2. Independently reproduce important delegated failures; this is evidence review, not repetition of an identical passing test command.
3. Search sibling consumers for the same contract error before recommending a local patch.
4. Specify positive, negative, and end-to-end acceptance cases for each recommendation.
5. Separate mechanical reuse/export cleanup from behavior changes.

Do not change golden snapshots to make a proposed correction pass. Existing behavior may encode deliberate compatibility; expose the conflict rather than silently redefining it.

## 5. Deliver a decision-ready review

Lead with whether to retain the architecture. Present reproduced findings by impact, then a module-purpose/usage matrix, verification scope, and deferred decisions. Attach the complete symbol inventory rather than dumping hundreds of bindings into chat.

When the ask is consolidation or unification into a structured artifact, group exports by purpose first. Give each group one verdict: keep compiled, derive, extend the existing table, generate, or delete. Do not write one paragraph per binding. Overlap percent is not a merge license; name the residue and any same-name sets that are different contracts.

Keep these claims separate:
- A conventional algorithm fits the workload.
- Its implementation and consumers honor the contract.
- It outperforms alternatives on a common evaluation set.

Only the last supports a comparative best-in-class claim. Include output-sensitive matching and postprocessing costs when discussing complexity; a linear discovery primitive does not make the entire pipeline linear.

For implementation handoffs, use `technical-reporting` and its existing handoff reference. Preserve evidence labels, dirty-tree context, acceptance criteria, bounded first-package scope, and deferred policy questions rather than copying the conversation wholesale.
