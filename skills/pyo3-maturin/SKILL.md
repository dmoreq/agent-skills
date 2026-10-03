---
name: pyo3-maturin
description: >-
  Build Python native extensions with PyO3 and Maturin for a profiled CPU-bound hotspot.
  Not for I/O-bound work or unmeasured rewrites.
risk: safe
source: local
date_added: "2026-08-23"
---

# PyO3 + Maturin Skill

Python modules backed by Rust, only after a measured CPU hotspot.

## When to Use
- Creating or modifying a Python module backed by Rust
- Speeding up a **confirmed** CPU-bound hotspot
- Packaging Rust as a Python extension
- Debugging Maturin/PyO3 develop, build, or import issues

## When Not to Use
- I/O-bound bottlenecks
- No profiling evidence
- NumPy / Polars / SciPy already solve it
- Pure Python feature work

## Related Skills
- Use **python-performance** first to confirm a CPU-bound hotspot.
- Use **python-testing** for parity and regression tests.
- Use **doubt-driven-development** when this is the first native module in a pure-Python repo. Rust API/unsafe: **rust-pro**.

## Decision Gate
All must be true:
1. Hotspot profiled and CPU-bound
2. Pure compute or needs low-level control (memory, SIMD, threads)
3. Expected speedup justifies build/maintenance cost
4. Python API boundary stays small and stable

Prefer extracting a hot function over rewriting a module.

## Recommended Stack
- PyO3 (0.21+ with `Bound<'py, T>` API), Maturin (`maturin develop`, `maturin build`)
- `pyproject.toml` + `Cargo.toml`
- `uv` for the Python env

## Mixed Layout
```text
my-project/
  pyproject.toml        # [build-system] requires = ["maturin>=1.0"]
  Cargo.toml            # crate-type = ["cdylib"]
  python/my_project/__init__.py
  src/lib.rs            # #[pymodule]
```

- `[tool.maturin] python-source = "python"`
- Native submodule e.g. `my_project._native`
- Ignore `*.so`, `*.pyd`, `target/`

## GIL & Memory Transfer (PyO3 0.21+)
1. **Modern Bound API**: Use `Bound<'py, T>` smart pointers (e.g. `Bound<'_, PyList>`, `Bound<'_, PyDict>`) for compile-time GIL safety.
2. **Zero-Copy Exchange**:
   - For arrays: use `numpy` crate with `PyReadonlyArray` / `PyReadwriteArray` to access memory directly without allocation.
   - For binary data: use `PyBuffer<u8>` to inspect contiguous memory without cloning.
   - For tabular queries: use `pyo3-polars` for native Polars expression plugins executed without GIL overhead.
3. **GIL Release**:
   - `py.allow_threads(...)` for pure compute.
   - Run parallel iterators (Rayon) only **after** detaching GIL via `allow_threads`.
4. **Return Types**: Return `PyResult<T>` mapped to standard Python exceptions (`PyValueError`, `PyRuntimeError`).

Never hold the GIL in long CPU loops. Minimize boundary crossings; process bulk data.

## Maturin Workflow
1. Profile (`python-performance`)
2. Minimal interface
3. `maturin develop` in the active venv
4. `pytest` parity
5. Benchmark with `maturin develop --release`
6. Commit only after measurable gains

## Troubleshooting
- **ImportError: symbol not found**: `#[pymodule]` name matches the `.so`/`.pyd`
- **Slow:** not a `--release` build
- **Rayon deadlock:** `allow_threads` before parallel iterators
- **Wheels:** `--zig` or `abi3` as needed

## Final Checklist
- [ ] CPU-bound hotspot profiled
- [ ] Small stable Python ↔ Rust boundary
- [ ] Mixed layout
- [ ] GIL released during compute
- [ ] `PyResult<T>` with meaningful exceptions
- [ ] `maturin develop --release` + pytest pass
- [ ] Build artifacts gitignored
