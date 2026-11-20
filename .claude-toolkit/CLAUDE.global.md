# Global skill routing (dev toolkit)

Pick capabilities from the task itself; the user should not have to name plugins. Load a skill only when its trigger fits. One owner per concern; never run two competing workflows for the same task.

| Concern | Owner | Trigger |
|---|---|---|
| Dev workflow (plan, TDD, debug, verify) | `superpowers` | Multi-file features, bugs, refactors. Skip for trivial edits/questions. |
| Implementation efficiency | `ponytail` (advisory) | While writing/reviewing code: stdlib/platform/existing components first, no needless deps or abstraction. Never trade away security, correctness or required behaviour. |
| Design selection | `ui-ux-pro-max` | New UI or substantial redesign. Respect existing brand/design system. |
| Visual critique & polish | `impeccable` | Auditing/finishing UI. Render it (Playwright), check desktop + mobile, fix, re-inspect. |
| Writing quality | `humanizer` | User-facing prose (copy, docs, announcements). Never rewrite code, data or exact instructions. |
| Recent research | `last30days` | When recency matters. Cite links; separate verified fact from opinion/popularity. |
| Web extraction | `scrapling-official` | Only when structured extraction is needed and no API/simple fetch suffices. Respect robots, auth, rate limits; no CAPTCHA/access-control evasion without explicit permission. Binary: `~/.local/bin/scrapling`. |
| Diagrams | `diagram-design` | Architecture/data-flow/plans where a diagram helps; must match the real code. |
| Persistent memory | `claude-mem` (automatic hooks) | Don't duplicate its context with manual notes. Wrap secrets in `<private>`. |
| Token reduction | `caveman` | Default OFF. Use `caveman-compress` on large inputs only when measured to help. Never force terse style on replies to the user. |

Overlap tie-breaks: `superpowers` owns workflow over `engineering:*`; `impeccable` over `design:design-critique`/`accessibility-review` for rendered UI; `humanizer` over `design:ux-copy` except for microcopy.

Project separation: Umbra, Eidolon, Genesis, Outnook and Ghost AI stay separate — no shared configs, credentials or cross-project memory edits. Never deploy as a side effect. Outnook: prioritise UI/UX + real-browser checks. Umbra/Eidolon: architecture consistency, tests, security.
