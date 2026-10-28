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

# Test 4: Grok host detection and dry-run targets
OUT_GROK="$("$REPO_DIR/setup.sh" --dry-run --host grok)"

if ! echo "$OUT_GROK" | grep -q "file -> .*/\.grok/AGENTS.md"; then
    echo "FAIL: Grok AGENTS.md was not targeted by setup.sh!"
    exit 1
fi

if ! echo "$OUT_GROK" | grep -q "grok *.*\.grok/AGENTS.md"; then
    echo "FAIL: grok was not listed in installed summary table!"
    exit 1
fi

echo "  ✓ Grok host detection and AGENTS.md installation verified"

# Test 5: Hermes host support is removed
if OUT_REMOVED="$("$REPO_DIR/setup.sh" --dry-run --host hermes 2>&1)"; then
    echo "FAIL: --host hermes was accepted after Hermes support removal!"
    exit 1
fi

if ! echo "$OUT_REMOVED" | grep -q "Nothing installed"; then
    echo "FAIL: unexpected output for --host hermes!"
    exit 1
fi

echo "  ✓ Hermes host support removed"

# Test 6: Zed host detection and dry-run targets
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
