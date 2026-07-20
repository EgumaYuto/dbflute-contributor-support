---
name: dbflute-intro-contribute
description: DBFlute Intro contribution conventions — branch naming, commit message style, Issue creation (labels, title prefixes), and pull request flow for the dbflute/dbflute-intro repository. Use when creating a branch, writing a commit, opening an Issue or PR, or reviewing whether a change follows project convention in dbflute-intro.
---

# Contributing to DBFlute Intro

**Scope: `dbflute/dbflute-intro` only.** Other repos in the dbflute organization
(`dbflute-core`, `dbflute-document`, ...) are deliberately out of scope — their
conventions have not been verified. Do not apply the rules below to them; if
asked to contribute elsewhere, say the conventions are unconfirmed and check
that repo's own history first.

Conventions below were derived from the actual history of `dbflute/dbflute-intro`
(merged PRs, commit log, live labels), not from a written contributing guide —
**the repo has no CONTRIBUTING.md and no Issue template**. Treat them as
observed practice. When a maintainer contradicts them, the maintainer wins.

## The repo

| Repo | Base branch | Notes |
| --- | --- | --- |
| `dbflute/dbflute-intro` | `develop` | Java backend + Riot frontend. CI: CircleCI |

**Base branch is `develop`, not `master`/`main`.** Confirm before branching:

```bash
gh repo view dbflute/dbflute-intro --json defaultBranchRef
```

## Branches live in the org repo, not a fork

Merge commits read `Merge pull request #623 from dbflute/feature/...` — the
branch namespace is the upstream repo. Contributors with push access branch
directly rather than forking. If you lack push access, fork; otherwise follow
the local convention.

### Naming

```
feature/#<issue>_<short_description>     # most common
feature/#<issue>-<short-description>     # also used; both separators appear
fix/<short-description>                  # occasionally, without an issue number
```

Real examples:
- `feature/#615_node.js_version_update`
- `feature/#603-validation_error_unhandledrejection`
- `feature/#439_migrate_shema_policy`
- `fix/database-info-riot7`

Prefer `feature/#<issue>_<desc>` and **always reference an issue number** unless
there genuinely is not one. Descriptions are lowercase ASCII, words joined by
`_` or `-`.

## Commit messages

Two styles coexist in the log. Both are accepted; **match the recent history of
the area you are touching** rather than imposing one.

```
#615 fix:settings.jsonにトリムのしない設定を追加     # style A: issue number first
エラーオーバーレイのコメントを見直し #603             # style B: issue number last
```

Check which style the surrounding commits use:

```bash
git log develop --format='%s' -20
```

- The issue number is present either way — do not omit it.
- Bodies are written in **Japanese**.
- A `fix:` / `build(deps):` type prefix appears sometimes but is not required;
  this is not strict Conventional Commits.

## Issues

There is no template. Observed practice:

**Title** — Japanese, with an optional subsystem prefix in brackets:
```
[Riot7] api.ts の関数名、一貫性が欲しい
[Decomment] decommentダイアログ、command+Enter でOKしたい
開発環境の Node を 22 へ引き上げ
```
`[Riot7]` and `[Decomment]` group long-running efforts. Reuse an existing prefix
when the issue belongs to that effort — check open issues first.

**Labels** (`gh label list --repo dbflute/dbflute-intro`):

| Kind | Labels |
| --- | --- |
| Type | `bug`, `enhancement`, `dependencies`, `question` |
| Priority | `priS` > `priA` > `priB` > `priC` |
| Grouping | `Epic`, `desired`, `help wanted` |
| Tech | `javascript` |
| Closing | `duplicate`, `invalid`, `wontfix` |

Apply at least a type label. Priority is usually set by maintainers — do not
self-assign `priS`.

```bash
gh issue create --repo dbflute/dbflute-intro \
  --title "[Riot7] ..." --label enhancement --body "..."
```

## Pull requests

- Target `develop`.
- **PR bodies are often minimal** — PR #626's entire body is `#422`, just the
  issue reference. A short body linking the issue is acceptable here; do not
  pad it with ceremony the project does not use.
- CI (CircleCI `topic_branch_test_and_build`) must be green.
- Merges are plain merge commits (`Merge pull request #NNN from dbflute/<branch>`),
  not squash — so keep the individual commits meaningful.

```bash
gh pr create --repo dbflute/dbflute-intro --base develop \
  --title "..." --body "#<issue>"
```

## Before you start

Check whether the work is already discussed in Slack — the committers often
settle direction in `#intro_committers_ja` before an issue exists. See the
`dbflute-slack` skill.
