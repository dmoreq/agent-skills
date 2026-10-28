# HTML Report Scaffold (Zen Minimalism 3-Preset & Editorial Typography Architecture)

Reference for `html-report`. Copy the skeleton and trim only data sections the report does not need. Preserve the Google Fonts `<link>`, the 3-preset system (`dossier` default, `zen-garden`, `chronicle`) with distinct typography per preset, dual light/dark theme parity, offline self-containment, and print fidelity.

## 1. The Three Curated Presets & Typography Pairings

| Preset Attribute | UI Label | Default? | Palette & Distinct Typography Pairing |
| :--- | :--- | :--- | :--- |
| `data-preset="dossier"` | **Clinical Dossier** | **Yes (Default)** | **Palette**: Soft Parchment (`#F7F4EE`), Cream (`#FDFBF7`), Muted Clay (`#9E583B`).<br>**Typography**: `'Fraunces'` (optical-size variable editorial serif, weight `350`/`400`) + `'Inter'` (precision UI sans) + `'JetBrains Mono'` (tabular data).<br>**Layout**: Compact `240px` sticky chapter sidebar (`01`-`06`) + fluid evidence column (`1220px` max-width). |
| `data-preset="zen-garden"` | **Zen Garden** | User Option 2 | **Palette**: Raked Limestone (`#F4F1EA`), Warm Stone (`#F9F7F2`), Kyoto Moss (`#4A6B53`).<br>**Typography**: `'Cormorant Garamond'` (high-contrast classical serif, weight `300`/`400`, lyrical italics) + `'Inter'` (weight `400`/`500`, airy `1.75` line-height) + `'JetBrains Mono'`.<br>**Layout**: Centered `960px` contemplative single-column flow with `5.25rem` vertical *Ma* breathing room. |
| `data-preset="chronicle"` | **Slow Chronicle** | User Option 3 | **Palette**: Warm Paper (`#FBF9F5`), Sand (`#F5F0E6`), Earth Terracotta (`#A65638`).<br>**Typography**: `'Cormorant Garamond'` (oversized `1.65rem` pull-quotes & chapter banners, weight `300`/`400`) + `'Plus Jakarta Sans'` (warm geometric humanist body) + `'JetBrains Mono'`.<br>**Layout**: `1020px` single-column magazine flow with full-width horizontal chapter headers (`01`-`06`). |

The reference defines all three presets. A generated report keeps exactly one preset token block and deletes the other two. It never includes a preset switcher.

## 2. Document Skeleton (with Required Google Fonts Link)

```html
<!DOCTYPE html>
<html lang="en" data-preset="dossier" data-theme="light">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Report Title</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,300;0,400;0,500;1,300;1,400;1,500&family=Fraunces:ital,opsz,wght@0,9..144,300..500;1,9..144,300..400&family=Inter:wght@400;500;600&family=JetBrains+Mono:wght@400;500;600&family=Plus+Jakarta+Sans:wght@400;500;600&display=swap" rel="stylesheet">
  <style>
    /* 1. One-Preset Color & Typography Tokens + Dark Theme Parity */
    /* 2. Micro-Typesetting, Optical Sizing & Zen Ma Spacing */
    /* 3. Preset Layout Engine (dossier, zen-garden, chronicle) */
    /* 4. Print Stylesheet */
  </style>
</head>
<body>
  <a class="skip" href="#summary">Skip to summary</a>
  <div class="report-shell">
    <header class="report-header">
      <div class="header-title-group">
        <h1>Declarative Finding Title</h1>
        <p class="meta">2026-10-28 · Cohort N = 4,365,797 · Revision abc1234</p>
      </div>
      <button type="button" id="theme-toggle" class="theme-toggle no-print"
              aria-label="Toggle color theme" aria-pressed="false">Theme</button>
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
            <p>One- or two-sentence declarative thesis stating the exact primary metric, <em>delta</em>, and operational consequence.</p>
          </div>
          <div class="kpi-grid">
            <article class="kpi">
              <span class="kpi-label">Top-1 Accuracy</span>
              <strong>78.52%</strong>
              <span class="subtext">Baseline: 70.16% (<span class="delta-pos">+8.36 pp</span>)</span>
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
              <thead><tr><th>Category</th><th class="num">Current</th><th class="num">Baseline</th><th class="num">Delta</th></tr></thead>
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

## 3. Preset Color & Typography Tokens (Distinct Font Pairings per Preset)

```css
/* Shared editorial type roles (9), radius scale, and data palette.
   Keep only the preset block chosen for the report; delete the other two. */
:root {
  --text-xs: 0.75rem;
  --text-sm: 0.875rem;
  --text-base: 0.95rem;
  --text-md: 1.25rem;
  --text-lg: 1.65rem;
  --text-xl: 2rem;
  --text-2xl: 2.5rem;
  --text-3xl: 2.85rem;
  --radius-xs: 0.375rem;
  --radius-sm: 0.25rem;
  --radius-md: 0.5rem;
}

/* DEFAULT PRESET: dossier (The Shibumi Clinical Dossier — Fraunces + Inter + JetBrains Mono) */
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
  --chart-prod: #5A5550;
  --chart-old: #878079;
  --chart-pos: #2B6648;
  --chart-neg: #992B2B;
  --on-accent: #FDFBF7;

  --font-display: 'Fraunces', "Iowan Old Style", "Palatino Linotype", Georgia, serif;
  --font-sans: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
  --font-mono: 'JetBrains Mono', ui-monospace, SFMono-Regular, Menlo, monospace;
  --display-weight: 350;
  --display-tracking: -0.022em;
  --display-size: clamp(2.35rem, 4.2vw, 3.6rem);
  --text-thesis: 1.42rem;
  --chapter-size: var(--text-3xl);
  --kpi-size: var(--text-2xl);
  --body-lh: 1.65;

  --radius-card: var(--radius-md);
  --section-pad: 3.5rem;
  --container-max: 1220px;
}

/* PRESET 2: zen-garden (Karesansui Dry Rock Garden — Cormorant Garamond + Airy Inter + JetBrains Mono) */
:root[data-preset="zen-garden"] {
  --bg-page: #F4F1EA;
  --bg-card: #F9F7F2;
  --bg-subtle: #EAE5DB;
  --text-primary: #2B2A27;
  --text-secondary: #5E5C56;
  --text-muted: #8C887F;
  --border: #DCD6CA;
  --border-strong: #BDB5A6;
  --accent: #4A6B53;
  --accent-subtle: #E3ECE5;
  /* Shared warm data palette: Zen Garden charts match Dossier. */
  --status-ok: #2B6648;
  --status-warn: #A85B14;
  --status-bad: #992B2B;
  --chart-ps: #9E583B;
  --chart-prod: #5A5550;
  --chart-old: #878079;
  --chart-pos: #2B6648;
  --chart-neg: #992B2B;
  --on-accent: #F9F7F2;

  --font-display: 'Cormorant Garamond', "Iowan Old Style", Georgia, serif;
  --font-sans: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
  --font-mono: 'JetBrains Mono', ui-monospace, SFMono-Regular, Menlo, monospace;
  --display-weight: 400;
  --display-tracking: -0.012em;
  --display-size: clamp(2.65rem, 4.8vw, 4.1rem);
  --text-thesis: 1.6rem;
  --chapter-size: var(--text-3xl);
  --kpi-size: 2.75rem;
  --body-lh: 1.75;

  --radius-card: var(--radius-sm);
  --section-pad: 5.25rem;
  --container-max: 960px;
}

/* PRESET 3: chronicle (Kinfolk Slow-Living Chronicle — Cormorant Garamond + Plus Jakarta Sans + JetBrains Mono) */
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
  --chart-prod: #5C564F;
  --chart-old: #8C847A;
  --chart-pos: #356348;
  --chart-neg: #962D2D;
  --on-accent: #FBF9F5;

  --font-display: 'Cormorant Garamond', "Iowan Old Style", Georgia, serif;
  --font-sans: 'Plus Jakarta Sans', -apple-system, BlinkMacSystemFont, sans-serif;
  --font-mono: 'JetBrains Mono', ui-monospace, SFMono-Regular, Menlo, monospace;
  --display-weight: 400;
  --display-tracking: -0.015em;
  --display-size: clamp(2.65rem, 4.8vw, 4.1rem);
  --text-thesis: 1.65rem;
  --chapter-size: 2.35rem;
  --kpi-size: 2.75rem;
  --body-lh: 1.7;

  --radius-card: var(--radius-xs);
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
    --text-muted: #A8988A;
    --border: #2E2924;
    --border-strong: #4A423B;
    --accent: #D48462;
    --accent-subtle: #2C1F1A;
    --status-ok: #68B684;
    --status-warn: #E09F3E;
    --status-bad: #E06D6D;
    --chart-ps: #D48462;
    --chart-prod: #B8AFA6;
    --chart-old: #A8988A;
    --chart-pos: #68B684;
    --chart-neg: #E06D6D;
    --on-accent: #141210;
  }
}

:root[data-theme="dark"] {
  --bg-page: #141210;
  --bg-card: #1D1A17;
  --bg-subtle: #27231F;
  --text-primary: #F5EFE6;
  --text-secondary: #B8AFA6;
  --text-muted: #A8988A;
  --border: #2E2924;
  --border-strong: #4A423B;
  --accent: #D48462;
  --accent-subtle: #2C1F1A;
  --status-ok: #68B684;
  --status-warn: #E09F3E;
  --status-bad: #E06D6D;
  --chart-ps: #D48462;
  --chart-prod: #B8AFA6;
  --chart-old: #A8988A;
  --chart-pos: #68B684;
  --chart-neg: #E06D6D;
  --on-accent: #141210;
}
```

## 4. Base, Micro-Typesetting, Preset Layout Engine, and Components

```css
* { box-sizing: border-box; }
html {
  font-size: 16px;
  scroll-behavior: smooth;
  font-synthesis: none;
  text-rendering: optimizeLegibility;
}
body {
  margin: 0;
  background: var(--bg-page);
  color: var(--text-primary);
  font-family: var(--font-sans);
  font-size: 0.95rem;
  line-height: var(--body-lh);
  font-feature-settings: "kern" 1, "liga" 1, "calt" 1;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}
.report-shell { max-width: var(--container-max); margin: 0 auto; padding: 0 2rem 5rem; }
p, li { max-width: 66ch; text-wrap: pretty; }
h1, h2, h3 {
  font-family: var(--font-display);
  font-weight: var(--display-weight);
  letter-spacing: var(--display-tracking);
  font-optical-sizing: auto;
  font-feature-settings: "kern" 1, "liga" 1, "calt" 1;
  line-height: 1.12;
  text-wrap: balance;
  break-after: avoid;
}
.kpi-label, .tag {
  font-family: var(--font-mono);
  font-size: var(--text-xs);
  font-weight: 500;
  text-transform: uppercase;
  letter-spacing: 0.1em;
  color: var(--text-secondary);
}
.meta, .num, .kpi, td.num, th.num {
  font-family: var(--font-mono);
  font-variant-numeric: tabular-nums;
  letter-spacing: -0.01em;
}
.meta { font-size: var(--text-sm); color: var(--text-secondary); margin: 0; }

.report-header {
  display: flex;
  flex-wrap: wrap;
  gap: 2rem;
  align-items: flex-start;
  justify-content: space-between;
  padding: 4rem 0 2.5rem;
  border-bottom: 1px solid var(--border-strong);
}
.header-title-group h1 {
  font-size: var(--display-size);
  line-height: 1.06;
  margin: 0.5rem 0 0.85rem;
  max-width: 20ch;
}
:root[data-preset="zen-garden"] .header-title-group h1,
:root[data-preset="chronicle"] .header-title-group h1 {
  line-height: 1.04;
}
.theme-toggle { align-self: flex-start; }
button, .filter-input {
  font-family: var(--font-sans);
  font-size: var(--text-sm);
  font-weight: 500;
  min-height: 2rem;
  padding: 0.38rem 0.8rem;
  color: var(--text-primary);
  background: var(--bg-card);
  border: 1px solid var(--border-strong);
  border-radius: 999px;
  cursor: pointer;
}

.section-nav {
  position: sticky;
  top: 0;
  z-index: 10;
  display: flex;
  gap: 1.75rem;
  padding: 0.9rem 0;
  background: var(--bg-page);
  border-bottom: 1px solid var(--border);
  overflow-x: auto;
}
.section-nav a { color: var(--text-secondary); text-decoration: none; font-size: var(--text-sm); font-weight: 500; white-space: nowrap; }
.section-nav a .nav-num { font-family: var(--font-mono); font-size: var(--text-xs); color: var(--accent); margin-right: 0.35rem; }

/* DEFAULT LAYOUT (dossier): Compact 240px Sticky Chapter Sidebar + Evidence Column */
.report-section {
  padding: var(--section-pad) 0;
  border-bottom: 1px solid var(--border);
  display: grid;
  grid-template-columns: 240px 1fr;
  gap: 3rem;
  align-items: start;
}
.section-sidebar { position: sticky; top: 3.75rem; }
.chapter-index {
  font-family: var(--font-display);
  font-weight: 300;
  font-size: var(--chapter-size);
  line-height: 0.95;
  letter-spacing: -0.03em;
  color: var(--accent);
  font-optical-sizing: auto;
  font-feature-settings: "kern" 1, "liga" 1, "calt" 1;
  display: block;
  margin-bottom: 0.45rem;
}
.section-sidebar h2 { font-size: var(--text-lg); margin: 0 0 0.65rem; }
:root[data-preset="zen-garden"] .section-sidebar h2,
:root[data-preset="chronicle"] .section-sidebar h2 { font-size: var(--text-xl); }
.section-lead { font-size: var(--text-sm); color: var(--text-secondary); margin: 0; line-height: 1.6; }

/* PRESET 2 LAYOUT (zen-garden): Centered Contemplative Flow + Extra Ma Whitespace */
:root[data-preset="zen-garden"] .report-section { grid-template-columns: 1fr; gap: 2.25rem; }
:root[data-preset="zen-garden"] .section-sidebar { position: static; text-align: center; max-width: 640px; margin: 0 auto 0.5rem; }
:root[data-preset="zen-garden"] .thesis-box { border-left: 1px solid var(--border-strong); border-top: 2px solid var(--accent); text-align: center; }
:root[data-preset="zen-garden"] .thesis-box p { margin: 0 auto; font-size: 1.6rem; font-style: italic; }

/* PRESET 3 LAYOUT (chronicle): Kinfolk Horizontal Chapter Banner + Editorial Pull-Quotes */
:root[data-preset="chronicle"] .report-section { grid-template-columns: 1fr; gap: 2.25rem; }
:root[data-preset="chronicle"] .section-sidebar {
  position: static;
  display: grid;
  grid-template-columns: auto 240px 1fr;
  align-items: baseline;
  gap: 1.5rem;
  border-bottom: 1px solid var(--border-strong);
  padding-bottom: 1rem;
}
:root[data-preset="chronicle"] .chapter-index { font-size: 2.35rem; margin-bottom: 0; }
:root[data-preset="chronicle"] .thesis-box p { font-size: 1.65rem; line-height: 1.38; }

.thesis-box {
  background: var(--bg-card);
  border: 1px solid var(--border-strong);
  border-left: 3px solid var(--accent);
  padding: 1.6rem 1.85rem;
  margin-bottom: 2rem;
  border-radius: var(--radius-card);
}
.thesis-box p {
  font-family: var(--font-display);
  font-weight: var(--display-weight);
  font-size: var(--text-thesis);
  line-height: 1.4;
  letter-spacing: -0.01em;
  font-optical-sizing: auto;
  font-feature-settings: "kern" 1, "liga" 1, "calt" 1;
  margin: 0;
  max-width: 54ch;
}
.thesis-box p em, .thesis-box p strong { color: var(--accent); font-weight: 400; font-style: italic; }

.kpi-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(195px, 1fr)); gap: 1.1rem; margin-bottom: 2rem; }
.kpi { padding: 1.35rem 1.3rem; background: var(--bg-card); border: 1px solid var(--border); border-radius: var(--radius-card); }
.kpi strong {
  display: block;
  font-family: var(--font-display);
  font-weight: var(--display-weight);
  font-size: var(--kpi-size);
  letter-spacing: -0.025em;
  line-height: 1.05;
  font-optical-sizing: auto;
  font-feature-settings: "kern" 1, "liga" 1, "calt" 1;
  margin: 0.55rem 0 0.35rem;
}
.kpi .subtext { font-family: var(--font-sans); color: var(--text-secondary); font-size: var(--text-sm); line-height: 1.5; }
.delta-pos { font-family: var(--font-mono); color: var(--status-ok); font-weight: 600; }
.delta-neg { font-family: var(--font-mono); color: var(--status-bad); font-weight: 600; }

.table-wrap { overflow-x: auto; margin: 1.25rem 0 1.75rem; border: 1px solid var(--border); border-radius: var(--radius-card); background: var(--bg-card); }
table { border-collapse: collapse; width: 100%; font-size: var(--text-sm); }
th, td { padding: 0.75rem 0.95rem; text-align: left; border-bottom: 1px solid var(--border); }
thead th { background: var(--bg-subtle); font-family: var(--font-mono); font-size: var(--text-xs); font-weight: 500; text-transform: uppercase; letter-spacing: 0.08em; color: var(--text-secondary); }
tbody th { background: transparent; font-family: var(--font-sans); font-size: var(--text-sm); font-weight: 500; text-transform: none; letter-spacing: 0; color: var(--text-primary); }
tr:hover td, tr:hover tbody th { background: var(--bg-subtle); }
.num, th.num { text-align: right; font-family: var(--font-mono); font-size: var(--text-sm); }

svg.chart { width: 100%; height: auto; display: block; background: var(--bg-card); border: 1px solid var(--border); border-radius: var(--radius-card); padding: 0.5rem; }
svg text { font-family: var(--font-mono); fill: var(--text-secondary); font-variant-numeric: tabular-nums; }

details { margin: 0.9rem 0; padding: 1.1rem 1.35rem; background: var(--bg-card); border: 1px solid var(--border); border-radius: var(--radius-card); }
summary { cursor: pointer; font-family: var(--font-display); font-size: var(--text-md); font-weight: var(--display-weight); letter-spacing: -0.01em; font-optical-sizing: auto; font-feature-settings: "kern" 1, "liga" 1, "calt" 1; }
pre, code { font-family: var(--font-mono); font-size: 0.82rem; background: var(--bg-subtle); padding: 0.14rem 0.4rem; border-radius: 4px; }
pre { overflow-x: auto; padding: 0.85rem; }

@media (max-width: 900px) {
  .report-section { grid-template-columns: 1fr; gap: 1.5rem; }
  .section-sidebar { position: static; }
  :root[data-preset="chronicle"] .section-sidebar { grid-template-columns: 1fr; gap: 0.4rem; }
}
```

## 5. Print CSS

```css
@media print {
  .no-print, nav, button, .filter-input, .skip { display: none !important; }
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

## 6. Interaction Patterns (Theme Toggle + Table Filter)

```js
const root = document.documentElement;

function storageGet(key) {
  try { return localStorage.getItem(key); } catch { return null; }
}

function storageSet(key, value) {
  try { localStorage.setItem(key, value); } catch { /* file:// or privacy mode */ }
}

const themeButton = document.getElementById("theme-toggle");
themeButton?.addEventListener("click", () => {
  const next = root.dataset.theme === "dark" ? "light" : "dark";
  root.dataset.theme = next;
  themeButton.setAttribute("aria-pressed", next === "dark" ? "true" : "false");
  storageSet("report-theme", next);
});

const storedTheme = storageGet("report-theme");
if (storedTheme) {
  root.dataset.theme = storedTheme;
  themeButton?.setAttribute("aria-pressed", storedTheme === "dark" ? "true" : "false");
}

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

## 7. Controlled Chart.js Opt-In

Use this block only when complex interactive charting is required, the user explicitly approves the CDN, the page shows an offline warning, and the tag carries a verified SHA-384 SRI hash:

```html
<p class="no-print">This report loads Chart.js from a CDN. Offline viewing shows a static fallback.</p>
<script
  src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"
  integrity="sha384-9nhczxUqK87bcKHh20fSQcTGD4qq5GhayNYSYWqwBkINBhOfQLg/P5HG5lF1urn4"
  crossorigin="anonymous"></script>
```

## 8. Self-Check

Run these against the generated file before delivery:

```bash
test -f <report>.html
grep -q '<!DOCTYPE html>' <report>.html
test "$(grep -o 'data-preset="[^"]*"' <report>.html | sort -u | wc -l | tr -d ' ')" -eq 1
! grep -q 'preset-' <report>.html
! grep -q 'expand-' <report>.html
! grep -q 'collapse-' <report>.html
! grep -q 'copy-sum' <report>.html
grep -q 'id="theme-toggle"' <report>.html
grep -q 'fonts.googleapis.com' <report>.html
grep -q 'display=swap' <report>.html
grep -q 'Fraunces' <report>.html
grep -q 'Cormorant+Garamond' <report>.html
grep -q 'prefers-color-scheme' <report>.html
grep -q '@media print' <report>.html
grep -q 'tabular-nums' <report>.html
! grep -q 'REPLACE' <report>.html
```
