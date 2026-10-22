# Dead-Code, Compatibility Shim, and Git Untracking Audits

Load this reference when proving whether legacy symbols, `**kwargs` shims, duplicate data artifacts, or git-tracked directories are safe to delete.

## 1. Runtime Evidence Rules for Declaring Code Dead

1. **Whole-Repo & Sibling-Repo Search**:
   - "Nothing references it" means zero callers across the entire repository and any sibling repositories that import the package. If a module slated for deletion still houses a helper imported by a sibling module, move the helper to a neutral owner first.
2. **Verify Unimportable Scripts by Execution (`importlib`)**:
   - Static AST / `griffe` scans miss lazy imports inside functions or dynamic attributes. Load candidate modules via `importlib.util.spec_from_file_location` + `exec_module` to verify importability at runtime.
3. **Separate Facade Removal from Submodule Removal**:
   - Dropping an alias from `pkg/__init__.py` while `pkg/sub.py` still defines and exports it is a **removed from facade** change, not **removed from package**. Report both columns explicitly so changelog entries do not contradict passing submodule imports.
4. **Count Real Call Sites Separately from Registry Entries**:
   - An entry in `__all__`, `_DEPRECATED_NAMES`, or a README diagram keeps the external consumer channel open even if internal call sites equal zero. Audit downstream backends and UI repos before removing registered aliases ahead of a major release.
5. **Detect Pass-Through `**kwargs` & Unused Parameter Decoys**:
   - A constructor with `def __init__(self, ..., **legacy_kwargs)` silently turns renamed or misspelled arguments into no-ops. Probe it by passing a nonsense keyword and a superseded keyword and inspecting the resulting attributes.
   - Check parameters kept "for compatibility" with `inspect.getsource(fn)`: if the parameter name never appears outside the docstring and no external caller passes it positionally, it is a dead decoy knob.
6. **Guard Against Self-Comparing Parity Tests**:
   - Two imports of the same module under different aliases (`import pkg.v5 as legacy` beside `import pkg.v5 as current`) produce `legacy is current == True` and a parity suite with zero real coverage. Always assert `old_target is not new_target` at the top of any parity test.

## 2. Auditing Duplicate Data Artifacts & Untracking Git Directories

1. **Full Content Hash Comparison for Data Stores**:
   - Never delete a duplicate data store based on equal row counts alone. Compare full key/value sets and record SHA-256 hashes against the canonical store before removal.
2. **Untracking a Directory (`git rm -r --cached`) Is an Index Deletion**:
   - Adding an already-tracked directory to `.gitignore` does nothing until `git rm -r --cached <dir>` removes it from the index. Because the files remain in the local working copy, local `pytest` runs stay green while a fresh clone breaks.
   - Always measure what a fresh clone loses before untracking:
     ```bash
     mkdir -p /tmp/clone_probe
     git archive HEAD | tar -x -C /tmp/clone_probe
     rm -rf /tmp/clone_probe/<dir_to_untrack>
     pytest /tmp/clone_probe --collect-only
     ```
   - Report collected vs. expected test counts and convert hard fixture assertions (`assert DATA.is_file()`) to `pytest.skip(...)` or `conftest.py` `collect_ignore` rules before untracking.
3. **Low-to-High Risk Cleanup Batches**:
   - Delete in reversible batches: (1) build caches, (2) scratch outputs whose conclusions are already recorded, (3) verified duplicate stores—and never delete raw capture/training priors required to rebuild production artifacts.
   - Gate every cleanup batch on `git status --porcelain` before and after so tracked files are never deleted accidentally.
