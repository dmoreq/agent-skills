# Implementation handoffs from code analysis

## Procedure

1. Inspect repository instructions, current branch/status, and the existing documentation layout. Use the reporting skill's dated filename convention.
2. Recover the substantive analysis, including qualifications from independent review. Exclude unsupported findings and do not turn a hypothetical counterexample into an executed reproduction.
3. Identify the baseline as revision plus relevant dirty-tree scope. Warn the implementing agent to recheck source and preserve existing edits.
4. Consolidate findings into stable policy or work-package IDs. Keep source locations, behavior, proposed direction, prerequisites, and counterexamples together.
5. Separate three queues: direct correctness/reuse work; data- or product-dependent changes; domain contracts to preserve. Explain that analytical family percentages are not removable LOC or predicted gains.
6. Define invariants before prescribing abstractions. Include identity coherence, eligibility, evidence ownership, ordering, repeatability, and explanation consistency where applicable.
7. Sequence small packages with concrete acceptance cases. Keep mechanical reuse separate from behavior changes; keep broad reliability defects in a separately selected backlog.
8. List existing utilities to inspect, not guessed imports or proposed symbols presented as existing APIs. State semantic reuse limits.
9. Specify evaluation scope, required artifacts, and blockers. Distinguish frozen-input component experiments from end-to-end retrieval experiments.
10. Add a copy-ready agent prompt that selects the first bounded package, prohibits unrelated changes, and defines the completion report.
11. Write the file, then validate structure and references programmatically. Verify numbered inventory uniqueness/completeness, category totals, balanced fences, and explicit repository paths. A successful file write already verifies persistence; do not reread merely to check the write landed.
12. Report the path and verification briefly. Documentation-only changes do not justify runtime test execution.

## Recommended report outline

- TL;DR and purpose.
- Baseline, scope, evidence status, and limitations.
- Architecture diagnosis and essential contracts.
- Complete policy/work-package inventory with source references.
- Non-negotiable invariants and counterexample tests.
- Phased implementation with acceptance criteria.
- Existing reuse points and implementation constraints.
- Evaluation plan and required quality gates.
- Product/data decisions with safe interim behavior.
- Separate deferred reliability issues.
- Copy-ready implementation prompt and completion checklist.

## Pitfalls

- Preserve reviewer qualifications because projection limitations do not establish absence from the underlying database schema.
- Keep prior verification tied to the reviewed snapshot because dirty files may change while the report is being prepared.
- Do not prescribe golden-snapshot regeneration as a fix because it can hide regressions instead of explaining them.
- Require authorization for live collection or large evaluation jobs because a handoff is not operational approval.
- Mark unresolved policy choices as decisions because an implementation agent may otherwise interpret tentative recommendations as mandatory behavior.
- Include negative and cross-stage tests because isolated positive examples do not establish safe generalization.
- Resolve every cited path from the directory the next agent will start in. A workspace root that is not the package git root makes `package/module.py` the wrong file when the package lives at `package/package/module.py`. Put a resolution table in the baseline. A private helper that builds a similar map is not the public API — compare it to the locked stripper before prescribing reuse.
- When the handoff sequences work packages that share an import graph (drop re-exports, then retarget consumers), tell the implementer that **commit slices must stay import-consistent**: those packages land in one commit if pre-commit typechecks the tree. List dirty paths that must stay unstaged per git root.
- Completion reports that touch Keep-a-Changelog repos should update `[Unreleased]` (or say the repo has no CHANGELOG); do not require inventing a new changelog file in a sibling package.
- Lock suites belong in the package that owns the symbol; forbid lower-layer tests from importing a higher-layer package solely for locks.
