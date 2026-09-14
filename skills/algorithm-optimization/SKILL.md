---
name: algorithm-optimization
description: >-
  Improve quality KPIs (accuracy, F1, error rate) on real cases while protecting healthy ones.
  Not for Python runtime/memory profiling.
risk: safe
source: local
date_added: "2026-08-23"
---

# Algorithm Optimization Skill

Systematic workflow to improve algorithms or process flows using real input data and target metrics, without harming already-good performance.

## When to Use
- Optimizing an algorithm or multi-step process against clear metrics
- Improving confidence, accuracy, precision, recall, or similar **quality** KPIs on labeled/real cases
- Diagnosing why some cases perform poorly
- Iteratively fixing weak cases while protecting strong ones

## When Not to Use
- No input dataset or no measurable metric
- Pure conceptual discussion without evaluation data
- Runtime latency/CPU/memory tuning (`python-performance`)
- One-off code cleanup unrelated to quality metrics

## Required Inputs
- Input dataset (or representative samples)
- Target metrics to optimize (e.g. confidence score, accuracy, F1, error rate)
- Current algorithm/process to evaluate
- Definition of "low performance" threshold when available

## Optimization Loop

### Step 1: Run Baseline
- Run the algorithm/process on the input data
- Collect outputs and metric values for each case

### Step 2: Evaluate Performance
- Compute overall metrics
- Rank or segment cases by performance

### Step 3: Filter Low Performance
- Isolate cases below the accepted threshold
- Keep high-performance cases as a regression guardrail

### Step 4: Classify Failure Cause
For each low-performance group, classify:

- **Input data issue** (noise, labeling error, missing fields, invalid format)
  → Document and report; do not force algorithm changes for bad data
- **Algorithm / process issue**
  → Continue to Step 5

### Step 5: Deep Analysis
- Investigate root causes in the algorithm/process
- Identify failure patterns (edge cases, feature gaps, brittle rules, weak models, bad thresholds, pipeline order issues)
- Search for candidate fixes (logic changes, features, parameters, alternative methods)

### Step 6: Plan Safe Improvements
- Propose targeted fixes for the weak cases
- Explicitly check risk to already-good cases
- Prefer changes that are localized, testable, and reversible
- Define success criteria before implementing

### Step 7: Implement, Re-run, and Verify
- Apply the planned improvement
- Re-evaluate on:
  1. Previously low-performance cases
  2. Previously good-performance cases (regression check)
- Outcomes:
  - Improved and no major regression → proceed to Step 8
  - Not improved or unclear → return to Step 4/5 with new evidence
  - Regression on good cases → revise or roll back the change

### Step 8: Report
Default: in-chat baseline vs after table (weak cases + healthy-case regression).
Load **technical-reporting** only if the user asked for a saved markdown file. Cover: baseline, cause classification, changes, before/after, residual risk.

## Guardrails
- **Isolate Root-Cause First**: Always complete diagnostic root-cause isolation before coding fixes.
- **Strict Separation**: Rigorously separate data quality issues (noise, labels, format) from algorithm/process logic issues — never mutate algorithm logic to patch bad data.
- **Regression Protection**: Never optimize only on failing cases without validating against healthy baseline cases.
- **Incremental Changes**: Prefer incremental, evidence-based changes over large rewrites.
- **Stopping Rule**: Stop when metric targets are met or gains are no longer worth the added complexity.

## Related Skills
- Use **data-science** for statistical diagnosis of failure groups.
- Use **python-performance** when the bottleneck is runtime/memory/I/O, not quality KPIs.
- Use **data-visualization** for before/after KPI charts. Saved markdown only if requested (`technical-reporting`).

## Final Checklist
- [ ] Baseline run completed and metrics collected
- [ ] Low-performance cases filtered with a clear threshold
- [ ] Failures classified as data vs algorithm/process
- [ ] Root-cause analysis completed before coding fixes
- [ ] Improvement plan protects existing good performance
- [ ] Changes re-evaluated on both weak and strong cases
- [ ] Final report includes baseline, analysis, changes, and results
