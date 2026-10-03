---
name: python-concurrency
description: >-
  Choose and implement asyncio vs ThreadPoolExecutor vs ProcessPoolExecutor for a Python workload.
  Not for FastAPI vs Django, native Rust extensions, or runtime profiling.
risk: safe
source: local
date_added: "2026-02-27"
---

# Python Concurrency & Parallelism Skill

Select the right concurrency or parallelism model for the workload.

- `asyncio` for **I/O-bound** concurrency.
- `ProcessPoolExecutor` / `multiprocessing` for **CPU-bound** work (default on GIL builds).
- `ThreadPoolExecutor` for legacy/blocking I/O without a full async rewrite.

## When to Use
- Designing async services (FastAPI, aiohttp, Starlette) once the framework is already chosen
- High-concurrency I/O (HTTP, DB, files, sockets)
- Parallel CPU jobs (transforms, image/video, large parsing)
- Offloading blocking I/O or CPU from an event loop
- Deciding among asyncio, threads, and processes

## When Not to Use
- Framework / layout still open (`python-patterns`)
- Measuring whether concurrency helps (`python-performance`)
- Native CPU rewrite (`pyo3-maturin`)
- Sequential scripts with no concurrency need
- Non-Python stacks

## Related Skills
- Use **python-performance** to measure whether the model actually helps.
- Use **python-testing** for cancellation/timeout/exception paths.
- Before merge: **code-review**.

## 1. Decision Guide

| Workload | Model | Avoid | Why |
| :--- | :--- | :--- | :--- |
| High I/O wait | **`asyncio`** | `multiprocessing` | Many waiters, low memory |
| CPU-bound (GIL build) | **`ProcessPoolExecutor`** | Pure `asyncio` | Bypass GIL across cores |
| CPU-bound (free-threaded CPython is the **repo standard**) | threads or processes as measured | Assuming GIL still applies | Confirm with `python-performance` |
| Simple blocking I/O / legacy SDK | **`ThreadPoolExecutor`** | Full async rewrite | Cheap concurrency for blocking C/sync code |
| Mixed I/O + CPU | **`asyncio` + ProcessPool offload** | CPU on the event loop | Keep the loop responsive |

## 2. Core Principles
1. Match model to workload.
2. Structured concurrency: `TaskGroup` (3.11+) over fire-and-forget.
3. Never block the event loop: blocking I/O → `ThreadPoolExecutor`; heavy CPU → `ProcessPoolExecutor`.
4. Timeouts, cancellation, and resource cleanup by default.
5. Do not force async onto simple sync or CPU-only jobs.

## 3. Parallel CPU
Use `concurrent.futures.ProcessPoolExecutor` or `multiprocessing`.

- Process spawn and IPC are expensive; batch coarse jobs.
- Arguments/results must pickle (unless using shared buffers).
- No shared memory by default.

```python
loop = asyncio.get_running_loop()
result = await loop.run_in_executor(process_pool, cpu_heavy_function, data)
```

## 4. Modern Async Patterns (Python 3.11+)
- **Structured Concurrency with `TaskGroup`**:
  Use `asyncio.TaskGroup` instead of `asyncio.gather`. If one task fails, all sibling tasks are cancelled and awaited automatically:
  ```python
  async with asyncio.TaskGroup() as tg:
      task1 = tg.create_task(fetch_a())
      task2 = tg.create_task(fetch_b())
  # Both tasks completed cleanly, or ExceptionGroup raised
  ```
- **Handling Composite Errors (`except*`)**:
  Catch task group errors with PEP 654 syntax:
  ```python
  try:
      async with asyncio.TaskGroup() as tg:
          tg.create_task(fetch_data())
  except* (TimeoutError, ConnectionError) as eg:
      logger.error(f"Network failure: {eg.exceptions}")
  ```
- **Cancellation Hygiene & Shielding**:
  - Never swallow `asyncio.CancelledError` in generic exception blocks. Always re-raise.
  - Protect critical rollback or cleanup from interruption:
    ```python
    try:
        await do_work()
    except asyncio.CancelledError:
        await asyncio.shield(release_lock_or_rollback())
        raise
    ```
- **Backpressure & Flow Control**:
  - `asyncio.Semaphore` for downstream rate limiting.
  - `asyncio.Queue` for producer/consumer pipelines.
  - `asyncio.timeout(seconds)` (Python 3.11+) on external calls.

## 5. Anti-Patterns
- Using `asyncio.gather` without bounds (leaks uncancelled zombie tasks on failure)
- Swallowing `asyncio.CancelledError` via bare `except:` or `except Exception:`
- Running CPU-bound work directly on the event loop (GIL stalls all concurrent I/O)
- Thousands of tiny OS processes for light I/O
- Blocking standard library calls (`time.sleep()`, `requests.get()`) on the event loop

## Output Expectations
- Explicit justification of asyncio vs threads vs processes
- Structured concurrency pattern (`TaskGroup`, `Queue`, `Semaphore`, executor)
- Timeouts and cancellation explicitly handled
- Notes on IPC/process cost when using processes
