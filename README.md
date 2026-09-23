# Agent Skills

A curated, token-efficient collection of **Global Agent Rules** and **Custom Skills** designed for the **Google Antigravity**, **Cursor**, **Pi**, **Grok**, and **Windsurf** coding assistant environments.

---

## Repository Structure

```text
agent-skills/
├── rules/
│   └── AGENTS.md                    # Global agent behavioral directives & kernel standards
├── skills/
│   ├── algorithm-optimization/      # Systematic KPI & algorithm improvement loop
│   ├── code-minimalism/             # YAGNI-first minimalist code generation (stdlib/platform native)
│   ├── code-review/                 # Multi-axis review + YAGNI/bloat quality gate
│   ├── code-simplification/         # Safe refactoring, reducing nesting & accidental complexity
│   ├── context7-mcp/                # Live documentation lookup for libraries/frameworks
│   ├── data-science/                # EDA, modeling, statistics, causal inference & A/B testing
│   ├── data-storytelling/           # Decision-ready narratives for business stakeholders
│   ├── data-visualization/          # Plotly-first charts, layout optimization & anti-overlap QA
│   ├── deprecation-migration/       # Safe removal, replacement & sunsetting of legacy APIs/systems
│   ├── doubt-driven-development/    # Adversarial stress-testing of non-trivial architectural choices
│   ├── plotly-dash/                 # Interactive Python data apps with Plotly Dash & clean callbacks
│   ├── pyo3-maturin/                # Rust native extensions with PyO3 & Maturin for CPU hotspots
│   ├── python-concurrency/          # Concurrency models: asyncio, thread pool, process pool
│   ├── python-patterns/             # Architecture-time: framework, layout, ADR
│   ├── python-performance/          # Profile-driven performance optimization
│   ├── python-pro/                  # Modern Python 3.12+ implementation (uv, ruff, pyright)
│   ├── python-testing/              # Testing strategies with pytest, fixtures & TDD
│   ├── rust-async-patterns/         # Production async Rust patterns with Tokio, channels & cancellation
│   ├── rust-pro/                    # Modern Rust 2024+ engineering, memory safety & performance
│   ├── tech-research/               # SOTA survey, benchmark comparison & technical trade-offs
│   ├── technical-reporting/         # Saved technical reports, benchmarks, Mermaid, asset paths
│   └── verify-and-stop/             # Termination discipline, decisive checks & runaway prevention
├── tests/                           # Automated schema validation & invariant verification
├── setup.sh                         # Unified setup (default skips Rust; --with-rust to enable)
├── package.sh                       # Offline distribution packager
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
| **`context7-mcp`** | Fetching up-to-date documentation and code references via Context7 MCP. |
| **`data-science`** | Statistical modeling, machine learning, A/B testing, exploratory analysis, and causal inference. |
| **`data-storytelling`** | Decision narrative from **already-validated** metrics. Does not analyze or invent numbers. |
| **`data-visualization`** | Plotly-first clean visual creation, SVG export, text density hygiene, and anti-overlap QA. |
| **`deprecation-migration`** | Safely sunset, replace, and migrate legacy APIs/systems using Strangler, Adapter, and Feature Flags. |
| **`doubt-driven-development`** | Adversarial review to stress-test high-risk decisions and uncover unstated assumptions. |
| **`plotly-dash`** | Production-grade Plotly Dash apps with modular layouts, disciplined callbacks, state hygiene & performance. |
| **`pyo3-maturin`** | High-performance Rust native extensions with PyO3 and Maturin for CPU-bound hotspots. *(Rust skill)* |
| **`python-concurrency`** | Concurrency models: `asyncio` for I/O, `ThreadPool` for blocking I/O, `ProcessPool` for CPU. |
| **`python-patterns`** | Architecture-time: framework, project layout, ADR. Executor choice lives in `python-concurrency`. |
| **`python-performance`** | Measure-first, profile-driven optimization with `cProfile`, `py-spy`, and memory profilers. |
| **`python-pro`** | Implement/modernize Python modules: typing, `uv`, `ruff`, pyright. Not architecture, concurrency model, or profiling. |
| **`python-testing`** | Pytest strategies, focused fixtures, mocking, and robust test suites. |
| **`rust-async-patterns`** | Production async Rust patterns with Tokio: structured concurrency, channels, cancellation, and backpressure. *(Rust skill)* |
| **`rust-pro`** | Production-grade Rust (Edition 2024 / rustc 1.85+): ownership, types, errors, unsafe. Tokio lives in `rust-async-patterns`. *(Rust skill)* |
| **`tech-research`** | SOTA methods, benchmark evaluation, and conditional recommendations before implementation. |
| **`technical-reporting`** | Saved formal markdown: benchmarks, ADRs, Mermaid, asset paths. Not Plotly charts or QBR narrative. |
| **`verify-and-stop`** | Disciplined execution and termination protocol. Verifies minimal acceptance criteria with a single decisive check, presents proof, and stops immediately without runaway loops. |

---

## Skill Relationship Map (Kernel & Plugins)

### Core Principles
- **Micro-Kernel Architecture**: `rules/AGENTS.md` holds global negative constraints, invariants, token hygiene, and the YAGNI code generation ladder.
- **Zero Restatement**: Skills never duplicate global rules (tone, emoji, LaTeX minimization). Each skill inherits them cleanly.
- **Optional Handoffs**: Most relationships are conditional pointers (`Use X when <condition>`).
- **Four Hard Invariants**: Core gates that cannot be bypassed.
- **No Long Chains**: Avoid default multi-hop chains to protect context and token budgets.

### 0. Ownership (Single Source of Truth)

| Fact | Home | Not here |
| :--- | :--- | :--- |
| Tone, no emoji, LaTeX minimization, ASD-STE100, git/secrets, temp files | `rules/AGENTS.md` §1 | Skills |
| YAGNI Code Generation Ladder (stdlib/native first) | `rules/AGENTS.md` §2 | Skills (kernel-wide) |
| Verify-and-Stop Invariant (runaway prevention) | `rules/AGENTS.md` §3 + `verify-and-stop` | Ongoing loops |
| Subagent delegation, parallel planning & peer-review | `rules/AGENTS.md` §1 | Skills |
| Skip formal reports; tables first; date-prefixed files | `AGENTS.md` §5 stub | Full viz encyclopedias |
| Aggressive YAGNI intensity tiers (`lite|full|ultra`) | `code-minimalism` | `AGENTS.md` |
| Over-engineering & bloat review checklist | `code-review` | `AGENTS.md` |
| Saved markdown, Mermaid allowlist, asset paths | `technical-reporting` | Plotly, QBR narrative |
| Plotly chart type, anti-overlap, SVG/Kaleido | `data-visualization` | Reporting, Dash figure restatement |
| Stakeholder Hook → Ask | `data-storytelling` | Analysis |
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
| Live library docs | `context7-mcp` | SOTA comparison |

---

### 1. Standard Relationships Table

| Domain | Skill | Input | Output / Handoff | Mode |
| :--- | :--- | :--- | :--- | :--- |
| **Discovery** | **`context7-mcp`** | Need version-sensitive docs/API | `python-pro`, `python-concurrency`, `tech-research`, `data-science` | Optional |
| **Discovery** | **`tech-research`** | Need SOTA, alternatives, trade-offs | `doubt-driven-development` (to lock); `deprecation-migration` (replace legacy); `technical-reporting` (formal report) | Optional |
| **Decision** | **`doubt-driven-development`** | Non-trivial choice from research/architecture | `python-testing` (lock risks into tests); `code-review` (via implementation) | Optional, conditional |
| **Design** | **`code-minimalism`** | Code creation or bloat reduction (/minimal, /ponytail) | `verify-and-stop` (verify completion); `code-review` (merge gate) | Optional |
| **Execution** | **`verify-and-stop`** | Implementation complete | Emits proof and stops; prevents runaway loops | Mandatory on task finish |
| **Migration** | **`deprecation-migration`** | Zombie/legacy code from review | `python-testing` (verify compatibility); `code-simplification` (clean shims) | Optional |
| **Analysis** | **`data-science`** | Raw data, EDA, modeling, statistics, A/B | `data-visualization` (charts); `data-storytelling` (narrative); `technical-reporting` | Optional / Required* |
| **Visualization** | **`data-visualization`** | Metrics/insights from `data-science` | `plotly-dash`, `technical-reporting`, `data-storytelling` | Optional |
| **Dashboard** | **`plotly-dash`** | Figures from `data-visualization`; pipeline from `data-science` | `python-testing` (callback test); `code-review` (merge gate) | Optional |
| **Narrative** | **`data-storytelling`** | Validated insights from `data-science` | Embedded in `technical-reporting` with `data-visualization` charts | **Required input from `data-science`** |
| **Reporting** | **`technical-reporting`** | Formal results from research, data science, optimization | Complete technical report with Mermaid/SVG assets | Optional presentation |
| **Architecture** | **`python-patterns`** | Framework choice, layout, ADR | `python-pro` (implement); `python-concurrency` (executor choice) | Optional |
| **Implementation** | **`python-pro`** | Design from patterns or feature request | `python-testing` (test suite); `code-review` (merge gate) | **Required on merge path** |
| **Concurrency** | **`python-concurrency`** | Concurrency model choice | `python-performance` (measured profiling); `python-testing` | Optional |
| **Performance** | **`python-performance`** | Bottleneck runtime/memory/I/O | `pyo3-maturin` (CPU hotspot); `python-concurrency`; `algorithm-optimization` | Optional |
| **Native Extension**| **`pyo3-maturin`** | CPU hotspot profiled from Python | `python-testing` (parity tests); `code-review` | Optional (Rust skill) |
| **Rust Dev** | **`rust-pro`** | Rust service/crate implementation | `rust-async-patterns` (async Tokio); `code-review` | Optional (Rust skill) |
| **Rust Concurrency**| **`rust-async-patterns`** | Tokio, channels, streams | `rust-pro`; `code-review` | Optional (Rust skill) |
| **Optimization** | **`algorithm-optimization`** | KPI/quality degradation on real data | `data-visualization` (charts); `technical-reporting` | Optional |
| **Testing** | **`python-testing`** | Logic change from `python-pro` or cleanup | Pre-merge verification safety net | **Required for logic changes** |
| **Cleanup** | **`code-simplification`** | Deep nesting, complexity flagged in review | Verified by tests; returned to `code-review` | Optional |
| **QA Gate** | **`code-review`** | PR/diff from implementation or refactoring | Merged when passing 6 review axes | **Required on merge path** |

---

### 2. Four Hard Invariants

1. **`data-storytelling`** must strictly use validated metrics from **`data-science`** (zero invented numbers).
2. **Behavior or public-API diffs** must pass **`code-review`** before merge.
3. **Behavior modifications** require tests: Python → **`python-testing`**; Rust → crate tests; Dash → integration tests.
4. **Subagent Delegation**: Only delegate non-trivial, modular tasks (< ~100 lines stays in main thread); subagent deliverables require independent **peer-review** (<= 2 rounds) before acceptance.

---

### 3. Execution Flowchart

```text
context7-mcp
    └─ docs on demand ─► python-pro / python-concurrency / tech-research / data-science

tech-research
    ├─ options/evidence ─► algorithm-optimization
    ├─ decision to lock ─► doubt-driven-development
    ├─ replace legacy ─► deprecation-migration
    └─ formal write-up ─► technical-reporting

doubt-driven-development
    ├─ missing alternatives ─► tech-research
    ├─ actionable risks ─► python-testing
    └─ stable decision ─► implementation ─► code-review

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
    └─ sunset legacy ─► deprecation-migration
```

---

### 4. Situational Quick Router

| Situation | Recommended Skill |
| :--- | :--- |
| Generate minimal code / avoid over-engineering / YAGNI | **`code-minimalism`** |
| Verify acceptance criteria and terminate cleanly (prevent loop) | **`verify-and-stop`** |
| Explore SOTA methods, evaluate technical alternatives | **`tech-research`** |
| Adversarial review of a high-risk architectural decision | **`doubt-driven-development`** |
| EDA, statistics, machine learning, A/B testing | **`data-science`** |
| Create clean Plotly charts with anti-overlap QA | **`data-visualization`** |
| Build interactive dashboard / data app | **`plotly-dash`** |
| Present data insights to business stakeholders | **`data-storytelling`** |
| Write durable technical report / ADR / Mermaid diagram | **`technical-reporting`** |
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

### Automated Setup Script

```bash
chmod +x setup.sh
./setup.sh              # Installs core, arch, data, Python (skips Rust by default)
./setup.sh --with-rust  # Includes Rust skills (rust-pro, rust-async-patterns, pyo3-maturin)
```

Useful flags:

```bash
./setup.sh --with-rust              # include Rust skills
./setup.sh --all                    # enable --with-rust and install to all detected hosts
./setup.sh --dry-run                # print destinations only
./setup.sh --host cursor,grok       # subset of hosts
./setup.sh --project                # current repo: .agents/skills + AGENTS.md
./setup.sh --link                   # symlink skills from this clone (dev)
./setup.sh --mirror-native          # also copy into ~/.cursor|~/.grok|~/.pi skills dirs
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

Tarballs generated in `dist/`:
- **`dist/skills.tar.gz`**: Standalone skills package.
- **`dist/agent-skills.tar.gz`**: Complete offline bundle (`skills/`, `rules/`, `tests/`, `setup.sh`).
