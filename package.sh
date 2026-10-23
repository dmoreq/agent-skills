#!/usr/bin/env bash
set -e

# Prevent macOS AppleDouble (._*) files from being added to archives
export COPYFILE_DISABLE=1

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DIST_DIR="$REPO_DIR/dist"

mkdir -p "$DIST_DIR"

echo "========================================================"
echo "==> Packaging Agent Skills (tar.gz + zip)"
echo "========================================================"

BUILD_SKILLS=true
BUILD_BUNDLE=true

case "${1:-}" in
    --skills-only)
        BUILD_BUNDLE=false
        ;;
    --bundle-only)
        BUILD_SKILLS=false
        ;;
esac

# 1. Package skills-only archives (dist/skills.tar.gz & dist/skills.zip)
if [ "$BUILD_SKILLS" = true ]; then
    echo "==> Creating skills-only packages: dist/skills.tar.gz & dist/skills.zip"
    tar --exclude='.DS_Store' \
        --exclude='__pycache__' \
        --exclude='*.pyc' \
        -czf "$DIST_DIR/skills.tar.gz" \
        -C "$REPO_DIR/skills" .
    (cd "$REPO_DIR/skills" && zip -rq "$DIST_DIR/skills.zip" . -x "*.DS_Store" "*__pycache__*" "*.pyc")
    SKILLS_SIZE=$(du -h "$DIST_DIR/skills.tar.gz" | cut -f1 | xargs)
    SKILLS_ZIP_SIZE=$(du -h "$DIST_DIR/skills.zip" | cut -f1 | xargs)
    echo "    ✓ Created: $DIST_DIR/skills.tar.gz ($SKILLS_SIZE) & $DIST_DIR/skills.zip ($SKILLS_ZIP_SIZE)"
fi

# 2. Package complete customization suite (dist/agent-skills.tar.gz & dist/agent-skills.zip)
if [ "$BUILD_BUNDLE" = true ]; then
    echo "==> Creating full offline bundles: dist/agent-skills.tar.gz & dist/agent-skills.zip"
    tar --exclude='.git' \
        --exclude='.gitignore' \
        --exclude='.DS_Store' \
        --exclude='.pytest_cache' \
        --exclude='dist' \
        --exclude='__pycache__' \
        --exclude='*.pyc' \
        -czf "$DIST_DIR/agent-skills.tar.gz" \
        -C "$REPO_DIR/.." \
        "$(basename "$REPO_DIR")"
    (cd "$REPO_DIR/.." && zip -rq "$DIST_DIR/agent-skills.zip" "$(basename "$REPO_DIR")" \
        -x "*/.git/*" "*/.gitignore" "*.DS_Store" "*/.pytest_cache/*" "*/dist/*" "*__pycache__*" "*.pyc")
    BUNDLE_SIZE=$(du -h "$DIST_DIR/agent-skills.tar.gz" | cut -f1 | xargs)
    BUNDLE_ZIP_SIZE=$(du -h "$DIST_DIR/agent-skills.zip" | cut -f1 | xargs)
    echo "    ✓ Created: $DIST_DIR/agent-skills.tar.gz ($BUNDLE_SIZE) & $DIST_DIR/agent-skills.zip ($BUNDLE_ZIP_SIZE)"
fi

echo "========================================================"
echo "==> Summary of Generated Packages in $DIST_DIR:"
ls -lh "$DIST_DIR"/*.tar.gz "$DIST_DIR"/*.zip 2>/dev/null || true
echo "========================================================"
