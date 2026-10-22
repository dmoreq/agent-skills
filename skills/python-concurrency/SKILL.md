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

Select the right concurrency or parallelism model for the workload, enforce structured concurrency, and bound in-flight resources.

- `asyncio` for **I/O-bound** concurrency.
- `ProcessPoolExecutor` / `multiprocessing` for **CPU-bound** work (default on GIL builds).
- `ThreadPoolExecutor` for legacy/blocking I/O without a full async rewrite.

## When to Use
- Designing async services (FastAPI, aiohttp, Starlette) once the framework is already chosen
- High-concurrency I/O (HTTP, DB, files, sockets) and rate-limited remote batch pipelines
- Parallel CPU jobs (transforms, image/video, large parsing)
- Offloading blocking I/O or CPU from an event loop
- Deciding among asyncio, threads, and processes

## When Not to Use
- Framework / layout still open (`python-patterns`)
- Measuring whether concurrency helps (`python-performance`)
- Native CPU rewrite (`pyo3-maturin`)
- Sequential scripts with no concurrency need

## Related Skills
- Use **python-performance** to measure whether the concurrency model actually improves throughput/latency.
- Use **python-testing** for cancellation, timeout, retry, and exception paths.
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
2. Structured concurrency: `asyncio.TaskGroup` (3.11+) over fire-and-forget `gather`.
3. Never block the event loop: blocking I/O → `ThreadPoolExecutor`; heavy CPU → `ProcessPoolExecutor`.
4. Timeouts, cancellation, and resource cleanup by default.
5. Do not force async onto simple sync or CPU-only jobs.

## 3. Resumable & Rate-Limited Remote Batch Pipelines

When running concurrent batch jobs against external APIs, search backends, or databases:
1. **Freeze Manifests Before Dispatch**: Inspect input schema and partition counts first. Persist fixed-seed sampled IDs and partition manifests before issuing requests so interrupted runs resume deterministically without re-sampling.
2. **Separate Worker Concurrency from Transport Rate Limits**:
   - Pipeline calls often fan out into fallback or retry requests. Enforce rate limits (`requests/sec`) at the **HTTP transport boundary** (charging every attempt, including retries and reconnects) rather than assuming worker count caps QPS.
   - Maintain per-worker limiters when quotas are per-worker, plus a shared aggregate limiter when protecting a single downstream service.
3. **Atomic Batch Checkpoints**:
   - Keep in-flight futures bounded (`asyncio.Semaphore` or bounded queue). Write completed partition batches via atomic temp-file rename stamped with manifest/source hashes, and validate existing batch payloads before skipping on resume.
4. **Separate Transport Failures from Empty Results**:
   - Validate both HTTP status and response payload (upstream proxies may return HTTP 200 with an embedded backend 4xx/5xx error).
   - Retry only transient network/5xx/429 errors with explicit backoff; fail fast on permanent 4xx errors; treat a valid zero-hit response as a completed result, never a retry trigger.
5. **Cooperative Stop & Completion Accounting**:
   - Check OS process tables before relaunching to avoid duplicate workers, support cooperative stop-after-partition signals, and verify `completed + failed == input_total` with unique IDs before publishing final metrics.

## 4. Parallel CPU
Use `concurrent.futures.ProcessPoolExecutor` or `multiprocessing`:
- Process spawn and IPC serialization are expensive; batch coarse chunks rather than dispatching tiny per-item tasks.
- Arguments and return values must be picklable (or use `multiprocessing.shared_memory`).

```python
loop = asyncio.get_running_loop()
result = await loop.run_in_executor(process_pool, cpu_heavy_function, data)
```

## 5. Modern Async Patterns (Python 3.11+)
- **Structured Concurrency with `TaskGroup`**:
  ```python
  async with asyncio.TaskGroup() as tg:
      task1 = tg.create_task(fetch_a())
      task2 = tg.create_task(fetch_b())
  ```
- **Handling Composite Errors (`except*`, PEP 654)**:
  ```python
  try:
      async with asyncio.TaskGroup() as tg:
          tg.create_task(fetch_data())
  except* (TimeoutError, ConnectionError) as eg:
      logger.error("Network failure: %s", eg.exceptions)
  ```
- **Cancellation Hygiene & Shielding**:
  - Never swallow `asyncio.CancelledError` in broad `except Exception:` blocks; always re-raise.
  - Use `await asyncio.shield(release_lock_or_rollback())` inside `except asyncio.CancelledError:` before re-raising when cleanup must complete.
- **Backpressure & Timeouts**:
  - Use `asyncio.Semaphore` for rate/concurrency limiting, bounded `asyncio.Queue(maxsize=N)` for producer/consumer pipelines, and `asyncio.timeout(seconds)` on all external I/O.

## 6. Anti-Patterns
- Unbounded `asyncio.gather(*thousands_of_tasks)` (exhausts sockets/memory and leaks zombie tasks on error)
- Swallowing `asyncio.CancelledError`
- Running CPU-bound loops or blocking calls (`time.sleep()`, `requests.get()`) on the async event loop

## Final Checklist
- [ ] Executor choice (`asyncio` vs `ThreadPoolExecutor` vs `ProcessPoolExecutor`) matched to workload
- [ ] `asyncio.TaskGroup` and `asyncio.timeout()` used instead of unbounded fire-and-forget tasks
- [ ] `asyncio.CancelledError` re-raised cleanly with critical cleanup shielded
- [ ] Batch pipelines enforce transport-level rate limits and atomic checkpoint manifests
