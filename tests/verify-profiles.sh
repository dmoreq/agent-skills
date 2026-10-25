#!/usr/bin/env bash
# Static conformance check: live Hermes profiles vs. the seven-bots provisioning invariants.
# No gateway calls, no network, no model spend. Exit non-zero on any FAIL.
# Run after any change under ~/.hermes/profiles/ (see bots/seven-bots/README.md).
set -uo pipefail

HERMES_ROOT="${HERMES_BRAIN_SRC:-$HOME/.hermes}"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
AGENT_SKILLS_DIR="$REPO_DIR/skills"
MAIN_SKILLS_DIR="$HERMES_ROOT/skills"

# Profile roster and per-profile expectations. Update together with the seven-bots specs.
ALL_PROFILES=(builder conductor critic data-scientist optimizer reporer scout)
OPENCODE_PROFILES=(builder data-scientist optimizer reporer)
# Expected model pin per profile (default provider river/custom). scout rides the
# deepseek direct API as the deliberate fallback-diversity exception (see seven-bots/README.md).
expected_model() {
    case "$1" in
        scout) echo "__SCOUT__" ;;
        *)     echo "deepseek-ai/DeepSeek-V4.1-Flash-1017" ;;
    esac
}

fails=0
fail() { echo "FAIL [$1] $2"; fails=$((fails + 1)); }
pass() { echo "PASS [$1] $2"; }

yaml_scalar() { # yaml_scalar <file> <top-key> <sub-key>
    awk -v top="^$2:" -v subk="^  $3:" '
        $0 ~ top {in_top=1; next}
        in_top && /^[^ #]/ {in_top=0}
        in_top && $0 ~ subk {sub(/\$/, ""); val=$NF; gsub(/"/, "", val); print val; exit}
    ' "$1"
}

external_dirs() { # external_dirs <file>  (only entries directly under skills.external_dirs)
    awk '
        /^  external_dirs:/ {in_ext=1; next}
        in_ext && /^    - / {print $2; next}
        in_ext {in_ext=0}
    ' "$1"
}

toolset_names() { # toolset_names <file>  (only entries directly under platform_toolsets.cli)
    awk '
        /^platform_toolsets:/ {in_pt=1; next}
        in_pt && /^[a-zA-Z_]/ {in_pt=0; in_cli=0; next}
        in_pt && /^  cli:/ {in_cli=1; next}
        in_cli && /^    - / {print $2; next}
        in_cli {in_cli=0}
    ' "$1"
}

known_toolsets() { # union of known_builtin_toolsets + known_plugin_toolsets entries
    awk '
        /^(known_builtin_toolsets|known_plugin_toolsets):/ {in_k=1; next}
        in_k && /^  [a-z_]+:/ {in_sub=1; next}
        in_k && in_sub && /^    - / {print $2; next}
        in_k && in_sub && /^[^ ]/ {in_k=0; in_sub=0}
    ' "$1"
}

known_list="$(known_toolsets "$HERMES_ROOT/config.yaml")"

for profile in "${ALL_PROFILES[@]}"; do
    home="$HERMES_ROOT/profiles/$profile"
    cfg="$home/config.yaml"
    if [[ ! -f "$cfg" ]]; then
        fail "$profile" "config.yaml missing"
        continue
    fi

    # 1. external_dirs coverage
    for want in "$AGENT_SKILLS_DIR" "$MAIN_SKILLS_DIR"; do
        if external_dirs "$cfg" | grep -qx "$want"; then
            pass "$profile" "external_dirs includes $want"
        else
            fail "$profile" "external_dirs missing $want"
        fi
    done

    # 2. model pin
    want_model="$(expected_model "$profile")"
    got_model="$(yaml_scalar "$cfg" model default)"
    got_provider="$(yaml_scalar "$cfg" model provider)"
    if [[ "$want_model" == "__SCOUT__" ]]; then
        # scout: any pin is acceptable as long as the provider is not the shared river relay
        if [[ "$got_provider" == "river" || "$got_provider" == "custom" ]]; then
            fail "$profile" "expected non-river provider for fallback diversity, got $got_provider"
        else
            pass "$profile" "fallback provider pin: $got_provider / ${got_model:-<default>}"
        fi
    elif [[ "$got_model" == "$want_model" && "$got_provider" == "custom" ]]; then
        pass "$profile" "model pin $got_model (custom/river)"
    else
        fail "$profile" "model pin mismatch: want $want_model (custom), got ${got_model:-<unset>} ($got_provider)"
    fi

    # 3. plaintext river key anywhere under the profile home
    leaks="$(grep -rIlE 'rv_[A-Za-z0-9_-]{20,}' "$home" 2>/dev/null | grep -vE '/\.env$|/auth\.json$' || true)"
    if [[ -z "$leaks" ]]; then
        pass "$profile" "no plaintext river key outside .env/auth.json"
    else
        fail "$profile" "plaintext river key in: $(echo "$leaks" | tr '\n' ' ')"
    fi

    # 4. .opencode/opencode.json presence per roster + exact env-reference apiKey
    is_oc=false
    for oc in "${OPENCODE_PROFILES[@]}"; do
        [[ "$oc" == "$profile" ]] && is_oc=true
    done
    if $is_oc; then
        if [[ -f "$home/.opencode/opencode.json" ]]; then
            pass "$profile" ".opencode/opencode.json present"
            got_key="$(python3 - "$home/.opencode/opencode.json" <<'PY'
import json, sys
try:
    d = json.load(open(sys.argv[1]))
    print(d['provider']['river']['options'].get('apiKey', ''))
except Exception as exc:
    print(f'__PARSE_ERROR__:{exc}')
PY
)"
            if [[ "$got_key" == "{env:RIVER_API_KEY}" ]]; then
                pass "$profile" "opencode apiKey is the env reference"
            elif [[ "$got_key" == __PARSE_ERROR__* ]]; then
                fail "$profile" "opencode.json unreadable: ${got_key#__PARSE_ERROR__:}"
            else
                fail "$profile" "opencode apiKey must be exactly {env:RIVER_API_KEY}, got: ${got_key:-<empty>}"
            fi
        else
            fail "$profile" ".opencode/opencode.json missing (opencode-capable profile)"
        fi
    else
        if [[ ! -d "$home/.opencode" ]]; then
            pass "$profile" "no .opencode dir (not opencode-capable)"
        else
            fail "$profile" ".opencode dir present but profile is not in OPENCODE_PROFILES roster"
        fi
    fi

    # 4b. scout needs its own deepseek credential for the non-river pin
    if [[ "$profile" == "scout" ]]; then
        if grep -q "^DEEPSEEK_API_KEY=" "$home/.env" 2>/dev/null; then
            pass "$profile" "DEEPSEEK_API_KEY present in scout .env"
        else
            fail "$profile" "DEEPSEEK_API_KEY missing from scout .env (deepseek-direct pin cannot auth)"
        fi
    fi

    # 5. toolsets subset of known set; an empty parse of the cli list is itself a failure
    ts_list="$(toolset_names "$cfg")"
    if [[ -z "$ts_list" ]]; then
        fail "$profile" "no toolsets parsed from platform_toolsets.cli (malformed block?)"
    else
        while IFS= read -r ts; do
            [[ -z "$ts" ]] && continue
            if grep -qx "$ts" <<<"$known_list"; then
                pass "$profile" "toolset $ts known"
            else
                fail "$profile" "toolset $ts not in known_builtin_toolsets/known_plugin_toolsets"
            fi
        done <<<"$ts_list"
    fi
done

echo
if [[ "$fails" -gt 0 ]]; then
    echo "RESULT: $fails check(s) FAILED"
    exit 1
fi
echo "RESULT: all checks PASSED"
