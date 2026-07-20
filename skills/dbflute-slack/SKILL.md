---
name: dbflute-slack
description: Read the dbflute Slack workspace (dbflute.slack.com) — channel map, who is who, and how discussions map to GitHub repos. Use when asked to look up, summarize, or search dbflute Slack, or when a question needs the context of what the committers have been discussing.
---

# DBFlute Slack

Reads `dbflute.slack.com` through the `slack-mcp` server (tools named `slack_*`).
Read-only. If the tools are missing, the server is not registered — see
https://github.com/EgumaYuto/slack-mcp

## Channel map

IDs are stable; use them directly instead of re-listing channels every time.
Re-derive with `slack_list_channels` if one stops resolving.

| ID | Channel | What it carries |
| --- | --- | --- |
| `CAQ2T8KC4` | `intro_committers_ja` | **Main channel.** Intro committer discussion, 勉強会, daily わいわいスレッド |
| `CAPH91CH2` | `dbflute_users_ja` | User-facing Q&A about DBFlute itself |
| `CAPMSMTCK` | `lastaflute_users_ja` | LastaFlute user Q&A |
| `C09RKQYE519` | `erflute_committers_ja` | ERFlute committer discussion |
| `CAQLU6CS2` | `whole_committers_ja` | Cross-project committer announcements |
| `CPL36SSGG` | `intro_issues_ja` | Intro issue discussion |
| `CRUFWK4L9` | `intro_github_notify` | **Bot.** GitHub PR/push/merge notifications |
| `CRTNNA35H` | `intro_ci_notify` | **Bot.** CircleCI results |
| `C04PR5F4LG6` | `intro_committers_playground` | Casual / experiments |
| `CAPMGTU6P` | `jflute_park_ja` | Personal channel; low traffic |
| `CAPPW1NUA` | `general` | Rarely used |
| `CAQR9SZ8F` | `random` | Rarely used |
| `GAQRQTHGA` | `zone_intronzon_ja` | Private |

Activity is concentrated in `intro_committers_ja` plus the two bot channels.
The other channels are often empty for a given week — that is normal, not a bug.

## How to work

1. **For a time range** ("this week", "since Monday") use `slack_get_activity`,
   not `slack_get_history`. History returns only top-level messages, so replies
   to threads started earlier are silently missed — and in this workspace most
   real discussion happens inside daily わいわいスレッド threads.
2. **For a keyword** use `slack_search` with operators: `in:#intro_committers_ja`,
   `from:@<handle>`, `after:2026-07-01`. Cite the returned `permalink`.
   Resolve handles with `slack_list_users` rather than guessing.
3. **Bot channels are the audit trail.** `intro_github_notify` and
   `intro_ci_notify` tell you what actually landed; the human channels tell you
   why. Read both before concluding what happened.

## Gotchas

- **~90 days of history only.** This workspace is on a plan that caps API history
  at roughly 90 days. Older messages return nothing even though they exist in the
  UI. Do not report "no discussion" for an older period — report that it is out
  of the retrievable window.
- **Bot posts are verbose.** Dependabot notifications run ~3000 characters each.
  Pull them selectively when summarizing.
- **Slack notifications overstate activity.** A GitHub "N new commits pushed"
  message counts commits authored earlier on a feature branch. Verify with `gh`
  before quoting a number — see the `dbflute-catchup` skill.
