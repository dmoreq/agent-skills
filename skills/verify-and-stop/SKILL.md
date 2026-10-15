---
name: verify-and-stop
description: >-
  Disciplined execution and termination protocol. Verifies minimal acceptance criteria
  with a single decisive check, presents proof, and stops immediately without runaway loops.
risk: safe
source: local
date_added: "2026-09-22"
---

# Verify-and-Stop Skill

Enforces strict termination discipline for coding agents. Complete the requested task, verify the acceptance criteria with a decisive command, present the proof, and stop. Never continue into unprompted refactoring, speculative cleanup, or endless loop cycles.

## When to Use
- Implementation or fix is complete and requires definitive validation
- Guarding against agent runaways, over-refactoring, or perpetual tool calls
- Finishing a subagent delegation stream cleanly

## When Not to Use
- Active debugging when the cause of a test failure is not yet identified
- Initial design or research phases where code has not been written

## The 4-Step Termination Protocol

1. **Check Acceptance Criteria**:
   Compare the current state strictly against what was requested. Ask: did we satisfy the exact prompt contract?
2. **Execute One Decisive Verification (or Reuse Prior Proof)**:
   - **Reuse Prior Proof**: If the immediately preceding step or tool call already executed a verification command that proved correctness with clean passing output, **do NOT re-run it**. Reuse that output as proof.
   - Otherwise, run the smallest runnable command that proves correctness:
     - Python: `pytest path/to/test.py -k test_name`
     - Rust: `cargo test test_name`
     - Build / Lint: targeted linter check (`ruff check <files>`)
3. **Present Decisive Proof**:
   Output the result concisely:
   - Status (PASS / FAIL)
   - Scope touched (files and delta LOC)
   - Verification evidence (command output or reused proof from immediate prior step)
   - Zero speculative commentary
4. **STOP**:
   Call no more tools. Do not initiate drive-by refactoring, extra cleanup, or tangential improvements. State completion directly.

## Anti-Patterns
- ❌ Continuing to edit unrelated files after the requested test passes.
- ❌ Running multiple redundant test commands that check the same thing.
- ❌ Re-running tests or pre-commit when the previous step already verified the exact same code with passing output.
- ❌ Running full repository test suites or `pre-commit run --all-files` when targeted checks suffice.
- ❌ Asking the user "Would you like me to also refactor X, Y, and Z?" when not requested.

## Related Skills
- Use **python-testing** to write or debug targeted test assertions.
- Use **code-review** for pre-merge multi-axis inspection.
- Use **code-minimalism** to ensure the verified solution remains minimal.
