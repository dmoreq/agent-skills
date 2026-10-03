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
- **CPU / runtime**: `py-spy` (non-intrusive sampling for live processes), `cProfile` (deterministic), `scalene`
- **Memory**: `memray` (SOTA heap profiler, tracks native C and Python allocations, generates flamegraphs), `scalene`, `tracemalloc`
- **Line-level**: `line_profiler` or sampling profilers
- **I/O**: timing/logs or async-aware profilers

Use `time.perf_counter` / `timeit`, not `time.time()`. Ignore micro-gains off the critical path.

### 3. Classify

| Type | Signs | Direction |
| :--- | :--- | :--- |
| **CPU-bound** | High CPU, pure compute | Algorithm, vectorization (NumPy/Polars), SIMD libraries, concurrency |
| **I/O-bound** | Waiting on net/disk/DB | Async, batching, caching, connection pooling |
| **Memory-bound** | High RSS, GC pressure, OOM | `memray` flamegraph, generators, `@dataclass(slots=True)`, `memoryview` |
| **Database** | Slow queries, N+1 queries | Indexes, query shape, batch fetching |
| **Algorithmic** | Scales poorly with n (O(n²)) | Better complexity, early exit, hash lookups |

### 4. Apply (in order)
1. Better algorithm or data structure (replace linear search with dict/set, early exit).
2. Less work (memoize/cache with `@functools.lru_cache`, batch operations).
3. **Drop-in SIMD / Native Accelerators**:
   - JSON parsing: `orjson` (Rust-based, 5x–10x faster serialization of datetime, dataclasses, dicts).
   - Fuzzy string matching: `rapidfuzz` (C++ bindings, 10x–50x faster than fuzzywuzzy).
   - Large text search & hashing: `stringzilla` (C/SIMD vector instructions on AVX2/NEON).
   - Data processing: `polars` (Rust arrow engine) over Pandas.
   - Zero-copy buffer slicing: `memoryview` and `bytearray` (prevents intermediate string copies).
   - Memory footprint: `@dataclass(slots=True)` (eliminates `__dict__`, reducing RAM by 40–60%).
4. Concurrency or parallelism only when workload matches (`python-concurrency`).
5. Low-level tricks or Rust FFI (`pyo3-maturin`) last.

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
