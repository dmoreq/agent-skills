# Auditing a headline accuracy number before adopting it

Use this before you inherit, quote, or build a plan on someone else's reported accuracy — a
repo README, a shipped evaluator, a model card, a paper table. The goal is to know whether
the number is a property of the model or of the scorer.

## 1. Reproduce, then re-derive

Run the author's own evaluator to confirm the claim is at least reproducible:

```bash
javac -d /tmp/build $(find src -name '*.java')
java -cp /tmp/build their.pkg.AccuracyCalculator
```

Then score the **same prediction file** with your own per-item counter and report both:

| Run | Score |
|---|---|
| Author's evaluator | 96.29% |
| Independent per-token counter | 91.50% |

The lower number is the baseline. The delta is a finding in its own right — name the
mechanism (off-by-one counter, length-mismatch skip, dropped blank records) so the user can
see it is arithmetic, not a disagreement about the model.

### Common inflators in hand-rolled evaluators

- Accumulator initialised to 1 (`int countAll = 1;`) — adds a free correct item.
- `if (a.length != b.length) continue;` — silently drops every misaligned case, which is
exactly where the model failed.
- Blank or empty segments counted as correct, or filtered from the gold but not the predicted.
- Case- and whitespace-insensitive comparison of only the token, ignoring whether the gold
token was unambiguous anyway.

## 2. Four-cell data/code ablation

When a repo ships rewritten code *and* rebuilt data, never conclude "the algorithm regressed"
from the current-diff alone. Build the cross-swap:

| | old data | new data |
|---|---|---|
| **old code** | 96.28% | 95.89% (old 1-gram + new 2-gram) |
| **new code** | 90.13% | 91.83% |

Read the marginals, not the diagonal. Here the legacy vocabulary carried the entire
difference and the larger-by-type new table was the regression — a code-only diff would have
blamed the algorithm. Always report the mixing cell that isolates each component.

## 3. Separate the decoder from the vocabulary

Two ablations localise the cause faster than reading code:

- **Context-free decoder** (pick the most frequent candidate per item, ignore order). If this
  scores ~68% while the real decoder scores ~91%, the value is in the sequence constraint.
- **Candidate ceiling** — share of items where the correct answer is *representable* at all.
  If gold is in the candidate set 99.87% of the time, no replacement model can exceed 99.87%
  regardless of size, so "switch to a bigger model" cannot be the plan.

Report both. Together they say whether to invest in data, in the decision rule, or in a new
model family — and they rule out the expensive option cheaply.

## 4. Port parity is a gate, not a nice-to-have

Before trusting any number a reimplementation produces, pin item-level agreement against the
original:

```
matching items / total items >= 99.9%
```

A port that disagrees is buggy, not better. When it disagrees, do not tweak the port until the
score looks right — isolate one diverging input and diff the intermediate state (candidate set,
score vector, chosen index) against the reference using a reflective or diagnostic harness.
The divergences that cost the most time are the ones with no exception attached:
- the reference lowercases before candidate generation (so your uppercase path yields no candidates);
- the reference prunes candidates by length (`maxWordLength = 8`), silently returning none for longer words;
- the reference restores case by character offset over the *joined* output, not per token;
- a sentinel token exists in one code path and not the other;
- the two paths load **different data files** even though both constructors look the same.

Checklist before blaming your port: same data files, same normalisation order, same
lowercasing point, same pruning caps, same sentinel handling, same case-restoration unit.

## 5. Cross-register / cross-slice generalisation

In-domain accuracy says little if the task has registers with different ambiguity density.
Score the incumbent on an open external set with the same scorer:

```
in-domain  : 91.50%
out-of-domain: 91.12%   -> the model generalises; the metric was the problem
```

A large gap means the plan needs slice coverage, not a model change. A small gap on a
truthful scorer means the in-domain number was never inflated by the data — it was inflated
by the grader. Distinguish these explicitly; they lead to opposite recommendations.

## 6. Whether to replace the decoder

Build one table with accuracy **and** throughput for every option before recommending a
rewrite. Do not accept a "newer model" recommendation without both axes in the same row.

A fast classic decoder at equal accuracy to a neural one is not a technical debt to repay —
report the speed ratio (often 60-200x) and recommend keeping it. Reserve neural compute for
re-ranking the classic decoder's top-k, where the recall is already fixed and only the
ambiguity needs judging.

### 6a. Before recommending model order, count the support it needs

A higher-order model is not free capacity — it conditions on lower-order observations that
must exist. Count them before promising a gain:

```python
# share of positions where the extra term has any signal
both = one = none = 0
for sent in sents:
    for i in range(len(sent) - 2):
        ab = (sent[i], sent[i+1]) in bigrams
        bc = (sent[i+1], sent[i+2]) in bigrams
        both += ab and bc; one += ab != bc; none += not ab and not bc
```

Measured on one corpus: 6.9% of trigram positions had both supporting bigrams, 69% had
neither. The implemented trigram then scored **91.14% vs the bigram's 91.50%** and ran 5x
slower — the extra term was noise over a mostly-empty denominator. When support is thin,
the recommendation is "increase corpus density first, revisit the model order after", and
the model-order arm belongs in a later milestone, not the current plan.

### 6b. Sparse ≠ worthless

The same corpus had only 19.1% of adjacencies hitting the 2-gram table. Removing it cost
**19.93 points** (91.50% -> 71.57%): the never-observed fallback is itself the discriminator,
because wrong candidates tend to be unobserved pairs while the right one is usually observed.
Run the with/without arm before writing "drop the sparse table" into a plan. If the artifact
is genuinely load-bearing, attack its *representation* (compact trie, sorted array +
searchsorted) rather than its existence — a measured trie swap took the same 4.6M entries
from 500 MB to 19 MB with zero accuracy change.
