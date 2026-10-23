# A/B Testing & Causal Inference Reference

Load this file when designing experiments, diagnosing Sample Ratio Mismatch (SRM), applying variance reduction (CUPED), or estimating causal effects from observational data.

## 1. Pre-Experiment Design & Power Calculation

1. **Define One Primary Decision Metric + Guardrail Metrics**:
   - **Primary Metric**: Single metric that determines ship/no-ship (e.g., 7-day retention, net revenue per assigned user).
   - **Guardrail Metrics**: Invariants that must not degrade beyond a pre-specified non-inferiority margin (e.g., crash rate, p95 latency, unsubscribe rate).
2. **Unit of Randomization vs. Unit of Analysis**:
   - When randomization is by cluster (store, city, session) while analysis is by item/page-view, compute cluster-robust standard errors or aggregate to the randomization unit first; naive observation-level tests underestimate variance and inflate Type I error.
3. **Minimum Detectable Effect (MDE) & Sample Size**:
   - Size the experiment for `alpha = 0.05` (two-sided) and `power = 0.80` (or `0.90`) using baseline variance measured on historical cohorts of the exact same duration. Never stop an experiment early merely because `p < 0.05` on day 2 (peeking inflates false positives to >25% unless using group-sequential boundaries or mSPRT always-valid p-values).

## 2. Sample Ratio Mismatch (SRM) Gate (Run First!)

Before reading any treatment lift, test whether observed assignment counts match the intended split ratio (e.g., 50/50) using a Pearson chi-square goodness-of-fit test:

```python
from scipy.stats import chisquare

# Example: intended 50/50 split with observed counts
obs = [49_120, 50_880]
exp = [50_000, 50_000]
stat, p_srm = chisquare(f_obs=obs, f_exp=exp)
assert p_srm >= 0.001, f"CRITICAL: Sample Ratio Mismatch detected (p={p_srm:.2e}). Halt treatment analysis!"
```

- **Rule**: If `p_srm < 0.001`, **halt treatment evaluation**. An SRM indicates broken randomization, bot filtering bias, redirect loss, or logging pipeline asymmetry; any treatment effect estimate is biased.

## 3. Variance Reduction with CUPED

When pre-experiment baseline data `X` (same metric in the 14–28 days strictly prior to assignment) exists for assigned units, apply **CUPED (Controlled-experiment Using Pre-Existing Data)**:

1. Compute covariance and variance pooled across control and treatment: `theta = cov(Y, X) / var(X)`.
2. Compute adjusted outcome: `Y_cuped = Y - theta * (X - mean(X_pooled))`.
3. Evaluate treatment vs. control on `Y_cuped` (assigning `X = mean(X_pooled)` or a separate stratum for new users with no pre-period history).
4. **Invariants**: `X` must be strictly pre-assignment (zero post-treatment contamination), and `mean(X_treatment) vs mean(X_control)` must be checked for pre-period balance.

## 4. Multiple Testing & Heterogeneous Treatment Effects (HTE)

- When evaluating `M` multiple primary variants or cohort slices simultaneously, control Family-Wise Error Rate with **Holm-Bonferroni** or False Discovery Rate with **Benjamini-Hochberg** (`scipy.stats.false_discovery_control`).
- Treat post-hoc subgroup discoveries ("metric was flat overall, but +4% on iOS users in tier 2") as **exploratory hypotheses** requiring a follow-up confirmatory test unless pre-registered.

## 5. Observational Causal Inference (When A/B Is Infeasible)

When randomization is impossible, select the quasi-experimental method whose identifying assumption can be falsified with pre-intervention data:

| Method | When to Use | Mandatory Diagnostic / Falsification Check |
| :--- | :--- | :--- |
| **Difference-in-Differences (DiD)** | Policy/feature rollout across regions or cohorts at a discrete time | Plot event-study pre-trends (`t = -4, -3, -2, -1`); reject DiD if parallel pre-trends fail, and use staggered-adoption estimators (Callaway-Sant'Anna) when rollout dates vary |
| **Synthetic Control / Geo-Lift** | Small number of treated markets/geos | Check pre-intervention RMSE fit and run in-time / in-space placebo permutations |
| **Doubly Robust (AIPW) / Propensity Score** | Observational user-level adoption with rich pre-treatment covariates | Verify propensity overlap (`0.05 < e(X) < 0.95`), check post-weighting standardized mean differences (`SMD < 0.10`), and compute E-value / sensitivity to unobserved confounders |
| **Regression Discontinuity (RDD)** |Deterministic eligibility cutoff (score >= threshold) | Run McCrary density test around the threshold to rule out manipulation, and test bandwidth sensitivity |
