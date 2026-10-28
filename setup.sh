#!/usr/bin/env bash
# Sync Global Agent Rules + Skills to Antigravity, Grok Build, OpenCode, Codex, Zed, and ZCode.
# Default: user-global, skips Rust skills. See --help.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RULES_FILE="$REPO_DIR/rules/AGENTS.md"
SKILLS_DIR="$REPO_DIR/skills"

SCOPE="user"          # user | project
MODE="copy"           # copy | link
DRY_RUN=false
FORCE=false
MIRROR_NATIVE=false   # also copy skills into native host dirs (duplicates ~/.agents)
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
  --host LIST        Comma-separated: antigravity,grok,opencode,codex,zed,zcode,portable
                     Default: portable + antigravity always; grok/opencode/codex/zed/zcode if detected
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
  ZCode Desktop      ~/.zcode/skills (rules: ~/.zcode/AGENTS.md)
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

detected_grok() {
    [[ -d "$HOME/.grok" ]] || have_cmd grok
}

detected_opencode() {
    [[ -d "$HOME/.config/opencode" ]] || [[ -d "$HOME/.opencode" ]] || have_cmd opencode
}

detected_codex() {
    [[ -d "$HOME/.codex" ]] || have_cmd codex || [[ -d "/Applications/ChatGPT.app/Contents/Resources/codex-cli" ]]
}

detected_zed() {
    [[ -d "$HOME/.config/zed" ]] || have_cmd zed || [[ -d "/Applications/Zed.app" ]]
}

detected_zcode() {
    [[ -d "$HOME/.zcode" ]] || [[ -d "/Applications/ZCode.app" ]]
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
        grok)     detected_grok || $FORCE ;;
        opencode) detected_opencode || $FORCE ;;
        codex)    detected_codex || $FORCE ;;
        zed)      detected_zed || $FORCE ;;
        zcode)    detected_zcode || $FORCE ;;
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
    if ! $DRY_RUN; then
        mkdir -p "$dest"
    fi
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

write_zed_rules() {
    local dest="$HOME/.config/zed/AGENTS.md"
    if $DRY_RUN; then
        log "  file -> $dest"
        return 0
    fi
    mkdir -p "$(dirname "$dest")"
    if [[ -f "$dest" ]] && ! cmp -s "$dest" "$RULES_FILE"; then
        if grep -q "^## Commit message" "$dest" && ! grep -q "^## Commit message" "$RULES_FILE"; then
            log "    preserving existing ## Commit message section in $dest"
            local custom_part
            custom_part="$(awk '/^## Commit message/{flag=1} flag' "$dest")"
            {
                cat "$RULES_FILE"
                printf '\n\n'
                printf '%s\n' "$custom_part"
            } > "$dest"
            return 0
        fi
    fi
    cp "$RULES_FILE" "$dest"
}

write_opencode_rules() {
    local rules_path="$HOME/.config/opencode/AGENTS.md"
    local config_file="$HOME/.config/opencode/opencode.json"
    if $DRY_RUN; then
        log "  file -> $rules_path"
        return 0
    fi
    mkdir -p "$(dirname "$rules_path")"
    cp "$RULES_FILE" "$rules_path"

    if [[ -f "$config_file" ]]; then
        python3 - "$config_file" "$rules_path" <<'PY'
import json, pathlib, sys
config_path = pathlib.Path(sys.argv[1])
rule_str = sys.argv[2]
try:
    data = json.loads(config_path.read_text(encoding='utf-8'))
    instructions = data.get('instructions', [])
    if rule_str not in instructions:
        instructions.append(rule_str)
        data['instructions'] = instructions
        config_path.write_text(json.dumps(data, indent=2, ensure_ascii=False) + '\n', encoding='utf-8')
except Exception:
    pass
PY
    fi
}

write_zcode_rules() {
    local rules_path="$HOME/.zcode/AGENTS.md"
    if $DRY_RUN; then
        log "  file -> $rules_path"
        return 0
    fi
    mkdir -p "$(dirname "$rules_path")"
    cp "$RULES_FILE" "$rules_path"
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
    # Portable Agent Skills root scanned by Grok, Codex, Zed, and other Agent Skills hosts.
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

    if host_wanted opencode; then
        log "==> [opencode] ~/.config/opencode/AGENTS.md (skills via ~/.agents/skills)"
        write_opencode_rules
        INSTALLED+=("opencode|$HOME/.config/opencode/AGENTS.md|~/.agents/skills")
    elif [[ -z "$HOSTS_FILTER" ]]; then
        log "==> [opencode] skipped (OpenCode not detected)"
    fi

    if host_wanted codex; then
        log "==> [codex] ~/.codex/AGENTS.md (skills via ~/.agents/skills)"
        write_file "$HOME/.codex/AGENTS.md" "$RULES_FILE"
        if $MIRROR_NATIVE; then
            sync_skills "$HOME/.codex/skills"
            INSTALLED+=("codex|$HOME/.codex/AGENTS.md|$HOME/.codex/skills + ~/.agents/skills")
        else
            prune_our_skills "$HOME/.codex/skills"
            INSTALLED+=("codex|$HOME/.codex/AGENTS.md|~/.agents/skills")
        fi
    elif [[ -z "$HOSTS_FILTER" ]]; then
        log "==> [codex] skipped (Codex not detected)"
    fi

    if host_wanted zed; then
        log "==> [zed] ~/.config/zed/AGENTS.md (skills via ~/.agents/skills)"
        write_zed_rules
        INSTALLED+=("zed|$HOME/.config/zed/AGENTS.md|~/.agents/skills")
    elif [[ -z "$HOSTS_FILTER" ]]; then
        log "==> [zed] skipped (Zed not detected; pass --force or --host zed)"
    fi

    if host_wanted zcode; then
        log "==> [zcode] ~/.zcode/AGENTS.md + native skills root"
        write_zcode_rules
        sync_skills "$HOME/.zcode/skills"
        INSTALLED+=("zcode|$HOME/.zcode/AGENTS.md|$HOME/.zcode/skills")
    elif [[ -z "$HOSTS_FILTER" ]]; then
        log "==> [zcode] skipped (ZCode not detected; pass --force or --host zcode)"
    fi
fi

log "========================================================"
if [[ ${#INSTALLED[@]} -eq 0 ]]; then
    log "Nothing installed. Use --force or --host antigravity,grok,opencode,codex,zed,zcode,portable"
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
log "  Codex:       ask which skills are available, /skills, or codex exec 'What skills are installed?'"
log "  Grok Build:  grok inspect"
log "  Zed:         ask which skills are available in the Agent Panel, or /skills"
log "  OpenCode:    opencode debug config"
log "  ZCode:       Settings → Skills, or ask which skills are available"
log "========================================================"
