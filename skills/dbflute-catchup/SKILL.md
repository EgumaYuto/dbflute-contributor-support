---
name: dbflute-catchup
description: Catch up on what happened in DBFlute development over a period — cross-references Slack discussion, GitHub PRs/issues/commits, CI results, and Dependabot alerts, then flags what needs attention. Use for "what happened this week", "what did I miss", weekly summaries, or before picking up contribution work.
---

# DBFlute Catch-up

Produces a situation report by reading **both** Slack and GitHub, because neither
alone is accurate. Slack shows intent and discussion; GitHub shows what actually
landed and what is rotting. The gaps between them are the interesting part.

Scope is the whole `dbflute` organization, not one repository.

Requires the `slack-mcp` server (`slack_*` tools) and an authenticated `gh`.
See also the `dbflute-slack` skill for the channel map.

## Procedure

Default period is the last 7 days. Compute the epoch bound first:

```bash
node -e 'console.log(Math.floor(new Date("YYYY-MM-DDT00:00:00+09:00").getTime()/1000))'
```

### 1. Slack

Call `slack_get_activity` (NOT `slack_get_history` — it misses thread replies)
for each channel in the `dbflute-slack` channel map. Traffic concentrates in a
few committer and bot channels while the rest are often empty for a given week;
check the map rather than assuming which ones matter this time.

### 2. GitHub

Start org-wide, then drill into whichever repos actually moved.

```bash
# which repos exist and when they were last touched
gh repo list dbflute --limit 100 --json name,updatedAt,defaultBranchRef

# PRs touched in the period, across the org
gh search prs --owner dbflute --updated ">=<DATE>" --limit 40 \
  --json number,title,repository,state,author,updatedAt

# issues touched, across the org
gh search issues --owner dbflute --updated ">=<DATE>" --limit 40 \
  --json number,title,repository,state,author
```

Then, for each repo that shows activity (`<repo>`, with `<branch>` from
`defaultBranchRef` — it is not always `main`):

```bash
# commits actually authored in the period
gh api "repos/dbflute/<repo>/commits?sha=<branch>&since=<DATE>T00:00:00Z" \
  --jq '.[] | "\(.commit.author.date[:16]) \(.commit.author.name) | \(.commit.message | split("\n")[0])"'

# review + CI state of an open PR
gh pr view <N> --repo dbflute/<repo> \
  --json number,title,mergeable,reviewDecision,statusCheckRollup

# security debt (NOT visible in Slack at all)
gh api repos/dbflute/<repo>/dependabot/alerts --paginate
```

Dependabot alerts are worth checking even on repos with no activity in the
period — a dormant repo accumulates them silently.

### 3. Cross-check, then report

Report what happened, then what needs attention.

## What to look for

These checks have each caught something real. Run them every time.

**Dependabot alerts vs Dependabot PRs.** Slack only shows the PRs. The alert
list is far larger and includes packages nobody has opened a PR for. Aggregate
open alerts by severity and package, and call out any CRITICAL/HIGH with **no
corresponding PR** — that is the actionable gap.

**Open PRs that are green but unreviewed.** `reviewDecision` empty +
`statusCheckRollup` all SUCCESS means the PR is mergeable and simply waiting on
a human. These pile up quietly; list them with age.

**Slack commit counts are inflated.** A GitHub notification saying "7 new commits
pushed to develop" counts commits authored earlier on the feature branch and
merged now. The `commits?since=` API gives the real count for the period. Always
verify before quoting a number.

**PR URLs mentioned in Slack without context.** Committers paste a bare PR link
mid-conversation. Resolve it with `gh pr view` to get the title, linked issue,
and diff size — the Slack message alone does not say what the PR does.

**Discussion with no GitHub follow-through.** A decision reached in a committer
channel with no issue or PR afterwards is worth surfacing as a loose end, as is
an "I'll tell you later" that never got a follow-up.

**Repos nobody mentions.** Slack traffic skews heavily toward whichever project
is active right now. A repo can go quiet for months while still carrying open
PRs and security alerts. Enumerate the org rather than following Slack alone.

**Local clones drifting.** `git log -1 --format='%ad' --date=short` per cloned
repo, compared against the remote default branch, shows whether the working
copies are stale before starting work.

## Reporting

Lead with what needs attention, not a channel-by-channel transcript. A useful
report answers: what landed, what is blocked, what is rotting, and what was
decided but not yet acted on.

Separate **observed fact** from **inference**. Say when a person mapping between
Slack handle and GitHub login is a guess, and when a period is outside Slack's
~90-day retrievable window rather than genuinely quiet.
