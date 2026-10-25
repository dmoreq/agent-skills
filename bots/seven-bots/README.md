# Seven Bots — provisioning notes

The files in this directory (`common.md` + one persona per bot) are **behavior specs**.
They are not executed by any generator: the live profiles under `~/.hermes/profiles/`
are provisioned manually, and this repo has no script that creates or updates them.

## Roster

| Spec file | Hermes profile | Role |
|---|---|---|
| `common.md` | (shared contract) | authority, task handoff, execution, review rules |
| `conductor.md` | conductor | Chief of Staff; scopes work, owns kanban admission, Telegram-facing |
| `builder.md` | builder | smallest correct implementation; OpenCode for bounded multi-file work |
| `critic.md` | critic | independent review; kanban review lane always preloads `sdlc-review` |
| `data-scientist.md` | data-scientist | analysis and measurement |
| `optimizer.md` | optimizer | performance tuning |
| `reporer.md` | reporer | report assembly (name kept as-is everywhere; do not rename) |
| `scout.md` | scout | reconnaissance; pinned to the deepseek direct API (not the shared river relay) as the fallback-diversity exception |

## Invariants (enforced by `tests/verify-profiles.sh`)

Run from the repo root after any profile change:

```sh
./tests/verify-profiles.sh
```

Checks, per profile: `skills.external_dirs` includes both the agent-skills skills dir and
`~/.hermes/skills`; model pin matches the roster (scout exempt — must not ride the shared
river relay; DEEPSEEK_API_KEY lives in the scout profile's own `.env`);
no plaintext `rv_` key outside `.env`/`auth.json`; `.opencode/opencode.json` presence
matches the opencode-capable roster (builder, data-scientist, optimizer, reporer);
toolset entries are known builtin/plugin toolsets. Exit non-zero on any failure.

## History notes

- A Docker-sandbox terminal backend for the opencode path was provisioned once
  (`patch_profile.py`, `cfg_predocker_*` snapshots under `~/.hermes/cache/scratch/oc-baseline/`)
  and reverted to `backend: local` with the `opencode-host.sh` wrapper approach.
- Integration of OpenCode was validated per profile on 2026-10-24 via
  `LOCAL_OK_<profile>` probes in `~/.local/share/opencode/opencode.db`.
