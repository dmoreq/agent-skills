---
name: rust-async-patterns
description: >-
  Production Tokio: structured concurrency, channels, streams, cancellation, backpressure.
  Not for sync Rust, ownership/API design, or PR review.
risk: safe
source: local
date_added: "2026-09-11"
---

# Rust Async Patterns Skill

Production asynchronous Rust on Tokio.

## When to Use
- Async applications or network services
- Concurrent task execution
- Channels, streams, or `select!`
- Graceful shutdown or cancellation
- Async performance, deadlocks, backpressure

## When Not to Use
- Purely synchronous code (`rust-pro`)
- Ownership/type/unsafe design without concurrency (`rust-pro`)
- No I/O-bound or concurrent work

## Related Skills
- Use **rust-pro** for types, ownership, errors, and unsafe.
- Before merge: **code-review**.

## Core Principles
- Structured concurrency over ad-hoc `tokio::spawn`
- Message passing over shared mutable state
- Never hold locks across `.await`
- Design for cancellation from day one
- Always handle backpressure
- Never ignore `JoinError`
- Instrument with `tracing`
- Prefer bounded channels

## Recommended Dependencies
Enable only the Tokio features you use (avoid `full` in production):

```toml
tokio = { version = "1", features = ["rt-multi-thread", "macros", "sync", "time", "signal"] }
tokio-util = { version = "0.7", features = ["rt"] }
futures = "0.3"
anyhow = "1"
thiserror = "1"
tracing = "0.1"
tracing-subscriber = "0.3"
```

`async-trait` only when a `dyn Trait` with async methods is required; prefer native async trait fns on Edition 2024 / 1.85+.

## Key Patterns

### Structured Concurrency
- Prefer `JoinSet` over fire-and-forget spawns
- `CancellationToken` for coordinated shutdown
- Always await or abort tasks intentionally

### Channels
- `mpsc` → work queues
- `oneshot` → request/response
- `broadcast` → fan-out
- `watch` → latest state
- Bounded channels for backpressure

### Select & Racing
- `tokio::select!` with cancellation branches
- Avoid nested `select!` when possible

### Streams
- `Stream` + `StreamExt`
- `ready_chunks`, `buffer_unordered`, `for_each_concurrent` with limits

### Graceful Shutdown
- Propagate `CancellationToken`
- Drain pending work
- `tokio::signal` for OS signals

### Errors
- Apps: `anyhow`; libs: `thiserror`
- Handle task panics / `JoinError`
- Preserve context

## Pitfalls
- Blocking the runtime (use `spawn_blocking`)
- `Mutex`/`RwLock` held across `.await`
- Unbounded channels
- Dropping tasks without await/abort

## Checklist
- [ ] Concurrency model defined (channels vs shared state)
- [ ] Cancellation strategy (`CancellationToken` or equivalent)
- [ ] Backpressure (bounded channel / semaphore)
- [ ] No locks across `.await`
- [ ] No blocking in async tasks
- [ ] Spawned tasks tracked (`JoinSet` or handles)
- [ ] `JoinError` handled
- [ ] Graceful shutdown path
- [ ] Timeouts/cancellation tested
