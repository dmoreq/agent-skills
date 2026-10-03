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

echo "==> All setup script tests passed!"
