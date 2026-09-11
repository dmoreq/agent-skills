---
name: python-patterns
description: >-
  Architecture-time choices: framework, project layout, and ADRs.
  Not for asyncio vs process-pool selection, pytest recipes, or line-by-line implementation.
risk: safe
source: local
date_added: "2026-02-27"
---

# Python Patterns Skill

Decision-making for Python architecture: framework, project structure, and trade-offs. Think; do not copy patterns.

## When to Use
- Choosing a Python framework or service shape
- Structuring a new or growing Python project
- Recording an ADR for a durable architecture choice

## When Not to Use
- Executor choice (asyncio / threads / processes) → **python-concurrency**
- Implementing modules → **python-pro**
- Writing tests → **python-testing**
- Basic syntax or non-Python stacks
- One-off scripts with no architectural decision

## Related Skills
- Use **python-pro** once the architecture decision is made.
- Use **python-concurrency** when the remaining question is I/O vs CPU execution model.

## 1. Framework Selection
Choose based on context, not habit.

- **API / microservices / AI serving** → FastAPI
- **Full-stack / CMS / admin-heavy** → Django
- **Simple service or learning** → Flask
- **Background workers** → Celery, ARQ, or equivalent (with any web framework)

Ask: API-only or full-stack? Need built-in admin? Team async-ready? Existing constraints?

## 2. Typing Strategy
Always type function parameters/returns, public APIs, and class attributes that matter. Can be lighter on obvious locals, one-off scripts, and some tests. Prefer `list[str]`, `str | None` when the version allows. Pydantic for request/response, settings, validation.

## 3. Project Structure
- **Small**: flat files
- **Medium API**: `app/` with routes, services, models, schemas
- **Large**: `src/myapp/` with layers or feature modules

Routes/views stay thin. Services own business logic. Models/schemas own shape. Data access isolated when needed.

## 4. Error Handling
- Domain exceptions in services
- Convert at the API boundary
- Consistent error shape (code, message, details)
- Never expose stack traces to clients

## 5. Background Tasks
- Simple fire-and-forget → framework background tasks
- Long-running / retry / distributed → Celery, ARQ, or equivalent
- Choose from persistence, retry, and scale needs

## Design Principles
Apply pragmatically: clear names, focused modules, composition over deep inheritance, tests for critical behavior. DRY only when the abstraction is cheaper than repetition.

## Optional ADR
For significant choices (framework, ORM vs SQL, sync vs async *at the service boundary*):
- **Context**: constraints and drivers
- **Decision**: chosen pattern
- **Consequences**: trade-offs

If the open question is which executor to use, stop and load **python-concurrency**.

## Core Decision Checklist
- [ ] Framework chosen from context, not habit
- [ ] Structure matches current scale
- [ ] Error handling is consistent at the boundary
- [ ] Background work has the right tool
- [ ] Trade-offs understood before implementing

## Anti-Patterns
- Defaulting to one framework for every project
- Putting business logic in routes/views
- Skipping types on public APIs
- Over-engineering small projects
