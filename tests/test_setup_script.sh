#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "==> Running test_setup_script.sh"

# Test 1: Default dry-run must skip Rust skills
OUT_DEFAULT="$("$REPO_DIR/setup.sh" --dry-run)"

if echo "$OUT_DEFAULT" | grep -q "skill rust-pro ->"; then
    echo "FAIL: rust-pro was synced by default!"
    exit 1
fi
if echo "$OUT_DEFAULT" | grep -q "skill rust-async-patterns ->"; then
    echo "FAIL: rust-async-patterns was synced by default!"
    exit 1
fi
if echo "$OUT_DEFAULT" | grep -q "skill pyo3-maturin ->"; then
    echo "FAIL: pyo3-maturin was synced by default!"
    exit 1
fi

if ! echo "$OUT_DEFAULT" | grep -q "skill code-minimalism ->"; then
    echo "FAIL: code-minimalism was not synced!"
    exit 1
fi
if ! echo "$OUT_DEFAULT" | grep -q "skill verify-and-stop ->"; then
    echo "FAIL: verify-and-stop was not synced!"
    exit 1
fi

echo "  ✓ Default setup skips Rust skills and includes new core skills"

# Test 2: Dry-run with --with-rust must sync Rust skills
OUT_RUST="$("$REPO_DIR/setup.sh" --dry-run --with-rust)"

if ! echo "$OUT_RUST" | grep -q "skill rust-pro ->"; then
    echo "FAIL: rust-pro was not synced with --with-rust!"
    exit 1
fi
if ! echo "$OUT_RUST" | grep -q "skill rust-async-patterns ->"; then
    echo "FAIL: rust-async-patterns was not synced with --with-rust!"
    exit 1
fi
if ! echo "$OUT_RUST" | grep -q "skill pyo3-maturin ->"; then
    echo "FAIL: pyo3-maturin was not synced with --with-rust!"
    exit 1
fi

echo "  ✓ --with-rust flag correctly syncs Rust skills"

# Test 3: Codex host detection and dry-run targets
OUT_CODEX="$("$REPO_DIR/setup.sh" --dry-run --host codex)"

if ! echo "$OUT_CODEX" | grep -q "file -> .*/\.codex/AGENTS.md"; then
    echo "FAIL: codex AGENTS.md was not targeted by setup.sh!"
    exit 1
fi

if ! echo "$OUT_CODEX" | grep -q "codex *.*\.codex/AGENTS.md"; then
    echo "FAIL: codex was not listed in installed summary table!"
    exit 1
fi

echo "  ✓ Codex host detection and AGENTS.md installation verified"

# Test 4: DeepSeek Harness host detection and dry-run targets
OUT_DSH="$("$REPO_DIR/setup.sh" --dry-run --host dsh --mirror-native)"

if ! echo "$OUT_DSH" | grep -q "file -> .*/\.dsh/AGENTS.md"; then
    echo "FAIL: DSH AGENTS.md was not targeted by setup.sh!"
    exit 1
fi

if ! echo "$OUT_DSH" | grep -q "skill code-minimalism -> .*/\.dsh/skills/code-minimalism"; then
    echo "FAIL: DSH native skills root was not targeted by setup.sh!"
    exit 1
fi

if ! echo "$OUT_DSH" | grep -q "dsh *.*\.dsh/AGENTS.md"; then
    echo "FAIL: dsh was not listed in installed summary table!"
    exit 1
fi

echo "  ✓ DeepSeek Harness host detection and AGENTS.md installation verified"

# Test 5: Hermes composes SOUL.md and does not copy skills into ~/.hermes/skills
OUT_HERMES="$("$REPO_DIR/setup.sh" --dry-run --host hermes)"

if ! echo "$OUT_HERMES" | grep -q "file -> .*/\\.hermes/SOUL.md"; then
    echo "FAIL: Hermes SOUL.md was not targeted by setup.sh!"
    exit 1
fi

if echo "$OUT_HERMES" | grep -q "skill .* -> .*/\\.hermes/skills"; then
    echo "FAIL: Hermes host copied skills into ~/.hermes/skills!"
    exit 1
fi

if ! echo "$OUT_HERMES" | grep -q "hermes *.*SOUL.md"; then
    echo "FAIL: hermes was not listed in the installed summary table!"
    exit 1
fi

TMP_HOME="$(mktemp -d)"
env -u HERMES_HOME HOME="$TMP_HOME" "$REPO_DIR/setup.sh" --host hermes >/dev/null
python3 - "$TMP_HOME" "$REPO_DIR" <<'PY'
import sys
from pathlib import Path

home = Path(sys.argv[1])
repo = Path(sys.argv[2])
soul = (home / ".hermes" / "SOUL.md").read_text(encoding="utf-8")
rules = (repo / "rules" / "AGENTS.md").read_text(encoding="utf-8").strip()
preamble = (repo / "rules" / "hermes-preamble.md").read_text(encoding="utf-8").strip()
if not soul.startswith(preamble):
    raise SystemExit("FAIL: SOUL.md does not start with hermes-preamble.md")
if not soul.rstrip().endswith(rules):
    raise SystemExit("FAIL: SOUL.md does not end with rules/AGENTS.md")
if "one-line question" in soul:
    raise SystemExit("FAIL: SOUL.md still conflicts with the Vietnamese TL;DR rule")
if len(soul) >= 20000:
    raise SystemExit(f"FAIL: SOUL.md is {len(soul)} chars, at or over the 20000 cap")
if (home / ".hermes" / "skills").exists():
    raise SystemExit("FAIL: Hermes install created ~/.hermes/skills")
print(f"  composed SOUL.md chars={len(soul)}")
PY
rm -rf "$TMP_HOME"

echo "  ✓ Hermes SOUL.md composition verified"

# Test 6: Hermes with --mirror-native targets ~/.hermes/skills and skips Rust skills
OUT_HERMES_NATIVE="$("$REPO_DIR/setup.sh" --dry-run --host hermes --mirror-native)"

if ! echo "$OUT_HERMES_NATIVE" | grep -q "skill code-minimalism -> .*/\\.hermes/skills/code-minimalism"; then
    echo "FAIL: Hermes native skills root was not targeted by setup.sh --mirror-native!"
    exit 1
fi

if echo "$OUT_HERMES_NATIVE" | grep -q "skill rust-pro -> .*/\\.hermes/skills/rust-pro"; then
    echo "FAIL: rust-pro was synced to hermes without --with-rust!"
    exit 1
fi

echo "  ✓ Hermes --mirror-native targets ~/.hermes/skills and excludes Rust skills"

# Test 7: Zed host detection and dry-run targets
OUT_ZED="$("$REPO_DIR/setup.sh" --dry-run --host zed)"

if ! echo "$OUT_ZED" | grep -q "file -> .*/\\.config/zed/AGENTS.md"; then
    echo "FAIL: Zed AGENTS.md was not targeted by setup.sh!"
    exit 1
fi

if ! echo "$OUT_ZED" | grep -q "zed *.*\\.config/zed/AGENTS.md"; then
    echo "FAIL: zed was not listed in installed summary table!"
    exit 1
fi

echo "  ✓ Zed host detection and AGENTS.md installation verified"

echo "==> All setup script tests passed!"
