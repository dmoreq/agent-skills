---
name: data-science
description: >-
  Run EDA, statistical inference, A/B testing, causal analysis, forecasting, and tabular ML modeling.
  Not for Polars/DuckDB ETL syntax, Plotly layout, Dash apps, or SOTA literature surveys.
risk: safe
source: local
date_added: "2026-02-27"
---

# Data Science, Experimentation & ML Modeling Skill

Analyze datasets to answer business and scientific questions with rigorous validation, leakage-free modeling, and quantified uncertainty.

Load `references/ab-testing-and-causal.md` when designing or analyzing A/B experiments, sample ratio mismatches (SRM), variance reduction (CUPED), or quasi-experimental causal inference.

## When to Use
- Exploratory data analysis (EDA), data quality profiling, and anomaly detection
- Hypothesis testing, A/B testing, power analysis, and causal inference
- Predictive ML modeling, cross-validation design, calibration, and slice evaluation
- Time series forecasting and cohort/funnel retention analysis

## When Not to Use
- High-volume CSV/Parquet ETL or Polars/DuckDB query mechanics (`polars-duckdb`)
- Plotly chart styling and anti-overlap layout (`data-visualization`)
- Interactive Dash web applications (`plotly-dash`)
- Executive stakeholder narrative after numbers are locked (`data-storytelling`)
- Iterative quality KPI / search-ranking ablation loops (`algorithm-optimization`)

## Related Skills
- Use **polars-duckdb** for fast, memory-safe tabular ingestion, joins, and aggregations.
- Use **data-visualization** when findings require charts.
- Use **plotly-dash** when the analysis needs an interactive app rather than a static chart.
- Use **data-storytelling** when translating validated metrics into an executive decision narrative.
- Use **algorithm-optimization** when running multi-arm KPI or search-ranking evaluations.

## 1. Automated EDA & Data Quality Protocol

Before fitting any model or running a hypothesis test, execute a deterministic profile of the dataset (use `python skills/data-science/scripts/eda_profile.py <path>` for quick tabular diagnostics):

1. **Grain & Identity Check**: Confirm what one row represents (e.g., `user_id`, `(order_id, item_id)`), verify primary-key uniqueness, and check date spans for gaps or truncation.
2. **Missingness Mechanism Diagnosis**:
   - Count null rates and sentinel values (`-1`, `9999`, `""`, `"null"`, `1970-01-01`).
   - Classify missingness before imputing: **MCAR** (missing completely at random), **MAR** (conditional on observed features), or **MNAR** (missingness itself is informative—always add a binary `_is_missing` indicator column rather than blindly mean-imputing).
3. **Distribution & Anomaly Audit**:
   - Inspect numeric quantiles (`p01`, `p05`, `p50`, `p95`, `p99`), skewness, and impossible values (negative durations, future timestamps, unit mismatches such as cents vs. dollars).
   - For heavy-tailed metrics (revenue, latency, session length), report median/IQR alongside mean/SD or log-transform before parametric tests.
4. **Separate Exploratory vs. Confirmatory Findings**:
   - Frame EDA synthesis using **What** (quantified observation with exact cohort denominators), **So What** (magnitude/business impact), and **Now What** (testable hypothesis or action).

## 2. Leakage Prevention & Validation Split Design

Data leakage is the #1 cause of invalidated ML models. Enforce these invariants before training:

1. **Split Before Any Stateful Transform**:
   - Never compute target encodings, scalers, imputers, vocabulary TF-IDF, or outlier clip bounds on the full dataset before splitting. Encapsulate all preprocessing inside `sklearn.pipeline.Pipeline` / `ColumnTransformer` (or fit strictly on the training fold).
2. **Match Cross-Validation Strategy to Data Generating Process**:
   - **i.i.d. tabular classification/regression**: `StratifiedKFold` (or binned stratification for skewed regression targets).
   - **Grouped / repeated-entity observations** (multiple rows per user, merchant, device, or patient): `GroupKFold` or `StratifiedGroupKFold` so the same entity never spans train and validation.
   - **Temporal / forecasting / event logs**: Strict chronological cutoff or `TimeSeriesSplit` with a purge gap equal to the label horizon so future labels never leak into historical features.
3. **Audit Feature-Target Contamination**:
   - If a single feature achieves abnormally high univariate importance or AUC (> 0.95), audit its timestamp and provenance for post-outcome leakage (e.g., `refund_date`, `cancellation_reason`, or post-event status updates).

## 3. Baselines-First Modeling & Evaluation Ladder

1. **Always Beat Two Baselines First**:
   - **Rung 0 (Heuristic / Dummy)**: Majority class, group median, seasonal naive (`y_{t-s}`), or existing production rule.
   - **Rung 1 (Interpretable Linear / Simple Tree)**: `LogisticRegression` / `Ridge` with standardized features, or depth-3 decision tree.
   - **Rung 2 (Gradient Boosted Trees)**: `LightGBM`, `CatBoost`, or `XGBoost` for tabular workloads.
   - **Rung 3 (Ensembles / Deep Learning)**: Only if Rung 2 saturates and latency/complexity budgets permit.
2. **Match Evaluation Metric to Decision Mechanics**:
   - **Imbalanced classification**: Report `PR-AUC` (Average Precision) and precision/recall at the operational threshold alongside `ROC-AUC` (`ROC-AUC` alone masks false-positive explosions on rare classes).
   - **Probability decisions**: When downstream logic multiplies `P(event) × value`, verify probability calibration (`brier_score_loss`, reliability curve, `CalibratedClassifierCV`).
   - **Regression**: Report `MAE` and `MdAE` alongside `RMSE` when outliers exist; use `WMAPE` or `sMAPE` instead of raw `MAPE` when actuals approach zero.
3. **Slice & Error Analysis**:
   - Never approve a model on aggregate metrics alone. Evaluate metrics across key cohorts (new vs. returning users, device/region tiers, high-value segments) and inspect the top 20 worst residual errors.

## 4. Statistical Inference & Uncertainty Reporting

- **Effect Size + Confidence Interval Always**: Never report a bare `p < 0.05` or "statistically significant" without the point estimate, relative lift (`%`), absolute delta, and 95% confidence interval.
- **Test Selection**:
  - Continuous normal / large-N means: Welch's t-test (`equal_var=False`, never Student's equal-variance t-test by default).
  - Heavy-tailed / skewed continuous: Mann-Whitney U test, permutation test, or non-parametric bootstrap CI.
  - Proportions / conversion rates: Two-proportion z-test or Fisher's exact test (small counts).
- For A/B testing guardrails, SRM checks, CUPED, and causal inference, load `references/ab-testing-and-causal.md`.

## Output Expectations
- **Executive Summary (What / So What / Now What)**: Headline finding with exact sample sizes, denominators, effect sizes, and uncertainty bounds.
- **Validation & Data Hygiene Evidence**: Split strategy, leakage checks performed, and cohort/slice breakdown table.
- **Limitations & Next Action**: Explicit assumptions, data gaps, and concrete next step.

## Final Checklist
- [ ] Dataset grain, schema, missingness, and sentinel values audited before modeling
- [ ] Validation split matches data structure (Stratified / Group / TimeSeries) with zero post-outcome leakage
- [ ] Simple baseline (`Dummy` / linear / seasonal naive) compared against candidate model on identical folds
- [ ] Uncertainty reported via effect sizes and confidence intervals (not p-values alone)
- [ ] Performance verified across critical slices, not just aggregate averages
