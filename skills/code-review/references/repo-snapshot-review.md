# Reviewing an unpacked repo snapshot

Use when the code under review arrives as an archive, a fresh clone, or a colleague's handoff — no PR, no diff to anchor on, and the README may be the only statement of intent. The deliverable is a working artifact plus evidence, not a reading of the source.

## 1. Establish provenance before reading code

1. Extract to a scratch location; if the archive is a `.tar.xz` holding `.git`, extract it whole rather than unpacking files selectively — `tar -tJf <file> | grep -v '/\.git/' | wc -l` tells you how much is real content versus history.
2. In the extracted tree: `git log -1 --format='%H %ad %s' --date=iso`, `git rev-list --count HEAD`, `git remote -v`, and `git status --short`.
3. Classify the working tree into three buckets and report them separately:
   - **committed** — what upstream actually ships,
   - **dirty edits** — uncommitted source changes that carry real work,
   - **untracked artifacts** — data files, `.idea/`, build outputs.
4. A large `git status` of `D</code>` deletions plus `AM` additions on a recently touched tree means somebody rewrote the project and never committed it. That changes the review: you now have two candidate products and must evaluate both.
5. Check `git reflog` and `git stash list` when files look deleted. A single `clone:` entry and an empty stash list means the deletions exist only in the working tree and are easy to recover.

Report the last-commit date honestly. A repo whose only source commits are years old, with 2022-era working-tree edits, is a research snapshot, not a maintained library — say so in the summary rather than implying currency.

## 2. Build both sides before judging either

When committed and working-tree versions disagree, build both into separate output directories and run the same measurement on each.

```bash
mkdir -p /tmp/x-headsrc && git archive HEAD src | tar -x -C /tmp/x-headsrc
javac -encoding UTF-8 -d /tmp/x-head $(find /tmp/x-headsrc/src -name '*.java')
```

- Compose the classpath explicitly; never inherit a stale `bin/` directory that may predate the source (confirm the committed `.class` files are actually stale by checking a method list: `javap -p <class>`).
- For the committed data files, `git show HEAD:path/to/data > /tmp/.../data` — the working tree often has replacements under new names.
- Run the project's own benchmark entry point on each build and keep both result lines.

The version that reproduces the README number is the baseline. A rewrite that scores worse is a regression finding with a number attached, not a stylistic observation.

## 3. Reproduce, then dispute

A README performance claim is a hypothesis with a specified harness.

- Run the exact command the README shows, from the exact working directory it assumes.
- Record whether it succeeded, the accuracy/speed figures, and the failure mode if it did not.
- **A claim that reproduces is not automatically the claim about the shipped code.** State which build produced it. Reproducing 96.52% on the committed build while the working tree scores 92.29% means the README is accurate about history and inaccurate about the tree the user received — report both numbers in one table.
- If the documented harness cannot run as shipped (stale `.classpath`/output-dir mapping, missing files, relative paths), reassembling the inputs by hand is legitimate for measurement — but the inability to run as shipped is itself a finding. Do not silently fix the environment and present the number without noting the surgery.
- Sanity-check the denominator. Count sentences and words with an independent script (`re.split` over the same separators, `len(s.split())`) instead of trusting the grader's own `All:` counter; a grader that skips mismatched sentences can under-count and inflate accuracy.

## 4. Probe the documented API surface

The README is a contract. Resolve every advertised entry point against the compiled artifact:

- `getMethod` via reflection, or a small caller compiled against the built classes, per advertised signature.
- Report a documented method absent from the artifact as **Critical**.
- Read the README snippets as code: a bare `LinkedHashMap<String, Double> = ...` with no variable name, a wrong return type, or a constructor argument the code cannot accept is a documentation defect worth a line each.
- Run a handful of literal README examples. They are the cheapest functional test that exists and they either work or they do not.

## 5. Reviewing a declarative skill bundle

For a ZIP of instruction-only skills:
1. Inspect the archive manifest and reject absolute paths, `..` traversal, and symlinks before extracting to scratch. Count skill files and read every `SKILL.md` plus install instructions; do not infer coverage from the README.
2. Compare the archive's actual directory prefix with its documented install destination and the platform's documented discovery layout. Test discovery with the target CLI when available; label an untested layout risk as unverified, not a reproduced failure.
3. Check each skill's declared triggers, required tools, action boundaries, and verification criteria. Flag conflicting read/write approval rules across skills, especially when a summary request would create drafts, tasks, or external records.
4. Verify absolute model, SDK, deprecation, and API claims against current primary documentation. Distinguish a documented contradiction from an unverified attribution; check API feature gaps and default retention before recommending a migration.
5. Report findings with skill path and line range, concrete failure scenario, smallest correction, and evidence status. Do not run code tests when the bundle has no executable files, and do not install reviewed skills merely to inspect them.

## 6. Verifying claims and resolution paths

- A scan's conclusion is only as wide as its pattern. Before reporting "0 references" / "clean", state the exact scope searched and sweep once from the repo root (`git grep`) as a cross-check.
- When a sweep reports hits, classify each before escalating: names in regex literals, comments explaining removals, or substrings (`optional`, `optimus`) are not live references. Report accurate findings ("0 dangling live references; N benign mentions").
- When a contract states "every named X must be reachable/loadable", prove reachability with the loader's real resolution path, never a flat probe. Enumerate discovery roots from the loader/config, search recursively, and invoke the loader on a sample.

## 5. Boundary probes for text/DSP-style pipelines

For anything that maps strings to strings, a handful of adversarial inputs separate working code from plausible code:

| Input class | What it exposes |
|---|---|
| Out-of-vocabulary token beside an in-vocabulary neighbour | Whether per-token candidate sets are preserved, or offsets/case are re-mapped blindly |
| Separator-only or blank segment (`,,` or `\n\n`) | Index misalignment between input split and output split |
| Punctuation not in the split set (`(` `)`) | Characters silently glued to or dropped from a token |
| Total garbage (`qwrtyp zxcvbn`) | Whether the model hallucinates structure where none exists |
| Upper case input spanning non-ASCII | Whether case restoration is per-character or per-token |

Compare every probe across both builds. A case the old code gets right and the new code gets wrong is the regression's root cause; quote the exact input and both outputs.

## 6. Read for defects the compiler accepts

Java- and Go-style codebases silently no-op where Python would raise. Look for:

- `catch (IOException e) { }` with an empty body — a missing data file becomes an empty model and nonsense output with no warning.
- Character-index re-mapping (`output.charAt(i)` driven by `input.charAt(i)`) with no length guard — an unchecked `StringIndexOutOfBoundsException` waiting for any length-changing transformation.
- Class fields populated only in one constructor branch (`firstGramFrequency` when `isOneGram`), then read unconditionally.
- `line.split(sep)` repeated on the same line inside a large-file parse loop.
- Dead utility classes referenced by nothing — confirm with a repo-wide grep before listing them.
- Deprecated API use (`BigDecimal.ROUND_HALF_UP`, `new Date().getTime()`), stray `;;`, unused imports.

## 7. Report shape

- Lead with what the thing is (language, size, data, last real commit, upstream URL) in a compact table.
- Follow with one measurement table comparing every build you actually ran: correct/all, accuracy, speed.
- Then blocking defects ordered by what stops a user from succeeding, then smaller issues, then a short assessment naming what to do first.
- State clearly that you changed nothing in the reviewed tree, and confirm with `git status` being unchanged.
- Install and disclose any toolchain you had to add to run the code (a JDK, a compiler) rather than presenting results as if the environment was already capable.
