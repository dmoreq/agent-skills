# Agent Skills

A curated, token-efficient collection of **Global Agent Rules** and **Custom Skills** designed for the **Google Antigravity**, **Cursor**, **Pi**, and **Grok** coding assistant environments.

---

## Repository Structure

```
agent-skills/
├── rules/
│   └── AGENTS.md                    # Global agent behavioral directives & standards
├── skills/
│   ├── algorithm-optimization/      # Systematic KPI & algorithm improvement loop
│   ├── technical-reporting/         # Saved technical reports, benchmarks, Mermaid, asset paths
│   ├── code-review/                 # Multi-axis code review checklist before merging
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
│   └── tech-research/               # SOTA survey, benchmark comparison & technical trade-offs
├── setup.sh                         # Unified setup (Antigravity, Cursor, Pi, Grok)
└── README.md
```

---

## Skills Catalog

| Skill Name | Purpose |
| :--- | :--- |
| **`algorithm-optimization`** | Systematic workflow to optimize algorithms/processes against target metrics while guarding healthy cases. |
| **`technical-reporting`** | Saved formal markdown: benchmarks, ADRs, Mermaid, asset paths. Not Plotly charts or QBR narrative. |
| **`tech-research`** | SOTA methods, benchmark evaluation, and conditional recommendations before implementation. |
| **`data-science`** | Statistical modeling, machine learning, A/B testing, exploratory analysis, and causal inference. |
| **`data-storytelling`** | Decision narrative from **already-validated** metrics. Does not analyze or invent numbers. |
| **`data-visualization`** | Plotly-first clean visual creation, SVG export, text density hygiene, and anti-overlap QA. |
| **`plotly-dash`** | Production-grade Plotly Dash apps with modular layouts, disciplined callbacks, state hygiene & performance. |
| **`deprecation-migration`** | Safely sunset, replace, and migrate legacy APIs/systems using Strangler, Adapter, and Feature Flags. |
| **`doubt-driven-development`** | Adversarial review to stress-test high-risk decisions and uncover unstated assumptions. |
| **`python-pro`** | Implement/modernize Python modules: typing, `uv`, `ruff`, pyright. Not architecture, concurrency model, or profiling. |
| **`python-patterns`** | Architecture-time: framework, project layout, ADR. Executor choice lives in `python-concurrency`. |
| **`python-concurrency`** | Concurrency models: `asyncio` for I/O, `ThreadPool` for blocking I/O, `ProcessPool` for CPU. |
| **`python-performance`** | Measure-first, profile-driven optimization with `cProfile`, `py-spy`, and memory profilers. |
| **`python-testing`** | Pytest strategies, focused fixtures, mocking, and robust test suites. |
| **`pyo3-maturin`** | High-performance Rust native extensions with PyO3 and Maturin for CPU-bound hotspots. |
| **`rust-pro`** | Production-grade Rust (Edition 2024 / rustc 1.85+): ownership, types, errors, unsafe. Tokio lives in `rust-async-patterns`. |
| **`rust-async-patterns`** | Production async Rust patterns with Tokio: structured concurrency, channels, cancellation, and backpressure. |
| **`code-review`** | Systematic multi-axis review for Python & Rust (correctness, safety, performance, style). Mandatory quality gate. |
| **`code-simplification`** | Safe refactoring to improve readability and reduce nesting without changing behavior. |
| **`context7-mcp`** | Fetching up-to-date documentation and code references via Context7 MCP. |

---

## Skill Relationship Map (Optimized)

### Core Principles
- Hầu hết quan hệ là **optional handoff** (chỉ kích hoạt khi thật sự có điều kiện).
- Chỉ duy trì **4 quan hệ cứng (Hard Invariants)** cốt lõi.
- **Không bao giờ chain dài theo mặc định** để tối ưu hóa context và token.
- **One home per fact**: mỗi quy tắc/list chỉ sống trong một skill hoặc `AGENTS.md`; skill khác chỉ pointer.
- **Không nhét merge-gate vào YAML `description`**. Invariant merge nằm ở README + `code-review`. Related Skills dùng `Use X when <condition>`.

### 0. Ownership (single source of truth)

| Fact | Home | Not here |
| :--- | :--- | :--- |
| Tone, no emoji, scope, git/secrets, temp files | `rules/AGENTS.md` | Skills |
| Subagent delegation, parallel planning & peer-review | `rules/AGENTS.md` | Skills |
| Skip formal reports; tables first; date-prefixed files | `AGENTS.md` §5 stub | Full viz encyclopedias |
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
| Behavior-preserving cleanup | `code-simplification` | Redesign |
| Sunset / strangler | `deprecation-migration` | Local dead-code only |
| Adversarial lock-in of a decision | `doubt-driven-development` | Every research note |
| Live library docs | `context7-mcp` | SOTA comparison |

### 1. Bảng quan hệ chuẩn

| Nhóm | Skill | Nhận từ (Input) | Chuyển đến (Output) | Mức độ |
| :--- | :--- | :--- | :--- | :--- |
| **Discovery** | **`context7-mcp`** | Nhu cầu docs/API cụ thể, version-sensitive | `python-pro`, `python-concurrency`, `tech-research`, `data-science` | Optional |
| **Discovery** | **`tech-research`** | Nhu cầu SOTA, alternatives, trade-offs kỹ thuật | `doubt-driven-development` (khi chốt quyết định); `deprecation-migration` (thay hệ thống cũ); `technical-reporting` (formal report); `algorithm-optimization` (validate trên data thật) | Optional |
| **Decision** | **`doubt-driven-development`** | Quyết định non-trivial từ `tech-research`, `python-patterns`, architecture / cutover decisions | `python-testing` (chốt risk thành regression test); `tech-research` (nếu thiếu alternatives); implementation path rồi qua `code-review` | Optional, có điều kiện |
| **Migration** | **`deprecation-migration`** | Legacy/zombie code từ `code-review`; replacement options từ `tech-research` | `python-testing` (verify tương thích); `code-simplification` (dọn shim/adapter thừa sau cùng) | Optional |
| **Analysis** | **`data-science`** | Dữ liệu thô, EDA, modeling, thống kê, A/B | `data-visualization` (vẽ chart); `data-storytelling` (narrative); `algorithm-optimization` (tối ưu KPI); `technical-reporting` (formal report) | Optional / Required* |
| **Visualization** | **`data-visualization`** | Metric/insight từ `data-science`; before/after từ `algorithm-optimization`; benchmark từ `python-performance` | `plotly-dash`, `technical-reporting`, `data-storytelling` | Optional |
| **Dashboard** | **`plotly-dash`** | Plotly figures từ `data-visualization`; pipeline/metrics từ `data-science`; docs từ `context7-mcp` | `python-testing` (test callback/integration); `code-review` (merge gate); `python-performance` (nếu bottleneck) | Optional |
| **Narrative** | **`data-storytelling`** | Insight đã validate từ `data-science` | Dùng chart từ `data-visualization`; nhúng vào `technical-reporting` | **Required input from `data-science`** |
| **Reporting** | **`technical-reporting`** | Kết quả formal từ `tech-research`, `data-science`, `algorithm-optimization` | Báo cáo kỹ thuật hoàn chỉnh kèm visual Tier-1/Tier-2 | Optional presentation layer |
| **Architecture** | **`python-patterns`** | Nhu cầu chọn framework, layout, ADR | `python-pro` (implement); `python-concurrency` (khi cần chọn asyncio/threads/processes) | Optional |
| **Implementation** | **`python-pro`** | Design từ `python-patterns` hoặc requirement tính năng | `python-testing` (bảo vệ behavior); `context7-mcp` (tra cứu docs); `code-review` (trước khi merge) | **Required on merge path** |
| **Concurrency** | **`python-concurrency`** | Lựa chọn concurrency từ `python-patterns` hoặc bottleneck I/O vs CPU | `python-performance` (đo lường thực tế); `python-testing` (async/parallel safety) | Optional |
| **Performance** | **`python-performance`** | Bottleneck runtime/memory/I/O từ implementation hoặc concurrency | `pyo3-maturin` (nếu là CPU-bound hotspot cần native Rust); `python-concurrency` (nếu đúng loại bottleneck); `tech-research` (cần approach mới); `algorithm-optimization` (nếu là quality/process KPI) | Optional |
| **Native Extension** | **`pyo3-maturin`** | CPU-bound bottleneck đã profile từ `python-performance` | `python-testing` (parity và regression test); `code-review` (trước khi merge) | Optional |
| **Rust Dev** | **`rust-pro`** | Nhu cầu phát triển Rust service/crate hoặc tối ưu hóa hiệu năng | `rust-async-patterns` (khi cần async); `pyo3-maturin` (nếu làm Python extension); `code-review` (trước khi merge) | Optional |
| **Rust Concurrency** | **`rust-async-patterns`** | Tokio, channels, streams, task coordination trong Rust | `rust-pro` (để implement); `code-review` (trước khi merge) | Optional |
| **Optimization** | **`algorithm-optimization`** | KPI/process kém trên data thật; candidate từ `tech-research`; chẩn đoán từ `data-science` | `data-visualization` (before/after chart); `technical-reporting` (báo cáo); `python-performance` (nếu lộ runtime bottleneck) | Optional |
| **Testing** | **`python-testing`** | Python behavior change từ `python-pro`; parity từ `pyo3-maturin`; risk từ `doubt-driven`; migration / cleanup | Safety net trước `code-review` cho Python | **Required for Python behavior changes** |
| **Cleanup** | **`code-simplification`** | Complexity, deep nesting, duplication từ `code-review` hoặc sau feature complete | Dựa trên `python-testing` giữ nguyên behavior; đưa lại `code-review` | Optional |
| **QA Gate** | **`code-review`** | PR/diff từ `python-pro`, `pyo3-maturin`, `code-simplification`, `deprecation-migration`, hoặc subagent/agent khác | `python-pro` (sửa code); `code-simplification` (giảm complexity); `deprecation-migration` (sunset legacy); merge khi đạt chuẩn | **Required on merge path** |

---

### 2. Bốn quan hệ cứng (Hard Invariants)

1. **`data-storytelling`** bắt buộc phải dựa trên insight đã được validate từ **`data-science`** (không tự bịa số liệu).
2. **Merge behavior hoặc public-API diffs vào main** bắt buộc qua **`code-review`**.
3. **Mọi thay đổi hành vi** bắt buộc có test: Python → **`python-testing`**; Rust → crate tests; Dash → unit + `dash_duo` khi đụng UI.
4. **Chạy subagents**: Chỉ phân rã subagent cho task phi tầm thường (non-trivial, có ranh giới module rõ ràng); deliverable bắt buộc qua bước **peer-review** độc lập (tối đa 2 vòng, bám sát artifact + contract) trước khi nghiệm thu.

*Tất cả các quan hệ còn lại đều mang tính chất có điều kiện (conditional/optional).*

---

### 3. Sơ đồ dòng chảy tối ưu (Flowchart)

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

data-science
    ├─ charts ─► data-visualization
    ├─ narrative ─► data-storytelling
    ├─ KPI loop ─► algorithm-optimization
    └─ formal report ─► technical-reporting

algorithm-optimization
    ├─ visuals ─► data-visualization
    ├─ report ─► technical-reporting
    └─ runtime issue found ─► python-performance

python-patterns
    ├─ implement ─► python-pro
    └─ executor choice ─► python-concurrency

python-pro
    ├─ docs ─► context7-mcp
    ├─ tests ─► python-testing
    └─ merge gate ─► code-review

python-concurrency ◄──► python-performance
                            └─ CPU hotspot ─► pyo3-maturin ─► python-testing ─► code-review

rust-pro
    ├─ Tokio / tasks ─► rust-async-patterns
    └─ Python extension ─► pyo3-maturin

code-review
    ├─ fix code ─► python-pro
    ├─ reduce complexity ─► code-simplification
    └─ sunset legacy ─► deprecation-migration

deprecation-migration
    ├─ verify ─► python-testing
    └─ optional cleanup ─► code-simplification
```

---

### 4. Router nhanh theo tình huống

| Tình huống thực tế | Skill ưu tiên kích hoạt |
| :--- | :--- |
| Tìm approach, giải pháp SOTA, khảo sát thư viện | **`tech-research`** |
| Chốt quyết định lớn / rủi ro cao từ research hoặc kiến trúc | **`doubt-driven-development`** |
| EDA, modeling, phân tích thống kê, A/B testing | **`data-science`** |
| Vẽ biểu đồ chuẩn chỉnh, không đè chữ (Text Density Hygiene) | **`data-visualization`** |
| Xây dựng interactive dashboard / data app với Plotly Dash | **`plotly-dash`** |
| Kể chuyện dữ liệu / trình bày insight cho stakeholder | **`data-storytelling`** |
| Soạn thảo báo cáo kỹ thuật formal (Mermaid / SVG) | **`technical-reporting`** |
| Chọn framework, cấu trúc module, ADR | **`python-patterns`** |
| Lập trình tính năng bằng Python 3.12+ | **`python-pro`** |
| Chọn asyncio / threads / processes | **`python-concurrency`** |
| Điểm nghẽn độ trễ, ngốn CPU hoặc RAM | **`python-performance`** |
| Làm Rust service / crate / performance-critical code | **`rust-pro`** (+ `rust-async-patterns` nếu cần async) |
| Viết Rust native extension cho Python (CPU hotspot) | **`pyo3-maturin`** $\rightarrow$ **`python-testing`** $\rightarrow$ **`code-review`** |
| Tối ưu chất lượng / accuracy / KPI trên dữ liệu thực tế | **`algorithm-optimization`** |
| Viết, debug hoặc bổ sung test suite (pytest / TDD) | **`python-testing`** |
| Code chạy đúng nhưng rối, nesting sâu, cần refactor | **`code-simplification`** |
| Review chất lượng code trước khi merge PR | **`code-review`** |
| Tra cứu tài liệu thư viện / API mới nhất | **`context7-mcp`** |
| Khai tử, thay thế và chuyển đổi hệ thống / API cũ | **`deprecation-migration`** |

---

### 5. Anti-Patterns trong điều phối quan hệ

- ❌ **Bật `technical-reporting` cho câu trả lời ngắn trung gian**: Gây lãng phí token không cần thiết.
- ❌ **Bật `doubt-driven-development` cho mọi khảo sát research thông thường**: Chỉ bật khi kết quả chuẩn bị khóa thành quyết định triển khai.
- ❌ **Dùng `python-performance` cho accuracy / confidence KPI**: Runtime bottleneck và algorithmic quality KPI là 2 bài toán khác nhau.
- ❌ **Dùng `algorithm-optimization` cho pure runtime tuning**: Cần dùng `python-performance` có profiling thực tế.
- ❌ **`data-storytelling` tự tạo số liệu/insight**: Luôn phải nhận insight đã được chứng thực từ `data-science`.
- ❌ **Merge PR khi chưa qua `code-review`**: Bỏ qua cổng kiểm soát an toàn 5 trục.
- ❌ **Chain bắt buộc Research $\rightarrow$ Optimize $\rightarrow$ Report cho mọi request**: Chỉ kích hoạt skill phù hợp trực tiếp với intent của người dùng.
- ❌ **Nhét “always code-review” vào YAML `description` của skill khác**: Merge-gate chỉ thuộc README + `code-review`.
- ❌ **Spam subagent cho task nhỏ hoặc tuyến tính**: Tác vụ cục bộ, đơn giản (< ~100 dòng) xử lý trực tiếp ở main thread để tránh lãng phí token khởi tạo.
- ❌ **Dump toàn bộ transcript vào subagent hoặc reviewer**: Chỉ chuyển artifact cô lập + contract/tiêu chí đánh giá để tối ưu hóa context.

---

## Installation & Setup

Skills are installed **once** into the portable Agent Skills root (`~/.agents/skills`). Cursor, Pi, Grok Build, and Antigravity 2.0 all scan that path. Antigravity IDE/CLI also get native copies because their discovery is split across two Gemini trees.

### Option 1: Automatic Setup Script (Recommended)

```bash
chmod +x setup.sh
./setup.sh
```

Useful flags:

```bash
./setup.sh --dry-run                 # print destinations only
./setup.sh --host grok,cursor        # subset
./setup.sh --project                 # current repo: .agents/skills + AGENTS.md
./setup.sh --link                    # symlink skills from this clone (dev)
./setup.sh --mirror-native           # also copy into ~/.cursor|~/.grok|~/.pi skills dirs
./setup.sh --force                   # create host dirs even if the app is not detected
```

Restart each agent session after install. Verify:

| Host | Check |
| :--- | :--- |
| Antigravity | Ask which skills are available, or `/skills` |
| Grok Build | `grok inspect` |
| Cursor | Settings → Skills |
| Pi | `/skill:python-pro` |

### What the installer writes (user scope)

| Host | Rules (always-on) | Skills |
| :--- | :--- | :--- |
| **Portable** (all) | — | `~/.agents/skills/<name>/` |
| **Antigravity IDE** | `~/.gemini/GEMINI.md` | `~/.gemini/config/skills/` |
| **Antigravity CLI** | same AGENTS.md (installed as GEMINI.md) | `~/.gemini/antigravity-cli/skills/` |
| **Cursor** | `~/.cursor/rules/agent-rules.mdc` (`alwaysApply: true`) | via `~/.agents/skills` |
| **Pi** | `~/.pi/agent/AGENTS.md` | via `~/.agents/skills` |
| **Grok Build** | `~/.grok/AGENTS.md` | via `~/.agents/skills` |

Do **not** put a plain `GEMINI.md` in `~/.cursor/rules/` — Cursor only loads `.mdc` with frontmatter. Do **not** use Pi `APPEND_SYSTEM.md` as the primary rules file (it is unlabeled extra prompt text); `AGENTS.md` is the documented global instruction file.

`--mirror-native` is only for older Cursor/Grok/Pi builds that do not scan `~/.agents/skills`. Using it **and** the portable root duplicates catalog entries.

### Option 2: Manual Installation

```bash
# 1. Portable skills (Cursor, Pi, Grok, Antigravity 2.0)
mkdir -p ~/.agents/skills
cp -R skills/* ~/.agents/skills/

# 2. Antigravity IDE + CLI
cp rules/AGENTS.md ~/.gemini/GEMINI.md
mkdir -p ~/.gemini/config/skills ~/.gemini/antigravity-cli/skills
cp -R skills/* ~/.gemini/config/skills/
cp -R skills/* ~/.gemini/antigravity-cli/skills/

# 3. Cursor global rule (not a plain .md)
mkdir -p ~/.cursor/rules
# Write ~/.cursor/rules/agent-rules.mdc with:
#   ---
#   description: Global agent working style, safety, and verification rules.
#   alwaysApply: true
#   ---
#   <contents of rules/AGENTS.md>

# 4. Pi global instructions
mkdir -p ~/.pi/agent
cp rules/AGENTS.md ~/.pi/agent/AGENTS.md

# 5. Grok Build global instructions
mkdir -p ~/.grok
cp rules/AGENTS.md ~/.grok/AGENTS.md
```

Project-only (shared with the team, no home-dir writes):

```bash
mkdir -p .agents/skills
cp -R skills/* .agents/skills/
cp rules/AGENTS.md AGENTS.md
```

---

## Offline Packaging (No GitHub / Air-gapped)

To package skills and customizations for transfer to another computer without GitHub access:

### 1. Build Archives

Run the packaging script on your source machine:

```bash
chmod +x package.sh
./package.sh
```

This creates two tarballs in `dist/`:
- **`dist/skills.tar.gz`**: Standalone skills package (only skill folders).
- **`dist/agent-skills.tar.gz`**: Full offline suite including `skills/`, `rules/`, and `setup.sh`.

### 2. Deploy on Target Computer

#### Option A: Full Suite Setup (Recommended)
Transfer `agent-skills.tar.gz` (via USB, SCP, AirDrop, etc.) to the target machine:
```bash
tar -xzf agent-skills.tar.gz
cd agent-skills
./setup.sh
```

#### Option B: Skills Only (Google Antigravity Global)
Transfer `skills.tar.gz` to the target machine:
```bash
mkdir -p ~/.gemini/config/skills
tar -xzf skills.tar.gz -C ~/.gemini/config/skills
```

#### Option C: Skills Only (Per-Project / Workspace)
Extract directly into a repository root:
```bash
mkdir -p .agents/skills
tar -xzf skills.tar.gz -C .agents/skills
```

