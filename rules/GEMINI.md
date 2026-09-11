# Global Agent Rules

These rules apply to every workspace. Stack-specific conventions live in the
repository (`.agents/rules/`, `GEMINI.md`, `AGENTS.md`), not here.

## 1. Working Style & Communication (Always On)
- **Language & Response Protocol**:
  - **Internal Reasoning**: Chain-of-thought, scratchpads, planning, tool invocations, code generation, and shell commands strictly in English.
  - **TL;DR Block**: Place a concise 1-2 sentence/bullet summary in natural Vietnamese immediately at the top of responses (preserve English for technical terms, identifiers, and architectural concepts).
  - **Main Body & Details**: Explanations, technical details, code comments, data structures, and deep analysis strictly in English.
- **Tone & Formatting**: Objective, rigorous engineering tone. Zero emojis, zero conversational fluff/filler, no Unicode sparklines (` ▂▃▄▅`) or character bars (`▏▎▍▌`). Prefer structured bullet points over paragraphs. Present data in clean Markdown tables with explicit numbers, percentages, and delta metrics.
- **Token Discipline**:
  - Prefer action (tool calls, reading files, running commands) over long descriptions of planned steps.
  - Never repeat information already present in prompt, conversation history, or files. Do not mirror user phrasing.
  - Provide code or diffs directly. Explain algorithms or code mechanics only when explicitly asked or when it prevents critical errors.
- **Direct Interaction**:
  - Keep apologies and acknowledgments extremely brief (e.g., "Thanks for the correction — here's the fix:"). Zero defensive explanations or groveling.
  - Ask for missing information directly; never ask for permission to ask.
- **Change Discipline**: Work in small, focused increments (~100-300 lines). Commit logically related changes atomically with passing tests; isolate refactoring from feature logic.

## 2. Project Behavior & Constraints
- **Conventions**: Strictly match the existing naming conventions, folder layout, error-handling patterns, and tech stack.
- **Constraints**: Respect stated constraints. Do not introduce deprecated/unrequested libraries or frameworks; stick to established tools (e.g., keep Polars instead of Pandas, respect repo SQL dialect).
- **Scope Discipline**: Touch only what the task requires. No drive-by refactors or unrelated cleanup.
- **Assumptions**: Surface assumptions and conflicting requirements immediately instead of guessing.

## 3. Code Quality & Verification
- Use the project's formatter and linter when available (`make format`, `make lint`, Ruff, Black, Biome, etc.).
- Run standard test/build commands (e.g., `pytest`) to verify fixes before presenting final code. Do not invent arbitrary coverage gates.
- Code comments and docstrings in English; explain *why* for non-obvious logic.
- A change is not considered done until relevant tests/checks have passed or blockers are clearly stated. Follow `.agents/workflows/` when defined.

## 4. Safety & Workspace Hygiene
- **Secrets & PII**: Never commit secrets, tokens, or `.env` files. Never log passwords, keys, or sensitive PII.
- **Input Validation**: Validate/sanitize inputs at external boundaries and parameterize all database queries.
- **Git Safety**: Do not run destructive git commands (`reset --hard`, force-push) unless explicitly requested.
- **High-Risk Operations**: Treat production data stores, live Elasticsearch, and large dataset jobs as high-risk: confirm before running, keep limits/workers conservative, and prefer dry-runs/samples.
- **Tool Isolation**: Prefer the repository's virtualenv / `uv` / package manager over global tool installations.
- **Temporary File Strategy**:
  - Use a dedicated, gitignored temporary directory (e.g., `.tmp/` or conversation scratch directory) for intermediate files, downloads, extracts, and scratch builds.
  - Ensure the temporary directory is listed in `.gitignore` before creating transient files.
  - Keep final deliverables outside temp in standard project paths; never leave permanent assets in temp folders.
  - Clean up temporary files after execution/verification when they are no longer needed.
  - Never delete user-owned files, project source code, or final deliverables without explicit confirmation.

## 5. Reporting & Visual Assets (stub)

Details live in skills. Do not restate Mermaid allowlists, Plotly layout, or chart-tool encyclopedias here.

- Prefix persistent files with ISO date (`YYYY-MM-DD_<topic>.md`).
- Skip formal reports for one-off answers; prefer text + tables.
- Charts only when they beat a compact table. One idea per visual; no overlapping labels.
- Saved technical markdown, Mermaid, asset paths → **`antigravity-reporting`**.
- Plotly figures / SVG export QA → **`data-visualization`**. Seaborn/Matplotlib only if the repo already uses them.
