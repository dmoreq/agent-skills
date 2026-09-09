---
name: plotly-dash
description: "Build interactive Python data apps with Plotly Dash using modular architecture, disciplined callbacks, robust state management, and optimized performance."
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

### Standard Multi-Page App (Dash 2.x `pages` plugin)
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
- Use Dash `@callback(..., background=True, manager=background_callback_manager)`.
- Or dispatch async tasks to an external worker queue (Celery, ARQ, Redis Queue) and poll status via `dcc.Interval`.

---

## State Management & Data Handling

### `dcc.Store` Best Practices
| Storage Type | Lifetime | Use Case |
| :--- | :--- | :--- |
| `memory` (default) | Reset on page refresh | Intermediate calculation cache per tab session |
| `session` | Survives refresh, dies on tab close | User session preferences, authentication token |
| `local` | Persists across browser restarts | Theme preferences, saved filters |

- **Payload Limit**: Keep `dcc.Store` payload under 2 MB. Do not serialize huge raw DataFrames to client JSON.
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
- Build figures via dedicated builder functions returning `go.Figure`.
- Embed figures in layout using `dcc.Graph(figure=..., config={"displayModeBar": False, "responsive": True})`.
- Apply uniform design theme across all charts (consistent fonts, margins, color palettes).
- Comply with `data-visualization` rules:
  - Axis automargin enabled (`xaxis_automargin=True`, `yaxis_automargin=True`).
  - Legends placed cleanly outside plotted data area.
  - Zero overlapping labels or unformatted numerical metrics.

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
- **data-visualization**: Core rules for Plotly figure aesthetics, layout sizing, and anti-overlap.
- **data-science**: Analytical computation, feature engineering, and statistical pipelines feeding Dash.
- **python-pro**: Modern Python typing, package architecture, and production standards.
- **python-performance**: Bottleneck profiling, memory management, and caching strategies.
- **python-testing**: Comprehensive `pytest` test suites and mocking patterns.
- **context7-mcp**: Querying latest Dash, Dash AG Grid, and component library documentation.
- **code-review**: Multi-axis code review before merging Dash applications.

---

## Final Delivery Checklist
- [ ] Layout, callbacks, and data services strictly separated into modular packages.
- [ ] No global mutable state; session/filter state managed explicitly via `dcc.Store` or URL query params.
- [ ] Callbacks have single responsibilities and use `Input` vs `State` appropriately.
- [ ] Unnecessary re-renders prevented via `dash.no_update` and `PreventUpdate`.
- [ ] Heavy computations cached or executed asynchronously via background callbacks.
- [ ] Figures follow `data-visualization` standards with clean margins and readable annotations.
- [ ] Up-to-date Dash 2.x APIs (`dash.register_page`, `dash.ctx`, `dash.callback`) used throughout.
- [ ] Unit tests in place for business logic and core figure generation.
