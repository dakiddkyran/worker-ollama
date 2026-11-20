# Global skill routing (dev toolkit)

Pick capabilities from the task itself; the user should not have to name plugins.
Load a skill only when its trigger fits. One owner per concern; never run competing workflows for one task.

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
