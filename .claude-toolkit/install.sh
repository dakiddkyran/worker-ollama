#!/usr/bin/env bash
# Idempotent installer for the Claude Code dev toolkit (user scope).
# Safe to re-run: skips anything already present. Never touches project repos.
set -uo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
log(){ echo "[toolkit] $*"; }
have_mp(){ claude plugin marketplace list 2>/dev/null | grep -q "> $1\$"; }
have_pl(){ claude plugin list 2>/dev/null | grep -q "> $1\$"; }

# marketplace-name  github-repo  plugin@marketplace
while read -r mp repo pl; do
  have_mp "$mp" || claude plugin marketplace add "$repo" >/dev/null 2>&1 || log "WARN marketplace $repo"
  have_pl "$pl" || claude plugin install "$pl" >/dev/null 2>&1 || log "WARN install $pl"
done <<'EOF'
superpowers-dev obra/superpowers superpowers@superpowers-dev
ponytail DietrichGebert/ponytail ponytail@ponytail
ui-ux-pro-max-skill nextlevelbuilder/ui-ux-pro-max-skill ui-ux-pro-max@ui-ux-pro-max-skill
impeccable pbakaus/impeccable impeccable@impeccable
humanizer Aboudjem/humanizer-skill humanizer@humanizer
last30days-skill mvanhorn/last30days-skill last30days@last30days-skill
diagram-design cathrynlavery/diagram-design diagram-design@diagram-design
caveman JuliusBrussee/caveman caveman@caveman
EOF

# Caveman: conservative default (off). Opt in per session with /caveman.
mkdir -p ~/.config/caveman
[ -f ~/.config/caveman/config.json ] || echo '{"defaultMode":"off","reinforce":false}' > ~/.config/caveman/config.json

# Scrapling: Python lib + CLI in an isolated venv, plus the official skill.
if [ ! -x ~/.local/share/scrapling-venv/bin/scrapling ]; then
  python3 -m venv ~/.local/share/scrapling-venv
  ~/.local/share/scrapling-venv/bin/pip install -q "scrapling[fetchers]==0.5.1"
fi
mkdir -p ~/.local/bin && ln -sf ~/.local/share/scrapling-venv/bin/scrapling ~/.local/bin/scrapling
if [ ! -f ~/.claude/skills/scrapling-official/SKILL.md ]; then
  t=$(mktemp -d) && git clone -q --depth 1 https://github.com/D4Vinci/Scrapling "$t/s" \
    && mkdir -p ~/.claude/skills && cp -r "$t/s/agent-skill/Scrapling-Skill" ~/.claude/skills/scrapling-official
  rm -rf "$t"
fi

# Claude-Mem: local storage, your own Claude plan as observer, no cloud sync, no telemetry.
if ! have_pl claude-mem@thedotmack; then
  (cd ~ && CLAUDE_MEM_ONLINE_OPTIN=false CI=1 npx -y claude-mem@16.0.1 install --provider claude --ide claude-code </dev/null >/dev/null 2>&1) || log "WARN claude-mem install"
fi
(cd ~ && npx -y claude-mem@16.0.1 telemetry disable </dev/null >/dev/null 2>&1) || true
[ -f ~/.claude-mem/settings.json ] && python3 - <<'PY'
import json; p='/root/.claude-mem/settings.json'.replace('/root',__import__('os').path.expanduser('~'))
d=json.load(open(p)); d.update({"CLAUDE_MEM_REDACT_ENABLED":"true","CLAUDE_MEM_REDACT_GENERIC_ENABLED":"true",
 "CLAUDE_MEM_MEDIA_CAPTURE_ENABLED":"false",
 "CLAUDE_MEM_SKIP_BASH_PATTERNS":r"(\benv\b|printenv|\.env\b|credentials|\.netrc|id_rsa|\.ssh/|secret|token|passw|api[_-]?key|\.ccr/)"})
json.dump(d,open(p,'w'),indent=2)
PY

# Global routing rules: install only if no global CLAUDE.md exists (never overwrite yours).
[ -f ~/.claude/CLAUDE.md ] || cp "$HERE/CLAUDE.global.md" ~/.claude/CLAUDE.md
log "done"
