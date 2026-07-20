# dbflute-contributor-support

DBFlute のコントリビュート活動を支援する [Claude Code](https://claude.com/claude-code) Skill 集です。

**現在の対象リポジトリは `dbflute/dbflute-intro` のみです。** `dbflute-core` などは規約を検証していないため、意図的にスコープ外にしています（対象を広げる際は、そのリポジトリの履歴から規約を起こし直してください）。

> ⚠️ **試験段階のリポジトリです。** 個人アカウント配下で運用しており、dbflute organization の公式ドキュメントではありません。ここに書かれた規約は、リポジトリの実際の履歴（マージ済み PR・コミットログ・ラベル）から観測したものであり、公式の CONTRIBUTING.md に基づくものではありません（そもそも存在しません）。

## 収録 Skill

| Skill | 用途 |
| --- | --- |
| **`dbflute-catchup`** | 「今週何があった？」— Slack と GitHub を突き合わせて状況を報告し、放置されている PR や脆弱性を洗い出す |
| **`dbflute-intro-contribute`** | **`dbflute-intro` 限定。** ブランチ命名・コミットメッセージ・Issue 作成（ラベル、タイトル規約）・PR の出し方 |
| **`dbflute-slack`** | dbflute Slack の読み方。チャンネル ID マップ、人物対応、注意点 |

## 前提

1. **`slack-mcp`** — Slack 読み取り用の MCP サーバー
   → https://github.com/EgumaYuto/slack-mcp （セットアップ手順あり）
2. **`gh`** — 認証済みの GitHub CLI
   ```bash
   brew install gh && gh auth login
   ```
3. **Node.js 18+**（`slack-mcp` の実行と、日付計算に使用）

## インストール

```bash
git clone https://github.com/EgumaYuto/dbflute-contributor-support.git
cd dbflute-contributor-support
./install.sh
```

`~/.claude/skills/` にシンボリックリンクを張るので、以後は `git pull` するだけで最新化されます。反映には Claude Code の再起動が必要です。

特定のプロジェクト配下だけで使いたい場合:

```bash
CLAUDE_SKILLS_DIR=/path/to/project/.claude/skills ./install.sh
```

## 使い方

インストール後は自然言語で依頼するだけで、該当する Skill が読み込まれます。

```
今週の DBFlute の動きをまとめて
→ dbflute-catchup

Issue #615 に対応するブランチを切りたい
→ dbflute-intro-contribute

#intro_committers_ja で最近話されていることは？
→ dbflute-slack
```

明示的に呼ぶこともできます: `/dbflute-catchup`

## 規約情報の鮮度について

`dbflute-intro-contribute` に書かれたブランチ名やラベルの規約は、ある時点の `dbflute-intro` の履歴から起こしたものです。**プロジェクトの実態が変われば古くなります。** 迷ったら実際の履歴を確認してください:

```bash
gh pr list --repo dbflute/dbflute-intro --state merged --limit 25 --json headRefName,title
gh label list --repo dbflute/dbflute-intro
```

メンテナの指示が、この Skill の記述より常に優先されます。

## ライセンス

MIT
