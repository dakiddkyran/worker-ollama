# Claude Code dev toolkit

Installed at user scope, so it applies to every project opened in the environment. Routing rules live in `~/.claude/CLAUDE.md` (source: `CLAUDE.global.md`). `install.sh` rebuilds everything idempotently. Cloud containers are ephemeral, so the environment's setup script runs it on each fresh container.

## Tools

| # | Tool | Source (commit) | Installed as | Location | Activation |
|---|---|---|---|---|---|
| 1 | Impeccable 4.10.0 | pbakaus/impeccable `b49177d` | plugin | `~/.claude/plugins/cache/impeccable` | Skill auto-selected for UI audits; hooks on Edit/Write/Stop check UI files |
| 2 | UI/UX Pro Max 2.15.0 | nextlevelbuilder/ui-ux-pro-max-skill `2de1134` | plugin | `…/cache/ui-ux-pro-max-skill` | Skill auto-selected for new UI/redesigns |
| 3 | Ponytail 5.3.3 | DietrichGebert/ponytail `96608e0` | plugin | `…/cache/ponytail` | SessionStart hook, always on (~3 KB) |
| 4 | Humanizer 0.8.4 | Aboudjem/humanizer-skill `ae6ce56` | plugin | `…/cache/humanizer` | Skill auto-selected for prose |
| 5 | Last 30 Days 4.3.2 | mvanhorn/last30days-skill `2623916` | plugin | `…/cache/last30days-skill` | Skill auto-selected for recency questions |
| 6 | Scrapling 0.5.1 | D4Vinci/Scrapling `2998c9e` | pip venv + skill | `~/.local/share/scrapling-venv`, `~/.local/bin/scrapling`, `~/.claude/skills/scrapling-official` | Skill, only when an API or simple fetch won't do |
| 7 | Diagram Design 2.6.168 | cathrynlavery/diagram-design `d74d8c2` | plugin | `…/cache/diagram-design` | Skill auto-selected for architecture visuals |
| 8 | Caveman 4.1.0 | **JuliusBrussee/caveman** `a192894` (see note) | plugin | `…/cache/caveman`, `~/.config/caveman/config.json` | **Off by default**; `/caveman` to opt in |
| 9 | Superpowers 7.0.2 | obra/superpowers `22f0b46` | plugin | `…/cache/superpowers-dev` | SessionStart hook (~3.6 KB) + skills |
| 10 | Claude-Mem 16.0.1 | thedotmack/claude-mem `c0f37d6` | plugin + local worker (Bun, port 37700) | `~/.claude/plugins/marketplaces/thedotmack`, data in `~/.claude-mem` | Automatic hooks; per-project memory |

**Caveman note:** `caveman-app/caveman` contains only a Go provider layer and binary releases (a local API proxy, partly BSL-1.1 licensed). This environment's proxy blocks those release downloads. The Claude skill is published as a plugin from the upstream `JuliusBrussee/caveman` repo, which the caveman-app README credits.

## Privacy and safety settings
- Claude-Mem: local only. Cloud sync off, telemetry disabled, observer = your own Claude plan (`--provider claude`), no paid trial. Secret redaction is on (built-in + generic patterns). Media capture is off. Commands that read env, credentials or keys are not recorded. Use `<private>…</private>` to exclude text. Memory is keyed per project directory.
- Ponytail: the ledger writes a local CSV to `~/.config/ponytail/band/`. Webhook is empty, so nothing leaves the machine.
- Last 30 Days: keyless sources need one-time setup (`/last30days` first run). API keys are optional and none are configured.

## Verify
```bash
claude plugin list                          # 9 toolkit plugins enabled
~/.local/bin/scrapling --help
npx -y claude-mem@16.0.1 telemetry          # Telemetry: DISABLED
curl -s localhost:37700/api/health          # claude-mem worker
cat ~/.config/caveman/config.json           # defaultMode off
```

## Update
`claude plugin marketplace update && claude plugin update <name>@<marketplace>`, then `npx claude-mem@<ver> install …` for Claude-Mem and `pip install -U` in the Scrapling venv. Re-run the smoke tests after updating.

## Roll back
- One plugin: `claude plugin uninstall <name>@<marketplace>` (or `disable`).
- Routing: delete `~/.claude/CLAUDE.md` (it did not exist before this install).
- Claude-Mem: `npx claude-mem uninstall`, then remove `~/.claude-mem`. Pre-hardening settings are in `~/.claude/backups/claude-mem-settings.pre-hardening.json`.
- Scrapling: `rm -rf ~/.local/share/scrapling-venv ~/.local/bin/scrapling ~/.claude/skills/scrapling-official`.
- Before this install there was no `~/.claude/settings.json` or global `CLAUDE.md`, and only the claude.ai-synced plugins were present.
