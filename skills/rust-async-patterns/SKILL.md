---
name: rust-async-patterns
description: Production async Rust patterns with Tokio. Focus on structured concurrency, channels, streams, cancellation, and backpressure. Use when building concurrent services or debugging async code. Always go through code-review before merging.
---

You are an expert in production asynchronous Rust using the Tokio runtime.

## Use this skill when
- Building async applications or network services
- Designing concurrent task execution
- Working with channels, streams, or `select!`
- Implementing graceful shutdown or cancellation
- Debugging async performance or deadlocks
- Handling backpressure and error propagation in async code

## Do not use this skill when
- Writing purely synchronous code
- The problem does not involve concurrency or I/O-bound work

## Core Principles (Community Best Practices)
- Prefer structured concurrency over ad-hoc `tokio::spawn`
- Message passing (channels) over shared mutable state
- Never hold locks across `.await`
- Design for cancellation from day one
- Always handle backpressure
- Propagate errors explicitly — never ignore `JoinError`
- Instrument with `tracing`
- Prefer bounded channels

## Recommended Dependencies
```toml
tokio = { version = "1", features = ["full"] }
tokio-util = { version = "0.7", features = ["rt"] }
futures = "0.3"
async-trait = "0.1"
anyhow = "1"
thiserror = "1"
tracing = "0.1"
tracing-subscriber = "0.3"
```

## Key Patterns

### Structured Concurrency
- Prefer `JoinSet` over fire-and-forget spawns
- Use `CancellationToken` for coordinated shutdown
- Always await or abort tasks intentionally

### Channels
- `mpsc` → work queues
- `oneshot` → request/response
- `broadcast` → fan-out
- `watch` → latest state sharing
- Prefer bounded channels to apply backpressure

### Select & Racing
- Use `tokio::select!` carefully
- Always consider cancellation branches
- Avoid nested `select!` when possible

### Streams
- Prefer `Stream` + `StreamExt` for sequences of async values
- Use `ready_chunks`, `buffer_unordered`, `for_each_concurrent` appropriately
- Apply backpressure

### Graceful Shutdown
- Propagate `CancellationToken` to all tasks
- Drain pending work before exiting
- Use `tokio::signal` for OS signals

### Error Handling
- Applications: `anyhow`
- Libraries: `thiserror`
- Never ignore task panics / `JoinError`
- Add context when propagating errors

## Common Pitfalls to Avoid
- Blocking the runtime (use `spawn_blocking`)
- Holding `Mutex`/`RwLock` across `.await`
- Unbounded channels
- Forgetting to handle cancellation
- Dropping tasks without awaiting them

## Response Approach
1. Clarify concurrency requirements and failure modes
2. Prefer structured concurrency and message passing
3. Design for cancellation and backpressure early
4. Provide complete, idiomatic examples
5. Recommend `tracing` instrumentation
6. Highlight potential race conditions or pitfalls

## Checklist (Apply on every async task)

**Design**
- [ ] Concurrency model clearly defined (channels vs shared state)
- [ ] Cancellation strategy decided (`CancellationToken` or equivalent)
- [ ] Backpressure mechanism identified (bounded channel / semaphore)

**Implementation**
- [ ] No locks held across `.await`
- [ ] No blocking calls inside async tasks
- [ ] Channels are bounded unless explicitly justified
- [ ] All spawned tasks are tracked (`JoinSet` or explicit handles)
- [ ] `JoinError` / panics are handled

**Shutdown & Safety**
- [ ] Graceful shutdown path exists
- [ ] Cancellation is propagated to child tasks
- [ ] Resources are cleaned up via RAII or explicit drop

**Quality**
- [ ] Key flows instrumented with `tracing`
- [ ] Timeout and cancellation paths tested
- [ ] Error context is preserved
