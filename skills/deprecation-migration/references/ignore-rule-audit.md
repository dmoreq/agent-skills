# Auditing exclusion rules (`.gitignore` and friends)

The same method covers `.gitignore`, `.dockerignore`, `MANIFEST.in`, linter
`exclude`/`ignore` lists, and CI path filters: every entry silently decides what
some later action cannot see. Optimizing one means classifying each rule by
mechanism, never by how generic it looks.

## Procedure

1. **Snapshot behaviour before touching anything.** Pick ~25 representative
   paths — one per rule family, plus the paths the repository actually depends
   on — and record `git check-ignore -q <path>` for each. Write the map to a
   scratch file. The rewrite is judged only against this baseline.
2. **Measure each rule's hits.** For each pattern, count real matching files in
   the tree (`find ... -name '<pattern>'`) and whether any *tracked* file matches.
   A rule with zero hits in the working tree is a deletion candidate, not proof.
3. **Classify each zero-hit rule into one of three kinds** before deciding:
   - *Template noise* — never applied to this repository (`*.egg`, `*.cover`,
     `nosetests.xml`, `MANIFEST`). Safe to delete.
   - *Load-bearing, currently idle* — the artifact is absent right now but the
     directory holds tracked content it must not swallow. Keep.
   - *Real gap* — the artifact exists and is **not** ignored. Add.
4. **Re-run the baseline and diff it.** Every change of a path's ignore status
   must be one you intended. Any unexplained flip is a bug in the rewrite.
5. **Prove no tracked file became invisible:**
   ```bash
   git ls-files | git check-ignore --stdin --no-index
   ```
   Output must be empty. This is the only check that catches a rule silently
   hiding real work from every future diff and status call.
6. **Re-run the consumers of the ignore list.** A build that reads `MANIFEST.in`
   or a packaging config must still ship the same contents: build the artifact
   and list its entries. A wheel missing `artifacts/*.xz` is an ignore rewrite
   that broke releases.

## Traps

- **Check before you delete.** "This rule matches nothing" is a statement about
  the current tree, not about the rule. Ask what mechanism it guards.
  - A directory holding tracked modules plus a runtime store needs the store's
    rule: several tracked `*.py` sit next to an ignored `*.sqlite`. Deleting it
    stages a multi-MB database on the next tool run.
  - A subdirectory's own ignore file may repeat a root rule. Keep the root rule
    anyway when a checkout opens at the root; that is the case the root rule
    covers.
- **Anchor intentional directories.** `/.tmp/` scopes to the repo root;
  unanchored `.tmp/` also matches a nested `src/.tmp/`. Anchor the ones you mean
  to be root-only, and check with the baseline in step 1.
- **Distinguish environment-level protection from config.** A nested ignore file
  inside a cache directory (`__pycache__/`, `.pytest_cache/`) is written by the
  tool and does not make the root rule redundant.
- **Never drop build-artifact rules wholesale.** Wheels, sdists, and egg-info
  regenerate, but their rules also stop a stray `dist/` from being committed.
  Keep artifact rules; drop only ones naming a tool this repo does not use.
- **Adding `*.log`, `*.orig`, `*.rej`, `*.tmp`** is usually a real gap in a
  Python repo and costs nothing. Verify no tracked file matches first:
  `git ls-files | grep -E '\.(log|orig|rej|tmp)$'`.

## Reporting

State the rule count and status before and after and list the removals by
category, the additions, and the rules deliberately kept with the mechanism they
guard. Naming a kept rule as "not duplicate" with its reason stops the next
reader from deleting it again.
