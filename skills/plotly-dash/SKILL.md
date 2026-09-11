---
name: plotly-dash
description: >-
  Build interactive Plotly Dash apps: pages, callbacks, dcc.Store, background jobs.
  Not for static Plotly charts, EDA, or REST APIs without a Dash UI.
risk: safe
source: local
date_added: "2026-08-23"
---

# Plotly Dash Development Skill

Build production-grade, interactive Python data applications with Plotly Dash using clear separation of concerns, disciplined callback architecture, and readable charts.

---

## When to Use
- Building or refactoring Dash dashboards and web applications
- Designing modular layouts, callback graphs, and multi-page routing
- Wiring interactive UI controls to Plotly figures and tabular data
- Optimizing Dash callback performance, state persistence, and memory usage
- Implementing pattern-matching callbacks, clientside callbacks, or background tasks

## When Not to Use
- Static reports or charts with no interactivity needs (use `data-visualization` directly)
- Pure data analysis or modeling without a web interface (use `data-science`)
- Standalone REST APIs without Dash UI (use `python-pro` / FastAPI)

---

## Core Principles
1. **Separation of Concerns**: Strictly decouple UI layout, callback wiring, and data transformation logic.
2. **Minimal & Explicit Callbacks**: One clear responsibility per callback; avoid monolithic multi-output mega-callbacks.
3. **Deterministic Data Flow**: Prefer unidirectional data flow. Avoid circular callback loops and unintended cascade triggers.
4. **Visual Rigor**: Adhere strictly to `data-visualization` standards (no label collisions, purpose-driven chart selection, lean layouts).
5. **State Hygiene**: Store shared state explicitly in `dcc.Store` or URL parameters; never use global mutable variables.

---

## Recommended Project Layout

### Standard Multi-Page App (`pages` plugin, Dash 2.14+ / 3.x)
```text
my_dash_app/
├── app.py                      # App initialization and root layout shell
├── pages/                      # Multi-page routing (dash.register_page)
│   ├── home.py
│   ├── analytics.py
│   └── settings.py
├── components/                 # Reusable UI widgets and layout fragments
│   ├── header.py
│   ├── sidebar.py
│   └── filters.py
├── callbacks/                  # Global or shared callback handlers
│   └── navigation.py
├── services/                   # Pure business logic and data loaders (no Dash imports)
│   ├── data_loader.py
│   └── analytics_engine.py
├── figures/                    # Plotly figure generation helpers
│   ├── timeseries.py
│   └── distributions.py
├── assets/                     # Custom CSS, JS (clientside callbacks), images, favicon
│   └── styles.css
├── tests/
│   ├── unit/                   # Unit tests for services and figure builders
│   └── integration/            # Dash integration tests (dash_duo)
└── pyproject.toml / requirements.txt
```

### Layout Guidelines
- Keep `app.py` minimal: instantiate `Dash(__name__, use_pages=True)`, set outer layout shell (`dash.page_container`), and run server.
- Pure functions in `services/` and `figures/` must NOT import Dash components or depend on callback context.
- Single-file prototypes are acceptable only for exploratory spikes (< 150 lines); refactor into modular layout immediately when scaling.

---

## Callback Architecture & Design

### 1. Input vs State vs Output
- **`Input`**: Use strictly for props that *must* trigger the callback execution.
- **`State`**: Use to read current values without triggering re-execution (e.g., form fields evaluated on submit button click).
- **`Output`**: Specify exact component property to update.

### 2. Modern Callback Context (`dash.ctx`)
Use `dash.ctx` to inspect triggering inputs and state cleanly:
```python
from dash import Input, Output, callback, ctx, no_update
from dash.exceptions import PreventUpdate

@callback(
    Output("output-container", "children"),
    Input("btn-apply", "n_clicks"),
    Input("btn-reset", "n_clicks"),
    prevent_initial_call=True,
)
def handle_action(apply_clicks, reset_clicks):
    if not ctx.triggered_id:
        raise PreventUpdate

    if ctx.triggered_id == "btn-reset":
        return "Filters reset to default"

    return "Filters applied successfully"
```

### 3. Pattern-Matching Callbacks
Use `MATCH`, `ALL`, or `ALLSMALLER` for dynamic component collections (e.g., dynamic filter rows, generated tabs):
```python
from dash import ALL, MATCH, Input, Output, callback

@callback(
    Output({"type": "dynamic-output", "index": MATCH}, "children"),
    Input({"type": "dynamic-input", "index": MATCH}, "value"),
    prevent_initial_call=True,
)
def sync_dynamic_item(value):
    return f"Selected: {value}"
```

### 4. Long-Running Jobs & Background Callbacks
Never block the WSGI request thread with long computations (> 2-3s).
- Use `@callback(..., background=True, manager=background_callback_manager)`. Construct the manager explicitly: DiskCache is for local/dev; Celery/Redis for production. Do not use removed `long_callback`.
- Or dispatch to Celery/ARQ/RQ and poll via `dcc.Interval`.

---

## State Management & Data Handling

### `dcc.Store` Best Practices
| Storage Type | Lifetime | Use Case |
| :--- | :--- | :--- |
| `memory` (default) | Reset on page refresh | Intermediate calculation cache per tab session |
| `session` | Survives refresh, dies on tab close | User session preferences, authentication token |
| `local` | Persists across browser restarts | Theme preferences, saved filters |

- Keep Store JSON small (budget ~2 MB). Do not serialize huge DataFrames to the client.
- **Server-Side Data Caching**: Store large datasets in Redis / disk cache keyed by user/session ID; store only the cache key in `dcc.Store`.

---

## Performance Optimization

1. **Clientside Callbacks**:
   - Offload simple UI toggles, modal open/close, theme switching, or lightweight DOM interactions to JavaScript via `clientside_callback`.
   - Eliminates network roundtrips to the server.
2. **Server-Side Caching**:
   - Cache expensive data queries and transformations with `flask_caching.Cache` (`@cache.memoize()` or `@cache.cached()`).
3. **Efficient Rendering**:
   - Use `dash_ag_grid` for large tabular datasets instead of default `dash_table.DataTable` for virtualization and performance.
   - Avoid returning massive raw figures when aggregated data points suffice.
   - Use `no_update` for unchanged outputs to avoid unneeded DOM re-renders.

---

## Figure Construction & Quality
- Build figures in `figures/` as functions returning `go.Figure`. Layout, overlap, and SVG rules: **`data-visualization`**.
- Embed with `dcc.Graph(figure=..., config={"displayModeBar": False, "responsive": True})`.
- Apply a uniform theme (fonts, margins, palette) across charts.

---

## Testing & Verification

1. **Unit Testing**:
   - Test data loaders and transform functions in `services/` independently with `pytest`.
   - Test figure generators in `figures/` by validating figure layout, trace counts, and data properties.
2. **Callback Testing**:
   - Test callback functions directly as plain Python functions with simulated arguments.
3. **Integration Testing (`dash.testing`)**:
   - Use `dash_duo` with Selenium / Webdriver for end-to-end user interaction tests.
```python
def test_dashboard_flow(dash_duo, app):
    dash_duo.start_server(app)
    dash_duo.wait_for_text_to_equal("#header-title", "Analytics Dashboard", timeout=4)
    dash_duo.find_element("#filter-dropdown").click()
    assert dash_duo.get_logs() == []
```

---

## Related Skills
- Use **data-visualization** for all Plotly figure layout and overlap QA.
- Use **context7-mcp** when Dash / Dash AG Grid APIs are version-sensitive.
- Use **python-testing** (unit) and `dash_duo` (UI) when behavior changes.

---

## Final Delivery Checklist
- [ ] Layout, callbacks, and data services strictly separated into modular packages.
- [ ] No global mutable state; session/filter state managed explicitly via `dcc.Store` or URL query params.
- [ ] Callbacks have single responsibilities and use `Input` vs `State` appropriately.
- [ ] Unnecessary re-renders prevented via `dash.no_update` and `PreventUpdate`.
- [ ] Heavy computations cached or executed asynchronously via background callbacks.
- [ ] Figures follow `data-visualization` standards with clean margins and readable annotations.
- [ ] Dash 2.14+ / 3.x APIs (`dash.register_page`, `dash.ctx`, `dash.callback`) used; no `long_callback`.
- [ ] Unit tests in place for business logic and core figure generation.
