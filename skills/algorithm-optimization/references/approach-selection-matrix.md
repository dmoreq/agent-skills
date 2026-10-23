# Choosing between candidate approaches on accuracy, storage, latency, complexity

Use when the user asks which approach to adopt and the answer has to balance several criteria,
not just maximise one metric. Do not answer from vendor numbers — every row of the matrix
except the ones you explicitly label *reported* should be measured on the user's own data on
their own machine.

## 1. Measure the incumbent on every axis first

Before adding candidates to the table, fill the baseline row with measured values:

```python
# storage + latency of the model artifact, in one process per config
import resource, time
rss_mb = lambda: resource.getrusage(resource.RUSAGE_SELF).ru_maxrss / 1024 / 1024
t = time.time(); model = load(); load_s = time.time() - t
rss = rss_mb()          # peak RSS, not VSS
```

Report per-artifact: on-disk bytes, in-RAM after load, cold-load time, steady-state
per-item latency, and the throughput a user actually feels (items/single core). Keep
"startup" separate from "per-item" — a model that loads in 2 s but serves in 0.6 ms has a
completely different operating story from one that loads instantly and serves in 200 ms.

## 2. Populate reported rows honestly

For external options (papers, model cards, vendor docs), record the number **and** the
hardware/context it was measured in. Mark them `reported`. Never average a reported latency
into a measured one, and never compare a reported accuracy from author-set A with a measured
accuracy on set B as if the delta were an effect.

State latency in the same unit across rows. A paper quoting sentences/second on a 2017 GPU
and a model card quoting ms/sentence must be converted to one scale before they sit in the
same column.

## 3. Score the axes, then break ties with the purpose

Scores 1-5 per axis, higher better (invert for "effort" so the arithmetic is uniform):

| Approach | Accuracy | Storage | Latency | Simplicity | Ops | Total |
|---|---|---|---|---|---|---|

The total column is a discussion aid, not the decision. Break ties with:

- **The axis that is the purpose of the task wins.** A component at 71% accuracy on a
  restoration/transcription task is not "balanced" — it is unusable output, whatever its
  storage score. Do not let a cheap-but-wrong option top a matrix.
- **A row that is best or near-best on every axis needs no tie-break.** Look for these;
  representation changes often produce them and they end the debate.
- **A row that wins one axis by losing three is a targeted tool, not a replacement.**
  Recommend it for the slice where it wins, if any, and keep the incumbent elsewhere.

## 4. Representation before reduction

When storage is the pressure point, try re-encoding before removing anything:

| Representation | Typical effect on a large key→count table |
|---|---|
| Language dict of dicts | baseline, ~100-110 B/entry |
| Compact trie (marisa-trie) | measured 500 MB → 19 MB, load 1.6 s → ~0 s, same queries |
| Sorted bytes + `numpy.searchsorted` | near-trie, no dependency |

Re-measure accuracy after a representation swap on the *same* cohort. A container change
should move zero accuracy points; if it moves any, the swap was not lossless and the table
needs a value column preserved.

A 26x RAM reduction for an unchanged model beats any model simplification, because it costs
no accuracy and removes an entire class of objection. Do this before proposing a smaller or
weaker model.

## 5. Sanity-check every claim before it reaches the report

The failure mode in this class of answer is a confident optimisation that was never run.
Before writing a recommendation that says "dropping X saves N", "adding Y gains M", or
"switching to Z is better", confirm you have:

- [ ] run the with/without (or before/after) arm on one scorer
- [ ] quoted the measured delta, not an expected one
- [ ] labelled every unmeasured cell `reported` or `est.`
- [ ] checked the *fallback* path's value before dismissing a sparsely-hit structure
- [ ] verified the storage claim by actually building the compact form and reloading it

If an earlier draft of the table asserted something the measurement later contradicts, fix
the row and say plainly that the draft was wrong. A corrected matrix is worth more than a
consistent-looking one.

## 6. Output shape

1. One-line recommendation at the top naming the winner and why.
2. The full matrix, measured vs reported marked.
3. The two or three findings that changed the decision, each with its number.
4. Explicit rejections with the axis each loser lost on.
5. Repro commands for the measurement scripts.
