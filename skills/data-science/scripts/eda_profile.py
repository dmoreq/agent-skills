#!/usr/bin/env python3
"""Deterministic Exploratory Data Analysis (EDA) profiler for CSV, TSV, Parquet, and JSONL files."""
from __future__ import annotations

import argparse
import csv
import json
import math
from collections import Counter
from pathlib import Path
import sys


def _try_float(val: str) -> float | None:
    try:
        v = float(val)
        return v if math.isfinite(v) else None
    except (ValueError, TypeError):
        return None


def _quantile(sorted_vals: list[float], q: float) -> float:
    if not sorted_vals:
        return float("nan")
    pos = (len(sorted_vals) - 1) * q
    lo = int(math.floor(pos))
    hi = int(math.ceil(pos))
    if lo == hi:
        return sorted_vals[lo]
    return sorted_vals[lo] + (sorted_vals[hi] - sorted_vals[lo]) * (pos - lo)


def _sanitize_md(val: str) -> str:
    """Escape pipes, newlines, and backticks for safe Markdown table cells."""
    return val.replace("\r", " ").replace("\n", " ").replace("|", "\\|").replace("`", "'").strip()


def _read_jsonl_sample(handle: Any, max_rows: int) -> tuple[list[str], list[dict[str, str]], int]:
    rows: list[dict[str, str]] = []
    cols_seen: dict[str, None] = {}
    for line in handle:
        line = line.strip()
        if not line:
            continue
        if len(rows) >= max_rows:
            break
        obj = json.loads(line)
        for k in obj:
            cols_seen[str(k)] = None
        rows.append({str(k): ("" if v is None else str(v)) for k, v in obj.items()})
    return list(cols_seen.keys()), rows, len(rows)


def _read_delimited_sample(
    handle: Any, delimiter: str, max_rows: int
) -> tuple[list[str], list[dict[str, str]], int]:
    rows: list[dict[str, str]] = []
    reader = csv.DictReader(handle, delimiter=delimiter)
    cols = [c for c in (reader.fieldnames or []) if c is not None]
    for row in reader:
        if len(rows) >= max_rows:
            break
        rows.append({k: ("" if v is None else str(v)) for k, v in row.items() if k is not None})
    return cols, rows, len(rows)


def load_rows_stdlib(path: Path, max_rows: int) -> tuple[list[str], list[dict[str, str]], int]:
    """Load up to max_rows bounded sample using Python stdlib for CSV/TSV/JSONL."""
    suffix = path.suffix.lower()
    if suffix in (".jsonl", ".ndjson"):
        with path.open("r", encoding="utf-8", errors="replace") as f:
            return _read_jsonl_sample(f, max_rows)

    delim = "\t" if suffix == ".tsv" else ","
    with path.open("r", encoding="utf-8", errors="replace", newline="") as f:
        return _read_delimited_sample(f, delim, max_rows)


def _extract_batch_rows(
    batch_dict: dict[str, list[Any]], cols: list[str], limit: int
) -> list[dict[str, str]]:
    n = len(next(iter(batch_dict.values()))) if batch_dict else 0
    return [
        {c: ("" if batch_dict[c][i] is None else str(batch_dict[c][i])) for c in cols}
        for i in range(min(n, limit))
    ]


def _load_parquet_pyarrow(path: Path, max_rows: int) -> tuple[list[str], list[dict[str, str]], int]:
    import pyarrow.parquet as pq

    pf = pq.ParquetFile(path)
    total_rows = pf.metadata.num_rows
    cols = pf.schema_arrow.names
    rows: list[dict[str, str]] = []
    for batch in pf.iter_batches(batch_size=min(max_rows, 65536)):
        remaining = max_rows - len(rows)
        if remaining <= 0:
            break
        rows.extend(_extract_batch_rows(batch.to_pydict(), cols, remaining))
    return cols, rows, total_rows


def _load_parquet_duckdb(path: Path, max_rows: int) -> tuple[list[str], list[dict[str, str]], int]:
    import duckdb

    total_rows = duckdb.execute("SELECT count(*) FROM read_parquet(?)", [str(path)]).fetchone()[0]
    cur = duckdb.execute("SELECT * FROM read_parquet(?) LIMIT ?", [str(path), max_rows])
    cols = [col[0] for col in cur.description]
    fetched = cur.fetchall()
    rows = [{c: ("" if v is None else str(v)) for c, v in zip(cols, r)} for r in fetched]
    return cols, rows, total_rows


def _load_parquet(path: Path, max_rows: int) -> tuple[list[str], list[dict[str, str]], int]:
    """Load up to max_rows from a Parquet file using pyarrow or duckdb fallback."""
    try:
        return _load_parquet_pyarrow(path, max_rows)
    except ImportError:
        pass

    try:
        return _load_parquet_duckdb(path, max_rows)
    except ImportError:
        pass

    sys.stderr.write(
        f"ERROR: Reading Parquet files ({path.name}) requires 'pyarrow' or 'duckdb'.\n"
        "Install via `pip install pyarrow` or use the 'polars-duckdb' skill.\n"
    )
    raise SystemExit(1)


def load_rows(path: Path, max_rows: int) -> tuple[list[str], list[dict[str, str]], int]:
    """Route tabular dataset loading by file extension."""
    suffix = path.suffix.lower()
    if suffix == ".parquet":
        return _load_parquet(path, max_rows)
    return load_rows_stdlib(path, max_rows)


def profile_table(path: Path, max_rows: int = 100_000) -> None:
    """Profile a tabular dataset and print a Markdown summary."""
    if not path.is_file():
        sys.stderr.write(f"ERROR: File not found: {path}\n")
        raise SystemExit(1)

    cols, rows, total_rows = load_rows(path, max_rows)
    n_sampled = len(rows)
    row_hashes = Counter(tuple(r.get(c, "") for c in cols) for r in rows)
    n_dups = sum(cnt - 1 for cnt in row_hashes.values() if cnt > 1)

    print(f"# EDA Profile: `{path.name}`")
    print(f"- **Total Rows**: {total_rows:,} (Profiled sample: {n_sampled:,})")
    print(f"- **Columns**: {len(cols)}")
    print(f"- **Exact Duplicate Rows (in sample)**: {n_dups:,} ({(n_dups / max(n_sampled, 1)) * 100:.2f}%)\n")

    print("## Column Summary")
    print("| Column | Inferred Type | Null / Empty | Distinct | Top Value / Quantiles (p05 / p50 / p95) | Outliers (IQR) |")
    print("| :--- | :--- | :--- | :--- | :--- | :--- |")

    sentinels = {"", "null", "none", "nan", "n/a", "na"}
    for col in cols:
        raw_vals = [r.get(col, "").strip() for r in rows]
        non_null = [v for v in raw_vals if v.lower() not in sentinels]
        n_null = n_sampled - len(non_null)
        null_pct = (n_null / max(n_sampled, 1)) * 100.0
        n_distinct = len(set(non_null))

        floats = [_try_float(v) for v in non_null]
        valid_floats = [v for v in floats if v is not None]

        if non_null and len(valid_floats) / len(non_null) >= 0.9:
            col_type = "numeric"
            s = sorted(valid_floats)
            p05, p25, p50, p75, p95 = (
                _quantile(s, 0.05),
                _quantile(s, 0.25),
                _quantile(s, 0.50),
                _quantile(s, 0.75),
                _quantile(s, 0.95),
            )
            iqr = p75 - p25
            lo_fence, hi_fence = p25 - 1.5 * iqr, p75 + 1.5 * iqr
            n_out = sum(1 for v in s if v < lo_fence or v > hi_fence) if iqr > 0 else 0
            summary = f"`{p05:.4g}` / `{p50:.4g}` / `{p95:.4g}`"
            out_str = f"{n_out:,} ({(n_out / len(s)) * 100:.1f}%)"
        else:
            col_type = "categorical/text"
            top_val, top_cnt = Counter(non_null).most_common(1)[0] if non_null else ("<all null>", 0)
            safe_top = _sanitize_md(top_val[:24])
            summary = f"`{safe_top}` ({top_cnt:,})"
            out_str = "-"

        print(
            f"| `{col}` | {col_type} | {n_null:,} ({null_pct:.1f}%) | {n_distinct:,} | {summary} | {out_str} |"
        )


def main() -> None:
    parser = argparse.ArgumentParser(description="Deterministic EDA profiler for CSV, TSV, JSONL, and Parquet files.")
    parser.add_argument("path", type=Path, help="Path to input dataset (.csv, .tsv, .jsonl, .parquet)")
    parser.add_argument("--max-rows", type=int, default=100_000, help="Max rows to profile (default: 100000)")
    args = parser.parse_args()
    profile_table(args.path, args.max_rows)


if __name__ == "__main__":
    main()
