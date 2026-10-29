"""Regression tests for the EDA profiler."""
from __future__ import annotations

import importlib.util
import io
from pathlib import Path
import subprocess
import sys
import typing

SCRIPT = (
    Path(__file__).resolve().parent.parent
    / "skills"
    / "data-science"
    / "scripts"
    / "eda_profile.py"
)
SPEC = importlib.util.spec_from_file_location("eda_profile", SCRIPT)
assert SPEC and SPEC.loader
eda = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(eda)


def test_total_rows_is_unknown_when_sample_is_capped():
    """A capped sample must not be reported as the total row count."""
    cols, rows, total = eda._read_delimited_sample(io.StringIO("a,b\n1,x\n2,y\n3,z\n"), ",", 1)
    assert cols == ["a", "b"]
    assert len(rows) == 1
    assert total is None

    cols, rows, total = eda._read_jsonl_sample(
        io.StringIO('{"a": "1"}\n{"a": "2"}\n{"a": "3"}\n'), 1
    )
    assert cols == ["a"]
    assert len(rows) == 1
    assert total is None


def test_total_rows_is_exact_when_sample_fits():
    cols, rows, total = eda._read_delimited_sample(io.StringIO("a,b\n1,x\n2,y\n"), ",", 10)
    assert cols == ["a", "b"]
    assert len(rows) == 2
    assert total == 2


def test_profile_table_reports_sample_cap(tmp_path, capsys):
    data = tmp_path / "three.csv"
    data.write_text("a,b\n1,x\n2,y\n3,z\n", encoding="utf-8")
    eda.profile_table(data, max_rows=1)
    output = capsys.readouterr().out
    assert "Total Rows**: unknown (sample-capped)" in output
    assert "Profiled sample: 1" in output


def test_profile_table_sanitizes_columns_and_filename(tmp_path, capsys):
    data = tmp_path / "evil&file.csv"
    data.write_text("a|b,c\n1,x\n", encoding="utf-8")
    eda.profile_table(data)
    output = capsys.readouterr().out
    assert "evil&amp;file.csv" in output
    assert "a\\|b" in output
    assert "`a|b`" not in output


def test_profile_table_rejects_non_positive_max_rows(tmp_path):
    data = tmp_path / "one.csv"
    data.write_text("a\n1\n", encoding="utf-8")
    try:
        eda.profile_table(data, max_rows=0)
    except SystemExit as error:
        assert error.code == 1
    else:
        raise AssertionError("profile_table accepted max_rows=0")


def test_cli_rejects_non_positive_max_rows(tmp_path):
    data = tmp_path / "one.csv"
    data.write_text("a\n1\n", encoding="utf-8")
    result = subprocess.run(
        [sys.executable, str(SCRIPT), str(data), "--max-rows", "0"],
        capture_output=True,
        text=True,
        check=False,
        timeout=60,
    )
    assert result.returncode == 2
    assert "must be >= 1" in result.stderr


def test_all_type_hints_resolve():
    """Undefined annotations such as Any must fail here, not at introspection time."""
    for name, value in vars(eda).items():
        if callable(value) and getattr(value, "__module__", "") == eda.__name__:
            typing.get_type_hints(value)
