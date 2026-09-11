---
name: tech-research
description: >-
  Survey and compare external approaches (papers, benchmarks, production write-ups) when the repo does not already decide.
  Not for implementing, plotting, or EDA.
risk: safe
source: local
date_added: "2026-08-23"
---

# Tech Research Skill

Research current best practices, SOTA methods, algorithms, and engineering approaches to support informed implementation decisions.

## When to Use
- Looking for best practices or SOTA solutions for a specific problem
- Comparing algorithms, models, or techniques (classic vs modern)
- Surveying how the community or industry solves similar problems
- Evaluating trade-offs to choose an implementation approach for a project
- Questions like: "What are the SOTA metrics?", "Is there a better approach?", "What are people using now?"

## When Not to Use
- The answer is already clear from the existing codebase or internal docs
- Only a basic concept explanation is needed
- Pure coding or debugging with no need for external research
- EDA / modeling (`data-science`); Plotly (`data-visualization`)

## Research Process

### 1. Clarify Scope
- Specific problem to solve
- Key constraints (latency, memory, interpretability, data size, team skills, production readiness...)
- Current project context (what is already in use, what the pain points are)
- Required depth (quick survey vs deep comparison)

### 2. Gather Information
- Search for SOTA / modern approaches from recent papers, benchmarks, official docs, GitHub, and technical blogs
- Prioritize reliable sources: well-cited papers, production case studies, active repositories, recent benchmarks
- Use Context7 when accurate library/framework documentation is needed
- Also collect classic methods to serve as baselines

### 3. Analyze & Compare
Evaluate candidates against relevant criteria:

| Criterion | Key Questions |
| :--- | :--- |
| **Effectiveness** | Performance / accuracy on similar tasks |
| **Practicality** | Ease of implementation, maintenance, and debugging |
| **Resource Cost** | Compute, memory, latency, data requirements |
| **Maturity** | Battle-tested or still experimental? |
| **Interpretability** | Can results be explained? |
| **Ecosystem** | Available tooling, community, integrations |
| **Migration / Integration** | Effort to adopt into the current stack |
| **Trade-offs** | Clear strengths and weaknesses |

Keep only the 3–5 most relevant options.

### 4. Recommend for Implementation
- Provide conditional recommendations (when to choose A, when to choose B, when to keep the current approach)
- Clearly state trade-offs and risks
- Suggest practical next steps: POC, benchmark on real data, decision criteria for migration

## Output Guidance & ADR Format
- For short answers, respond directly and concisely.
- Answer in-chat with the output structure below unless the user asked to save a file.
- Load **antigravity-reporting** only for a saved markdown/ADR.
- **ADR** only when a durable architecture choice is locked:
  - **Context**: Problem background, requirements, and key constraints.
  - **Decision**: Chosen solution, framework, or algorithm.
  - **Alternatives Considered**: Evaluated candidates and why they were rejected.
  - **Consequences**: Expected gains, operational trade-offs, and migration risks.

## Output Structure
1. **Recommendation** at the top
2. Comparison table of the main options
3. Short analysis of each key candidate (pros/cons + when it fits)
4. Trade-offs and risks
5. Suggested next implementation steps

## Principles
- Prefer recent evidence and real production usage over pure theory
- Clearly distinguish "SOTA on paper" from "widely used in practice"
- Recommendations must be tied to the project's constraints and context
- Do not overstate benefits; clearly state limitations
- Keep the output concise and decision-focused

## Related Skills
- Use **doubt-driven-development** when a recommendation is about to lock in.
- Use **algorithm-optimization** when candidates need validation on real KPIs.
- Use **context7-mcp** for version-sensitive library docs.

## Final Checklist
- [ ] Scope and constraints are clearly understood
- [ ] Both modern and classic approaches are considered
- [ ] Candidates are evaluated against relevant criteria
- [ ] Only the most relevant 3–5 options are kept
- [ ] Recommendation is conditional and tied to project context
- [ ] Trade-offs and risks are clearly stated
- [ ] Practical next steps are suggested
- [ ] Output is concise and focused on decision-making
