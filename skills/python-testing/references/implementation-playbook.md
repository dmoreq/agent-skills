# Python Testing Recipes

Load this file only for a concrete pytest snippet. Policy lives in `SKILL.md`.
Do not add coverage percentage gates. One **behavior** per test, not one assert.

## Parametrize

```python
import pytest

@pytest.mark.parametrize(
    "email,expected",
    [
        ("user@example.com", True),
        ("invalid", False),
    ],
)
def test_email_validation(email, expected):
    assert is_valid_email(email) is expected
```

## Fixture with teardown

```python
import pytest

@pytest.fixture
def db():
    database = Database("sqlite:///:memory:")
    database.connect()
    yield database
    database.disconnect()


def test_query_returns_row(db):
    rows = db.query("SELECT 1")
    assert rows == [{"n": 1}]
```

## Mock an HTTP boundary

```python
from unittest.mock import Mock, patch
import requests

def test_get_user_not_found():
    client = APIClient("https://api.example.com")
    response = Mock()
    response.raise_for_status.side_effect = requests.HTTPError("404")
    with patch("requests.get", return_value=response):
        with pytest.raises(requests.HTTPError):
            client.get_user(999)
```

## Async (pytest-asyncio)

```python
import pytest
import asyncio

@pytest.mark.asyncio
async def test_fetch_completes_when_event_set():
    ready = asyncio.Event()

    async def worker():
        await ready.wait()
        return "ok"

    task = asyncio.create_task(worker())
    ready.set()
    assert await task == "ok"
```

Do not use `asyncio.sleep` as an assertion.

## Exceptions

```python
import pytest

def test_divide_rejects_zero():
    with pytest.raises(ZeroDivisionError, match="zero"):
        divide(1, 0)
```

## Layout

```text
tests/
  conftest.py
  test_unit/
  test_integration/
```

Prefer `pyproject.toml` `[tool.pytest.ini_options]` over a separate `pytest.ini`. Markers (`slow`, `integration`) are fine; do not fail CI on an invented coverage number.
