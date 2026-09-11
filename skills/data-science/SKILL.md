---
name: data-science
description: >-
  Run EDA, inference, A/B tests, forecasting, or model evaluation on a dataset.
  Not for Plotly layout, Dash apps, stakeholder narrative, or SOTA library surveys.
risk: safe
source: local
date_added: "2026-02-27"
---

# Data Science Skill

Analyze a dataset to answer a defined question with appropriate methods and uncertainty.

## When to Use
- EDA, hypothesis testing, A/B testing
- Predictive / ML model build or evaluation
- Time series forecasting, causal inference, segmentation
- Experiment design or impact measurement

## When Not to Use
- Plotly chart polish (`data-visualization`)
- Dash UI (`plotly-dash`)
- Stakeholder QBR copy (`data-storytelling`)
- External SOTA survey (`tech-research`)
- Quality KPI loop on labeled cases (`algorithm-optimization`)
- Pure backend feature work

## Related Skills
- Use **data-visualization** when results need charts.
- Use **data-storytelling** when a non-technical decision narrative is required (after validation).
- Use **algorithm-optimization** when findings should drive a KPI loop on real cases.

## Method Card
1. **Objective**: business question, success metric, constraints, available data.
2. **Data checks**: missingness, outliers, leakage, unit of analysis, train/serve skew.
3. **Method class**: inference/experiment vs predictive vs causal vs forecast — pick one primary.
4. **Validation**: holdout / CV / residual checks / robustness; match the method class.
5. **Uncertainty**: inference → effect size + interval (not p-values alone). Predictive → holdout metric + error bars or calibration. Do not force CIs onto every ML score.
6. **Recommendations**: feasible next actions; assumptions and limitations explicit.

Prefer simpler interpretable methods when they perform adequately. Separate exploratory findings from confirmatory results. Flag data quality issues before modeling.

## Output Expectations
- Short summary of the key finding or recommendation
- Relevant metrics/tables (charts via `data-visualization`)
- Assumptions, limitations, next verification step

## Final Checklist
- [ ] Objective and success metric defined
- [ ] Data checks done before modeling
- [ ] Method class matches the question
- [ ] Validation matches the method class
- [ ] Uncertainty reported appropriately
- [ ] Recommendations are actionable
