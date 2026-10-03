#!/usr/bin/env bash
# Sync Global Agent Rules + Skills to Antigravity, Cursor, Pi, Grok Build, Windsurf, Claude, and OpenCode.
# Default: user-global, skips Rust skills. See --help.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RULES_FILE="$REPO_DIR/rules/AGENTS.md"
SKILLS_DIR="$REPO_DIR/skills"

SCOPE="user"          # user | project
MODE="copy"           # copy | link
DRY_RUN=false
FORCE=false
MIRROR_NATIVE=false   # also copy skills into ~/.cursor|~/.grok|~/.pi (duplicates ~/.agents)
HOSTS_FILTER=""       # empty = auto-detect
WITH_RUST=false       # skip Rust skills by default

# Rust skills skipped by default unless --with-rust is passed
RUST_SKILLS=("rust-pro" "rust-async-patterns" "pyo3-maturin")

usage() {
    cat <<'EOF'
Usage: ./setup.sh [options]

Install this repo's rules (AGENTS.md) and skills to coding agents.

Options:
  --project          Install into the current directory (.agents/skills, AGENTS.md)
  --user             Install user-global (default)
  --host LIST        Comma-separated: antigravity,cursor,pi,grok,claude,windsurf,opencode,portable
                     Default: portable + antigravity always; cursor/pi/grok/windsurf/claude if detected
  --with-rust        Include Rust skills (rust-pro, rust-async-patterns, pyo3-maturin). Default: skipped.
  --all              Enable --with-rust and install to all detected hosts.
  --link             Symlink skill folders from this repo (dev). Default is copy.
  --mirror-native    Also copy skills into native host dirs (duplicates ~/.agents/skills; for old hosts)
  --force            Create host dirs even if the product is not detected
  --dry-run          Print destinations; do not write
  -h, --help         Show this help

Canonical skill path (all modern hosts scan it):
  ~/.agents/skills/<name>/SKILL.md

Native extras (hosts that do not reliably use ~/.agents/skills):
  Antigravity IDE    ~/.gemini/config/skills
  Antigravity CLI    ~/.gemini/antigravity-cli/skills
EOF
}

log() { printf '%s\n' "$*"; }
run() {
    if $DRY_RUN; then
        log "  dry-run: $*"
        return 0
    fi
    eval "$@"
}

have_cmd() { command -v "$1" >/dev/null 2>&1; }

detected_antigravity() {
    [[ -d "$HOME/.gemini" ]] || have_cmd agy || have_cmd gemini || have_cmd antigravity
}

detected_cursor() {
    [[ -d "$HOME/.cursor" ]] || have_cmd cursor || have_cmd cursor-agent
}

detected_pi() {
    [[ -d "$HOME/.pi" ]] || have_cmd pi
}

detected_grok() {
    [[ -d "$HOME/.grok" ]] || have_cmd grok
}

detected_windsurf() {
    [[ -d "$HOME/.windsurf" ]] || have_cmd windsurf
}

detected_claude() {
    [[ -d "$HOME/.claude" ]] || have_cmd claude
}

detected_opencode() {
    [[ -d "$HOME/.opencode" ]] || have_cmd opencode
}

is_rust_skill() {
    local name="$1"
    for r in "${RUST_SKILLS[@]}"; do
        [[ "$name" == "$r" ]] && return 0
    done
    return 1
}

host_wanted() {
    local name="$1"
    if [[ -n "$HOSTS_FILTER" ]]; then
        [[ ",$HOSTS_FILTER," == *",$name,"* ]]
        return
    fi
    case "$name" in
        portable|antigravity) return 0 ;;
        cursor)   detected_cursor || $FORCE ;;
        pi)       detected_pi || $FORCE ;;
        grok)     detected_grok || $FORCE ;;
        windsurf) detected_windsurf || $FORCE ;;
        claude)   detected_claude || $FORCE ;;
        opencode) detected_opencode || $FORCE ;;
        *)        return 1 ;;
    esac
}

# Remove this repo's skill names from a dest (keeps unrelated user skills).
prune_our_skills() {
    local dest="$1"
    [[ -d "$dest" ]] || return 0
    local skill name
    for skill in "$SKILLS_DIR"/*; do
        [[ -d "$skill" ]] || continue
        name="$(basename "$skill")"
        if $DRY_RUN; then
            log "  prune $dest/$name"
            continue
        fi
        rm -rf "$dest/$name"
    done
}

# Overwrite only skill folders shipped by this repo. Other skills stay.
sync_skills() {
    local dest="$1"
    mkdir -p "$dest"
    local skill name dest_skill
    for skill in "$SKILLS_DIR"/*; do
        [[ -d "$skill" ]] || continue
        name="$(basename "$skill")"
        dest_skill="$dest/$name"

        if ! $WITH_RUST && is_rust_skill "$name"; then
            # Clean up previously installed Rust skill if now skipping
            if [[ -e "$dest_skill" ]] || [[ -L "$dest_skill" ]]; then
                if $DRY_RUN; then
                    log "  prune skipped rust skill $name from $dest"
                else
                    rm -rf "$dest_skill"
                fi
            fi
            continue
        fi

        if $DRY_RUN; then
            log "  skill $name -> $dest_skill"
            continue
        fi
        rm -rf "$dest_skill"
        if [[ "$MODE" == "link" ]]; then
            ln -s "$skill" "$dest_skill"
        else
            cp -R "$skill" "$dest_skill"
        fi
    done
}

write_file() {
    local dest="$1"
    local src="$2"
    if $DRY_RUN; then
        log "  file -> $dest"
        return 0
    fi
    mkdir -p "$(dirname "$dest")"
    cp "$src" "$dest"
}

write_cursor_mdc() {
    local dest="$1"
    if $DRY_RUN; then
        log "  mdc  -> $dest"
        return 0
    fi
    mkdir -p "$(dirname "$dest")"
    {
        printf '%s\n' '---'
        printf '%s\n' 'description: Global agent working style, safety, and verification rules.'
        printf '%s\n' 'alwaysApply: true'
        printf '%s\n' '---'
        printf '\n'
        cat "$RULES_FILE"
    } > "$dest"
}

# Remove a previous copy of this repo's rules if it is a byte-identical leftover.
maybe_remove_old_rules() {
    local path="$1"
    [[ -f "$path" ]] || return 0
    if $DRY_RUN; then
        log "  consider removing leftover $path"
        return 0
    fi
    if cmp -s "$path" "$RULES_FILE"; then
        rm -f "$path"
        log "    removed leftover identical $path"
    fi
}

skill_count() {
    local n=0
    local d name
    for d in "$SKILLS_DIR"/*; do
        [[ -d "$d" ]] || continue
        name="$(basename "$d")"
        if ! $WITH_RUST && is_rust_skill "$name"; then
            continue
        fi
        n=$((n + 1))
    done
    printf '%s' "$n"
}

# --- args ---
while [[ $# -gt 0 ]]; do
    case "$1" in
        --project) SCOPE="project"; shift ;;
        --user)    SCOPE="user"; shift ;;
        --host)    HOSTS_FILTER="${2:-}"; shift 2 ;;
        --host=*)  HOSTS_FILTER="${1#--host=}"; shift ;;
        --with-rust) WITH_RUST=true; shift ;;
        --without-rust) WITH_RUST=false; shift ;;
        --all)     WITH_RUST=true; shift ;;
        --link)    MODE="link"; shift ;;
        --mirror-native) MIRROR_NATIVE=true; shift ;;
        --force)   FORCE=true; shift ;;
        --dry-run) DRY_RUN=true; shift ;;
        -h|--help) usage; exit 0 ;;
        *)
            log "Unknown option: $1"
            usage
            exit 1
            ;;
    esac
done

HOSTS_FILTER="$(printf '%s' "$HOSTS_FILTER" | tr 'A-Z' 'a-z' | tr -d ' ')"

if [[ ! -f "$RULES_FILE" ]]; then
    log "Missing $RULES_FILE"
    exit 1
fi
if [[ ! -d "$SKILLS_DIR" ]]; then
    log "Missing $SKILLS_DIR"
    exit 1
fi

N_SKILLS="$(skill_count)"

log "========================================================"
log "==> Agent Skills Setup"
log "    repo:        $REPO_DIR"
log "    scope:       $SCOPE"
log "    mode:        $MODE"
log "    skills:      $N_SKILLS"
if $WITH_RUST; then
    log "    rust skills: enabled (rust-pro, rust-async-patterns, pyo3-maturin)"
else
    log "    rust skills: skipped by default (pass --with-rust to enable)"
fi
$DRY_RUN && log "    dry-run:     yes"
log "========================================================"

INSTALLED=()

if [[ "$SCOPE" == "project" ]]; then
    PROJECT_SKILLS="$PWD/.agents/skills"
    PROJECT_AGENTS="$PWD/AGENTS.md"
    log "==> Project scope ($PWD)"
    log "    skills -> $PROJECT_SKILLS"
    log "    rules  -> $PROJECT_AGENTS"
    if ! $DRY_RUN; then
        mkdir -p "$PROJECT_SKILLS"
    fi
    sync_skills "$PROJECT_SKILLS"
    write_file "$PROJECT_AGENTS" "$RULES_FILE"
    INSTALLED+=("project|$PROJECT_AGENTS|$PROJECT_SKILLS")
else
    # Portable Agent Skills root. Cursor, Pi, Grok, Windsurf, Claude, and Antigravity 2.0 scan this.
    if host_wanted portable; then
        DEST="$HOME/.agents/skills"
        log "==> [portable] ~/.agents/skills"
        sync_skills "$DEST"
        INSTALLED+=("portable|-|$DEST")
    fi

    if host_wanted antigravity; then
        log "==> [antigravity] IDE + CLI"
        write_file "$HOME/.gemini/GEMINI.md" "$RULES_FILE"
        sync_skills "$HOME/.gemini/config/skills"
        sync_skills "$HOME/.gemini/antigravity-cli/skills"
        INSTALLED+=("antigravity|$HOME/.gemini/GEMINI.md|$HOME/.gemini/config/skills + ~/.gemini/antigravity-cli/skills")
    elif [[ -z "$HOSTS_FILTER" ]]; then
        log "==> [antigravity] skipped (no ~/.gemini, agy, or gemini; pass --force or --host antigravity)"
    fi

    if host_wanted cursor; then
        log "==> [cursor] alwaysApply .mdc rule (skills via ~/.agents/skills)"
        write_cursor_mdc "$HOME/.cursor/rules/agent-rules.mdc"
        if $DRY_RUN; then
            log "  remove leftover $HOME/.cursor/rules/GEMINI.md"
        else
            rm -f "$HOME/.cursor/rules/GEMINI.md"
        fi
        if $MIRROR_NATIVE; then
            sync_skills "$HOME/.cursor/skills"
            INSTALLED+=("cursor|$HOME/.cursor/rules/agent-rules.mdc|$HOME/.cursor/skills + ~/.agents/skills")
        else
            prune_our_skills "$HOME/.cursor/skills"
            INSTALLED+=("cursor|$HOME/.cursor/rules/agent-rules.mdc|~/.agents/skills")
        fi
    elif [[ -z "$HOSTS_FILTER" ]]; then
        log "==> [cursor] skipped (Cursor not detected)"
    fi

    if host_wanted pi; then
        log "==> [pi] ~/.pi/agent/AGENTS.md (skills via ~/.agents/skills)"
        write_file "$HOME/.pi/agent/AGENTS.md" "$RULES_FILE"
        maybe_remove_old_rules "$HOME/.pi/agent/APPEND_SYSTEM.md"
        if $MIRROR_NATIVE; then
            sync_skills "$HOME/.pi/agent/skills"
            INSTALLED+=("pi|$HOME/.pi/agent/AGENTS.md|$HOME/.pi/agent/skills + ~/.agents/skills")
        else
            prune_our_skills "$HOME/.pi/agent/skills"
            INSTALLED+=("pi|$HOME/.pi/agent/AGENTS.md|~/.agents/skills")
        fi
    elif [[ -z "$HOSTS_FILTER" ]]; then
        log "==> [pi] skipped (Pi not detected)"
    fi

    if host_wanted grok; then
        log "==> [grok] ~/.grok/AGENTS.md (skills via ~/.agents/skills)"
        write_file "$HOME/.grok/AGENTS.md" "$RULES_FILE"
        if $MIRROR_NATIVE; then
            sync_skills "$HOME/.grok/skills"
            INSTALLED+=("grok|$HOME/.grok/AGENTS.md|$HOME/.grok/skills + ~/.agents/skills")
        else
            prune_our_skills "$HOME/.grok/skills"
            INSTALLED+=("grok|$HOME/.grok/AGENTS.md|~/.agents/skills")
        fi
    elif [[ -z "$HOSTS_FILTER" ]]; then
        log "==> [grok] skipped (Grok not detected)"
    fi

    if host_wanted windsurf; then
        log "==> [windsurf] ~/.windsurf/rules/agent-rules.md (skills via ~/.agents/skills)"
        write_file "$HOME/.windsurf/rules/agent-rules.md" "$RULES_FILE"
        INSTALLED+=("windsurf|$HOME/.windsurf/rules/agent-rules.md|~/.agents/skills")
    fi

    if host_wanted claude; then
        log "==> [claude] rules and skills via ~/.agents/skills"
        INSTALLED+=("claude|-|~/.agents/skills")
    fi

    if host_wanted opencode; then
        log "==> [opencode] rules and skills via ~/.agents/skills"
        INSTALLED+=("opencode|-|~/.agents/skills")
    fi
fi

log "========================================================"
if [[ ${#INSTALLED[@]} -eq 0 ]]; then
    log "Nothing installed. Use --force or --host antigravity,cursor,pi,grok,portable"
    exit 1
fi
log "Done. Restart each agent session so it re-scans skills."
log ""
log "Host         Rules                                      Skills"
for row in "${INSTALLED[@]}"; do
    IFS='|' read -r host rules skills <<<"$row"
    printf '  %-12s %-43s %s\n' "$host" "$rules" "$skills"
done
log "========================================================"
log "Verify:"
log "  Antigravity: ask which skills are available, or /skills"
log "  Grok Build:  grok inspect"
log "  Cursor:      Settings → Skills"
log "  Pi:          /skill:python-pro  (after restart)"
log "========================================================"
