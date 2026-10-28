---
name: html-report
description: >-
  Build a single-file, offline-first, interactive, print-ready HTML report for
  audits, architecture explainers, comparison matrices, and decision memos using
  Zen Minimalism and three curated presets (dossier, zen-garden, chronicle).
  Not for short answers, Git-tracked Markdown, or server-backed Dash apps.
risk: safe
source: local
date_added: "2026-10-28"
---

# HTML Report Skill

Deliver findings as one offline-capable HTML file. HTML is a presentation format; the analysis and numbers come from the owning skill. Every report strictly follows **Zen Minimalism** principles and ships with three built-in aesthetic and typographic presets.

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

## Curated Zen Minimalism Presets & Typography System (Single-Preset Output)

Each report uses exactly one preset via `data-preset` on `<html>`, chosen by the generator from the report profile. Default to **`dossier`**; never expose a runtime preset switcher. Each preset has a **distinct editorial typography pairing** loaded via Google Fonts (`Fraunces`, `Cormorant Garamond`, `Plus Jakarta Sans`, `Inter`, `JetBrains Mono`) with graceful offline fallbacks.

Preset routing: **`dossier`** for audits, engineering reports, and decision memos; **`zen-garden`** for contemplative deep dives; **`chronicle`** for executive narratives and QBRs. Select one before writing markup. Do not ask the reader to choose.

| Preset ID | Memorable Name | Palette (Canvas / Surface / Accent) | Typography Pairing (`--font-display` / `--font-sans` / `--font-mono`) | Layout & Pacing |
| :--- | :--- | :--- | :--- | :--- |
| **`dossier`** *(Default)* | **Clinical Dossier** *(Shibumi)* | Parchment `#F7F4EE` / Cream `#FDFBF7` / Clay `#9E583B` | `'Fraunces'` `350`/`400` + `'Inter'` `400`/`500` + `'JetBrains Mono'` | `240px` sticky chapter sidebar + fluid column, `3.5rem` padding, `1220px` max-width. |
| **`zen-garden`** | **Zen Garden** *(Karesansui)* | Limestone `#F4F1EA` / Stone `#F9F7F2` / Moss `#4A6B53` | `'Cormorant Garamond'` `300`/`400` + `'Inter'` `400`/`500` + `'JetBrains Mono'` | Centered `960px` stream, centered headers, `5.25rem` *Ma* space. |
| **`chronicle`** | **Slow Chronicle** *(Kinfolk)* | Paper `#FBF9F5` / Sand `#F5F0E6` / Terracotta `#A65638` | `'Cormorant Garamond'` `300`/`400` + `'Plus Jakarta Sans'` `400`/`500` + `'JetBrains Mono'` | `1020px` editorial column, horizontal chapter banners. |

## Mandatory Typography & Micro-Typesetting Rules
1. **Webfonts**: Load `Fraunces`, `Cormorant Garamond`, `Plus Jakarta Sans`, `Inter`, and `JetBrains Mono` with `preconnect` and `display=swap`; back them with local fallbacks. This stylesheet is the only permitted network request.
2. **Optical sizing**: Set `font-optical-sizing: auto` and `font-feature-settings: "kern" 1, "liga" 1, "calt" 1` on headings, thesis, KPI figures, summaries, and body.
3. **Display contrast**: Serif headings use weights `300`/`350`/`400` (never `700`), tracking `-0.03em` to `-0.012em`, and line-height `1.04`-`1.06` for `h1`, `1.12` for `h2`.
4. **Italic nuance**: Use `<em>` for emphasis in `.thesis-box p` and section titles instead of bold sans.
5. **Numeric precision**: Numeric cells, KPI deltas, and SVG axes use `var(--font-mono)`, `tabular-nums`, and `-0.01em`.
6. **Labels**: Uppercase eyebrows, KPI labels, and table headers use `var(--font-mono)`, `0.75rem`, weight `500`, and `+0.08em` to `+0.1em`; no tabular numerals.

## Chart Interaction Contract
- Use native SVG, not a library: hover/focus tooltip, legend dimming, and chart/table cross-highlight.
- Always show data labels: percentages two decimals (`78.52`), counts `k`/`M` (`501k`). Labels `>=12px`, `aria-hidden`, `pointer-events="none"`, never overlapping. Exact values stay in the tooltip and table.
- Chart SVG uses `role="group"`; each mark uses `role="img"`, `tabindex="0"`, `aria-label`; tooltip uses `role="status"` and `visibility`. Respect reduced motion and print.
- The table is the accessible source; see the scaffold pattern.

## Zen Minimalism Wording & Paragraphing Rules
1. **Kanso (Essentialist Prose)**: Strip ornamental adjectives, hype superlatives, and throat-clearing intros. Open every section with a single declarative thesis sentence containing the primary number and direction.
2. **Ma (Paragraph Breathing Room)**: Keep paragraphs at 2-3 sentences, <= 60 words (60ch-70ch measure; target 66ch). Never emit dense wall-of-text paragraphs; let whitespace separate distinct ideas.
3. **Shibumi (Understated Precision)**: State exact deltas (`+8.36 pp`, `N = 4,365,797`) in calm, active voice. Let verified numbers carry authority rather than exclamation marks.
4. **Sequential Chapter Rhythm**: Guide the eye through numbered architectural chapters (`01`, `02`, `03`...) where the chapter lead states *why it matters* in <= 25 words before presenting the table or chart.

## Workflow

### Step 1: Calibrate Scope, Preset, and Zen Register
1. Choose one preset: `dossier` for audits, engineering, and decision memos; `zen-garden` for contemplative deep dives; `chronicle` for executive narratives and QBRs. Default to `dossier`. Do not render a switcher.
2. Honor user instructions, then project tokens from **design-system**, then preset defaults. Presets own layout and typography; project tokens override palette.
3. Ban cold slate/blue defaults, purple gradients, neon dashboards, rainbow charts, emoji headers, and nested cards.
4. Never use pure `#FFFFFF` or `#000000` in light mode.

### Step 2: Enforce a Self-Contained and Secure Architecture
- Emit a complete `<!DOCTYPE html>` with `meta charset`, `meta viewport`, the font `<link>`, inline `<style>`, and inline `<script>`.
- Use CSS Grid, Flexbox, and custom properties; never load Tailwind.
- Prefer inline SVG for diagrams and bar/delta comparisons.
- Never call `fetch()` or a live API. The font stylesheet is the only network request; the file must render offline with fallbacks. Do not fake SRI on fonts.
- Redact credential-shaped strings and HTML-escape `&`, `<`, `>`, `"`, and `'` in every interpolated value.
- **Controlled Chart.js exception**: pinned CDN only when the user explicitly approves, the page shows an offline warning, and the script tag carries a verified SRI hash; otherwise embed an SVG from `data-visualization`.

### Step 3: Implement Dual-Theme Tokens, Presets, and Responsive Typography
- Define per-preset tokens on `:root`, with `prefers-color-scheme` and manual `data-theme` overrides.
- Use `html { font-size: 16px; }` and `rem`. Body prose `>=0.9375rem`, labels `>=0.75rem`, code `>=0.82rem`.
- Keep exactly one preset token block; delete the other two. Use the nine editorial roles and print rules in `references/html-report-scaffold.md`.

### Step 4: Structure for Scanning and Progressive Disclosure
1. Header: declarative serif title, one provenance line (date, cohort, revision), and a single `Theme` button at the top-right. No eyebrow, status pill, preset switcher, expand/collapse, or copy-summary controls.
2. Sticky section navigation with numbered anchors (`01` through `06`) when the report has 4+ sections.
3. Executive rollup: a one- or two-sentence thesis callout (`.thesis-box`) and 3-4 biomarker-style KPI cards (`.kpi-grid`). Never hide the primary conclusion in a closed tab.
4. Findings and comparison matrices: use declarative action titles, tag claims as `FACT`, `INFERENCE`, `DECISION`, or `RISK` when auditing, and cite `file:line` or a source link.
5. Wrap wide tables in `.table-wrap` and place secondary deep-dives inside `<details>`. Attach listeners with `addEventListener`, never inline `onclick`. Add search filtering for tables over 6 rows.
6. Apply the minimalism and YAGNI doctrine from **design-system**: one primary action, no unrequested navigation, search, filter, export, or account chrome, and whitespace over nested cards.

### Step 5: Guarantee Print and PDF Fidelity
Include the `@media print` block from `references/html-report-scaffold.md` to hide chrome, force white background/black text at 10.5pt, collapse split grids, expand `<details>`, prevent page breaks inside blocks, and set `@page` margins to 16mm by 14mm.

### Step 6: Review and Deliver
Select the review gate from the report profile before delivery:

| Report profile | Required gate |
| :--- | :--- |
| Internal, one-off, non-interactive | `verify-and-stop` artifact check |
| Shared, interactive, or print/PDF | `ui-accessibility` -> `verify-and-stop` |
| Executive or decision report | `ux-critic` -> `ui-accessibility` -> `verify-and-stop` |

- Never publish or upload the file to an external service without explicit confirmation.
- Save the `.html` file, give the path, and return a concise executive summary in chat. Do not dump raw HTML.
- The decisive `verify-and-stop` check remains: one file, one preset, no scripted network requests, both themes render, print preview expands details.

## Verification Checklist
- [ ] One complete HTML file with inline CSS, JavaScript, SVG, data, and the Google Fonts `<link>` block.
- [ ] Exactly one preset is fixed at generation time; no preset switcher is present.
- [ ] Header contains only the title, one provenance line, and the Theme button at top-right.
- [ ] Display serifs use light/regular weights (`300`/`350`/`400`), optical sizing, and tight tracking (`-0.03em` to `-0.012em`).
- [ ] Prose follows Zen Minimalism wording and paragraphing (2-3 sentences, <= 60 words per paragraph).
- [ ] No Tailwind CDN and no live `fetch()`; the font stylesheet is the only network request and degrades offline.
- [ ] Light and dark themes work through semantic tokens; print CSS expands details and hides the Theme button.
- [ ] Headline conclusion and KPIs are visible without a click.
- [ ] The selected review gate matches the report profile (`ui-accessibility` / `ux-critic`).
- [ ] Shared or print reports passed `ui-accessibility`.
- [ ] Executive reports passed `ux-critic`.

## Related Skills
- Use **design-system** for project tokens, component specs, theme parity, and the Zen minimalism/YAGNI doctrine; this skill consumes them.
- Use **ui-accessibility** for shared, interactive, or print reports; audit contrast, keyboard, focus, and table semantics.
- Use **ux-critic** for executive or decision reports; critique hierarchy, state honesty, and microcopy.
- Use **technical-reporting** for Markdown reports, ADRs, Mermaid, and `docs/reports/YYYY-MM-DD_*.md` conventions.
- Use **data-visualization** for chart selection, palettes, anti-overlap QA, and SVG export.
- Use **plotly-dash** for server callbacks, routing, `dcc.Store`, or background jobs.
- Use **data-storytelling** for a Hook -> Ask decision narrative.
- Use **verify-and-stop** for the decisive artifact check.
