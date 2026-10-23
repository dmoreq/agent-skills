# Turning an internal package into a standalone distribution

Use when a package lives inside a monorepo, a sibling checkout, or a private index and
must install on its own. Work in this order: dependency truth, package data, metadata,
artifact proof.

## 1. Dependency truth

Read what the code imports, then compare against `pyproject.toml`.

```bash
grep -rhoE "^(from|import) [a-zA-Z_][a-zA-Z0-9_]*" package/ --include=*.py \
  | awk '{print $2}' | sort | uniq -c | sort -rn
```

For each declared dependency, confirm at least one import site; for each third-party
import, confirm a declaration. Watch for packages imported only transitively today
(`pyahocorasick` via another library) — declare them, because a transitive dep can
disappear in a minor release.

Then check for swallowed imports that hide a requirement:

```bash
grep -rn "except ImportError" package/ --include=*.py
```

A function that returns `{}` or `[]` when a data library is missing is a required
dependency in disguise. Promote it, or fail loudly.

## 2. Package data

Ships only files that are committed and byte-identical on every machine.

```toml
[tool.setuptools.package-data]
pkg = ["py.typed", "artifacts/*.xz", "artifacts/*.parquet"]

[tool.setuptools.exclude-package-data]
pkg = ["artifacts/*.sqlite", "artifacts/*.sqlite-*", "**/__pycache__/*", "**/*.pyc"]
```

Rule: enumerate extensions. A bare `artifacts/*` sweeps in whatever the last local run
produced, so two builds of one commit differ and the wheel size changes with test
history. Unpack compressed sources at import (`lzma` into the package dir) rather than
committing the inflated form.

## 3. Metadata and layout

```toml
[build-system]
requires = ["setuptools>=77", "wheel"]
build-backend = "setuptools.build_meta"

[project]
name = "dist-name"            # may differ from the import package
license = "MIT"               # PEP 639: expression, not a table
license-files = ["LICENSE"]
dynamic = ["version"]

[tool.setuptools.dynamic]
version = { attr = "pkg.__version__" }

[tool.setuptools.packages.find]
include = ["pkg", "pkg.*"]
exclude = ["tests*", "scripts*", "data*", "docs*"]
```

`MANIFEST.in` decides the sdist: include `LICENSE`, `README`, `CHANGELOG`, docs and
tests if downstream packagers need them; `prune` datasets, internal reports, UI trees,
and scratch directories. The wheel is decided by `packages.find` and `package-data`
only.

## 4. Prove the artifact

```bash
python -m build --outdir .tmp/dist
python - <<'PY'
import zipfile, glob
w = glob.glob('.tmp/dist/*.whl')[0]
z = zipfile.ZipFile(w)
print(z.read([n for n in z.namelist() if n.endswith('METADATA')][0]).decode()[:400])
print(sorted({n.split('/')[0] for n in z.namelist()}))
PY
```

| Check | Failure it catches |
| --- | --- |
| `top_level.txt` lists only the package | A sibling package leaked in |
| No `*.sqlite`, `__pycache__`, `tests/` | Package-data glob too wide |
| `Requires-Dist` matches the import audit | Undeclared or unused dependency |
| Wheel size stable across two builds | Untracked local file swept in |
| `dist-info/licenses/LICENSE` present | Missing license file in metadata |

## 5. Install gate

Keep a script the release flow can run, not a manual checklist:

1. build the wheel (and the private dependencies as wheels, if they are path-resolved)
2. create a throwaway venv
3. `pip install --find-links <dist> <wheel>`
4. import the public API and assert the shipped data loaded
5. delete the venv

```bash
make verify-install     # uv run python scripts/verify_install.py
```

`--find-links` with locally built wheels is how a package with a private dependency is
proven installable before that dependency is published.

## Pitfalls

- Setting both `[project] license-files` and `[tool.setuptools] license-files` fails the
build with `'project.license-files' is defined already`. Keep the PEP 639 one.
- `[tool.setuptools.dynamic] version = {attr = ...}` works without importing the module
only while the version is a plain literal assignment, not a computed value.
- A path-resolved dependency (`[tool.uv.sources] dep = { path = "../dep" }`) is a
development convenience. Consumers cannot resolve it; the dependency must be published
or vendored. Prove the choice by installing the wheel in a venv with no sibling checkout.
- A distribution name that collides on the index forces a rename of the *distribution*,
not the import package. Keep imports stable, document the mapping once in the README.
- Removing an unused dependency can break a test that needs it indirectly (an HTTP test
client needing `httpx`); put it in the test extra, not back into core.
- A test that asserts the version as a literal makes every release a two-file edit.
Compare against `importlib.metadata.version(<dist>)` instead.
