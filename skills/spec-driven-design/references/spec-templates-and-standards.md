# Spec Templates and Standards

Reference for `spec-driven-design`. It holds the six brainstorm lens cards, the dispatch contract, the document standards, and the spec template.

## 1. Goldfish Dispatch Contract

A Goldfish reviewer runs in a fresh context with no conversation history. It is read-only.

- Pass only: the lens prompt card, the artifact path (and line range when given), and the source paths the reviewer may read.
- Never pass: conversation history, the author's rationale, prior review conclusions, or a desired verdict.
- Include a `Skill context:` line naming the owning review skill and its `SKILL.md` path when the lens depends on that skill's gates.
- The caller deduplicates findings and writes one report. Each reviewer returns raw findings only.
- If the host cannot isolate context, run a sequential cold-read pass. State plainly that isolation was simulated, not native.

| Tier | Hosts | Dispatch |
| :--- | :--- | :--- |
| 1 | Antigravity, Codex, OpenCode | Six parallel read-only subagents, one per lens |
| 2 | Zed, Grok, ZCode, single-thread CLI | Save the hypothesis first, then apply each card sequentially |

## 2. Brainstorm Lens Cards

### Lens 1: Contrarian / YAGNI

```text
You are the Contrarian Goldfish. You are read-only, stateless, and blunt.
Read the concept at: <ARTIFACT_PATH>.
Do not use conversation history. Do not narrate tool usage.

Challenge:
1. Why must this feature exist now? What happens if we do nothing?
2. Can an existing library, API, service, or codebase component solve 90% of it?
3. Which requirement is speculative rather than observed?
4. What is the smallest version that proves the value?

Search the repository before claiming something does not exist.
For each finding return: Severity (Critical, Important, Suggestion, Nit),
Dimension, Challenge, and Alternative or Reuse Opportunity.
Return only findings. Do not praise the concept.
```

### Lens 2: Cost, Quota, and Token Economics

```text
You are the Cost and Quota Goldfish. You are read-only, stateless, and blunt.
Read the concept at: <ARTIFACT_PATH>.

Challenge:
1. What are peak QPS, memory footprint, storage growth, and database load?
2. Does any LLM path have a bounded token budget per request and per day?
3. Which quota ceiling is hit first at 10x current traffic?
4. What is the unit cost per successful user action?
5. Which cost claim is estimated but presented as measured?

Label every number as measured, reported, or estimated.
For each finding return: Severity, Dimension, Risk Description, Mitigation Requirement.
```

### Lens 3: UX and Developer Ergonomics

```text
You are the Ergonomics Goldfish. You are a fresh developer who just joined.
Read the concept at: <ARTIFACT_PATH>.

Challenge:
1. Is the API, CLI, or workflow intuitive without a tutorial?
2. Does it match ecosystem conventions or invent its own?
3. Are error messages actionable, or do they expose internal state?
4. Which step adds avoidable cognitive load or manual work?
5. Can a mistaken input cause silent damage instead of a clear rejection?

For each finding return: Severity, Dimension, Usability Friction, Ergonomic Requirement.
```

### Lens 4: Migration and Backward Compatibility

```text
You are the Migration Goldfish. You are read-only, stateless, and blunt.
Read the concept at: <ARTIFACT_PATH>.

Challenge:
1. Which existing clients, serialized payloads, or stored records break?
2. Is the rollout ordered so old and new versions coexist safely?
3. How is a mid-migration rollback executed?
4. Which data backfill is required, and is it reversible?
5. What happens to records written during the version skew window?

For each finding return: Severity, Dimension, Compatibility Hazard, Migration Requirement.
```

### Lens 5: Observability and SRE Debuggability

```text
You are the Observability Goldfish. You are read-only, stateless, and blunt.
Read the concept at: <ARTIFACT_PATH>.

Challenge:
1. Which operations need trace context, metrics, or structured logs?
2. Can an on-call engineer locate a failing request at 3 AM?
3. Which failure mode is silent today?
4. Are alert thresholds tied to a user-visible symptom?
5. What is the rollback or kill-switch path during an incident?

For each finding return: Severity, Dimension, Operational Risk, Mitigation Requirement.
```

### Lens 6: Maintenance and Coupling

```text
You are the Maintenance Goldfish. You are read-only, stateless, and blunt.
Read the concept at: <ARTIFACT_PATH>.

Challenge:
1. Which new dependency or shared state couples two components?
2. Which state machine becomes brittle under retries or partial failure?
3. What will a maintainer in two years need that the concept omits?
4. Which abstraction exists for one caller?
5. What test or contract will detect future drift?

For each finding return: Severity, Dimension, Tech Debt Description, Maintainability Requirement.
```

## 3. Heilmeier Catechism Standard

A proposal passes only when a competent engineer unfamiliar with the project can answer every question from the document alone.

| Question | Required Content |
| :--- | :--- |
| Objective | What is being attempted, in plain language with no jargon |
| State of the Art | How it is done today and the limits of current practice |
| New Approach | What is new and why it should succeed |
| Impact | Who cares and what changes if it succeeds |
| Risks | Failure modes, blast radius, and payoffs |
| Cost | Compute, storage, headcount, and token budget |
| Timeline | Phases and expected duration |
| Metrics and Exams | Mid-term and final checks that prove success |

## 4. Feature Specification Standard

A feature spec passes only when it satisfies all of these:

- **Alternatives Rule**: Evaluate at least two viable designs. State why each rejected option lost. A single-path proposal fails.
- **Risks and Limits**: Name security, scalability, and complexity risks with mitigations.
- **Problem Statement**: State the user or business problem.
- **Goals and Non-Goals**: Separate delivered scope from excluded scope.
- **Proposed Architecture**: Show component layout and data flow.
- **Critical User Journeys**: Cover the primary journey and one failure journey.

## 5. Implementation Readiness Standard

A plan passes only when a fresh implementer can execute it without making a design decision.

- **Zero-Decision Rule**: Pre-determine schema, API shape, dependencies, error strategy, and edge-case behavior. Any open choice fails the plan.
- **File Ledger**: List every file as Create, Modify, or Delete, each with a rationale.
- **Phasing**: Partition work into phases that each leave the repository buildable and testable.
- **Test Plan**: Name happy-path and edge-case tests with the command that runs them.
- **Verification**: Name the build, lint, and test commands with pass conditions.

## 6. Critical User Journey Format

```text
CUJ: <short title>
Given: <preconditions and starting state>
When: <trigger, action, or system event>
Then: <observable outcome and postconditions>
```

## 7. Semantic Split Convention

The spec must contain one implementation boundary header. The reviewer uses it to bind line ranges.

- Accepted headers: `## Detailed Implementation Plan`, `## Implementation Plan`, `## Work Breakdown`, or `## Implementation Steps`.
- `FeatureRange` is line 1 through the line before the boundary header.
- `DetailedRange` is the boundary header through the last line.
- If no boundary exists, `FeatureRange` covers the whole document and `DetailedRange` is `N/A`. Report this as a Major structural gap.

## 8. Specification Template

Save as `docs/designs/YYYY-MM-DD_<feature>.md`.

```markdown
# <Feature Name>

- Author: <name or handle>
- Status: Draft | Proposed | In Review | Approved
- Date: YYYY-MM-DD

## Overview

<What this is and where it fits in the system.>

## The Problem

<Observed problem, affected users, and current workaround.>

## Goals

- <Measurable goal>

## Non-Goals

- <Explicitly excluded scope>

## Open Questions

- <Unresolved question with owner and due date>

## Critical User Journeys

### CUJ 1: <Title>

- Given: <preconditions>
- When: <trigger>
- Then: <observable outcome>

## Technical Plan

<Architecture, components, and data flow. Use a compact diagram.>

## Alternatives Considered

### Alternative A: <Title>

- Pros: <benefits>
- Cons: <drawbacks>
- Reason for Rejection: <evidence>

## Non-Functional Requirements

- Security and privacy:
- Performance and latency:
- Rollout and rollback:

## Detailed Implementation Plan

### File Ledger

#### <path> (Create | Modify | Delete)

- Scope: <module or test>
- Change: <API shape, data flow, or behavior>
- Rationale: <why this file>

### Verification Plan

- Build: <command>
- Lint: <command>
- Tests: <command and expected result>
```

## 9. Gate Quality Bar

Before presenting either gate, verify:

- The owner saw the actual artifact path, not a chat dump.
- Open-ended questions were asked one at a time.
- Architecture options had no default and no recommendation.
- Contradictions halted the turn before any write.
- Each review lens ran with isolated context or was labeled sequential.
