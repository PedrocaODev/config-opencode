---
name: camoufox-browser
description: Drives the Camoufox MCP for browser-rendered scraping, JS-heavy page inspection, screenshots, form interaction, and multi-step navigation. Do not use for plain text fetches, docs lookup, or general research — those stay with librarian/websearch/webfetch.
---

# Camoufox Browser Skill

Use the `camoufox` MCP server for tasks that need a real browser: JS-rendered pages, bot-walled sites, screenshots, structured page extraction, form filling, and interactive navigation.

**Do not trigger** for ordinary web searches, documentation lookup, or static page reads — use webfetch/librarian instead.

## Availability Check

Call `camoufox_status` first when availability is uncertain. If `browserAvailable` is `false`, the browser binary is missing. Explain:

> Camoufox needs a one-time ~780 MB browser download. Run `npx -y camoufox-js fetch` to fetch it.

Ask the user before downloading. If the server is unreachable, report that — do not silently fall back to other tools.

## Tool Selection

Pick the narrowest tool; bound every call with `maxChars`, `selector`, or `outputMode: "metadata"`.

| Need | Tool |
|------|------|
| Page loads? title? status? | `browse` + `outputMode: "metadata"` |
| Visible text / article | `browse` + `maxChars` |
| Specific text or pattern | `browse_find` + `query` |
| All links | `browse_links` |
| Form fields | `browse_forms` |
| Page headings/structure | `browse_outline` |
| Interactive element map | `browse_snapshot` |
| Navigate + actions, one shot | `browse_sequence` |
| Screenshot | `browse_screenshot` |
| Multi-step with state | Session tools (see below) |

## Sequences vs Sessions

- **Known fixed interactions** → `browse_sequence` (one call, one round trip).
- **State across decisions** (login → inspect → decide next) → session tools: `browse_session_start` → `browse_session_navigate` → `browse_session_action` → `browse_session_snapshot` → `browse_session_close`.
- Always close sessions when done.

## Safety Rules

- **Read-only by default.** Forms, clicks, navigation are fine for extraction. State-changing actions (submit, post, purchase, delete, upload, change account data) require explicit user approval.
- **No `evaluate`** — do not enable `CAMOUFOX_MCP_ALLOW_EVALUATE` or use the evaluate action.
- **No unsafe options** unless the project config already sets `CAMOUFOX_MCP_ALLOW_UNSAFE_OPTIONS=1`; do not add it yourself.
- **No CAPTCHA/auth bypass.** If a CAPTCHA is detected, pause and hand control to the user. Use `browse_session_resume` after they solve it.
- **Respect authorization, site terms, and privacy.** Minimize collected data.
- **Report Camoufox unavailability** rather than silently switching tools.
