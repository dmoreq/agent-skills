---
name: data-visualization
description: >-
  Build analytical Plotly and Matplotlib/Seaborn charts with form-first selection, colorblind-safe palettes, anti-overlap QA, and SVG export.
  Not for Mermaid/architecture diagrams, Dash apps, or stakeholder narrative.
risk: safe
source: local
date_added: "2026-08-23"
---

# Data Visualization Skill

Create clear, accurate, readable charts with Plotly (default for interactive/HTML/Kaleido SVG) or Matplotlib/Seaborn (when static publication figures are requested). Choose the visual form before the library, enforce semantic color palettes, and never deliver overlapping text.

## When to Use
- Analytical charts for reports, notebooks, or exploratory data analysis
- Selecting the right visual form for a distribution, comparison, trend, or relationship
- Exporting vector SVG or high-DPI PNG figures for reports
- Fixing unreadable charts (label collisions, clipped axes, poor color contrast)

## When Not to Use
- Comparisons that are clearer as a compact Markdown table
- Architecture / sequence / state diagrams (`technical-reporting` Mermaid)
- Interactive multi-page web dashboards (`plotly-dash`)
- Computing statistical metrics or running A/B tests (`data-science`)

## Related Skills
- Use **ui-accessibility** to audit chart contrast, legends, and text alternatives for WCAG 2.2.
- Use **data-science** or **polars-duckdb** to compute and validate metrics before plotting.
- Use **html-report** when exported SVG or Plotly figures must be assembled into one offline HTML deliverable.
- Use **plotly-dash** when the figure becomes an interactive application.
- Use **technical-reporting** when embedding exported SVG figures into a saved markdown report.
- Use **data-storytelling** when the chart supports an executive business recommendation.

## 1. Form Before Chart Library (Is It Even a Chart?)
Before writing plotting code, match the data cardinality to the right representation:
- **1 number + delta/trend** → Use a KPI callout or inline stat, not a 1-bar chart.
- **1 ratio against a capacity limit** → Use a progress bar or bullet meter, not a 2-slice pie chart.
- **Exact lookup values matter more than shape, or > 7 high-cardinality classes** → Use a sorted Markdown table with explicit numbers and `%` deltas.
- **> 5 time-series lines on one axis (spaghetti plot)** → Highlight 1–2 focal series in color against muted gray context lines, or split into small multiples (`facet_col` / `facet_row`).

## 2. Chart Selection Matrix

| Analytical Purpose | Preferred Form | Avoid |
| :--- | :--- | :--- |
| **Compare categories** | Horizontal bar (when labels > 8 chars or > 5 categories) / vertical bar | Pie / donut with > 4 slices, 3D bars |
| **Distribution & spread** | Histogram + median/p95 markers, box + strip, raincloud / violin | Mean-only bar chart with error bars hiding multimodal skew |
| **Trend over time** | Line chart (with shaded CI band if noisy) | Bar chart with truncated non-zero y-axis |
| **Relationship / joint** | Scatter (with alpha / hexbin for N > 2,000), residual plot | Dual-axis charts with arbitrary scale ratios |
| **Part-to-whole** | 100% stacked horizontal bar (<= 5 parts) | Stacked area with > 4 volatile series |
| **Model evaluation** | Calibration reliability curve, PR curve, lift/gain chart, confusion matrix | Raw ROC curve alone on heavily imbalanced data |

## 3. Semantic Color & Accessibility Discipline
Every color in a chart must perform exactly one of four jobs:
1. **Categorical (unordered groups, <= 6 classes)**: Use a colorblind-safe qualitative palette (Okabe-Ito: `#0072B2`, `#E69F00`, `#009E73`, `#CC79A7`, `#56B4E9`, `#D55E00`). Group tail categories into `"Other"` (`#999999`).
2. **Sequential (ordered magnitude, low → high)**: Use a perceptually uniform ramp (`Viridis`, `Cividis`, or single-hue blue/teal).
3. **Diverging (deviation around a meaningful zero/baseline)**: Use a symmetric two-hue ramp (`RdBu`, `Coolwarm`) anchored strictly at the neutral reference value (`zmid=0`).
4. **Highlight / Alert (focal vs. context)**: Color the focal series/bar (`#0072B2` or `#D55E00`) and mute baseline/context series (`#B0B5BC`).
- **Consistency Invariant**: When generating multiple charts in one analysis, bind each category (`"Control"`, `"Treatment"`, `"Basic"`, `"Pro"`) to the exact same hex color across every figure.

## 4. Plotly Defaults & Anti-Overlap Rules
- Use `plotly.express` (`px`) for concise construction; refine with `fig.update_layout()` and `fig.update_traces()`.
- Always set `template="plotly_white"`, explicit `width` and `height` (e.g., `width=900, height=520`), and axis automargins:
  ```python
  fig.update_layout(template="plotly_white", width=900, height=520, margin=dict(l=60, r=40, t=70, b=60))
  fig.update_xaxes(automargin=True, title_text="...")
  fig.update_yaxes(automargin=True, title_text="...")
  ```
- **Anti-Overlap Protocol**:
  - Never label every point on dense series; annotate only top-N, extrema, or threshold crossings.
  - Place legends outside the plot canvas (` orientation="h", yanchor="bottom", y=1.02, xanchor="right", x=1`) or label lines directly at their right endpoint.
  - Switch to a horizontal bar chart (`orientation="h"`) whenever category labels collide or rotate > 30°.
  - Export static report figures as vector `.svg` via **Kaleido** (`fig.write_image("chart.svg", width=900, height=520)`) and visually inspect the rendered output.

## Visual QA Checklist
- [ ] Visual form matches purpose (table used when exact lookup beats shape)
- [ ] Palette matches data semantics (Okabe-Ito categorical, Viridis sequential, centered diverging)
- [ ] Category colors stay identical across all figures in the same report
- [ ] Zero overlapping or clipped titles, axis ticks, data labels, or legends
- [ ] Units (`%`, `USD`, `ms`, `N=...`) explicitly stated in title/subtitle or axis labels
- [ ] Exported `.svg`/`.png` verified at target display dimensions
