# HTML Report Scaffold (Zen Minimalism 3-Preset Architecture)

Reference for `html-report`. Copy the skeleton and trim only data sections the report does not need. Preserve the 3-preset system (`dossier` default, `zen-garden`, `chronicle`), dual light/dark theme parity, offline self-containment, and print fidelity.

## 1. The Three Curated Presets

| Preset Attribute | UI Label | Default? | Inspiration & Visual Identity |
| :--- | :--- | :--- | :--- |
| `data-preset="dossier"` | **Clinical Dossier** | **Yes (Default)** | *Shibumi* (understated authority) + Function Health biomarker precision. Soft parchment (`#F7F4EE`), cream cards (`#FDFBF7`), muted clay accent (`#9E583B`), compact `230px` sticky chapter sidebar (`01`-`06`), high-density tabular scanning. |
| `data-preset="zen-garden"` | **Zen Garden** | User Option 2 | *Karesansui* dry rock garden + generous *Ma* negative space. Raked limestone (`#F4F1EA`), warm stone (`#F9F7F2`), Kyoto moss (`#4A6B53`), centered `960px` contemplative single-column flow with `5.25rem` vertical section breathing room. |
| `data-preset="chronicle"` | **Slow Chronicle** | User Option 3 | Kinfolk slow-living editorial narrative. Warm paper (`#FBF9F5`), sand cards (`#F5F0E6`), earth terracotta (`#A65638`), `1020px` single-column magazine flow with full-width horizontal chapter headers and editorial serif pull-quotes. |

## 2. Document Skeleton

```html
<!DOCTYPE html>
<html lang="en" data-preset="dossier" data-theme="light">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Report Title</title>
  <style>
    /* 1. 3-Preset Tokens + Dark Theme Parity */
    /* 2. Base, Typography & Zen Ma Spacing */
    /* 3. Preset Layout Engine (dossier, zen-garden, chronicle) */
    /* 4. Print Stylesheet */
  </style>
</head>
<body>
  <div class="report-shell">
    <header class="report-header">
      <div class="header-title-group">
        <span class="eyebrow">Evaluation Report</span>
        <h1>Declarative Finding Title</h1>
        <p class="meta">2026-10-28 · Cohort N = 4,365,797 · Revision abc1234</p>
      </div>
      <div class="header-controls">
        <span class="status-pill status-ok">Verified Parity</span>
        <div class="toolbar no-print" role="toolbar" aria-label="Report appearance and actions">
          <div class="preset-group" role="group" aria-label="Style preset">
            <button type="button" class="preset-btn active" data-preset-val="dossier" title="Shibumi Clinical Dossier (Default)">Dossier</button>
            <button type="button" class="preset-btn" data-preset-val="zen-garden" title="Karesansui Zen Garden">Zen Garden</button>
            <button type="button" class="preset-btn" data-preset-val="chronicle" title="Kinfolk Slow Chronicle">Chronicle</button>
          </div>
          <button type="button" id="theme-toggle">Theme</button>
          <button type="button" id="expand-all">Expand all</button>
          <button type="button" id="collapse-all">Collapse all</button>
          <button type="button" id="copy-summary">Copy Summary (MD)</button>
        </div>
      </div>
    </header>

    <nav class="section-nav no-print" aria-label="Sections">
      <a href="#summary"><span class="nav-num">01</span> Summary</a>
      <a href="#findings"><span class="nav-num">02</span> Findings</a>
      <a href="#evidence"><span class="nav-num">03</span> Evidence</a>
    </nav>

    <main>
      <section id="summary" class="report-section">
        <div class="section-sidebar">
          <span class="chapter-index">01</span>
          <h2>Executive Summary</h2>
          <p class="section-lead">Concise context sentence (<= 25 words) framing the scope and primary decision.</p>
        </div>
        <div class="section-content">
          <div class="thesis-box" id="thesis-statement">
            <p>One- or two-sentence declarative thesis stating the exact primary metric, delta, and operational consequence.</p>
          </div>
          <div class="kpi-grid">
            <article class="kpi">
              <span class="kpi-label">Top-1 Accuracy</span>
              <strong>78.52%</strong>
              <span class="subtext">Baseline: 70.16% (<span class="delta-pos">+8.36pp</span>)</span>
            </article>
            <article class="kpi">
              <span class="kpi-label">Evaluated Volume</span>
              <strong>4,365,797</strong>
              <span class="subtext">100% Converted Cohort</span>
            </article>
          </div>
        </div>
      </section>

      <section id="findings" class="report-section">
        <div class="section-sidebar">
          <span class="chapter-index">02</span>
          <h2>Core Findings</h2>
          <p class="section-lead">Short narrative guide explaining what the comparison table proves.</p>
        </div>
        <div class="section-content">
          <div class="table-wrap">
            <table>
              <thead><tr><th scope="col">Category</th><th scope="col" class="num">Current</th><th scope="col" class="num">Baseline</th><th scope="col" class="num">Delta</th></tr></thead>
              <tbody><!-- rows --></tbody>
            </table>
          </div>
          <details open>
            <summary>01 · Architectural Driver or Evidence Note</summary>
            <p>Short 2-3 sentence explanation grounded in exact mechanism and code/data reference.</p>
          </details>
        </div>
      </section>
    </main>
  </div>

  <script>
    /* preset switcher, theme toggle, expand/collapse, table filter, copy summary */
  </script>
</body>
</html>
```

## 3. Preset & Dual-Theme Tokens

```css
/* DEFAULT PRESET: dossier (The Shibumi Clinical Dossier) */
:root,
:root[data-preset="dossier"] {
  --bg-page: #F7F4EE;
  --bg-card: #FDFBF7;
  --bg-subtle: #EFEAE1;
  --text-primary: #22201E;
  --text-secondary: #5A5550;
  --text-muted: #878079;
  --border: #E0D9CE;
  --border-strong: #B8AFA3;
  --accent: #9E583B;
  --accent-subtle: #F2E5DF;
  --status-ok: #2B6648;
  --status-warn: #A85B14;
  --status-bad: #992B2B;
  --chart-ps: #9E583B;
  --chart-prod: #878079; /* 3.55:1 on --bg-page */
  --chart-pos: #2B6648;
  --chart-neg: #992B2B;
  --font-display: "Iowan Old Style", "Palatino Linotype", Palatino, Georgia, serif;
  --font-sans: -apple-system, BlinkMacSystemFont, "Segoe UI", Inter, sans-serif;
  --font-mono: ui-monospace, SFMono-Regular, Menlo, monospace;
  --radius-card: 8px;
  --section-pad: 3.5rem;
  --container-max: 1220px;
}

/* PRESET 2: zen-garden (Karesansui Dry Rock Garden) */
:root[data-preset="zen-garden"] {
  --bg-page: #F4F1EA;
  --bg-card: #F9F7F2;
  --bg-subtle: #EAE5DB;
  --text-primary: #2B2A27;
  --text-secondary: #605E58;
  --text-muted: #8C887F;
  --border: #DCD6CA;
  --border-strong: #BDB5A6;
  --accent: #4A6B53;
  --accent-subtle: #E3ECE5;
  --status-ok: #3B6E4C;
  --status-warn: #B06A2B;
  --status-bad: #9E3B33;
  --chart-ps: #4A6B53;
  --chart-prod: #878079; /* 3.45:1 on --bg-page */
  --chart-pos: #3B6E4C;
  --chart-neg: #9E3B33;
  --radius-card: 4px;
  --section-pad: 5.25rem;
  --container-max: 960px;
}

/* PRESET 3: chronicle (Kinfolk Slow-Living Chronicle) */
:root[data-preset="chronicle"] {
  --bg-page: #FBF9F5;
  --bg-card: #F5F0E6;
  --bg-subtle: #EBE4D6;
  --text-primary: #211E1B;
  --text-secondary: #5C564F;
  --text-muted: #8C847A;
  --border: #E3DAC9;
  --border-strong: #C2B6A1;
  --accent: #A65638;
  --accent-subtle: #EFE0D9;
  --status-ok: #356348;
  --status-warn: #A85C18;
  --status-bad: #962D2D;
  --chart-ps: #A65638;
  --chart-prod: #878079; /* 3.70:1 on --bg-page */
  --chart-pos: #356348;
  --chart-neg: #962D2D;
  --radius-card: 4px;
  --section-pad: 4.75rem;
  --container-max: 1020px;
}

/* Dark Theme Parity (Auto OS + Manual Toggle) */
@media (prefers-color-scheme: dark) {
  :root:not([data-theme="light"]) {
    --bg-page: #141210;
    --bg-card: #1D1A17;
    --bg-subtle: #27231F;
    --text-primary: #F5EFE6;
    --text-secondary: #B8AFA6;
    --text-muted: #7E756C;
    --border: #2E2924;
    --border-strong: #4A423B;
    --accent: #D48462;
    --accent-subtle: #2C1F1A;
    --status-ok: #68B684;
    --status-warn: #E09F3E;
    --status-bad: #E06D6D;
    --chart-ps: #D48462;
    --chart-prod: #746B62; /* 3.58:1 on --bg-page */
    --chart-pos: #68B684;
    --chart-neg: #E06D6D;
  }
}

:root[data-theme="dark"] {
  --bg-page: #141210;
  --bg-card: #1D1A17;
  --bg-subtle: #27231F;
  --text-primary: #F5EFE6;
  --text-secondary: #B8AFA6;
  --text-muted: #7E756C;
  --border: #2E2924;
  --border-strong: #4A423B;
  --accent: #D48462;
  --accent-subtle: #2C1F1A;
  --status-ok: #68B684;
  --status-warn: #E09F3E;
  --status-bad: #E06D6D;
  --chart-ps: #D48462;
  --chart-prod: #746B62; /* 3.58:1 on --bg-page */
  --chart-pos: #68B684;
  --chart-neg: #E06D6D;
}
```

## 4. Base, Preset Layout Engine, and Components

```css
* { box-sizing: border-box; }
html { font-size: 16px; scroll-behavior: smooth; }
body {
  margin: 0;
  background: var(--bg-page);
  color: var(--text-primary);
  font-family: var(--font-sans);
  font-size: 0.9375rem;
  line-height: 1.65;
  -webkit-font-smoothing: antialiased;
}
.report-shell { max-width: var(--container-max); margin: 0 auto; padding: 0 1.75rem 5rem; }
p, li { max-width: 68ch; }
h1, h2, h3 { font-family: var(--font-display); font-weight: 400; line-height: 1.2; break-after: avoid; }
.eyebrow, .kpi-label {
  font-family: var(--font-mono);
  font-size: 0.75rem;
  text-transform: uppercase;
  letter-spacing: 0.08em;
  color: var(--text-muted);
}
.meta, .status-pill, .num, .kpi { font-variant-numeric: tabular-nums; }

.report-header {
  display: flex;
  flex-wrap: wrap;
  gap: 1.5rem;
  align-items: flex-end;
  justify-content: space-between;
  padding: 3.5rem 0 2.25rem;
  border-bottom: 1px solid var(--border-strong);
}
.header-title-group h1 { font-size: clamp(2rem, 3.8vw, 3.1rem); margin: 0.4rem 0 0.65rem; }
.header-controls { display: flex; flex-direction: column; align-items: flex-end; gap: 0.75rem; }
.toolbar { display: flex; gap: 0.4rem; flex-wrap: wrap; align-items: center; }
.preset-group { display: inline-flex; background: var(--bg-subtle); padding: 0.2rem; border-radius: 999px; border: 1px solid var(--border); }
button {
  font: inherit;
  font-size: 0.78rem;
  padding: 0.38rem 0.75rem;
  color: var(--text-primary);
  background: var(--bg-card);
  border: 1px solid var(--border-strong);
  border-radius: 999px;
  cursor: pointer;
}
.preset-btn { border: none; background: transparent; color: var(--text-secondary); }
.preset-btn.active { background: var(--accent); color: #FDFBF7; font-weight: 600; }
.status-pill { padding: 0.25rem 0.75rem; border-radius: 999px; font-family: var(--font-mono); font-size: 0.75rem; border: 1px solid currentColor; }
.status-ok { color: var(--status-ok); background: var(--accent-subtle); }

.section-nav {
  position: sticky;
  top: 0;
  z-index: 10;
  display: flex;
  gap: 1.5rem;
  padding: 0.85rem 0;
  background: var(--bg-page);
  border-bottom: 1px solid var(--border);
  overflow-x: auto;
}
.section-nav a { color: var(--text-secondary); text-decoration: none; font-size: 0.84rem; white-space: nowrap; }
.section-nav a .nav-num { font-family: var(--font-mono); color: var(--accent); margin-right: 0.3rem; }

/* DEFAULT LAYOUT (dossier): Compact 230px Sticky Chapter Sidebar + Evidence Column */
.report-section {
  padding: var(--section-pad) 0;
  border-bottom: 1px solid var(--border);
  display: grid;
  grid-template-columns: 230px 1fr;
  gap: 2.5rem;
  align-items: start;
}
.section-sidebar { position: sticky; top: 3.5rem; }
.chapter-index { font-family: var(--font-display); font-size: 2.5rem; line-height: 1; color: var(--accent); display: block; margin-bottom: 0.35rem; }
.section-sidebar h2 { font-size: 1.5rem; margin: 0 0 0.6rem; }
.section-lead { font-size: 0.86rem; color: var(--text-secondary); margin: 0; }

/* PRESET 2 LAYOUT (zen-garden): Centered Contemplative Flow + Extra Ma Whitespace */
:root[data-preset="zen-garden"] .report-section {
  grid-template-columns: 1fr;
  gap: 2rem;
}
:root[data-preset="zen-garden"] .section-sidebar {
  position: static;
  text-align: center;
  max-width: 620px;
  margin: 0 auto 0.5rem;
}
:root[data-preset="zen-garden"] .thesis-box {
  border-left: none;
  border-top: 2px solid var(--accent);
  text-align: center;
}

/* PRESET 3 LAYOUT (chronicle): Kinfolk Horizontal Chapter Banner + Editorial Pull-Quotes */
:root[data-preset="chronicle"] .report-section {
  grid-template-columns: 1fr;
  gap: 2.25rem;
}
:root[data-preset="chronicle"] .section-sidebar {
  position: static;
  display: flex;
  align-items: baseline;
  gap: 1.25rem;
  border-bottom: 1px solid var(--border-strong);
  padding-bottom: 0.85rem;
}
:root[data-preset="chronicle"] .chapter-index { font-size: 2rem; margin-bottom: 0; }

.thesis-box {
  background: var(--bg-card);
  border: 1px solid var(--border-strong);
  border-left: 3px solid var(--accent);
  padding: 1.4rem 1.65rem;
  margin-bottom: 1.75rem;
  border-radius: var(--radius-card);
}
.thesis-box p { font-family: var(--font-display); font-size: 1.35rem; line-height: 1.42; margin: 0; }

.kpi-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(190px, 1fr)); gap: 1rem; margin-bottom: 2rem; }
.kpi { padding: 1.2rem; background: var(--bg-card); border: 1px solid var(--border); border-radius: var(--radius-card); }
.kpi strong { display: block; font-family: var(--font-display); font-size: 2.2rem; line-height: 1.1; margin: 0.45rem 0 0.25rem; }
.delta-pos { color: var(--status-ok); font-weight: 600; }
.delta-neg { color: var(--status-warn); font-weight: 600; }

.table-wrap { overflow-x: auto; margin: 1rem 0 1.5rem; border: 1px solid var(--border); border-radius: var(--radius-card); background: var(--bg-card); }
table { border-collapse: collapse; width: 100%; font-size: 0.88rem; }
th, td { padding: 0.7rem 0.9rem; text-align: left; border-bottom: 1px solid var(--border); }
th { background: var(--bg-subtle); font-family: var(--font-mono); font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.06em; color: var(--text-secondary); }
tr:hover td { background: var(--bg-subtle); }
.num, th.num { text-align: right; font-family: var(--font-mono); }

details { margin: 0.85rem 0; padding: 1rem 1.25rem; background: var(--bg-card); border: 1px solid var(--border); border-radius: var(--radius-card); }
summary { cursor: pointer; font-family: var(--font-display); font-size: 1.15rem; font-weight: 400; }
pre, code { font-family: var(--font-mono); font-size: 0.84rem; background: var(--bg-subtle); border-radius: 4px; }
pre { overflow-x: auto; padding: 0.85rem; }

@media (max-width: 900px) {
  .report-section { grid-template-columns: 1fr; gap: 1.5rem; }
  .section-sidebar { position: static; }
}
```

## 5. Print CSS

```css
@media print {
  .no-print, nav, button, .toolbar, .filter-input { display: none !important; }
  body { background: #ffffff !important; color: #000000 !important; font-size: 10.5pt; line-height: 1.45; }
  .report-shell, main { max-width: 100% !important; padding: 0 !important; margin: 0 !important; }
  .report-section { grid-template-columns: 1fr !important; padding: 1.25rem 0 !important; gap: 0.75rem !important; }
  details:not([open]) > *:not(summary) { display: block !important; }
  section, .kpi, table, figure, details, .thesis-box { break-inside: avoid; page-break-inside: avoid; box-shadow: none !important; }
  h1, h2, h3 { break-after: avoid; }
  *, *::before, *::after { animation: none !important; transition: none !important; opacity: 1 !important; }
  @page { margin: 16mm 14mm; }
}
```

## 6. Interaction Patterns (3-Preset Switcher + Table Filter + Theme)

```js
const root = document.documentElement;

function storageGet(key) {
  try { return localStorage.getItem(key); } catch { return null; }
}

function storageSet(key, value) {
  try { localStorage.setItem(key, value); } catch { /* file:// or privacy mode */ }
}

function applyPreset(preset) {
  root.dataset.preset = preset;
  document.querySelectorAll(".preset-btn").forEach((btn) => {
    btn.classList.toggle("active", btn.dataset.presetVal === preset);
  });
  storageSet("report-preset", preset);
}

document.querySelectorAll(".preset-btn").forEach((btn) => {
  btn.addEventListener("click", () => applyPreset(btn.dataset.presetVal));
});

const savedPreset = storageGet("report-preset");
if (savedPreset) applyPreset(savedPreset);

const themeButton = document.getElementById("theme-toggle");
themeButton?.addEventListener("click", () => {
  const next = root.dataset.theme === "dark" ? "light" : "dark";
  root.dataset.theme = next;
  storageSet("report-theme", next);
});

const storedTheme = storageGet("report-theme");
if (storedTheme) root.dataset.theme = storedTheme;

document.getElementById("expand-all")?.addEventListener("click", () => {
  document.querySelectorAll("details").forEach((item) => { item.open = true; });
});

document.getElementById("collapse-all")?.addEventListener("click", () => {
  document.querySelectorAll("details").forEach((item) => { item.open = false; });
});

document.getElementById("copy-summary")?.addEventListener("click", async () => {
  const summary = document.querySelector("#summary")?.innerText ?? "";
  try { await navigator.clipboard.writeText(summary); } catch { /* clipboard denied */ }
});

function attachTableTools(table) {
  const rows = Array.from(table.tBodies[0].rows);
  if (rows.length <= 6) return;
  const input = document.createElement("input");
  input.type = "search";
  input.className = "filter-input no-print";
  input.placeholder = "Filter rows...";
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

## 7. Controlled Chart.js Opt-In

Use this block only when complex interactive charting is required, the user explicitly approves the CDN, the page shows an offline warning, and the tag carries an SRI hash:

```html
<p class="status-warn no-print">This report loads Chart.js from a CDN. Offline viewing shows a static fallback.</p>
<script
  src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"
  integrity="sha384-9nhczxUqK87bcKHh20fSQcTGD4qq5GhayNYSYWqwBkINBhOfQLg/P5HG5lF1urn4"
  crossorigin="anonymous"></script>
```

## 8. Structural Self-Check

Run the validator against the generated file. A non-zero exit blocks delivery:

```bash
python3 <skill-dir>/scripts/check_html_report.py <report>.html
```

`<skill-dir>` is the directory containing this skill, for example `~/.agents/skills/html-report`.

The validator checks the document skeleton, all three presets and their buttons, dual-theme and reduced-motion CSS, print rules, `tabular-nums`, focus visibility, table headers, button types, duplicate IDs, inline event handlers, inline network calls, external or sidecar assets, and unresolved placeholders. It does not judge visual quality; run the render matrix in `references/review-gate.md`.

Keep this manual grep block as a fallback when the script cannot run:

```bash
test -f <report>.html
grep -q '<!DOCTYPE html>' <report>.html
grep -q 'data-preset="dossier"' <report>.html
grep -q 'data-preset="zen-garden"' <report>.html
grep -q 'data-preset="chronicle"' <report>.html
grep -q 'prefers-color-scheme' <report>.html
grep -q 'prefers-reduced-motion' <report>.html
grep -q '@media print' <report>.html
grep -q 'tabular-nums' <report>.html
grep -q 'focus-visible' <report>.html
grep -q 'Copy Summary' <report>.html
! grep -q 'fetch(' <report>.html
! grep -q 'onclick=' <report>.html
! grep -q 'cdn.tailwindcss.com' <report>.html
! grep -q 'REPLACE' <report>.html
```

## 9. Render Evidence

Capture the views required by the Visual Quality Bar in `references/review-gate.md`. Use browser automation already available in the environment; do not install a new browser stack without approval.

```bash
mkdir -p .tmp/report-review
# Playwright CLI, when already installed
npx playwright screenshot --viewport-size=1440,900 --full-page --color-scheme=light "file://$PWD/<report>.html" .tmp/report-review/desktop-light-dossier.png
npx playwright screenshot --viewport-size=390,844 --full-page --color-scheme=dark "file://$PWD/<report>.html" .tmp/report-review/mobile-dark-dossier.png
npx playwright pdf "file://$PWD/<report>.html" .tmp/report-review/report-print.pdf
```

If Playwright is unavailable, use the host browser's headless screenshot and print-to-PDF modes. If neither exists, stop the gate and request screenshots from the user. Do not substitute source inspection for rendered evidence.

Delete the evidence directory after the review record is complete unless the user wants to keep it.

## 10. Review Record

Use the template in `references/review-gate.md` section 6. Write the record beside the report, or in the host artifact directory for a session-only report.
