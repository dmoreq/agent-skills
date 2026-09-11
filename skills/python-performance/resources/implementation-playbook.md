# Python Performance Recipes

Load this file only for a named profiler recipe. Policy lives in `SKILL.md`.
Use `time.perf_counter` or `timeit`, never `time.time()`.

## cProfile (CPU)

```python
import cProfile
import pstats
from pstats import SortKey

profiler = cProfile.Profile()
profiler.enable()
main()
profiler.disable()
stats = pstats.Stats(profiler).sort_stats(SortKey.CUMULATIVE)
stats.print_stats(20)
stats.dump_stats("profile.prof")
```

```bash
python -m cProfile -o output.prof script.py
```

## py-spy (running process / flamegraph)

```bash
py-spy top --pid <PID>
py-spy record -o profile.svg --pid <PID>
py-spy record -o profile.svg -- python script.py
```

## scalene (CPU + memory)

```bash
scalene script.py
```

Prefer scalene when both CPU and allocation matter. Use `tracemalloc` for allocation diffs:

```python
import tracemalloc

tracemalloc.start()
s1 = tracemalloc.take_snapshot()
run_workload()
s2 = tracemalloc.take_snapshot()
for stat in s2.compare_to(s1, "lineno")[:15]:
    print(stat)
tracemalloc.stop()
```

## line_profiler (hot function)

```bash
kernprof -l -v script.py   # functions decorated with @profile
```

## High-leverage fixes (only after a profile)

- Better complexity / data structure (set/dict membership, not list scans)
- Batch I/O and DB writes; fix N+1
- Generators/streaming for large data
- Vectorized table/array work: **Polars** or NumPy if the repo already uses them
- `functools.lru_cache` for pure expensive functions
- I/O concurrency → `python-concurrency`; remaining CPU hotspot → `pyo3-maturin`

Do not: inline functions for speed, prefer `map(lambda)` over listcomps, or jump to Cython/PyPy without `tech-research`.
