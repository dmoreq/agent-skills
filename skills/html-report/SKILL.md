---
name: html-report
description: >-
  Build a single-file, self-contained, interactive, print-ready HTML report for
  audits, architecture explainers, comparison matrices, and decision memos using
  Zen Minimalism and three curated presets (dossier, zen-garden, chronicle).
  Not for short answers, Git-tracked Markdown, or server-backed Dash apps.
risk: safe
source: local
date_added: "2026-10-28"
---

# HTML Report Skill

Deliver findings as one offline HTML file. HTML is a presentation format; the analysis and numbers come from the owning skill. Every generated report strictly follows **Zen Minimalism** principles and ships with three built-in aesthetic presets.

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
- Review artifacts (screenshots, audits, record) live in `.tmp/` or `docs/reports/`, never beside the report.

## Curated Zen Minimalism Presets (Strict 3-Option Architecture)

Every report implements these three named templates via `data-preset`, defaulting to **`dossier`**, with a preset selector in the toolbar: **`dossier`** (Clinical Dossier, default), **`zen-garden`** (Zen Garden), and **`chronicle`** (Slow Chronicle). The full palette, origin, layout, and typography specs live in `references/html-report-scaffold.md` section 1.

## Zen Minimalism Wording & Paragraphing Rules
1. **Kanso (Essentialist Prose)**: Strip ornamental adjectives, hype superlatives, and throat-clearing meta-intros. Open every section with a single declarative thesis sentence containing the primary number and direction.
2. **Ma (Paragraph Breathing Room)**: Cap paragraphs at 2-3 sentences and `<= 60 words` (<= 70ch width). Never emit dense wall-of-text paragraphs; let whitespace separate distinct ideas.
3. **Shibumi (Understated Precision)**: State exact deltas (`+8.36pp`, `N = 4,365,797`) in calm, active voice. Let verified numbers carry authority rather than exclamation marks or marketing buzzwords.
4. **Sequential Chapter Rhythm**: Guide the eye through numbered architectural chapters (`01`, `02`, `03`...) where the chapter lead states *why it matters* in <= 25 words before presenting the table or chart.

## Visual Quality Bar (Blocking)

Judge rendered output, never source alone. Render matrix, hard-fail list, craft minimums, and record template: `references/review-gate.md`.

- Render desktop 1440x900, mobile 390x844, 320px reflow, and print/PDF in light and dark.
- Any overlap, clipping, horizontal scroll, contrast failure, broken control, console error, external request, or unexpanded print detail blocks delivery.
- Screenshots are review evidence, not report assets.

## Workflow

### Step 1: Calibrate Scope, Preset, and Zen Register
1. Honor explicit user instructions first, then project design tokens from **design-system**, then the preset defaults below. A preset owns layout and typography; project tokens override its palette.
2. Honor an explicit preset choice (`dossier`, `zen-garden`, or `chronicle`); otherwise default to `data-preset="dossier"` and include the 3-preset switcher in `.toolbar`.
3. Ban generic AI styling: cold slate/blue browser defaults, purple-to-blue gradients, neon cyberpunk dashboards, rainbow charts, emoji section headers, and nested bordered cards.
4. Never use pure `#FFFFFF` page backgrounds or pure `#000000` ink in light mode; use the warm organic paper and charcoal tokens in `references/html-report-scaffold.md`.

### Step 2: Enforce a Self-Contained and Secure Architecture
- Emit a complete `<!DOCTYPE html>` document with `meta charset="utf-8"`, `meta viewport`, inline `<style>`, and inline `<script>`.
- Use native CSS Grid and Flexbox with custom properties. Never load Tailwind CSS from a CDN.
- Prefer inline SVG for flowcharts, architecture diagrams, timelines, and bar/delta comparisons.
- Do not call `fetch()` or any live API. The file must work from the filesystem with no network.
- Redact credential-shaped strings before embedding logs or snippets.
- HTML-escape `&`, `<`, `>`, `"`, and `'` in every interpolated value, path, and diff.
- Embed data as UTF-8 JSON with non-ASCII preserved. Aggregate or downsample below 1 MB.
- **Controlled CDN exception**: Chart.js from a pinned CDN only when complex interactive charting is required, the user explicitly approves, the page shows an offline warning, and the script tag carries an SRI hash. Otherwise export the figure as SVG from `data-visualization` and embed it.

### Step 3: Implement Dual-Theme Tokens, Presets, and Responsive Typography
- Define semantic custom properties on `:root` for `dossier` (default), `zen-garden`, and `chronicle`; support `@media (prefers-color-scheme: dark)` and manual overrides with `:root[data-theme="dark"]` and `:root[data-theme="light"]`.
- Use `html { font-size: 16px; }` and `rem` units. Body text at least 0.9375rem, labels at least 0.75rem, monospace at least 0.84rem.
- Keep prose between 60ch and 70ch. Allow tables and grids to expand up to 1220px in `dossier`.
- Apply `font-variant-numeric: tabular-nums` to numeric columns, KPI cards, and timestamps.
- Use the exact 3-preset token block, layout rules, and print rules in `references/html-report-scaffold.md`.

### Step 4: Structure for Scanning and Progressive Disclosure
1. Header and outcome bar: eyebrow label, declarative title, cohort/timestamp metadata, status pill, and toolbar with preset switcher (`Dossier`, `Zen Garden`, `Chronicle`), theme toggle, expand/collapse all, and copy summary.
2. Sticky section navigation with numbered anchors (`01` through `06`) when the report has 4+ sections.
3. Executive rollup: a one- or two-sentence thesis callout (`.thesis-box`) and 3-4 biomarker-style KPI cards (`.kpi-grid`). Never hide the primary conclusion in a closed tab.
4. Findings and comparison matrices: use declarative action titles, tag claims as `FACT`, `INFERENCE`, `DECISION`, or `RISK` when auditing, and cite `file:line` or a source link.
5. Wrap wide tables in `.table-wrap` so the page never scrolls horizontally.
6. Put raw logs, methodology invariants, and secondary deep-dives inside `<details>`. Keep primary sections open by default.
7. Attach listeners with `addEventListener`, never inline `onclick`. Add search filtering for tables over 6 rows. Provide a "Copy Summary (MD)" button for the executive summary.
8. Apply the minimalism and YAGNI doctrine from **design-system**: one primary action, no unrequested navigation, search, filter, export, or account chrome, and whitespace over nested cards.

### Step 5: Guarantee Print and PDF Fidelity
Include the `@media print` block from `references/html-report-scaffold.md`. It must:
- Hide navigation, preset switchers, buttons, toolbars, and filter inputs.
- Force a white background and black text at 10.5pt.
- Collapse split grids into a clean single-column print flow and expand closed `<details>` elements.
- Prevent breaks inside cards, tables, figures, and sections.
- Set `@page` margins to 16mm by 14mm and disable animations/transitions.

### Step 6: Mandatory Delivery Gate

This review gate is blocking. Do not call the report complete until every profile gate passes; an unrun gate is a fail. Full rules, repair loop, and record template: `references/review-gate.md`.

| Report profile | Required gates, in order |
| :--- | :--- |
| Internal | Structural self-check -> rendered visual inspection -> `verify-and-stop` |
| Shared or print | Structural self-check -> rendered visual inspection -> `ui-accessibility` -> `verify-and-stop` |
| Executive | Structural self-check -> rendered visual inspection -> `ui-accessibility` -> `ux-critic` -> `verify-and-stop` |

- **Classify by consumption**: Internal is session-only, unshared, and unprinted; Shared is persisted, attached, or read by others; Print is any print/PDF intent; Executive is a decision or leadership audience. Toolbar controls do not make a report interactive. If two profiles fit, choose the stricter one; when uncertain, default to Shared.
- **Structural check**: run `scripts/check_html_report.py` from this skill directory; it must exit 0 with `PASS`.
- **Visual check**: render the matrix, fix Critical and Important findings, and re-render. Bound the loop to 2 cycles; a remaining Critical defect blocks delivery.
- **Shared or print**: `ui-accessibility` must return `Pass`.
- **Executive**: `ux-critic` must return `Ship` or `Ship with fixes` with zero Critical findings.
- **Record**: write `docs/reports/YYYY-MM-DD_<topic>_review.md` and link screenshots and audits.
- Missing screenshots, an unrun audit, or `Not tested` blocks delivery. Do not claim visual verification from source.
- `verify-and-stop` remains the final decisive check: one file, no external requests, both themes render, print preview expands details.

## Verification Checklist

Delivery is blocked until every checked item is true.

- [ ] The request benefits from HTML layout or interactivity.
- [ ] The profile is classified by consumption rules; uncertain cases default to Shared.
- [ ] One offline file with inline CSS, JavaScript, SVG, and data.
- [ ] All 3 presets work, with `dossier` default.
- [ ] Prose follows the 2-3 sentence, <= 60 word budget.
- [ ] No Tailwind CDN, live `fetch()`, inline `onclick`, or unapproved request.
- [ ] Secrets redacted and interpolated text escaped.
- [ ] Light and dark themes work across all 3 presets.
- [ ] Print expands details, hides chrome, and survives a real print/PDF render.
- [ ] Desktop, mobile, 320px reflow, and print were rendered and inspected.
- [ ] Zero hard-fail defects; Critical and Important findings fixed and re-checked within 2 cycles.
- [ ] Shared/print passed `ui-accessibility`; executive passed `ux-critic`.
- [ ] The review record exists and links every screenshot and audit.
- [ ] No gate is unrun, `Not tested`, or `Fail`.

## Related Skills
- Use **design-system** for project tokens, component specs, theme parity, and the Zen minimalism/YAGNI doctrine; this skill consumes them.
- Use **ui-accessibility** for shared, interactive, or print reports; audit contrast, keyboard, focus, and table semantics.
- Use **ux-critic** for executive or decision reports; critique hierarchy, state honesty, and microcopy.
- Use **technical-reporting** for editable Markdown reports, ADRs, Mermaid, and `docs/reports/YYYY-MM-DD_*.md` conventions.
- Use **data-visualization** for chart selection, palettes, anti-overlap QA, and SVG export; this skill embeds charts, it does not design them.
- Use **plotly-dash** when the deliverable needs server callbacks, routing, `dcc.Store`, or background jobs.
- Use **data-storytelling** when the report needs a Hook -> Ask decision narrative with Zen Minimalism pacing.
- Use **verify-and-stop** to run the decisive artifact check once and stop.
- The gate decision stays with this skill; audit skills supply evidence, not waivers.
