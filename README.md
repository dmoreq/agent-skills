# Agent Skills

A curated, token-efficient collection of **Global Agent Rules** and **Custom Skills** designed for the **Google Antigravity**, **Zed**, **Grok**, **OpenAI Codex**, **OpenCode**, and **ZCode Desktop** coding assistant environments.

---

## Repository Structure

```text
agent-skills/
├── rules/
│   └── AGENTS.md                    # Global agent behavioral directives & kernel standards
├── skills/
│   ├── algorithm-optimization/      # Systematic KPI & algorithm improvement loop (+ 3 references)
│   ├── code-minimalism/             # YAGNI-first minimalist code generation (+ 2 references)
│   ├── code-review/                 # Multi-axis review + YAGNI/bloat quality gate (+ 3 references)
│   ├── code-simplification/         # Safe refactoring, reducing nesting & accidental complexity
│   ├── codebase-contracts/          # Peanuts/Hay README contracts + spec/code drift audit (+ 1 reference)
│   ├── context7-mcp/                # Live documentation lookup for libraries/frameworks
│   ├── data-science/                # EDA, modeling, statistics, causal inference & A/B (+ script & reference)
│   ├── data-storytelling/           # Decision-ready narratives for business stakeholders
│   ├── data-visualization/          # Plotly-first charts, layout optimization & anti-overlap QA
│   ├── deprecation-migration/       # Safe removal, replacement & sunsetting of legacy APIs (+ 2 references)
│   ├── design-system/               # 3-tier DTCG tokens, component specs, responsive rules (+ 1 reference)
│   ├── doubt-driven-development/    # Adversarial stress-testing of non-trivial architectural choices
│   ├── html-report/                 # Single-file interactive HTML reports, print-ready PDF (+ 1 reference)
│   ├── plotly-dash/                 # Interactive Python data apps with Plotly Dash & clean callbacks
│   ├── polars-duckdb/               # High-performance DataFrame & local SQL ETL (+ migration reference)
│   ├── pyo3-maturin/                # Rust native extensions with PyO3 & Maturin for CPU hotspots
│   ├── python-concurrency/          # Concurrency models: asyncio, thread pool, process pool
│   ├── python-patterns/             # Architecture-time: framework, layout, ADR (+ parser reference)
│   ├── python-performance/          # Profile-driven performance optimization (+ playbook reference)
│   ├── python-pro/                  # Modern Python 3.12+ implementation (uv, ruff, pyright, packaging)
│   ├── python-testing/              # Testing strategies with pytest, fixtures & TDD (+ 2 references)
│   ├── rust-async-patterns/         # Production async Rust patterns with Tokio, channels & cancellation
│   ├── rust-pro/                    # Modern Rust 2024+ engineering, memory safety & performance
│   ├── spec-driven-design/          # 6-lens brainstorm + Zero-Decision spec drafting (+ 1 reference)
│   ├── tech-research/               # SOTA survey, benchmark comparison & technical trade-offs
│   ├── technical-reporting/         # Saved technical reports, benchmarks, Mermaid, asset paths (+ reference)
│   ├── ui-accessibility/            # WCAG 2.2 audits, keyboard/focus, ARIA (+ 1 reference)
│   ├── ux-critic/                   # Heuristic and visual critique, steering vocabulary (+ 1 reference)
│   ├── ux-product-shaper/           # Surface Mode, IA, 8-state product briefs (+ 1 reference)
│   └── verify-and-stop/             # Termination discipline, decisive checks & runaway prevention
├── tests/                           # Automated schema validation & invariant verification
├── setup.sh                         # Unified setup (default skips Rust; --with-rust to enable)
├── package.sh                       # Offline distribution packager (tar.gz & zip)
└── README.md
```

---

## Skills Catalog

| Skill Name | Purpose |
| :--- | :--- |
| **`algorithm-optimization`** | Systematic workflow to optimize algorithms/processes against target metrics while guarding healthy cases. |
| **`code-minimalism`** | Forces simplest, shortest, most minimal code (YAGNI). Reaches for stdlib before custom code, platform features before dependencies, 1-liner before 50. |
| **`code-review`** | Systematic multi-axis review for Python & Rust (correctness, safety, performance, YAGNI/bloat, style). Mandatory quality gate. |
| **`code-simplification`** | Safe refactoring to improve readability and reduce nesting in existing code without changing behavior. |
| **`codebase-contracts`** | Generate Peanuts/Hay directory README contracts from code, then audit spec and README drift across six vectors. |
| **`context7-mcp`** | Fetching up-to-date documentation and code references via Context7 MCP. |
| **`data-science`** | Statistical modeling, machine learning, A/B testing, exploratory analysis, and causal inference. |
| **`data-storytelling`** | Decision narrative from **already-validated** metrics. Does not analyze or invent numbers. |
| **`data-visualization`** | Plotly-first clean visual creation, SVG export, text density hygiene, and anti-overlap QA. |
| **`deprecation-migration`** | Safely sunset, replace, and migrate legacy APIs/systems using Strangler, Adapter, and Feature Flags. |
| **`design-system`** | Build 3-tier W3C DTCG tokens, dual light/dark themes, component specs, and responsive layout rules. |
| **`doubt-driven-development`** | Adversarial review to stress-test high-risk decisions and uncover unstated assumptions. |
| **`html-report`** | Single-file, self-contained HTML reports with dual-theme tokens, client-side filtering, and print/PDF fidelity. |
| **`plotly-dash`** | Production-grade Plotly Dash apps with modular layouts, disciplined callbacks, state hygiene & performance. |
| **`polars-duckdb`** | High-performance tabular data wrangling, ETL, and analytical SQL with Polars, DuckDB, PyArrow, and Pandas 2.x. |
| **`pyo3-maturin`** | High-performance Rust native extensions with PyO3 and Maturin for CPU-bound hotspots. *(Rust skill)* |
| **`python-concurrency`** | Concurrency models: `asyncio` for I/O, `ThreadPool` for blocking I/O, `ProcessPool` for CPU. |
| **`python-patterns`** | Architecture-time: framework, project layout, ADR. Executor choice lives in `python-concurrency`. |
| **`python-performance`** | Measure-first, profile-driven optimization with `cProfile`, `py-spy`, and memory profilers. |
| **`python-pro`** | Implement/modernize Python modules: typing, `uv`, `ruff`, pyright. Not architecture, concurrency model, or profiling. |
| **`python-testing`** | Pytest strategies, focused fixtures, mocking, and robust test suites. |
| **`rust-async-patterns`** | Production async Rust patterns with Tokio: structured concurrency, channels, cancellation, and backpressure. *(Rust skill)* |
| **`rust-pro`** | Production-grade Rust (Edition 2024 / rustc 1.85+): ownership, types, errors, unsafe. Tokio lives in `rust-async-patterns`. *(Rust skill)* |
| **`spec-driven-design`** | Turn a concept into an owner-approved spec with six-lens brainstorm, Gate 1/Gate 2, and Zero-Decision drafting. |
| **`tech-research`** | SOTA methods, benchmark evaluation, and conditional recommendations before implementation. |
| **`technical-reporting`** | Saved formal markdown: benchmarks, ADRs, Mermaid, asset paths. Not Plotly charts or QBR narrative. |
| **`ui-accessibility`** | Audit WCAG 2.2 AA, keyboard and focus models, ARIA, contrast, target size, and reduced motion. |
| **`ux-critic`** | Red-team rendered UI with heuristic critique, squint tests, and targeted design steering. |
| **`ux-product-shaper`** | Shape Surface Mode, information architecture, user flows, and the 8-state contract before UI work. |
| **`verify-and-stop`** | Disciplined execution and termination protocol. Verifies minimal acceptance criteria with a single decisive check, presents proof, and stops immediately without runaway loops. |

---

## Skill Relationship Map (Kernel & Plugins)

### Core Principles
- **Micro-Kernel Architecture**: `rules/AGENTS.md` holds global negative constraints, invariants, token hygiene, and the YAGNI code generation ladder.
- **Zero Restatement**: Skills never duplicate global rules (tone, emoji, LaTeX minimization). Each skill inherits them cleanly.
- **Optional Handoffs**: Most relationships are conditional pointers (`Use X when <condition>`).
- **Six Hard Invariants**: Core gates that cannot be bypassed.
- **No Long Chains**: Avoid default multi-hop chains to protect context and token budgets.

### 0. Ownership (Single Source of Truth)

| Fact | Home | Not here |
| :--- | :--- | :--- |
| Tone, no emoji, LaTeX minimization, ASD-STE100, git/secrets, memory safety, temp files | `rules/AGENTS.md` §1 & §4 | Skills |
| YAGNI Code Generation Ladder (stdlib/native first) | `rules/AGENTS.md` §2 | Skills (kernel-wide) |
| Verify-and-Stop Invariant (runaway prevention) | `rules/AGENTS.md` §3 + `verify-and-stop` | Ongoing loops |
| Subagent delegation, parallel planning & peer-review | `rules/AGENTS.md` §1 | Skills |
| Skip formal reports; tables first; date-prefixed files | `AGENTS.md` §5 stub | Full viz encyclopedias |
| Aggressive YAGNI intensity tiers (`lite` / `full` / `ultra`) | `code-minimalism` | `AGENTS.md` |
| Over-engineering & bloat review checklist | `code-review` | `AGENTS.md` |
| Saved Markdown, Mermaid allowlist, asset paths | `technical-reporting` | HTML reports, Plotly, QBR narrative |
| Single-file HTML layout, dual-theme and print CSS, client-side filtering | `html-report` | Markdown reports, chart design, server apps |
| Product UI visual design, 3-tier tokens, component specs, responsive layout | `design-system` | Markdown reports, chart design, UX research |
| UX research, Surface Mode, IA, 8-state contract | `ux-product-shaper` | Visual design, implementation |
| WCAG 2.2, keyboard/focus, accessibility audit | `ui-accessibility` | Visual style, token generation |
| Adversarial UI critique, heuristic evaluation, steering vocabulary | `ux-critic` | Implementation, code review |
| Plotly chart type, anti-overlap, SVG/Kaleido | `data-visualization` | Reporting, Dash figure restatement |
| Stakeholder Hook → Ask | `data-storytelling` | Analysis |
| High-volume CSV/Parquet ETL, Polars/DuckDB query mechanics | `polars-duckdb` | `data-science`, `python-performance` |
| EDA / inference / A/B / forecasting | `data-science` | Charts, Dash, SOTA survey |
| External SOTA / papers / benchmarks | `tech-research` | Implementation |
| Quality KPIs on real cases | `algorithm-optimization` | Runtime profiling |
| Framework, layout, ADR | `python-patterns` | Executor choice |
| Implement Python (typing, uv, ruff) | `python-pro` | Review, profiling, architecture |
| asyncio vs threads vs processes | `python-concurrency` | Framework choice |
| Runtime / memory / I/O profiling | `python-performance` | Accuracy/F1 loops |
| pytest, mocks, regression tests | `python-testing` | Feature implementation |
| PyO3 / Maturin / GIL | `pyo3-maturin` | Unprofiled rewrites |
| Dash callbacks, Store, pages | `plotly-dash` | Static Plotly charts |
| Rust types, errors, unsafe | `rust-pro` | Tokio task design |
| Tokio structured concurrency | `rust-async-patterns` | Sync Rust |
| Merge quality gate | `code-review` | Other skill YAML |
| Behavior-preserving cleanup of existing code | `code-simplification` | Redesign / generation |
| Sunset / strangler | `deprecation-migration` | Local dead-code only |
| Adversarial lock-in of a decision | `doubt-driven-development` | Every research note |
| Five-lens Goldfish review dispatch and reconciliation | `doubt-driven-development` + `references/goldfish-review-lenses.md` | Ad-hoc code review |
| Spec drafting, brainstorm lenses, Gate 1 and Gate 2 | `spec-driven-design` | Implementation, review verdicts |
| Directory README contracts, Peanuts/Hay, drift audit | `codebase-contracts` | Feature specs, diff review |
| Live library docs | `context7-mcp` | SOTA comparison |

---

### 1. Standard Relationships Table

| Domain | Skill | Input | Output / Handoff | Mode |
| :--- | :--- | :--- | :--- | :--- |
| **Discovery** | **`context7-mcp`** | Need version-sensitive docs/API | `python-pro`, `python-concurrency`, `polars-duckdb`, `plotly-dash`, `tech-research` | Optional |
| **Discovery** | **`codebase-contracts`** | Unknown codebase state or stale docs | `spec-driven-design` (ground the spec); `code-review` (contract drift); `verify-and-stop` | Optional |
| **Discovery** | **`tech-research`** | Need SOTA, alternatives, trade-offs | `spec-driven-design` (turn evidence into a spec); `doubt-driven-development` (to lock); `deprecation-migration` (replace legacy); `technical-reporting` (formal report) | Optional |
| **Decision** | **`spec-driven-design`** | Vague feature or open architecture | `doubt-driven-development` (five-lens review); `ux-product-shaper` (product shaping); `python-patterns`; `code-minimalism` | **Required before non-trivial implementation** |
| **Decision** | **`doubt-driven-development`** | Non-trivial choice from research/architecture | `spec-driven-design` (audited spec); `ux-critic` (rendered-UI critique); `python-testing` (lock risks into tests); `code-review` (via implementation) | Optional, conditional |
| **Design** | **`code-minimalism`** | Code creation or bloat reduction (/minimal, /ponytail) | `verify-and-stop` (verify completion); `code-review` (merge gate) | Optional |
| **Execution** | **`verify-and-stop`** | Implementation complete | Emits proof and stops; prevents runaway loops | Mandatory on task finish |
| **Migration** | **`deprecation-migration`** | Zombie/legacy code from review | `python-testing` (verify compatibility); `code-simplification` (clean shims); `design-system` (retire tokens/components) | Optional |
| **ETL & Data** | **`polars-duckdb`** | Tabular datasets (CSV, Parquet, Arrow, SQL) | `data-science` (analysis & ML); `python-performance` | Optional |
| **Analysis** | **`data-science`** | Raw data, EDA, modeling, statistics, A/B | `data-visualization` (charts); `data-storytelling` (narrative); `technical-reporting` | Optional / Required* |
| **Visualization** | **`data-visualization`** | Metrics/insights from `data-science` | `plotly-dash`, `html-report`, `technical-reporting`, `data-storytelling`, `ui-accessibility` (audit) | Optional |
| **Dashboard** | **`plotly-dash`** | Figures from `data-visualization`; pipeline from `data-science` | `python-testing` (callback test); `code-review` (merge gate); `html-report` (static single file); `design-system` (tokens) | Optional |
| **Narrative** | **`data-storytelling`** | Validated insights from `data-science` | Embedded in `technical-reporting` or `html-report` with `data-visualization` charts | **Required input from `data-science`** |
| **Reporting** | **`technical-reporting`** | Formal Markdown results from research, data science, optimization | Complete Markdown report with Mermaid/SVG assets; `html-report` for single-file HTML | Optional presentation |
| **HTML Output** | **`html-report`** | Validated content and exported figures | Single-file HTML with inline CSS/JS/SVG and print CSS; consumes `design-system` tokens | Optional presentation |
| **UX Shaping** | **`ux-product-shaper`** | Feature spec, audience, and constraints | `PRODUCT.md` with Surface Mode, IA, and 8-state contract; `design-system` | **Required before UI design** |
| **Design System** | **`design-system`** | Product brief and brand constraints | `DESIGN.md`, `tokens.css/json`, component specs; `html-report`/`plotly-dash` implementation; `ui-accessibility` audit | Optional |
| **Accessibility** | **`ui-accessibility`** | Implemented UI and design tokens | WCAG 2.2 audit report; `code-review` merge gate; `verify-and-stop` | **Required for UI delivery** |
| **UX Critique** | **`ux-critic`** | Rendered screenshots and design system | Heuristic critique report and steering commands; `verify-and-stop` | Optional |
| **Architecture** | **`python-patterns`** | Framework choice, layout, ADR | `python-pro` (implement); `python-concurrency` (executor choice) | Optional |
| **Implementation** | **`python-pro`** | Design from patterns or feature request | `python-testing` (test suite); `code-review` (merge gate) | **Required on merge path** |
| **Concurrency** | **`python-concurrency`** | Concurrency model choice | `python-performance` (measured profiling); `python-testing` | Optional |
| **Performance** | **`python-performance`** | Bottleneck runtime/memory/I/O | `pyo3-maturin` (CPU hotspot); `python-concurrency`; `algorithm-optimization` | Optional |
| **Native Extension**| **`pyo3-maturin`** | CPU hotspot profiled from Python | `python-testing` (parity tests); `code-review` | Optional (Rust skill) |
| **Rust Dev** | **`rust-pro`** | Rust service/crate implementation | `rust-async-patterns` (async Tokio); `code-review` | Optional (Rust skill) |
| **Rust Concurrency**| **`rust-async-patterns`** | Tokio, channels, streams | `rust-pro`; `code-review` | Optional (Rust skill) |
| **Optimization** | **`algorithm-optimization`** | KPI/quality degradation on real data | `data-visualization` (charts); `technical-reporting` or `html-report` (saved deliverable) | Optional |
| **Testing** | **`python-testing`** | Logic change from `python-pro` or cleanup | Pre-merge verification safety net | **Required for logic changes** |
| **Cleanup** | **`code-simplification`** | Deep nesting, Cyclomatic/Cognitive complexity flagged | Verified by tests; returned to `code-review` | Optional |
| **QA Gate** | **`code-review`** | PR/diff from implementation or refactoring | Merged when passing six review axes and complexity gates; `codebase-contracts` for drift; `ui-accessibility` for UI review; `html-report` for an HTML audit page | **Required on merge path** |

---

### 2. Six Hard Invariants

1. **Non-trivial features** require an owner-approved spec from **`spec-driven-design`** (Gate 1 and Gate 2) before implementation. Mechanical changes are exempt.
2. **`data-storytelling`** must strictly use validated metrics from **`data-science`** (zero invented numbers).
3. **Behavior, public-API, or UI diffs** must pass **`code-review`** before merge. UI diffs also pass **`ui-accessibility`**. If a spec or directory README documents the change, run **`codebase-contracts`** drift detection.
4. **Behavior modifications** require tests: Python → **`python-testing`**; Rust → crate tests; Dash → integration tests.
5. **Subagent Delegation**: Only delegate non-trivial, modular tasks (< ~100 lines stays in main thread); subagent deliverables require independent **peer-review** (<= 2 rounds) before acceptance.
6. **Structural Complexity Limits**: Functions must maintain Cyclomatic Complexity <= 10, Cognitive Complexity <= 15, and Nesting Depth <= 3.

---

### 3. Execution Flowchart

```text
context7-mcp
    └─ docs on demand ─► python-pro / python-concurrency / polars-duckdb / plotly-dash / tech-research

codebase-contracts
    ├─ current contracts ─► spec-driven-design
    ├─ drift report ─► code-review
    └─ verified contracts ─► verify-and-stop

spec-driven-design
    ├─ approved spec ─► doubt-driven-development (five-lens review)
    ├─ product shaping ─► ux-product-shaper
    ├─ architecture ─► python-patterns
    ├─ scope trim ─► code-minimalism
    └─ alternatives evidence ─► tech-research

tech-research
    ├─ chosen direction ─► spec-driven-design
    ├─ options/evidence ─► algorithm-optimization
    ├─ decision to lock ─► doubt-driven-development
    ├─ replace legacy ─► deprecation-migration
    └─ formal write-up ─► technical-reporting

doubt-driven-development
    ├─ spec to audit ─► spec-driven-design
    ├─ missing alternatives ─► tech-research
    ├─ bloat finding ─► code-minimalism
    ├─ actionable risks ─► python-testing
    └─ stable decision ─► implementation ─► code-review

html-report
    ├─ input from ─► technical-reporting / data-visualization / plotly-dash / data-storytelling / algorithm-optimization / code-review / design-system
    ├─ Markdown alternative ─► technical-reporting
    ├─ chart design and export ─► data-visualization
    ├─ server-backed app ─► plotly-dash
    ├─ design tokens ─► design-system
    ├─ decision narrative ─► data-storytelling
    └─ final artifact check ─► verify-and-stop

ux-product-shaper
    ├─ product brief ─► design-system
    ├─ requirements evidence ─► spec-driven-design
    └─ rendered critique ─► ux-critic

design-system
    ├─ tokens and specs ─► html-report / plotly-dash / python-pro
    ├─ legacy retirement ─► deprecation-migration
    ├─ accessibility audit ─► ui-accessibility
    └─ component findings ─► ux-critic

ui-accessibility
    ├─ findings ─► code-review
    ├─ contrast and focus fixes ─► design-system
    └─ final gate ─► verify-and-stop

ux-critic
    ├─ product mode check ─► ux-product-shaper
    ├─ design findings ─► design-system
    ├─ accessibility blocker ─► ui-accessibility
    ├─ decision challenge ─► doubt-driven-development
    └─ final gate ─► verify-and-stop

code-minimalism (YAGNI ladder)
    ├─ create minimum diff ─► verify-and-stop
    └─ audit diff ─► code-review

data-science
    ├─ charts ─► data-visualization
    ├─ narrative ─► data-storytelling
    ├─ KPI loop ─► algorithm-optimization
    └─ formal report ─► technical-reporting

python-patterns
    ├─ implement ─► python-pro
    └─ executor choice ─► python-concurrency

python-pro
    ├─ tests ─► python-testing ─► verify-and-stop
    └─ merge gate ─► code-review

code-review
    ├─ fix code ─► python-pro
    ├─ reduce complexity ─► code-simplification
    ├─ trim bloat ─► code-minimalism
    ├─ check documented contracts ─► codebase-contracts
    ├─ UI and WCAG review ─► ui-accessibility
    ├─ HTML audit page ─► html-report
    └─ sunset legacy ─► deprecation-migration
```

---

### 4. Situational Quick Router

| Situation | Recommended Skill |
| :--- | :--- |
| Turn a vague idea into an owner-approved design spec | **`spec-driven-design`** |
| Generate or audit directory README contracts (Peanuts/Hay) | **`codebase-contracts`** |
| Run a five-lens Goldfish review on a spec or plan | **`doubt-driven-development`** |
| Generate minimal code / avoid over-engineering / YAGNI | **`code-minimalism`** |
| Verify acceptance criteria and terminate cleanly (prevent loop) | **`verify-and-stop`** |
| Explore SOTA methods, evaluate technical alternatives | **`tech-research`** |
| Adversarial review of a high-risk architectural decision | **`doubt-driven-development`** |
| EDA, statistics, machine learning, A/B testing | **`data-science`** |
| High-performance ETL, Polars / DuckDB queries, Parquet / Arrow | **`polars-duckdb`** |
| Create clean Plotly charts with anti-overlap QA | **`data-visualization`** |
| Build a server-backed multi-page dashboard / data app | **`plotly-dash`** |
| Present data insights to business stakeholders | **`data-storytelling`** |
| Produce a single-file, interactive or print-ready HTML report | **`html-report`** |
| Shape product context, IA, user flows, and the 8-state contract | **`ux-product-shaper`** |
| Build or update design tokens, themes, and component specs | **`design-system`** |
| Audit WCAG 2.2, keyboard, focus, contrast, and target size | **`ui-accessibility`** |
| Critique a rendered UI and prescribe design steering | **`ux-critic`** |
| Write durable Markdown report / ADR / Mermaid diagram | **`technical-reporting`** |
| Choose Python framework, project layout, ADR | **`python-patterns`** |
| Implement Python 3.12+ features (uv, ruff, pyright) | **`python-pro`** |
| Select concurrency model (asyncio vs threads vs processes) | **`python-concurrency`** |
| Profile latency, memory, or CPU bottlenecks | **`python-performance`** |
| Write Rust crate / performance-critical logic | **`rust-pro`** (+ `rust-async-patterns` if async) |
| Build PyO3 / Maturin extension for Python hotspot | **`pyo3-maturin`** |
| Optimize quality / accuracy / KPI on real data | **`algorithm-optimization`** |
| Write or debug pytest suites | **`python-testing`** |
| Refactor working code to reduce nesting/complexity | **`code-simplification`** |
| Review PR/diff before merge (correctness, safety, YAGNI) | **`code-review`** |
| Look up version-sensitive library docs | **`context7-mcp`** |
| Safely sunset or migrate legacy APIs/systems | **`deprecation-migration`** |

---

## Installation & Setup

Skills are installed into the portable Agent Skills root (`~/.agents/skills`) and native host trees.

### Host Discovery Paths

| Host | Rules file | Skill roots scanned (priority order) |
|---|---|---|
| Codex | `~/.codex/AGENTS.md` | `~/.codex/skills`, `~/.agents/skills` |
| Antigravity | `~/.gemini/GEMINI.md` | `~/.gemini/config/skills`, `~/.gemini/antigravity-cli/skills` |
| Grok | `~/.grok/AGENTS.md` | `~/.agents/skills` |
| Zed | `~/.config/zed/AGENTS.md` | `~/.agents/skills` |
| OpenCode | `~/.config/opencode/AGENTS.md` | `~/.agents/skills`, `<project>/.opencode/skills` |
| ZCode Desktop | `~/.zcode/AGENTS.md` | `~/.zcode/skills`, `~/.agents/skills`, `<repo>/.zcode/skills` |

### Automated Setup Script

```bash
chmod +x setup.sh
./setup.sh              # Installs 27 of 30 skills (skips the three Rust skills)
./setup.sh --with-rust  # Includes Rust skills (rust-pro, rust-async-patterns, pyo3-maturin)
```

Useful flags:

```bash
./setup.sh --with-rust              # include Rust skills
./setup.sh --all                    # enable --with-rust and install to all detected hosts
./setup.sh --dry-run                # print destinations only
./setup.sh --host zed,codex         # subset of hosts
./setup.sh --project                # current repo: .agents/skills + AGENTS.md
./setup.sh --link                   # symlink skills from this clone (dev)
./setup.sh --mirror-native          # also copy into native host skills dirs
./setup.sh --force                  # create host dirs even if the app is not detected
```

Restart each agent session after install.

---

## Quality Assurance & Automated Tests

Run the test suite to verify YAML schemas and repository invariants:

```bash
# Run pytest schema and invariant checks
pytest tests/ -v

# Run setup script behavior test
bash tests/test_setup_script.sh
```

---

## Offline Packaging (Air-gapped)

To package skills for transfer to an offline system:

```bash
chmod +x package.sh
./package.sh
```

Packages generated in `dist/`:
- **`dist/skills.tar.gz` & `dist/skills.zip`**: Standalone skills package.
- **`dist/agent-skills.tar.gz` & `dist/agent-skills.zip`**: Complete offline bundle (`skills/`, `rules/`, `tests/`, `setup.sh`).
