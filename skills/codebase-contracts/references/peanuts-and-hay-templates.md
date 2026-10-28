# Peanuts, Hay, and Drift Templates

Reference for `codebase-contracts`. It holds the contract templates, the Re-Implementation Zero-Assumption standard, the worker return schema, and the six-vector drift specification.

## 1. Contract Terms

- **Peanuts**: a leaf-level component README. It states the file-level public contract.
- **Hay**: a parent-level blueprint. It rolls child contracts into a higher-level index.
- **Contract**: the observable interface, invariants, and side effects. It is not a code summary.

## 2. Peanut Template (Component Package)

```markdown
# <Component Name>

## Overview

<Architectural role and goal of this directory in two to four sentences.>

## Interface

- <Public class, function, type, or schema>
- <Child directory>: [relative link](./child/README.md) - <child role>

## Invariants

- <State or call invariant that callers and maintainers must preserve>

## Side Effects

- <Network call, disk write, lock, metric, or external state mutation>

## Verification

- Run: `<VerificationCommand>`
```

## 3. Hay Template (Repository Root)

```markdown
# <Repository Name> Blueprint

## System Overview

<High-altitude role of this repository or subsystem.>

## Local Interface and Invariants

<Only when the root contains direct source files.>

## Subdirectories and System Boundaries

- <Directory>: [relative link](./child/README.md) - <summary of child contract>

## Global Invariants

- <Constraint that crosses component boundaries>

## Global Side Effects

- <Shared database, queue, network dependency, or credential>

## System Verification

- Run: `<VerificationCommand>`
```

## 4. Intermediate Blueprint Template

```markdown
# <Directory Name>

## Overview

<Factual description of the systems grouped under this path.>

## Subdirectories and Boundaries

- <Directory>: [relative link](./child/README.md) - <summary of child contract>
```

## 5. Link Rules

- Use relative links only: `./child/README.md` or `../sibling/README.md`.
- Link only to files that exist in the pruned tree. Never emit a speculative link.
- When a child contains `SKILL.md` instead of a contract, either link `./child/SKILL.md` or use an unlinked bullet.
- Use absolute URLs only for targets outside the repository.

## 6. Re-Implementation Zero-Assumption Standard

A contract passes when a fresh engineer can write functionally identical code from the contract alone.

**Zero-Assumption Rule**: The contract fails if the reader must guess a default, choose an error strategy, infer an output schema, or assume a design pattern. State every behaviorally significant contract.

Include:

- APIs: signatures, types, and behavior
- Logic: control flow, algorithms, and validation
- Data: schemas, serialization, and state transitions
- Side effects: writes, calls, logs, and metrics
- Dependencies: external systems and libraries
- Configuration: flags, parameters, and hooks
- Constraints: hard limits and assumptions
- Errors: edge cases, empty states, retries, and timeouts
- Tests: shared fixtures, mocks, and helpers

Exclude:

- Syntax details such as loop shape or local variable names
- Private helper organization
- Non-observable internal collections

## 7. Worker Return Schema

Parallel bootstrap workers return this payload to the root orchestrator.

```json
{
  "type": "object",
  "properties": {
    "subtree_index": {
      "type": "array",
      "items": {
        "type": "object",
        "properties": {
          "path": { "type": "string" },
          "summary": { "type": "string" },
          "interface": { "type": "array", "items": { "type": "string" } },
          "invariants": { "type": "array", "items": { "type": "string" } },
          "side_effects": { "type": "array", "items": { "type": "string" } }
        },
        "required": ["path", "summary"]
      }
    }
  },
  "required": ["subtree_index"]
}
```

Worker rules:

- Read-only tools only. No write, edit, or VCS tools.
- Bounded reads: 50,000 bytes per directory, 300 lines per file.
- On timeout or failure, return placeholder values and continue. Do not abort the sibling subtrees.
- Report the subtree root exactly as assigned.

## 8. Drift Detection: Six Vectors

Report every divergence under exactly one vector.

| Vector | Definition | Example |
| :--- | :--- | :--- |
| Missing behavior | Specified behavior is absent from code | Documented retry is not implemented |
| Incomplete data model | Field, table, or type is missing | Documented `timeout_ms` absent from schema |
| Logic shortcut | Hardcoded value replaces planned dynamic logic | Fixed batch size where config was specified |
| Architectural divergence | Different pattern, library, or boundary | Spec says queue, code calls synchronously |
| Undocumented implemented behavior | Code has observable behavior with no contract | New public flag absent from README |
| Stale reference | Document names a file, symbol, or endpoint that does not exist | README links to a deleted module |

Rules:

- Report only divergences. Do not describe matching behavior.
- Treat proposed files as future state. Their absence is not drift.
- A trigger, threshold, or default in code must appear in the contract, or it is undocumented behavior.
- Prefer a symbol probe over a filename guess.

## 9. Drift Report Format

Save as `docs/reports/YYYY-MM-DD_drift-report_<topic>.md`.

```markdown
# Drift Report: <topic>

- Date: YYYY-MM-DD
- Scope: <directories and documents audited>
- Verification command: `<command>`

## <Document Name>

| Vector | Location | Document Claim | Code Reality | Suggested Action |
| :--- | :--- | :--- | :--- | :--- |
| <vector> | `<path>#L<n>` | <claim> | <observed> | <smallest correction> |

## Summary

- Documents audited: <n>
- Divergences: <n>
- Clean documents: <n>
```

If a document matches the code, write `No drift detected` under its heading.

## 10. Verification Checklist

- Every contract section is populated, not left as a template placeholder.
- Every relative link resolves on disk.
- The verification command exists in the manifest.
- Every drift row names a vector, a location, and a checkable observation.
- The report contains no source edits and no VCS mutations.
