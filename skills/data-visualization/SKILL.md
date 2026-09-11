---
name: data-visualization
description: >-
  Build analytical Plotly charts with lean labels, no overlap, and SVG export QA (Kaleido).
  Not for Mermaid/architecture diagrams, Dash apps, or stakeholder narrative.
risk: safe
source: local
date_added: "2026-08-23"
---

# Data Visualization Skill (Plotly-first)

Create clear, accurate, readable charts with Plotly. Prefer lean visuals, correct layout, and no overlapping text.

## When to Use
- Analytical charts for reports or exploration
- Choosing the right chart for a dataset and question
- Exporting SVG/PNG figures for documents
- Fixing unreadable charts (overlap, clipping, bad sizing)

## When Not to Use
- Comparisons already clear in a small table
- Mermaid / architecture diagrams (`antigravity-reporting`)
- Interactive Dash apps (`plotly-dash`)
- Pure statistical computation (`data-science`)

## Related Skills
- Use **data-science** when metrics still need to be computed.
- Use **antigravity-reporting** when embedding figures into a saved markdown file.
- Use **data-storytelling** when the chart supports a stakeholder decision (numbers must already be validated).

## Core Principles
1. Choose chart by purpose, not by habit.
2. Prefer fewer labels over complete labels.
3. Optimize layout for readability before styling.
4. Never deliver a chart with overlapping or clipped text.
5. If exact values matter more than shape, use a table.
6. Keep in-chart text short; put long explanation outside the visual.

## Chart Selection
| Purpose | Prefer | Avoid |
| :--- | :--- | :--- |
| **Compare categories** | Bar / horizontal bar | Pie with many slices |
| **Trend over time** | Line | Overplotted lines without focus |
| **Distribution** | Histogram / box / violin | 3D charts |
| **Relationship** | Scatter | Dual-axis unless justified |
| **Composition** | Stacked bar (few parts) | Pie > 6 slices |

If categories are many or names are long → prefer horizontal bar.

## Plotly Defaults
- Plotly Express for simple charts; Graph Objects when fine control is needed.
- Set explicit `width` and `height` for content density.
- Enable automargin: `fig.update_xaxes(automargin=True)` and `fig.update_yaxes(automargin=True)`.
- Keep legend off the data area when possible.
- Use consistent units and clear axis titles.

## Anti-Overlap Rules
- Do not label every point by default.
- Label only key points: top-N, outliers, or highlighted series.
- For dense labels, alternate `textposition`, thin ticks, or rely on hover.
- Rotate or shorten ticks when categories collide.
- If still colliding: (1) reduce label count, (2) modestly increase figure size, (3) keep only 1–3 annotations.
- Never "solve" overlap by making font unreadable.

## Layout & Export
- Leave margin for title, ticks, legend, annotations.
- Prefer one message per chart.
- SVG export requires **Kaleido**. Pass size on export, e.g. `fig.write_image("chart.svg", width=900, height=560)`.
- Prefer SVG for report-quality vector output.
- Visually inspect the exported file before delivery.

## Visual QA Checklist
- [ ] Chart type matches purpose
- [ ] Table considered when exact values matter more
- [ ] In-chart text is short and necessary
- [ ] No overlapping labels/ticks/legend
- [ ] No clipped text or overflow
- [ ] Width/height fit content; Kaleido used for SVG
- [ ] Readable at final display size
- [ ] Long explanation moved outside the figure
