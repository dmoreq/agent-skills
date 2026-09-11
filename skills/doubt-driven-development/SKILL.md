---
name: doubt-driven-development
description: >-
  Adversarial review of a non-trivial decision before it hardens (assumptions, edges, blast radius).
  Not for mechanical edits, exploratory research notes, or merge review.
risk: safe
source: local
date_added: "2026-08-23"
---

# Doubt-Driven Development Skill

Subject non-trivial decisions to adversarial review before they harden.

## When to Use
- Architectural or design choices under uncertainty
- Branching logic, cross-module contracts, concurrency, or security-sensitive behavior
- Claims not fully enforced by types/compiler/tests yet
- High blast-radius changes: public API, data migration, production-critical paths
- Unfamiliar code where confidence may be false
- Research outputs that are about to harden into an implementation decision

## When Not to Use
- Mechanical edits: rename, format, move files
- Obvious one-line fixes
- User explicitly prioritizes speed over verification
- Pure summary/research with no decision being locked in
- Intermediate research notes that are still exploratory

## Non-Trivial Test
Use this skill if at least one is true:
- Introduces or changes branching/state transitions
- Crosses module or service boundaries
- Asserts invariants not yet protected by tests/types
- Is expensive or hard to reverse
- Converts research findings into a concrete adoption/rejection decision

## Research Decisions
Use this skill on research outputs only when they harden into a decision.

Examples:
- Adopting a library, model, or approach
- Rejecting alternatives with material trade-offs
- Recommendations that will drive implementation

For research decisions:
- **Artifact** = recommendation + evidence summary
- **Contract** = project constraints and success criteria

Challenge:
- Weak or selective evidence
- Missing baselines
- Overconfident SOTA claims
- Recommendations not tied to constraints
- Confusion between "trending" and "battle-tested"

Do not use this skill to adversarially review every research report by default.

## Process

### 1. CLAIM
State the decision in 2–3 lines and why it matters.

### 2. EXTRACT
Isolate the smallest reviewable artifact + contract. Strip prior reasoning.

### 3. DOUBT
Review adversarially to find issues, not to approve.

Use this prompt shape:

```text
Find what is wrong with this artifact.
Assume the author is overconfident.
Look for unstated assumptions, missing edge cases, hidden coupling,
contract violations, and failure modes.
Do not validate. Do not summarize.
List concrete issues, or state that none were found.

ARTIFACT:
CONTRACT:
```

### 4. RECONCILE
Classify each finding:
- **Contract unclear**: Ambiguity in requirements or boundaries
- **Actionable fix**: Concrete defect or risk needing immediate fix
- **Accepted trade-off**: Known limitation with acceptable risk
- **Noise**: False positive (verify against code before discarding)

Re-read the artifact before accepting findings.

### 5. STOP
Stop when:
- Findings are trivial/noise, or
- 3 cycles are completed, or
- Residual risk is explicitly accepted by the user

## Rules
- Pass artifact + contract only; do not pass the claim as a conclusion.
- Prefer disproof over approval.
- Do not loop past 3 unresolved cycles; escalate instead.
- This is in-flight checking, not a replacement for final review.
- For research, challenge the decision — not every intermediate survey.

## Related Skills
- Use **tech-research** when alternatives/evidence are missing; hand off here only when a decision is being locked.
- Use **python-testing** (or crate tests) to turn important doubts into regression tests.
- Use **deprecation-migration** when the decision is a sunset/cutover.

## Final Checklist
- [ ] Decision is actually non-trivial
- [ ] Claim and stakes are explicit
- [ ] Artifact and contract are isolated
- [ ] Review prompt is adversarial
- [ ] Findings are classified, not rubber-stamped
- [ ] Actionable issues are fixed or explicitly deferred
- [ ] Stop condition is reached ($\le 3$ cycles)
- [ ] Important residual risks are visible to the user
- [ ] If research-derived, recommendation is tied to constraints and evidence quality was challenged
