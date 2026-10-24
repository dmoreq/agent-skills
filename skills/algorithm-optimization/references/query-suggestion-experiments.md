# Query/prefix suggestion experiments (autocomplete pre-submission)

Use when the proposal is autocomplete/suggest/typeahead over submitted search logs, and the input
data has no keystroke, impression, or acceptance columns. This is the offline-experiment analogue
of `search-ranking-evaluation.md`: there the gold label is a click; here it is a complete query
string nothing in the log observed being typed.

## 1. Establish what the log actually observed before designing a metric

1. Read the Parquet schema and refuse to assume keystrokes: a column set of
   `day, event_time, id, user_id, input_text, lat_lon, target, poi_ids, selected_poi` is one row per
   **submitted** search. There is no prefix, no suggestion shown, no acceptance.
2. Measure the distribution that decides the product scope, not the one that is convenient:
   submitted-length quantiles, share of 1–3 character submissions, share carrying a digit (house
   number), mean/max length, and distinct-key counts with support buckets (`support >= 2`, `>= 3`,
   singletons, and the event share covered by repeated keys).
3. Compute the **real transition rate** on consecutive same-user events instead of asserting that
   users type incrementally: sort by `(user_id, event_time)`, count pairs where the next normalized
   text `startswith` the previous one, overall and inside a 30-minute window. Then split by the
   previous text's length bucket. This is the only offline evidence that continuation is the user's
   intent, and it usually concentrates sharply in short inputs — report both numbers before
   scoping the feature to short input.
4. Never let a synthetic prefix acquire the status of an observed keystroke. Say "counterfactual"
   and "synthetic prefix at code-point boundary" in every table header that contains one.

## 2. Candidate sources and their traps

- **Click prior / signal stores are not lexicons.** A shipped `signals.sqlite` holding only
  `(query_hash INTEGER, poi_id, clicks)` with 100k rows cannot seed suggestions: the query text is
  unrecoverable. Verify the schema before planning to reuse a production store for a new purpose.
- **Broad prefixes are the dominating cost, not the tail.** Count distinct keys per 1-, 2-, and
  3-character prefix and print the largest buckets. A single common 3-character prefix can hold tens
  of thousands of keys; ranking the whole match set per keystroke is unshippable by construction,
  so cap expansion first and cache short-prefix top-K.
- **Accent folding loses display information.** Comparing distinct raw keys with distinct folded keys
  quantifies the collision rate. Keep three keys per string — `display` (original casing and accents),
  `exact` (NFC, lowercased), `folded` (diacritics removed, `đ -> d`) — and version the normalizer.
  Reimplement the fold in ~15 lines instead of importing the package under evaluation; a POC that
  imports the package it is auditing cannot report an independent result.
- **Catalog duplicates are ambiguous, not removable.** A name repeated under several
  `(status, type)` combos is common; the fix is an eligibility rule (active status required, and an
  inactive twin must not veto a key that also has an active row), never a blind duplicate delete.
  Split place titles from address labels with separate word caps and separate budgets; address keys
  are the majority of distinct strings and will bury named venues without a penalty.
- **Private strings hide inside valid strings.** Phone numbers and emails are appended to real
  addresses. Strip the span and keep the residual key; dropping whole rows loses genuine intents.
  Pin every observed pattern in a test.

## 3. Metric definitions that survive review

- **A prefix-recall metric needs a non-empty baseline.** "Improve Recall@5 over A1" is vacuous when
  A1 has no candidates for most cases; a 0 → 0.05 jump looks like a win. For a backoff/suffix arm,
  gate on **non-empty-candidate share** (old vs old+new) with a clustered bootstrap CI, not on recall
  over an empty set.
- **Harness equivalence is a gate, not a sanity check —— and it must compare lists, not aggregates.**
  Read the index artifact with its canonical reader and with a deliberately naive independent scorer
  (linear `startswith` scan, sort by `(-score, key)`) and require **identical per-case result lists**.
  Comparing only Success@5 hides the failure that matters: a bounded expansion window cuts by key
  order, not by score, so a broad prefix (`con`, `so`, `nha`) returns alphabetically-first garbage
  from the fast path while the full scan returns the real top hits. Blended over a cohort whose
  majority are long prefixes that never hit the cap, the two aggregates can agree to four decimals.
  If aggregates differ at all, ordering or gold comparison is broken — stop.
- **A cap on expansion is a design decision, not a safety valve.** Capping by key order makes the
  served top-K wrong exactly for the prefixes users type first. Choose explicitly: precompute
  score-ordered top-K for short prefixes, or walk a score-ordered list and filter by prefix
  membership; then report candidate loss for the cases that still hit the cap.
- **Blend buckets only after reporting them separately.** Generate synthetic prefixes at
  code-point boundaries of submitted text, but bucket the cohort by submitted length and make the
  bucket the product scope is stated in the headline. A short bucket with a handful of cases per
  prefix length next to an even-split bucket will be swamped in any blended number.
- **Representation arms (trie/keyvi/fsm) are compared on parity, then latency.** Feed both the same
  `(key, weight)` set, define the tie order, and require set equality of top-K on tens of thousands
  of sampled prefixes. A different retrieved set is a container change being mislabelled as a
  ranking change.
- **Slices are mandatory** because prefix length changes the task: 1–3 characters, word-boundary vs
  mid-word, accented vs unaccented, digit/house-number, target value. Report a short-input slice
  beside every all-input headline; never replace the headline with the slice the feature happens to
  win on, and never report only the slice the user asked to optimize.
- **Cluster the uncertainty by the originating event or user.** Synthetic prefixes of one submission
  are not independent observations; a bootstrap that resamples prefixes overstates precision.
- **Counterfactual downstream Hit@K is exposure-biased.** Substituting a suggested POI for a typed
  submission and reading the recorded click proves nothing causal; label it diagnostic.

## 4. Provenance and contamination

- Manifest every run: SHA-256 of each source file, normalizer version, privacy-policy version,
  scoring constants, prefix-generator parameters, and record counts. `file_sha256` + one JSON per
  split is enough; never infer provenance from filenames or mtimes.
- **An artifact written by older code is not a truncated artifact.** When on-disk key sets stop
  matching a fresh scan, do not assume truncation or randomness: re-fold the source with the
  *previous* normalizer and compare key sets. A file that reproduces exactly under the old
  tokenizer is stale, and one holding **more** keys than any current scan can produce proves it.
  Two scans in one process with identical digests settle determinism in minutes; a per-key reverse
  scan of the source parquet settles nothing and never terminates.
- **Record the code identity, not only the data identity.** Put `code_commit` and `code_dirty` in
  the manifest, write every artifact atomically (`.tmp` then `replace`), and store its own
  SHA-256 plus line count. Then a stale or half-written artifact fails a hash check instead of
  silently becoming the evaluation universe.
- Get the actual date range from the `day` column with `pc.min_max`, per file, and print it. Filenames
  encode bagged week ranges that do not match the data.
- A current-catalog snapshot has no historical cutoff. Run `log-only` and `current-catalog` as
  separate arms and separate report columns, each row labelled; a merged number cannot be excused
  later.
- Watch the documented click-prior training window: if it spans a validation fold, prior-backed
  downstream replay on that fold is contaminated and must move to the later untouched window.

## 4a. Privacy floor and catalog caps are policy, so report both sides

- **A support floor is a privacy gate, not a relevance gate.** Support >= 3 still admits private
  premises strings (`13/190 tran van hoang`) and house-number address labels. Ship a classifier for
  "house number plus street, no business marker", evaluate `source_policy=all` beside
  `source_policy=public-only`, and let the product owner choose — do not filter silently.
- **A catalog cap whose boundary lands on a huge tie is alphabetical selection.** Print how many
  keys tie at the cut (`active_count == 1` can carry millions). If the tie mass is large, run the
  evaluation twice, `universe=capped` and `universe=uncapped` (uncapped in memory, evaluation-only,
  never the served artifact) and report the gap; above ~2 pp the capped number is a statement about
  alphabet luck and must be labelled as such.

## 5. Pre-registered gates

Write the gate table into a committed `docs/gates.md` **before** opening the final split, one row per
gate: metric, threshold, and the action taken if it fails (drop arm, shrink window, publish the
negative result). At minimum cover: zero search-service calls on the typing path; harness
equivalence; representation top-K parity; in-process p95/p99; incremental arm value with CI;
no statistical loss on the headline slice; artifact bytes. Add the standing rule in the same file —
after the holdout is opened, thresholds are frozen and any change requires a new dated plan file.
Fields the user must decide, rather than the implementer guessing: the short-input threshold, and
whether a comparison arm ships when its accuracy gain is unproven.

## 6. Implementation sequencing for a POC repo

1. Bootstrap a separate package (`src/<pkg>/`) with its own `pyproject.toml` and venv; never add
   dependencies to the repository being evaluated.
2. Provenance manifest → text keys → query miner → catalog miner → merge/score → retrieval → prefix
   generator → cohort + independent scorer → per-arm evaluators → ablations → latency bench → report.
3. Each miner carries a numeric sanity range in its verification step (expected record count band,
   seconds, row-group count). A silent data bug otherwise passes as a result; a band makes it fail
   loudly.
4. Check wheel availability for a native trie/FSM dependency before promising the comparison arm:
   list the release's `filename`s from the PyPI JSON API, and verify the target Python and platform
   tag exists. Absence of the package from the current interpreter is a setup task, not evidence
   that the arm is impossible.
5. Keep the report's "what this does not prove" section non-optional: no service-call savings, no
   acceptance rate, synthetic prefixes, size of the catalog contamination.
