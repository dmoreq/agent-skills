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
- Review artifacts (screenshots, audits, record) live in `.tmp/` or `docs/reports/`, never beside the report.

## Preset & Typography Contract (Single Preset)

Exactly one preset is fixed at generation time via `data-preset` on `<html>`; never expose a runtime preset switcher. Route **`dossier`** to audits, engineering reports, and decision memos; **`zen-garden`** to contemplative deep dives; **`chronicle`** to executive narratives and QBRs. Default to `dossier`.

Load the Google Fonts stylesheet with `display=swap` and local fallbacks; it is the only permitted network request. Use a 60ch-70ch measure, body prose `>=0.9375rem`, labels `>=0.75rem`, and code `>=0.82rem`. The palette, type pairings, nine editorial roles, and per-preset layout live in `references/html-report-scaffold.md`.

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

## Visual Quality Bar (Blocking)

Judge rendered output, never source alone. Render matrix, hard-fail list, craft minimums, and record template: `references/review-gate.md`.

- Render the chosen preset at desktop 1440x900, mobile 390x844, 320px reflow, and print/PDF in light and dark.
- Any overlap, clipping, horizontal scroll, contrast failure, broken control, console error, external request outside the font stylesheet, or unexpanded print detail blocks delivery.
- Missing screenshots block delivery; screenshots are review evidence, not report assets.

## Workflow

### Step 1: Calibrate Scope and Preset
Choose one preset from the routing table. Honor user instructions, then project tokens from **design-system**, then preset defaults. Ban cold slate/blue defaults, purple gradients, neon dashboards, rainbow charts, emoji headers, and nested cards; never use pure `#FFFFFF` or `#000000` in light mode.

### Step 2: Enforce a Self-Contained and Secure Architecture
- Emit `<!DOCTYPE html>` with `meta charset`, `meta viewport`, the Google Fonts `<link>`, inline `<style>`, and inline `<script>`.
- Never call `fetch()` or a live API. The font stylesheet is the only network request; keep local fallbacks. Never load Tailwind.
- Redact credential-shaped strings, HTML-escape interpolated text, and allow the controlled Chart.js exception only when the user explicitly approves, the page shows an offline warning, and the script tag carries a verified SRI hash.

### Step 3: Implement Dual-Theme Tokens and Responsive Typography
- Define per-preset tokens on `:root` with `prefers-color-scheme` and manual `data-theme` overrides; keep exactly one preset token block.
- Use `rem` units. Body prose `>=0.9375rem`, labels `>=0.75rem`, code `>=0.82rem`. Use the nine editorial roles and print rules in `references/html-report-scaffold.md`.

### Step 4: Structure for Scanning and Progressive Disclosure
1. Header: declarative serif title, one provenance line, and a single `Theme` button. No eyebrow, status pill, preset switcher, expand/collapse, or copy-summary controls.
2. Use numbered section navigation for 4+ sections, a thesis callout, and 3-4 KPI cards. Keep the primary conclusion visible without a click.
3. Tag audit claims as `FACT`, `INFERENCE`, `DECISION`, or `RISK`; cite `file:line` or a source. Wrap wide tables in `.table-wrap`; put secondary detail inside `<details>`.
4. Use `addEventListener`, never inline `onclick`. Apply **design-system** YAGNI: one primary action, no unrequested chrome, whitespace over nested cards.

### Step 5: Guarantee Print and PDF Fidelity
Include the `@media print` block from `references/html-report-scaffold.md` to hide chrome, force white background/black text at 10.5pt, collapse split grids, expand `<details>`, prevent page breaks inside blocks, and set `@page` margins to 16mm by 14mm.

### Step 6: Mandatory Delivery Gate

This review gate is blocking. Do not call the report complete until every profile gate passes; an unrun gate is a fail. Full classification rules, repair loop, and record template: `references/review-gate.md`.

| Report profile | Required gates, in order |
| :--- | :--- |
| Internal | Structural self-check -> rendered visual inspection -> `verify-and-stop` |
| Shared or print | Structural self-check -> rendered visual inspection -> `ui-accessibility` -> `verify-and-stop` |
| Executive | Structural self-check -> rendered visual inspection -> `ui-accessibility` -> `ux-critic` -> `verify-and-stop` |

- **Classify by consumption**: Internal is session-only, unshared, and unprinted; Shared is persisted, attached, or read by others; Print is any print/PDF intent; Executive is a decision or leadership audience. If two profiles fit, choose the stricter one; when uncertain, default to Shared.
- **Structural check**: run `scripts/check_html_report.py` from this skill directory; it must exit 0 with `PASS`.
- **Visual check**: render the chosen preset at desktop 1440x900, mobile 390x844, 320px reflow, and print/PDF in light and dark. Fix Critical and Important findings and re-render; bound the loop to 2 cycles.
- **Shared or print**: `ui-accessibility` must return `Pass`.
- **Executive**: `ux-critic` must return `Ship` or `Ship with fixes` with zero Critical findings.
- **Record**: write `docs/reports/YYYY-MM-DD_<topic>_review.md` and link screenshots and audits.
- Missing screenshots, an unrun audit, or `Not tested` blocks delivery. Do not claim visual verification from source.
- `verify-and-stop` remains the final decisive check: one file, one preset, the font stylesheet as the only request, both themes render, print expands details.

## Verification Checklist

Delivery is blocked until every checked item is true.

- [ ] One complete HTML file with inline CSS, JavaScript, SVG, data, and the Google Fonts `<link>` block.
- [ ] Exactly one preset is fixed at generation time; no preset switcher is present.
- [ ] The profile is classified by consumption rules; uncertain cases default to Shared.
- [ ] Header contains only the title, one provenance line, and the Theme button.
- [ ] Display serifs use light/regular weights, optical sizing, and tight tracking.
- [ ] Prose follows the 2-3 sentence, <= 60 word, 60ch-70ch budget.
- [ ] No Tailwind CDN and no live `fetch()`; the font stylesheet is the only network request.
- [ ] Light and dark themes work; print expands details and hides the Theme button.
- [ ] Desktop, mobile, 320px reflow, and print were rendered and inspected.
- [ ] Zero hard-fail defects; Critical and Important findings fixed within 2 cycles.
- [ ] Shared/print passed `ui-accessibility`; executive passed `ux-critic`.
- [ ] The review record exists and links every screenshot and audit.
- [ ] No gate is unrun, `Not tested`, or `Fail`.

## Related Skills
- Use **design-system** for project tokens, component specs, theme parity, and the Zen minimalism/YAGNI doctrine; this skill consumes them.
- Use **ui-accessibility** for shared, interactive, or print reports; audit contrast, keyboard, focus, and table semantics.
- Use **ux-critic** for executive or decision reports; critique hierarchy, state honesty, and microcopy.
- Use **technical-reporting** for Markdown reports, ADRs, Mermaid, and `docs/reports/YYYY-MM-DD_*.md` conventions.
- Use **data-visualization** for chart selection, palettes, anti-overlap QA, and SVG export.
- Use **plotly-dash** for server callbacks, routing, `dcc.Store`, or background jobs.
- Use **data-storytelling** for a Hook -> Ask decision narrative.
- Use **verify-and-stop** for the decisive artifact check.
- The gate decision stays with this skill; audit skills supply evidence, not waivers.
