#!/bin/bash
# Claude Code dev toolkit (user scope). Idempotent; failures warn, never block session start.
set -u
command -v claude >/dev/null 2>&1 || { echo "toolkit: claude CLI missing, skipped"; exit 0; }
w(){ echo "toolkit WARN: $*"; }
mp(){ claude plugin marketplace list 2>/dev/null | grep -q "> $1\$" || claude plugin marketplace add "$2" >/dev/null 2>&1 || w "$2"; }
pl(){ claude plugin list 2>/dev/null | grep -q "> $1\$" || claude plugin install "$1" >/dev/null 2>&1 || w "$1"; }
mp superpowers-dev obra/superpowers; pl superpowers@superpowers-dev
mp ponytail DietrichGebert/ponytail; pl ponytail@ponytail
mp ui-ux-pro-max-skill nextlevelbuilder/ui-ux-pro-max-skill; pl ui-ux-pro-max@ui-ux-pro-max-skill
mp impeccable pbakaus/impeccable; pl impeccable@impeccable
mp humanizer Aboudjem/humanizer-skill; pl humanizer@humanizer
mp last30days-skill mvanhorn/last30days-skill; pl last30days@last30days-skill
mp diagram-design cathrynlavery/diagram-design; pl diagram-design@diagram-design
mp caveman JuliusBrussee/caveman; pl caveman@caveman
mkdir -p ~/.config/caveman
[ -f ~/.config/caveman/config.json ] || echo '{"defaultMode":"off","reinforce":false}' > ~/.config/caveman/config.json
V=~/.local/share/scrapling-venv
if [ ! -x $V/bin/scrapling ]; then
  python3 -m venv $V && $V/bin/pip install -q "scrapling[fetchers]==0.5.1" || w scrapling
fi
mkdir -p ~/.local/bin ~/.claude/skills && ln -sf $V/bin/scrapling ~/.local/bin/scrapling
if [ ! -f ~/.claude/skills/scrapling-official/SKILL.md ]; then
  T=$(mktemp -d)
  git clone -q --depth 1 https://github.com/D4Vinci/Scrapling $T/s && cp -r $T/s/agent-skill/Scrapling-Skill ~/.claude/skills/scrapling-official
  rm -rf $T
fi
if ! claude plugin list 2>/dev/null | grep -q '> claude-mem@thedotmack$'; then
  (cd ~ && CLAUDE_MEM_ONLINE_OPTIN=false CI=1 timeout 400 npx -y claude-mem@16.0.1 install --provider claude --ide claude-code </dev/null >/dev/null 2>&1) || w claude-mem
fi
(cd ~ && timeout 60 npx -y claude-mem@16.0.1 telemetry disable </dev/null >/dev/null 2>&1) || true
[ -f ~/.claude-mem/settings.json ] && python3 - <<'PY'
import json, os
p = os.path.expanduser('~/.claude-mem/settings.json'); d = json.load(open(p))
d.update({"CLAUDE_MEM_REDACT_ENABLED": "true", "CLAUDE_MEM_REDACT_GENERIC_ENABLED": "true", "CLAUDE_MEM_MEDIA_CAPTURE_ENABLED": "false",
  "CLAUDE_MEM_SKIP_BASH_PATTERNS": r"(\benv\b|printenv|\.env\b|credentials|\.netrc|id_rsa|\.ssh/|secret|token|passw|api[_-]?key|\.ccr/)"})
json.dump(d, open(p, 'w'), indent=2)
PY
[ -f ~/.claude/CLAUDE.md ] || cat > ~/.claude/CLAUDE.md <<'MD'
# Global skill routing (dev toolkit)

Pick capabilities from the task itself; the user should not have to name plugins.
Load a skill only when its trigger fits. One owner per concern; never run competing workflows for one task.
Never ask the user to type slash commands: invoke the matching skill yourself (Skill tool) whenever its trigger fits.

- Dev workflow (plan, TDD, debug, verify): `superpowers`. Multi-file features, bugs, refactors; skip trivial edits.
- Implementation efficiency: `ponytail` (advisory). Stdlib/platform/existing code first; no needless deps or abstraction.
  Never trade away security, correctness or required behaviour.
- Design selection: `ui-ux-pro-max` for new UI or substantial redesigns. Respect existing brand/design system.
- Visual critique & polish: `impeccable`. Render (Playwright), check desktop + mobile, fix, re-inspect.
- Writing quality: `humanizer` for user-facing prose. Never rewrite code, data or exact instructions.
- Recent research: `last30days` when recency matters. Cite links; separate verified fact from opinion/popularity.
- Web extraction: `scrapling-official` only if no API/simple fetch works. Respect robots, auth, rate limits.
  No CAPTCHA/access-control evasion without explicit permission. Binary: `~/.local/bin/scrapling`.
- Diagrams: `diagram-design` for architecture/data flow/plans; must match the real code.
- Persistent memory: `claude-mem` (automatic hooks). Don't duplicate its context; wrap secrets in `<private>`.
- Token reduction: `caveman`, default OFF. Use `caveman-compress` on large inputs only when measured to help.
  Never force terse style on replies to the user.

Tie-breaks: `superpowers` over `engineering:*` for workflow; `impeccable` over `design:design-critique`
and `design:accessibility-review` for rendered UI; `humanizer` over `design:ux-copy` except microcopy.

Project separation: Umbra, Eidolon, Genesis, Outnook and Ghost AI stay separate: no shared configs,
credentials or cross-project memory edits. Never deploy as a side effect. Outnook: UI/UX + real-browser checks.
Umbra/Eidolon: architecture consistency, tests, security.
MD
echo "toolkit: ready"
