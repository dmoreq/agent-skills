# Optimizing a .gitignore without changing what is ignored

Apply the YAGNI ladder to ignore rules: a rule that matches nothing is speculative
config, and a rule that duplicates a nested `.gitignore` may still be load-bearing.
The hard part is that removing a dead rule and removing a live one look identical
until something gets staged.

## Procedure

1. **Snapshot behaviour first.** Enumerate representative paths that cover every rule,
   then record their ignore status to a file. Run this twice — before and after — and
   diff. This is the acceptance criterion, not the readable test.

```bash
# representative list: caches, artifacts, secrets, datasets, tracked fixtures, negations
for p in .ruff_cache/x data/x docs/reports/x.md pkg/artifacts/*.sqlite.xz .env; do
  printf '%-40s ' "$p"; git check-ignore -q "$p" && echo 1 || echo 0
done > /tmp/ignore_baseline
```

2. **Classify every rule by hit count, not by eye.** For each pattern, search the tree.
   Zero matches over the whole working tree is the candidate set. Keep the counts: the
   commit message needs "removed N rules that never match", and the user will ask which.
3. **Read the nested `.gitignore` files before calling a root rule duplicate.**
   `find . -name .gitignore -not -path './.git/*' -not -path '*/node_modules/*'`.
   A rule repeated from a subdirectory is *not* redundant: a checkout opened at the root
   stages that subdirectory's `node_modules` if only the nested file carries the rule.
   Verify with `git check-ignore -v <path>` — the output names the file and line that won.
4. **A rule can look dead because the directory is gone, not because it is wrong.**
   `pkg/signals/*.sqlite` may match nothing tracked right now, while that directory holds
   tracked Python modules and the rule guards a runtime store written beside them. Check
   what lives *in* the directory before deleting a rule scoped to it.
5. **Anchor directory rules.** `/.tmp/` and `.tmp/` differ: the unanchored form matches a
   same-named directory at any depth. Anchor local-scratch roots to the repository root.
6. **Prove no tracked file became invisible.** This is the only check that catches a
   wrong deletion:

```bash
git ls-files | git check-ignore --stdin --no-index    # must print nothing
```

7. **Prove packaging is unchanged** when the repo ships artifacts. Rules interact with
   build tooling: build a wheel and list its contents for the artifact directory that
   carries committed `.xz`/`.parquet` files. A rule that silently excluded them would pass
   every ignore-status check and still break the release.

## Pitfalls
- `git check-ignore -q` inside a `for` loop that walks tracked files reports hits for
  *ignored* paths; it cannot tell you whether a rule protects a tracked file. Use
  `--no-index` with `--stdin` for that.
- Adding a `.log`/`.orig`/`.rej`/`.tmp` family is usually a real gap, not noise — check
  whether stray editor/merge residue is currently visible as untracked before dismissing it.
- `.pyre/` and `.pytype/` are template residue when the project runs `.pyright/`.
  Confirm the directory name the tool actually writes instead of keeping both.
- Do not add `/scripts/` or another source directory to `.gitignore` to "unclutter"
  `git status`: on a tracked directory the rule does nothing, and the correct action
  (untracking via `git rm -r --cached`) is a deletion from the index that must be audited
  against a clean `git archive HEAD` clone first (see **deprecation-migration**).
