---
name: python-performance
description: >-
  Profile and fix Python runtime, memory, or I/O bottlenecks with evidence (cProfile, py-spy, scalene).
  Not for accuracy/F1/quality KPI loops or unmeasured micro-optimizations.
risk: safe
source: local
date_added: "2026-02-27"
---

# Python Performance Optimization Skill

Find and fix real performance problems. Measure first.

Load `resources/implementation-playbook.md` **only** for a named profiler recipe (cProfile, py-spy, tracemalloc, scalene). Do not load it for process or policy.

## When to Use
- Slow Python, high latency, CPU, or memory
- Data-processing, I/O, or DB access that is measurably expensive
- Before/after profiling of a change

## When Not to Use
- No evidence of a performance problem
- Quality KPIs (accuracy, F1, confidence) → **algorithm-optimization**
- Premature optimization off the critical path
- Non-Python performance

## Related Skills
- Use **python-concurrency** when the bottleneck is I/O-bound or needs CPU parallelism.
- Use **pyo3-maturin** when a confirmed CPU hotspot cannot be accelerated further in Python.
- Use **algorithm-optimization** for quality KPIs on real cases, not runtime.

## Core Principles
1. Measure first — never optimize from guesses.
2. Fix the actual hotspot, not the whole codebase.
3. Simple readable fixes before rewrites.
4. Re-measure after each meaningful change.
5. Stop when the target is met.

## Optimization Process

### 1. Clarify Goals
Latency, CPU, memory, or throughput? Numeric target? Constraints (Python version, deps, architecture freeze)?

### 2. Profile
- **CPU / runtime**: `cProfile`, `py-spy`, `scalene`
- **Memory**: `tracemalloc`, `scalene` (`memory_profiler` if already in the repo)
- **Line-level**: `line_profiler` or sampling profilers
- **I/O**: timing/logs or async-aware profilers

Use `time.perf_counter` / `timeit`, not `time.time()`. Ignore micro-gains off the critical path.

### 3. Classify

| Type | Signs | Direction |
| :--- | :--- | :--- |
| **CPU-bound** | High CPU, pure compute | Algorithm, vectorization (NumPy/Polars if dataframes), concurrency |
| **I/O-bound** | Waiting on net/disk/DB | Async, batching, caching, pooling |
| **Memory-bound** | High RSS, GC pressure | Generators, in-place ops, smaller structures |
| **Database** | Slow queries, N+1 | Indexes, query shape, batching |
| **Algorithmic** | Scales poorly with n | Better complexity, early exit |

### 4. Apply (in order)
1. Better algorithm or data structure
2. Less work (cache, batch, skip repeats)
3. Better libraries (Polars/NumPy where the repo already processes tables/arrays)
4. Concurrency only when appropriate
5. Low-level tricks last

### 5. Validate
Same benchmark as baseline. Correctness preserved. Gain worth the complexity.

## Output Expectations
- Bottleneck statement with profiler evidence
- Prioritized changes
- Before/after when possible
- Trade-offs

## Final Checklist
- [ ] Goal and constraints clear
- [ ] Profiled before changing
- [ ] Bottleneck type named
- [ ] Changes target the hotspot
- [ ] Re-measured
- [ ] Correctness preserved
