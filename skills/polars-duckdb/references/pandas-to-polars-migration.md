# Pandas to Polars & DuckDB Migration Reference

Load this file when translating Pandas pipelines to Polars or combining DuckDB SQL with Polars/PyArrow.

## 1. Idiomatic Pandas → Polars Translation

| Operation | Pandas 2.x | Polars (Idiomatic) |
| :--- | :--- | :--- |
| **Lazy read** | *N/A (eager `pd.read_parquet`)* | `pl.scan_parquet("file.parquet")` |
| **Column select** | `df[["a", "b"]]` | `df.select("a", "b")` |
| **Row filter** | `df.loc[df["a"] > 5]` | `df.filter(pl.col("a") > 5)` |
| **New / mutated column** | `df.assign(c=df["a"] * 2)` | `df.with_columns((pl.col("a") * 2).alias("c"))` |
| **Conditional column** | `np.where(df["a"] > 0, "pos", "neg")` | `pl.when(pl.col("a") > 0).then(pl.lit("pos")).otherwise(pl.lit("neg"))` |
| **Group + multi-agg** | `df.groupby("g").agg(n=("a", "count"), s=("b", "sum"))` | `df.group_by("g").agg(pl.col("a").count().alias("n"), pl.col("b").sum().alias("s"))` |
| **Window function** | `df.groupby("g")["x"].transform("mean")` | `pl.col("x").mean().over("g")` |
| **Deduplicate** | `df.drop_duplicates(subset=["id"], keep="first")` | `df.unique(subset=["id"], keep="first", maintain_order=True)` |
| **Safe join** | `df.merge(right, on="id", how="left", validate="m:1")` | `df.join(right, on="id", how="left", validate="m:1")` |

## 2. Polars Anti-Patterns to Avoid

1. **Never loop over rows or call `.map_elements()` for string/math logic**:
   - Bad: `df.with_columns(pl.col("name").map_elements(lambda s: s.strip().lower()))`
   - Good: `df.with_columns(pl.col("name").str.strip_chars().str.to_lowercase())`
2. **Parallelize expressions inside one `.with_columns()` or `.select()` block**:
   - Bad: chaining ten separate `.with_columns()` calls for independent columns.
   - Good: pass all independent expressions in a single `.with_columns([...])` call so Polars evaluates them in parallel across threads.
3. **Keep lazy until the boundary**:
   - Build the full `LazyFrame` query plan (`pl.scan_*` → `.filter()` → `.join()` → `.group_by()`) and call `.collect()` once at the end. Calling `.collect()` mid-pipeline disables query optimization and predicate pushdown.

## 3. DuckDB + Polars Zero-Copy Pattern

Use DuckDB when complex multi-table SQL (range joins, `ASOF` joins, recursive CTEs, `QUALIFY` window filters) is clearer than DataFrame method chains:

```python
import duckdb
import polars as pl

events = pl.scan_parquet("events.parquet")
users = pl.scan_parquet("users.parquet")

# DuckDB reads Polars LazyFrames directly via Arrow with predicate pushdown
top_per_user = duckdb.sql("""
    SELECT
        e.user_id,
        u.segment,
        e.event_type,
        e.revenue_usd,
        ROW_NUMBER() OVER (PARTITION BY e.user_id ORDER BY e.revenue_usd DESC) AS rn
    FROM events e
    JOIN users u USING (user_id)
    WHERE e.event_ts >= DATE '2026-01-01'
    QUALIFY rn = 1
""").pl()
```
