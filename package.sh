#!/usr/bin/env bash
set -e

# Prevent macOS AppleDouble (._*) files from being added to tar archives
export COPYFILE_DISABLE=1

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DIST_DIR="$REPO_DIR/dist"

mkdir -p "$DIST_DIR"

echo "========================================================"
echo "==> Packaging Antigravity Customizations & Skills"
echo "========================================================"

BUILD_SKILLS=true
BUILD_BUNDLE=true

case "$1" in
    --skills-only)
        BUILD_BUNDLE=false
        ;;
    --bundle-only)
        BUILD_SKILLS=false
        ;;
esac

# 1. Package skills-only archive (dist/skills.tar.gz)
if [ "$BUILD_SKILLS" = true ]; then
    echo "==> Creating skills-only package: dist/skills.tar.gz"
    tar --exclude='.DS_Store' \
        --exclude='__pycache__' \
        --exclude='*.pyc' \
        -czf "$DIST_DIR/skills.tar.gz" \
        -C "$REPO_DIR/skills" .
    SKILLS_SIZE=$(du -h "$DIST_DIR/skills.tar.gz" | cut -f1 | xargs)
    echo "    ✓ Created: $DIST_DIR/skills.tar.gz ($SKILLS_SIZE)"
fi

# 2. Package complete customization suite (dist/antigravity-customizations.tar.gz)
if [ "$BUILD_BUNDLE" = true ]; then
    echo "==> Creating full offline bundle: dist/antigravity-customizations.tar.gz"
    tar --exclude='.git' \
        --exclude='.gitignore' \
        --exclude='.DS_Store' \
        --exclude='dist' \
        --exclude='vigeors' \
        --exclude='__pycache__' \
        --exclude='*.pyc' \
        -czf "$DIST_DIR/antigravity-customizations.tar.gz" \
        -C "$REPO_DIR/.." \
        "$(basename "$REPO_DIR")"
    BUNDLE_SIZE=$(du -h "$DIST_DIR/antigravity-customizations.tar.gz" | cut -f1 | xargs)
    echo "    ✓ Created: $DIST_DIR/antigravity-customizations.tar.gz ($BUNDLE_SIZE)"
fi

echo "========================================================"
echo "==> Summary of Generated Packages in $DIST_DIR:"
ls -lh "$DIST_DIR"/*.tar.gz
echo "========================================================"
echo ""
echo "Instructions for Target Computer (Offline / No GitHub):"
echo ""
echo "[Option 1: Full Suite (Antigravity, Cursor, Pi, Grok)]"
echo "  1. Copy 'antigravity-customizations.tar.gz' to target machine"
echo "  2. Extract and run installer:"
echo "       tar -xzf antigravity-customizations.tar.gz"
echo "       cd antigravity-customizations"
echo "       ./setup.sh"
echo ""
echo "[Option 2: Skills Only (portable + Antigravity)]"
echo "  1. Copy 'skills.tar.gz' to target machine"
echo "  2. Extract to the portable Agent Skills root (Cursor/Pi/Grok/AGY 2.0):"
echo "       mkdir -p ~/.agents/skills"
echo "       tar -xzf skills.tar.gz -C ~/.agents/skills"
echo "  3. Also extract for Antigravity IDE + CLI:"
echo "       mkdir -p ~/.gemini/config/skills ~/.gemini/antigravity-cli/skills"
echo "       tar -xzf skills.tar.gz -C ~/.gemini/config/skills"
echo "       tar -xzf skills.tar.gz -C ~/.gemini/antigravity-cli/skills"
echo ""
echo "[Option 3: Skills Only (Project-specific / Workspace)]"
echo "  1. Extract into your target project repository:"
echo "       mkdir -p <project-root>/.agents/skills"
echo "       tar -xzf skills.tar.gz -C <project-root>/.agents/skills"
echo "========================================================"
