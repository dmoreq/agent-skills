# Antigravity Customizations

A curated, token-efficient collection of **Global Agent Rules** and **Custom Skills** designed for the **Google Antigravity**, **Cursor**, **Pi**, and **Grok** coding assistant environments.

---

## Repository Structure

```
antigravity-customizations/
├── rules/
│   └── GEMINI.md                    # Global agent behavioral directives & standards
├── skills/
│   ├── algorithm-optimization/      # Systematic KPI & algorithm improvement loop
│   ├── antigravity-reporting/       # Technical reporting, benchmarks & 2-tier visualization
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
│   ├── python-patterns/             # Pragmatic architecture, framework choice & typing principles
│   ├── python-performance/          # Profile-driven performance optimization
│   ├── python-pro/                  # Modern Python 3.12+ engineering & legacy version handling
│   ├── python-testing/              # Testing strategies with pytest, fixtures & TDD
│   ├── rust-async-patterns/         # Production async Rust patterns with Tokio, channels & cancellation
│   ├── rust-pro/                    # Modern Rust 2024+ engineering, memory safety & performance
│   └── tech-research/               # SOTA survey, benchmark comparison & technical trade-offs
├── setup.sh                         # Unified multi-agent setup script (Antigravity, Cursor, Pi)
└── README.md
```

---

## Skills Catalog

| Skill Name | Purpose |
| :--- | :--- |
| **`algorithm-optimization`** | Systematic workflow to optimize algorithms/processes against target metrics while guarding healthy cases. |
| **`antigravity-reporting`** | Clean technical reports, benchmarks, and Tier 1 (Mermaid) / Tier 2 (Vector SVG) visualizations. |
| **`tech-research`** | SOTA methods, benchmark evaluation, and conditional recommendations before implementation. |
| **`data-science`** | Statistical modeling, machine learning, A/B testing, exploratory analysis, and causal inference. |
| **`data-storytelling`** | Turning quantitative analytics into decision-focused stories for stakeholders. |
| **`data-visualization`** | Plotly-first clean visual creation, SVG export, text density hygiene, and anti-overlap QA. |
| **`plotly-dash`** | Production-grade Plotly Dash apps with modular layouts, disciplined callbacks, state hygiene & performance. |
| **`deprecation-migration`** | Safely sunset, replace, and migrate legacy APIs/systems using Strangler, Adapter, and Feature Flags. |
| **`doubt-driven-development`** | Adversarial review to stress-test high-risk decisions and uncover unstated assumptions. |
| **`python-pro`** | Idiomatic Python 3.12+ development, strong typing, `uv`, `ruff`, and backward compatibility. |
| **`python-patterns`** | Architectural decision-making: async vs sync, framework choice, and project structure. |
| **`python-concurrency`** | Concurrency models: `asyncio` for I/O, `ThreadPool` for blocking I/O, `ProcessPool` for CPU. |
| **`python-performance`** | Measure-first, profile-driven optimization with `cProfile`, `py-spy`, and memory profilers. |
| **`python-testing`** | Pytest strategies, focused fixtures, mocking, and robust test suites. |
| **`pyo3-maturin`** | High-performance Rust native extensions with PyO3 and Maturin for CPU-bound hotspots. |
| **`rust-pro`** | Production-grade Rust (Edition 2024+): ownership, type system, performance, systems code, and idioms. |
| **`rust-async-patterns`** | Production async Rust patterns with Tokio: structured concurrency, channels, cancellation, and backpressure. |
| **`code-review`** | Systematic multi-axis review for Python & Rust (correctness, safety, performance, style). Mandatory quality gate. |
| **`code-simplification`** | Safe refactoring to improve readability and reduce nesting without changing behavior. |
| **`context7-mcp`** | Fetching up-to-date documentation and code references via Context7 MCP. |

---

## Skill Relationship Map (Optimized)

### Core Principles
- Hầu hết quan hệ là **optional handoff** (chỉ kích hoạt khi thật sự có điều kiện).
- Chỉ duy trì **3 quan hệ cứng (Hard Invariants)** cốt lõi.
- **Không bao giờ chain dài theo mặc định** để tối ưu hóa context và token.

### 1. Bảng quan hệ chuẩn

| Nhóm | Skill | Nhận từ (Input) | Chuyển đến (Output) | Mức độ |
| :--- | :--- | :--- | :--- | :--- |
| **Discovery** | **`context7-mcp`** | Nhu cầu docs/API cụ thể, version-sensitive | `python-pro`, `python-concurrency`, `tech-research`, `data-science` | Optional |
| **Discovery** | **`tech-research`** | Nhu cầu SOTA, alternatives, trade-offs kỹ thuật | `doubt-driven-development` (khi chốt quyết định); `deprecation-migration` (thay hệ thống cũ); `antigravity-reporting` (formal report); `algorithm-optimization` (validate trên data thật) | Optional |
| **Decision** | **`doubt-driven-development`** | Quyết định non-trivial từ `tech-research`, `python-patterns`, architecture / cutover decisions | `python-testing` (chốt risk thành regression test); `tech-research` (nếu thiếu alternatives); implementation path rồi qua `code-review` | Optional, có điều kiện |
| **Migration** | **`deprecation-migration`** | Legacy/zombie code từ `code-review`; replacement options từ `tech-research` | `python-testing` (verify tương thích); `code-simplification` (dọn shim/adapter thừa sau cùng) | Optional |
| **Analysis** | **`data-science`** | Dữ liệu thô, EDA, modeling, thống kê, A/B | `data-visualization` (vẽ chart); `data-storytelling` (narrative); `algorithm-optimization` (tối ưu KPI); `antigravity-reporting` (formal report) | Optional / Required* |
| **Visualization** | **`data-visualization`** | Metric/insight từ `data-science`; before/after từ `algorithm-optimization`; benchmark từ `python-performance` | `plotly-dash`, `antigravity-reporting`, `data-storytelling` | Optional |
| **Dashboard** | **`plotly-dash`** | Plotly figures từ `data-visualization`; pipeline/metrics từ `data-science`; docs từ `context7-mcp` | `python-testing` (test callback/integration); `code-review` (merge gate); `python-performance` (nếu bottleneck) | Optional |
| **Narrative** | **`data-storytelling`** | Insight đã validate từ `data-science` | Dùng chart từ `data-visualization`; nhúng vào `antigravity-reporting` | **Required input from `data-science`** |
| **Reporting** | **`antigravity-reporting`** | Kết quả formal từ `tech-research`, `data-science`, `algorithm-optimization` | Báo cáo kỹ thuật hoàn chỉnh kèm visual Tier-1/Tier-2 | Optional presentation layer |
| **Architecture** | **`python-patterns`** | Nhu cầu chọn framework, structure, async vs sync | `python-pro` (để implement); `python-concurrency` (chọn concurrency model); ADR ngắn (khi chốt kiến trúc) | Optional |
| **Implementation** | **`python-pro`** | Design từ `python-patterns` hoặc requirement tính năng | `python-testing` (bảo vệ behavior); `context7-mcp` (tra cứu docs); `code-review` (trước khi merge) | **Required on merge path** |
| **Concurrency** | **`python-concurrency`** | Lựa chọn concurrency từ `python-patterns` hoặc bottleneck I/O vs CPU | `python-performance` (đo lường thực tế); `python-testing` (async/parallel safety) | Optional |
| **Performance** | **`python-performance`** | Bottleneck runtime/memory/I/O từ implementation hoặc concurrency | `pyo3-maturin` (nếu là CPU-bound hotspot cần native Rust); `python-concurrency` (nếu đúng loại bottleneck); `tech-research` (cần approach mới); `algorithm-optimization` (nếu là quality/process KPI) | Optional |
| **Native Extension** | **`pyo3-maturin`** | CPU-bound bottleneck đã profile từ `python-performance` | `python-testing` (parity và regression test); `code-review` (trước khi merge) | Optional |
| **Rust Dev** | **`rust-pro`** | Nhu cầu phát triển Rust service/crate hoặc tối ưu hóa hiệu năng | `rust-async-patterns` (khi cần async); `pyo3-maturin` (nếu làm Python extension); `code-review` (trước khi merge) | Optional |
| **Rust Concurrency** | **`rust-async-patterns`** | Tokio, channels, streams, task coordination trong Rust | `rust-pro` (để implement); `code-review` (trước khi merge) | Optional |
| **Optimization** | **`algorithm-optimization`** | KPI/process kém trên data thật; candidate từ `tech-research`; chẩn đoán từ `data-science` | `data-visualization` (before/after chart); `antigravity-reporting` (báo cáo); `python-performance` (nếu lộ runtime bottleneck) | Optional |
| **Testing** | **`python-testing`** | Behavior change từ `python-pro`; parity từ `pyo3-maturin`; risk từ `doubt-driven`; migration từ `deprecation-migration`; cleanup từ `code-simplification` | Safety net bắt buộc trước `code-review` | **Required for behavior changes** |
| **Cleanup** | **`code-simplification`** | Complexity, deep nesting, duplication từ `code-review` hoặc sau feature complete | Dựa trên `python-testing` giữ nguyên behavior; đưa lại `code-review` | Optional |
| **QA Gate** | **`code-review`** | PR/diff từ `python-pro`, `pyo3-maturin`, `code-simplification`, `deprecation-migration`, hoặc agent khác | `python-pro` (sửa code); `code-simplification` (giảm complexity); `deprecation-migration` (sunset legacy); merge khi đạt chuẩn | **Required on merge path** |

---

### 2. Ba quan hệ cứng duy nhất (Hard Invariants)

1. **`data-storytelling`** bắt buộc phải dựa trên insight đã được validate từ **`data-science`** (không tự bịa số liệu).
2. **Mọi merge path vào main** bắt buộc phải qua cổng kiểm duyệt **`code-review`**.
3. **Mọi thay đổi hành vi logic (Behavior change)** bắt buộc phải có kiểm thử từ **`python-testing`**.

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
    └─ formal write-up ─► antigravity-reporting

doubt-driven-development
    ├─ missing alternatives ─► tech-research
    ├─ actionable risks ─► python-testing
    └─ stable decision ─► implementation ─► code-review

data-science
    ├─ charts ─► data-visualization
    ├─ narrative ─► data-storytelling
    ├─ KPI loop ─► algorithm-optimization
    └─ formal report ─► antigravity-reporting

algorithm-optimization
    ├─ visuals ─► data-visualization
    ├─ report ─► antigravity-reporting
    └─ runtime issue found ─► python-performance

python-patterns
    ├─ implement ─► python-pro
    └─ concurrency choice ─► python-concurrency

python-pro
    ├─ docs ─► context7-mcp
    ├─ tests ─► python-testing
    └─ merge gate ─► code-review

python-concurrency ◄──► python-performance
                            └─ CPU hotspot ─► pyo3-maturin ─► python-testing ─► code-review

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
| Soạn thảo báo cáo kỹ thuật formal (Mermaid / SVG) | **`antigravity-reporting`** |
| Chọn framework, cấu trúc module, thiết kế async/sync | **`python-patterns`** |
| Lập trình tính năng bằng Python 3.12+ | **`python-pro`** |
| Thiết kế mô hình Async / Multi-thread / Multi-process | **`python-concurrency`** |
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

- ❌ **Bật `antigravity-reporting` cho câu trả lời ngắn trung gian**: Gây lãng phí token không cần thiết.
- ❌ **Bật `doubt-driven-development` cho mọi khảo sát research thông thường**: Chỉ bật khi kết quả chuẩn bị khóa thành quyết định triển khai.
- ❌ **Dùng `python-performance` cho accuracy / confidence KPI**: Runtime bottleneck và algorithmic quality KPI là 2 bài toán khác nhau.
- ❌ **Dùng `algorithm-optimization` cho pure runtime tuning**: Cần dùng `python-performance` có profiling thực tế.
- ❌ **`data-storytelling` tự tạo số liệu/insight**: Luôn phải nhận insight đã được chứng thực từ `data-science`.
- ❌ **Merge PR khi chưa qua `code-review`**: Bỏ qua cổng kiểm soát an toàn 5 trục.
- ❌ **Chain bắt buộc Research $\rightarrow$ Optimize $\rightarrow$ Report cho mọi request**: Chỉ kích hoạt skill phù hợp trực tiếp với intent của người dùng.

---

## Installation & Setup

### Option 1: Automatic Setup Script (Recommended)

Run `setup.sh` to install or sync across **Antigravity**, **Cursor**, **Pi**, and **Grok**:

```bash
chmod +x setup.sh
./setup.sh
```

### Option 2: Manual Installation

1. **Global Rules**:
   ```bash
   cp rules/GEMINI.md ~/.gemini/GEMINI.md
   ```

2. **Global Skills**:
   ```bash
   mkdir -p ~/.gemini/config/skills
   cp -R skills/* ~/.gemini/config/skills/
   ```
