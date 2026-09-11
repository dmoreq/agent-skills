---
name: data-storytelling
description: >-
  Turn already-validated metrics into a stakeholder decision narrative (Hook → Ask).
  Not for analysis, Plotly construction, or saved engineering markdown.
risk: safe
source: local
date_added: "2026-02-27"
---

# Data Storytelling Skill

Transform validated analysis into a decision-ready narrative for stakeholders.

## When to Use
- Presenting insights to executives or non-technical audiences
- QBRs or business recommendations that need a "so what"
- Turning statistical / ML findings into an actionable ask

## When Not to Use
- Numbers are not yet validated (`data-science` first)
- Pure exploratory analysis still in progress
- Technical deep-dives for other data scientists (`antigravity-reporting` if a file is requested)
- Simple metric dump with no decision

## Related Skills
- **Required:** base the story on validated findings from **data-science**. Do not invent numbers.
- Use **data-visualization** for supporting charts (layout/overlap live there).
- Use **antigravity-reporting** only when the user asked to save a formal technical file.

## Core Structure
1. **Hook** — Surprising or high-impact finding (with specific numbers).
2. **Context** — Baseline and why it matters.
3. **Insight** — What the data reveals (quantitative evidence).
4. **Implication** — Business meaning and stakes.
5. **Recommendation** — Next actions + expected impact / ROI.
6. **Ask / Next Step** — Specific decision needed from stakeholders.

## Key Principles
- Lead with the insight, not the methodology.
- Every number must serve the narrative (no data dumps).
- Prefer simple comparisons and deltas over complex charts.
- State confidence and limitations briefly when relevant.
- Match language to the audience; end with a concrete ask.

## Output Expectations
- Start with a headline or TL;DR containing the key insight and proof.
- Charts: one pointer to `data-visualization`; tables by default.
- Separate findings from recommendations.

## Final Checklist
- [ ] Insights come from validated `data-science` output
- [ ] Hook / TL;DR has the core number
- [ ] Flow: Context → Insight → Implication → Recommendation → Ask
- [ ] Every metric serves the narrative
- [ ] Recommendation includes expected impact
- [ ] Limitations stated where they change the decision
