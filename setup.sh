#!/usr/bin/env bash
set -e

# Unified AI Agents Customizations Setup Script
# Installs and syncs Global Rules and Skills across:
# 1. Google Antigravity (~/.gemini)
# 2. Cursor (~/.cursor)
# 3. Pi Agent (~/.pi)
# 4. Grok CLI (~/.grok)

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RULES_FILE="$REPO_DIR/rules/GEMINI.md"
SKILLS_DIR="$REPO_DIR/skills"

sync_skills() {
    local dest="$1"
    mkdir -p "$dest"
    # Overwrite only skills shipped by this repo. Extra user skills are left intact.
    for skill in "$SKILLS_DIR"/*; do
        [ -d "$skill" ] || continue
        local name
        name="$(basename "$skill")"
        rm -rf "$dest/$name"
        cp -R "$skill" "$dest/$name"
    done
}

echo "========================================================"
echo "==> Setting up Unified AI Agent Customizations..."
echo "========================================================"

# ------------------------------------------------------------------
# 1. Google Antigravity Setup
# ------------------------------------------------------------------
DEST_GEMINI="$HOME/.gemini"
DEST_GEMINI_SKILLS="$DEST_GEMINI/config/skills"

echo "==> [1/4] Syncing to Google Antigravity (~/.gemini)..."
mkdir -p "$DEST_GEMINI" "$DEST_GEMINI_SKILLS"
cp "$RULES_FILE" "$DEST_GEMINI/GEMINI.md"
sync_skills "$DEST_GEMINI_SKILLS"
echo "    ✓ Antigravity rules & skills updated."

# ------------------------------------------------------------------
# 2. Cursor Setup
# ------------------------------------------------------------------
DEST_CURSOR="$HOME/.cursor"
DEST_CURSOR_RULES="$DEST_CURSOR/rules"
DEST_CURSOR_SKILLS="$DEST_CURSOR/skills"

if [ -d "$DEST_CURSOR" ]; then
    echo "==> [2/4] Syncing to Cursor (~/.cursor)..."
    mkdir -p "$DEST_CURSOR_RULES" "$DEST_CURSOR_SKILLS"
    rm -rf "$DEST_CURSOR"/skills-pruned-* 2>/dev/null || true
    cp "$RULES_FILE" "$DEST_CURSOR_RULES/GEMINI.md"
    sync_skills "$DEST_CURSOR_SKILLS"
    echo "    ✓ Cursor rules & skills updated."
else
    echo "==> [2/4] Skipping Cursor (~/.cursor not found)."
fi

# ------------------------------------------------------------------
# 3. Pi Agent Setup
# ------------------------------------------------------------------
DEST_PI="$HOME/.pi/agent"
DEST_PI_SKILLS="$DEST_PI/skills"

if [ -d "$HOME/.pi" ]; then
    echo "==> [3/4] Syncing to Pi Agent (~/.pi)..."
    mkdir -p "$DEST_PI" "$DEST_PI_SKILLS"
    cp "$RULES_FILE" "$DEST_PI/APPEND_SYSTEM.md"
    sync_skills "$DEST_PI_SKILLS"
    echo "    ✓ Pi system prompt & skills updated."
else
    echo "==> [3/4] Skipping Pi (~/.pi not found)."
fi

# ------------------------------------------------------------------
# 4. Grok CLI Setup
# ------------------------------------------------------------------
DEST_GROK="$HOME/.grok"
DEST_GROK_SKILLS="$DEST_GROK/skills"

if [ -d "$DEST_GROK" ] || command -v grok &> /dev/null; then
    echo "==> [4/4] Syncing to Grok CLI (~/.grok)..."
    mkdir -p "$DEST_GROK" "$DEST_GROK_SKILLS"
    cp "$RULES_FILE" "$DEST_GROK/AGENTS.md"
    sync_skills "$DEST_GROK_SKILLS"
    echo "    ✓ Grok global rules (AGENTS.md) & skills updated."
else
    echo "==> [4/4] Skipping Grok (~/.grok not found)."
fi

echo "========================================================"
echo "==> All AI agents are now synchronized with unified skills!"
echo "========================================================"
