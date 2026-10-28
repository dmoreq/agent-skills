---
name: html-report
description: >-
  Build a single-file, self-contained, interactive, print-ready HTML report for
  audits, architecture explainers, comparison matrices, and decision memos.
  Not for short answers, Git-tracked Markdown, or server-backed Dash apps.
risk: safe
source: local
date_added: "2026-10-28"
---

# HTML Report Skill

Deliver findings as one offline HTML file. HTML is a presentation format; the analysis and numbers come from the owning skill.

## When to Use
- The user asks for an HTML report, visual explainer, dashboard page, audit page, or decision memo.
- A report exceeds about 100 lines of Markdown.
- Tables have 4+ rows or 3+ columns and need spatial layout, filtering, or collapsible sections.
- The reader needs browser viewing or print-to-PDF output.

## When Not to Use
- Short conversational answers, quick snippets, or lists under about 100 lines.
- Files that live in version control and are edited by hand: `README.md`, `CHANGELOG.md`, `SKILL.md`, ADRs.
- Agent-to-agent payloads or source briefs intended for model ingestion.
- Server-backed interactive apps with callbacks or routing (`plotly-dash`).
- Chart design, palette selection, or anti-overlap QA (`data-visualization`).
- Editable Markdown reports and Mermaid diagrams (`technical-reporting`).

## Artifact Path
- Persistent report: `docs/reports/YYYY-MM-DD_<topic>.html`.
- Session fallback: the host artifact directory, with the same ISO date prefix.
- Emit one file. Inline CSS, JavaScript, SVG, and data. Do not create a sidecar asset folder.
- Keep the file under 1 MB. Aggregate or downsample embedded data.
- Never write an undated file at the repository root.

## Workflow

### Step 1: Calibrate Scope, Register, and Aesthetic
1. Honor explicit user instructions first, then project design tokens from **design-system**, then the defaults below.
2. Choose the register:
   - Polished-utilitarian default for audits, run reports, data notes, and code reviews. High information density, restrained palette, hairline borders, tabular numbers, no hero banner.
   - Editorial for executive briefs, concept explainers, and deep dives. A three-act arc: what happened, why it matters, what to do.
3. Ban generic AI styling: purple-to-blue gradient heroes, neon cyberpunk dashboards, rainbow charts, emoji section headers, and centered body text.

### Step 2: Enforce a Self-Contained and Secure Architecture
- Emit a complete `<!DOCTYPE html>` document with `meta charset="utf-8"`, `meta viewport`, inline `<style>`, and inline `<script>`.
- Use native CSS Grid and Flexbox with custom properties. Never load Tailwind CSS from a CDN.
- Prefer inline SVG for flowcharts, architecture diagrams, timelines, and sparklines.
- Do not call `fetch()` or any live API. The file must work from the filesystem with no network.
- Redact credential-shaped strings before embedding logs or snippets.
- HTML-escape `&`, `<`, `>`, `"`, and `'` in every interpolated value, path, and diff.
- Embed data as UTF-8 JSON with non-ASCII preserved. Aggregate or downsample below 1 MB.
- **Controlled CDN exception**: Chart.js from a pinned CDN only when complex interactive charting is required, the user explicitly approves, the page shows an offline warning, and the script tag carries an SRI hash. Otherwise export the figure as SVG from `data-visualization` and embed it.

### Step 3: Implement Dual-Theme Tokens and Responsive Typography
- Define semantic custom properties on `:root`; support `@media (prefers-color-scheme: dark)` and manual overrides with `:root[data-theme="dark"]` and `:root[data-theme="light"]`.
- Use `html { font-size: 16px; }` and `rem` units. Body text at least 0.9375rem, labels at least 0.75rem, monospace at least 0.85rem.
- Keep prose between 65ch and 75ch. Allow tables and grids to expand to 1120px.
- Apply `font-variant-numeric: tabular-nums` to numeric columns, KPI cards, and timestamps.
- Use the exact token block and print rules in `references/html-report-scaffold.md`.

### Step 4: Structure for Scanning and Progressive Disclosure
1. Header and outcome bar: title, context, timestamp, status pill, and toolbar for theme toggle, expand/collapse all, and copy summary.
2. Sticky section navigation when the report has 4+ sections.
3. Executive rollup: a two-sentence thesis and 3-4 KPI or verdict cards. Never hide the primary conclusion in a closed tab.
4. Findings and comparison matrices: use declarative action titles, tag claims as `FACT`, `INFERENCE`, `DECISION`, or `RISK`, and cite `file:line` or a source link.
5. Wrap wide tables in a scroll container so the page never scrolls horizontally.
6. Put raw logs, methodology notes, and secondary tables inside `<details>`. Keep primary sections open by default.
7. Attach listeners with `addEventListener`, never inline `onclick`. Add search or column sort for tables over 10 rows. Provide a "Copy Summary (MD)" button for the executive summary, decisions, and open actions.

### Step 5: Guarantee Print and PDF Fidelity
Include the `@media print` block from the scaffold reference. It must:
- Hide navigation, buttons, toolbars, and filter bars.
- Force a white background and black text at 10.5pt.
- Expand closed `<details>` elements.
- Prevent breaks inside cards, tables, figures, and sections.
- Set `@page` margins to 16mm by 14mm.
- Disable animations and transitions.

### Step 6: Review and Deliver
Select the review gate from the report profile before delivery:

| Report profile | Required gate |
| :--- | :--- |
| Internal, one-off, non-interactive | `verify-and-stop` artifact check |
| Shared, interactive, or print/PDF | `ui-accessibility` -> `verify-and-stop` |
| Executive or decision report | `ux-critic` -> `ui-accessibility` -> `verify-and-stop` |

- For the shared/print gate, run `ui-accessibility` against the final file: contrast, keyboard path, focus, `<details>` disclosure, table headers, target size, and print layout.
- For the executive gate, run `ux-critic` on desktop, mobile, and print screenshots: squint test, hierarchy, state honesty, and microcopy.
- Never publish or upload the file to an external service without explicit confirmation.
- Save the `.html` file, give the path, and return a concise executive summary in chat. Do not dump raw HTML.
- The decisive `verify-and-stop` check remains: one file, no external requests, both themes render, print preview expands details.

## Verification Checklist
- [ ] The request genuinely benefits from HTML spatial layout or interactivity.
- [ ] One complete offline file with inline CSS, JavaScript, SVG, and data.
- [ ] No Tailwind CDN and no live `fetch()`.
- [ ] Secrets redacted and all interpolated text escaped.
- [ ] Light and dark themes work through tokens.
- [ ] Print CSS expands details and hides chrome.
- [ ] Headline conclusion and KPIs are visible without a click.
- [ ] The selected review gate matches the report profile.
- [ ] Shared or print reports passed `ui-accessibility`.
- [ ] Executive reports passed `ux-critic`.

## Related Skills
- Use **design-system** for project tokens, component specs, and theme parity; this skill consumes them.
- Use **ui-accessibility** for shared, interactive, or print reports; audit contrast, keyboard, focus, and table semantics.
- Use **ux-critic** for executive or decision reports; critique hierarchy, state honesty, and microcopy.
- Use **technical-reporting** for editable Markdown reports, ADRs, Mermaid, and `docs/reports/YYYY-MM-DD_*.md` conventions.
- Use **data-visualization** for chart selection, palettes, anti-overlap QA, and SVG export; this skill embeds charts, it does not design them.
- Use **plotly-dash** when the deliverable needs server callbacks, routing, `dcc.Store`, or background jobs.
- Use **data-storytelling** when the report needs a Hook → Ask decision narrative; render after the numbers are validated.
- Use **verify-and-stop** to run the decisive artifact check once and stop.
