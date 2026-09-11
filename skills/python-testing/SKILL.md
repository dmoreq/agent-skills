---
name: python-testing
description: >-
  Write or fix pytest suites: fixtures, boundary mocks, async tests, flaky tests, regression guards.
  Not for implementing features or load/performance benchmarks.
risk: safe
source: local
date_added: "2026-02-27"
---

# Python Testing Skill

Design and write effective Python tests with pytest.

Load `resources/implementation-playbook.md` **only** for a concrete pytest recipe (fixtures, parametrize, mock, async). Do not load it for process or policy. Do not invent coverage percentage gates.

## When to Use
- Unit, integration, or API tests in Python
- pytest layout, fixtures, TDD
- Mocking external boundaries
- Async tests, flaky/slow tests

## When Not to Use
- Non-Python testing (use crate tests / `dash_duo` as appropriate)
- Feature implementation with no test intent (`python-pro`)
- Load/performance benches (`python-performance`)

## Related Skills
- Required for **Python** behavior changes before **code-review**.
- Do not co-load other skills unless those tasks are also in scope.

## Core Principles
1. Test behavior and contracts, not implementation details.
2. Fast deterministic unit tests for core logic.
3. Integration tests for boundaries (DB, API, filesystem).
4. Mock only what you do not own or cannot control.
5. Arrange → act → assert. One main behavior per test (not a hard one-assert rule).
6. Maintainability over coverage theater.

## Test Strategy
| Layer | Purpose | Typical tools |
| :--- | :--- | :--- |
| **Unit** | Business logic, pure functions | pytest, parametrize |
| **Integration** | API, DB, queue, filesystem | pytest + TestClient/httpx |
| **End-to-end** | Critical flows | few, high-value |

Prioritize: critical paths → edge/failure modes → regressions for fixed bugs.

## Pytest Patterns
- Fixtures for reusable setup, not hidden magic.
- Parametrize input matrices.
- Factory helpers over giant fixture graphs.
- Name by behavior: `test_rejects_invalid_token`.

## Mocking
Mock: external HTTP, third-party services, time/randomness.
Do not mock: the logic under test, in-process pure functions, local code you can run.
Prefer explicit fakes over spy-heavy tests.

## Async Testing
- `pytest-asyncio` for `async def` tests.
- Cover success, timeout, cancellation, exceptions.
- No `sleep`-based assertions when an `asyncio.Event` (or equivalent) works.

## TDD
Use when it clarifies design: failing test → minimal pass → refactor.
Skip ritual TDD on spikes; add tests before the code hardens.

## Bug-fixing Loop
1. **Reproduce** with a minimal failing test.
2. **Isolate** the divergence.
3. **Fix** the root cause.
4. **Guard** keep the test as a regression.

## Test Design Checklist
- [ ] Behavior under test is clear
- [ ] Deterministic and isolated
- [ ] Assertions specific
- [ ] External deps handled appropriately
- [ ] Failure messages diagnosable
- [ ] Edge/error paths considered
- [ ] Runtime reasonable
