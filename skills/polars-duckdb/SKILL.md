---
name: polars-duckdb
description: >-
  High-performance tabular data wrangling, ETL, and analytical SQL with Polars, DuckDB, PyArrow, and Pandas 2.x.
  Use when loading, cleaning, joining, aggregating, or converting CSV, Parquet, Arrow, or JSON datasets.
  Not for statistical modeling/A/B tests (data-science) or chart layout (data-visualization).
risk: safe
source: local
date_added: "2026-10-23"
---

# Polars, DuckDB & Tabular Data Engineering Skill

Process tabular datasets with the right engine for the data scale, strict schema/grain validation, and zero Python-loop bottlenecks.

Load `references/pandas-to-polars-migration.md` when translating Pandas code to Polars expressions or combining DuckDB with Polars/PyArrow.

## When to Use
- Loading, cleaning, filtering, joining, or aggregating CSV, Parquet, Arrow, IPC, or JSON datasets
- Choosing between `pandas`, `polars`, and `duckdb` for local data processing
- Writing memory-safe lazy queries over multi-GB files
- Auditing join keys, table grain, schema drift, and silent row duplication

## When Not to Use
- Hypothesis testing, A/B testing, causal inference, or ML modeling (`data-science`)
- Chart construction and visual layout (`data-visualization`)
- Interactive web dashboards (`plotly-dash`)

## Related Skills
- Use **data-science** when wrangled features or tables feed into EDA, statistical inference, or ML models.
- Use **python-performance** when profiling memory RSS or CPU bottlenecks outside tabular engines.
- Use **context7-mcp** when checking version-specific Polars or DuckDB APIs.

## 1. Engine Selection by Dataset Scale

Pick the engine from file size, memory budget, and existing repository conventions (`rules/AGENTS.md` §2):

| Dataset Size (Uncompressed) | Default Engine | Execution Pattern | Escape Hatch / Notes |
| :--- | :--- | :--- | :--- |
| **< 100 MB** | **Polars** (eager/lazy) or **Pandas 2.x** | `pl.read_parquet` / `pd.read_parquet(dtype_backend="pyarrow")` | Use Pandas only when required by downstream APIs (`scikit-learn`, legacy code) |
| **100 MB – 10 GB** | **Polars Lazy API** or **DuckDB** | `pl.scan_parquet(...)` + `.collect()` or `duckdb.sql(...)` | Enables predicate pushdown, projection pushdown, and parallel streaming |
| **10 GB – 100 GB (Single Node)** | **DuckDB** (out-of-core) or **Polars Streaming** | `pl.scan_parquet(...).collect(engine="streaming")` or DuckDB with `temp_directory` | Never call eager `pd.read_csv()` or `pl.read_csv()` on multi-GB files |
| **> 100 GB (Cluster)** | **Spark / Dask / Cloud Warehouse** | Push aggregation to warehouse SQL before pulling local extracts | Sample or aggregate remotely first |

## 2. Core Tabular Hygiene Invariants

1. **Inspect Metadata Before Full Reads**:
   - For Parquet files, inspect schema, row count, and row-group statistics via `pyarrow.parquet.ParquetFile(path)` or `pl.read_parquet_schema(path)` before scanning columns.
   - Scope multi-file scans to an explicit manifest or homogeneous partition glob (never `*.parquet` in a directory containing mixed schemas).
2. **Project and Filter Early**:
   - Select only required columns and push row filters into `pl.scan_parquet().select(...).filter(...)` or DuckDB `SELECT ... WHERE ...` so unneeded columns never enter RAM.
3. **Verify Grain and Prevent Join Explosions**:
   - State the expected grain (e.g., one row per `(user_id, date)`) before joining.
   - Assert uniqueness on the right-side join key or pass explicit join validation (`how="left", validate="m:1"` in Polars / `validate="many_to_one"` in Pandas).
   - Record row counts before and after every join (`n_before`, `n_after`, `matched_rate`). An unexpected row increase on a left join is a duplicate-key bug until proven otherwise.
4. **Vectorized Expressions Only (Zero Python Row Loops)**:
   - Never use `.iterrows()`, `.itertuples()`, or unvectorized `.apply(axis=1)` in Pandas.
   - Never use `.map_elements()` in Polars when native expressions (`pl.when().then().otherwise()`, `.str`, `.dt`, `.list`, `.struct`) can express the logic.
5. **Safe Pandas 2.x Defaults (When Pandas Is Required)**:
   - Enable Copy-on-Write (`pd.options.mode.copy_on_write = True`) and never use chained indexing (`df[mask]["col"] = val`); always use `df.loc[mask, "col"] = val` or `.assign()`.
   - Prefer `dtype_backend="pyarrow"` or explicit `category` / smaller integer dtypes to cut RAM by 50–70%.
6. **Zero-Copy Interop Between DuckDB and Polars**:
   - Exchange tables between DuckDB and Polars via Apache Arrow (`duckdb.sql("SELECT ... FROM pl_lazy_df").pl()`) without materializing intermediate CSVs or Python lists.

## 3. Standard Transformation Workflow

```python
import polars as pl

# 1. Lazy scan with predicate and projection pushdown
q = (
    pl.scan_parquet("data/events_*.parquet")
    .select(["user_id", "event_ts", "plan_tier", "revenue_cents"])
    .filter(pl.col("event_ts") >= pl.lit("2026-01-01").str.to_date())
    .with_columns(
        (pl.col("revenue_cents") / 100.0).alias("revenue_usd"),
        pl.col("plan_tier").fill_null("unknown"),
    )
)

# 2. Validate join key uniqueness on dimension table before joining
dim_users = pl.scan_parquet("data/users.parquet").select(["user_id", "cohort_month"])
result = (
    q.join(dim_users, on="user_id", how="left", validate="m:1")
    .group_by(["cohort_month", "plan_tier"])
    .agg(
        pl.len().alias("n_events"),
        pl.col("user_id").n_unique().alias("n_users"),
        pl.col("revenue_usd").sum().round(2).alias("total_revenue_usd"),
    )
    .sort(["cohort_month", "plan_tier"])
    .collect()
)
```

## 4. Gotchas
- **CSV Type Inference Traps**: `read_csv` / `scan_csv` infers types from the first N rows. Always pass `schema_overrides` for ID columns with leading zeros (zip codes, phone prefixes, administrative codes) as `pl.String` (`str`) so `"00123"` is never coerced to integer `123`.
- **Null Propagation in Arithmetic & Comparisons**: In Polars and SQL, `null == null` is `null` (not `True`), and `col_a + col_b` is `null` if either side is `null`. Use `.is_null()`, `.eq_missing()`, or `pl.sum_horizontal()` / `COALESCE()` intentionally.
- **Parquet Compression vs. In-Memory RSS**: A 200 MB dictionary-encoded Parquet file can expand 10x–20x in RAM if converted to Python `object` strings. Keep string-heavy columns in Arrow/Polars categorical (`pl.Categorical` / `pl.Enum`) or query via DuckDB.

## Final Checklist
- [ ] Engine matched to dataset size and repository stack
- [ ] Lazy scan (`scan_parquet`/`scan_csv` or DuckDB) used for files > 100 MB
- [ ] ID columns with leading zeros pinned as strings in `schema_overrides`
- [ ] Join cardinality validated (`validate="m:1"` / `"1:1"`) and pre/post row counts checked
- [ ] Zero `.iterrows()` or unnecessary `.map_elements()` loops
