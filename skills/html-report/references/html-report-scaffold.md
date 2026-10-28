# HTML Report Scaffold

Reference for `html-report`. Copy the skeleton and trim what the report does not need. Keep every rule that protects offline use, readability, and print fidelity.

## 1. Document Skeleton

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Report Title</title>
  <style>
    /* tokens, base, layout, components, print */
  </style>
</head>
<body>
  <header class="report-header">
    <div>
      <p class="eyebrow">Audit Report</p>
      <h1>Declarative Finding Title</h1>
      <p class="meta">2026-10-28 · Revision abc1234</p>
    </div>
    <span class="status-pill status-ok">Complete</span>
    <div class="toolbar no-print">
      <button type="button" id="theme-toggle">Theme</button>
      <button type="button" id="expand-all">Expand all</button>
      <button type="button" id="collapse-all">Collapse all</button>
      <button type="button" id="copy-summary">Copy Summary (MD)</button>
    </div>
  </header>

  <nav class="section-nav no-print" aria-label="Sections">
    <a href="#summary">Summary</a>
    <a href="#findings">Findings</a>
    <a href="#evidence">Evidence</a>
  </nav>

  <main>
    <section id="summary">
      <h2>Summary</h2>
      <p class="thesis">Two-sentence thesis with the decision and its consequence.</p>
      <div class="kpi-grid">
        <article class="kpi"><span class="kpi-label">Findings</span><strong>12</strong></article>
        <article class="kpi"><span class="kpi-label">Critical</span><strong>2</strong></article>
        <article class="kpi"><span class="kpi-label">Coverage</span><strong>87%</strong></article>
      </div>
    </section>

    <section id="findings">
      <h2>Database Pool Saturates at 120 RPS</h2>
      <div class="table-wrap">
        <table>
          <thead><tr><th>ID</th><th>Severity</th><th>Location</th><th>Failure</th></tr></thead>
          <tbody><!-- rows --></tbody>
        </table>
      </div>
      <details open>
        <summary>Evidence and raw probe output</summary>
        <pre><!-- escaped output --></pre>
      </details>
    </section>
  </main>

  <script>
    /* theme, expand/collapse, table search and sort, copy summary */
  </script>
</body>
</html>
```

## 2. Theme Tokens

```css
:root, :root[data-theme="light"] {
  --bg-page: #f8fafc;
  --bg-card: #ffffff;
  --bg-subtle: #f1f5f9;
  --text-primary: #0f172a;
  --text-secondary: #475569;
  --text-muted: #64748b;
  --border: #e2e8f0;
  --accent: #0284c7;
  --accent-subtle: #e0f2fe;
  --status-ok: #15803d;
  --status-warn: #b45309;
  --status-bad: #b91c1c;
}

@media (prefers-color-scheme: dark) {
  :root:not([data-theme="light"]) {
    --bg-page: #0b0f19;
    --bg-card: #111827;
    --bg-subtle: #1e293b;
    --text-primary: #f1f5f9;
    --text-secondary: #94a3b8;
    --text-muted: #64748b;
    --border: #1e293b;
    --accent: #38bdf8;
    --accent-subtle: #0c4a6e;
    --status-ok: #4ade80;
    --status-warn: #fbbf24;
    --status-bad: #f87171;
  }
}

:root[data-theme="dark"] {
  --bg-page: #0b0f19;
  --bg-card: #111827;
  --bg-subtle: #1e293b;
  --text-primary: #f1f5f9;
  --text-secondary: #94a3b8;
  --text-muted: #64748b;
  --border: #1e293b;
  --accent: #38bdf8;
  --accent-subtle: #0c4a6e;
  --status-ok: #4ade80;
  --status-warn: #fbbf24;
  --status-bad: #f87171;
}
```

## 3. Base, Layout, and Components

```css
html { font-size: 16px; }
body {
  margin: 0;
  background: var(--bg-page);
  color: var(--text-primary);
  font: 0.9375rem/1.55 system-ui, -apple-system, "Segoe UI", sans-serif;
}
main { max-width: 1120px; margin: 0 auto; padding: 1.5rem 1.25rem 4rem; }
p, li { max-width: 72ch; }
h1, h2, h3 { line-height: 1.25; break-after: avoid; }
.eyebrow, .kpi-label { font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.04em; color: var(--text-muted); }
.meta, .status-pill { font-variant-numeric: tabular-nums; }
.report-header {
  display: flex;
  flex-wrap: wrap;
  gap: 0.75rem;
  align-items: center;
  justify-content: space-between;
  padding: 1.25rem;
  background: var(--bg-card);
  border-bottom: 1px solid var(--border);
}
.toolbar { display: flex; gap: 0.5rem; flex-wrap: wrap; }
button {
  font: inherit;
  padding: 0.4rem 0.75rem;
  color: var(--text-primary);
  background: var(--bg-subtle);
  border: 1px solid var(--border);
  border-radius: 0.375rem;
  cursor: pointer;
}
.status-pill { padding: 0.2rem 0.6rem; border-radius: 999px; font-size: 0.75rem; border: 1px solid currentColor; }
.status-ok { color: var(--status-ok); }
.status-warn { color: var(--status-warn); }
.status-bad { color: var(--status-bad); }
.section-nav {
  position: sticky;
  top: 0;
  z-index: 2;
  display: flex;
  gap: 1rem;
  padding: 0.6rem 1.25rem;
  background: var(--bg-card);
  border-bottom: 1px solid var(--border);
}
.section-nav a { color: var(--accent); text-decoration: none; font-size: 0.85rem; }
.kpi-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(150px, 1fr)); gap: 0.75rem; }
.kpi {
  padding: 0.9rem;
  background: var(--bg-card);
  border: 1px solid var(--border);
  border-radius: 0.5rem;
  font-variant-numeric: tabular-nums;
}
.kpi strong { display: block; font-size: 1.6rem; }
.table-wrap { overflow-x: auto; margin: 1rem 0; }
table { border-collapse: collapse; width: 100%; font-variant-numeric: tabular-nums; }
th, td { padding: 0.5rem 0.65rem; text-align: left; border-bottom: 1px solid var(--border); }
th { background: var(--bg-subtle); font-size: 0.8rem; text-transform: uppercase; letter-spacing: 0.03em; }
tr:hover td { background: var(--bg-subtle); }
details { margin: 0.75rem 0; padding: 0.5rem 0.75rem; background: var(--bg-card); border: 1px solid var(--border); border-radius: 0.5rem; }
summary { cursor: pointer; font-weight: 600; }
pre { overflow-x: auto; padding: 0.75rem; background: var(--bg-subtle); border-radius: 0.375rem; font-size: 0.85rem; }
code, pre { font-family: ui-monospace, SFMono-Regular, Menlo, monospace; }
.badge { display: inline-block; padding: 0.1rem 0.45rem; border-radius: 999px; font-size: 0.7rem; border: 1px solid var(--border); }
```

## 4. Print CSS

```css
@media print {
  .no-print, nav, button, .toolbar, .filter-bar { display: none !important; }
  body { background: #ffffff !important; color: #000000 !important; font-size: 10.5pt; line-height: 1.45; }
  main { max-width: 100% !important; padding: 0 !important; margin: 0 !important; }
  details:not([open]) > *:not(summary) { display: block !important; }
  section, .card, table, figure, details { break-inside: avoid; page-break-inside: avoid; box-shadow: none !important; }
  h1, h2, h3 { break-after: avoid; }
  *, *::before, *::after { animation: none !important; transition: none !important; opacity: 1 !important; }
  @page { margin: 16mm 14mm; }
}
```

## 5. Interaction Patterns

```js
const root = document.documentElement;
const themeButton = document.getElementById("theme-toggle");
themeButton?.addEventListener("click", () => {
  const next = root.dataset.theme === "dark" ? "light" : "dark";
  root.dataset.theme = next;
  localStorage.setItem("report-theme", next);
});

const storedTheme = localStorage.getItem("report-theme");
if (storedTheme) root.dataset.theme = storedTheme;

document.getElementById("expand-all")?.addEventListener("click", () => {
  document.querySelectorAll("details").forEach((item) => { item.open = true; });
});

document.getElementById("collapse-all")?.addEventListener("click", () => {
  document.querySelectorAll("details").forEach((item) => { item.open = false; });
});

document.getElementById("copy-summary")?.addEventListener("click", async () => {
  const summary = document.querySelector("#summary")?.innerText ?? "";
  await navigator.clipboard.writeText(summary);
});

function attachTableTools(table) {
  const rows = Array.from(table.tBodies[0].rows);
  if (rows.length <= 10) return;
  const input = document.createElement("input");
  input.type = "search";
  input.placeholder = "Filter rows";
  input.addEventListener("input", () => {
    const needle = input.value.toLowerCase();
    rows.forEach((row) => {
      row.hidden = !row.innerText.toLowerCase().includes(needle);
    });
  });
  table.parentElement.before(input);
}

document.querySelectorAll("table").forEach(attachTableTools);
```

Use `addEventListener` only. Never write inline `onclick` attributes.

## 6. Inline SVG Guidance

- Use `viewBox` and `role="img"` with a `<title>` for every diagram.
- Prefer current color tokens such as `stroke="var(--accent)"`.
- Keep labels at 0.75rem or larger and avoid rotated text.
- For charts, export SVG from `data-visualization` and paste the markup into the document.

## 7. Controlled Chart.js Opt-In

Use this block only when all conditions hold: complex interactive charting is required, the user explicitly approved the CDN, the page warns that the chart needs network access, and the tag carries an SRI hash.

```html
<p class="status-warn no-print">This report loads Chart.js from a CDN. Offline viewing shows a static fallback.</p>
<script
  src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"
  integrity="sha384-REPLACE_WITH_VERIFIED_SRI_HASH"
  crossorigin="anonymous"></script>
```

If the CDN request fails, render a static SVG or a table. Never let a missing script leave the page blank.

## 8. Common Rationalizations

| Rationalization | Reality |
| :--- | :--- |
| Load Tailwind and Mermaid from a CDN to save time. | CDN scripts fail in offline views and strict CSP environments. Inline CSS variables and native SVG do not. |
| Hide every section in tabs so the page looks short. | The report must read before any click, and print/PDF breaks when primary content is trapped in an unselected tab. |
| Output a 300-line Markdown report in chat instead. | Long linear Markdown flattens comparison and filtering. Use HTML when spatial layout or multi-source synthesis matters. |
| Hardcode dark-mode colors on elements. | Hardcoded dark backgrounds waste toner in print and hurt readability in bright environments. Route colors through tokens. |

## 9. Self-Check

Run these against the generated file before delivery:

```bash
test -f <report>.html
grep -q '<!DOCTYPE html>' <report>.html
grep -q 'prefers-color-scheme' <report>.html
grep -q '@media print' <report>.html
grep -q 'tabular-nums' <report>.html
grep -q '<details' <report>.html
grep -nE 'src="http|href="http' <report>.html || echo "no external references"
```

The last check must print `no external references` unless the approved Chart.js exception is active.
