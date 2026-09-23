---
name: technical-reporting
description: >-
  Write saved formal markdown: benchmarks, ADRs, architecture notes, asset paths, Mermaid diagrams.
  Not for Plotly chart construction, Dash apps, or stakeholder QBR narrative.
risk: safe
source: local
date_added: "2026-08-22"
---

# Technical Reporting Skill

Create a saved technical markdown document when the user asked for a durable report, benchmark write-up, or ADR file. Skip this skill for in-chat answers.

## When to Use
- User asked to save a report, benchmark summary, or architecture analysis as markdown
- Embedding Mermaid or SVG assets into a persistent `.md` file

## When Not to Use
- Short in-chat answers (tables in the reply are enough)
- Plotly figure construction (`data-visualization`)
- Stakeholder decision narrative (`data-storytelling`)
- Interactive dashboards (`plotly-dash`)

## Related Skills
- Use **data-visualization** when embedding Plotly/SVG charts (layout and overlap QA live there).
- Numbers come from the skill that produced them; do not chain research → optimize → report.

## 1. Execution Flow
1. **Generate assets first**: compute metrics and export SVG (via `data-visualization`) before drafting.
2. **Draft the markdown** using verified numbers.
3. **Embed assets** with relative paths from the report file.

## 2. File Organization & Naming
- Prefix persistent files with ISO date: `YYYY-MM-DD_<topic>.md`.
- Workspace default: match existing docs layout, else `docs/reports/YYYY-MM-DD_<topic>.md`.
- Session default: host artifact directory if the environment provides one; otherwise `docs/reports/`.
- Assets: `docs/reports/assets/YYYY-MM-DD_<topic>/` or beside the report. Always relative paths.

## 3. Mermaid (in-document diagrams)
- Supported headers only: `xychart-beta`, `flowchart TD` / `flowchart LR` / `graph`, `sequenceDiagram`, `stateDiagram-v2`, `erDiagram`, `classDiagram`.
- Keep sketches compact (3–5 nodes). No HTML inside nodes.
- Architecture / EDA charts that need real axes: export SVG via `data-visualization` (Plotly) or, if the repo already uses them, Seaborn/Matplotlib. Infrastructure diagrams: `diagrams` (Mingrammer). Decision trees / state machines: `graphviz`.
- Prefer `.svg`; PNG only when SVG cannot be produced. Do not embed raw HTML or iframes.

## 4. Content Standards
- Start with `TL;DR` / Executive Summary (metrics + takeaway).
- Inherit global communication invariants (`AGENTS.md` §1): zero fluff, table preferences, and plain-text/Unicode math over LaTeX.
- Charts only when they reveal a pattern a table would hide.

## Final Checklist
- [ ] User actually asked for a saved file (otherwise answer in-chat)
- [ ] ISO date prefix on persistent files
- [ ] TL;DR with key metrics
- [ ] Mermaid headers from the allowlist, or SVG via `data-visualization`
- [ ] Relative asset paths
- [ ] Claims backed by explicit numbers
