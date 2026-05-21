# Using this repo with Cursor

This project includes a **Cursor project rule** so the Karpathy-inspired behavioral guidelines apply automatically when you work here. It complements this fork’s OpenClaw/Codex adapters and Chinese-first README rather than replacing them.

## In this repository

1. Open the folder in Cursor.
2. The rule [`.cursor/rules/karpathy-guidelines.mdc`](.cursor/rules/karpathy-guidelines.mdc) is committed with `alwaysApply: true`, so you do not need extra installation steps.
3. In Cursor, you can confirm it under **Settings → Rules** (or the project rules UI), where `karpathy-guidelines` should appear.

## Use the same guidelines in another project

**Cursor (recommended):** Copy `.cursor/rules/karpathy-guidelines.mdc` into that project’s `.cursor/rules/` directory (create the folders if needed). Adjust or merge with existing rules as you like.

**Other tools:** If a stack only supports a root instruction file, copy or merge the adapter that matches your tool: [`AI_RULES.md`](AI_RULES.md) as the universal baseline, [`AGENTS.md`](AGENTS.md) for OpenClaw/Codex, or [`CLAUDE.md`](CLAUDE.md) for Claude.


## OpenClaw / Codex / Claude vs Cursor

- **OpenClaw / Codex:** Use [`AGENTS.md`](AGENTS.md) or the OpenClaw native plugin described in [`README.md`](README.md).
- **Claude:** Use [`CLAUDE.md`](CLAUDE.md) or the optional Claude plugin flow described in [`README.md`](README.md).
- **Cursor:** Use the committed `.cursor/rules/` file as described above. Cursor does not read `.claude-plugin/` or `CLAUDE.md` by default.

## For contributors

When you change the four principles, keep **[`AI_RULES.md`](AI_RULES.md)**, **[`AGENTS.md`](AGENTS.md)**, **[`CLAUDE.md`](CLAUDE.md)**, **[`skills/universal-ai-guidelines/SKILL.md`](skills/universal-ai-guidelines/SKILL.md)**, and **[`.cursor/rules/karpathy-guidelines.mdc`](.cursor/rules/karpathy-guidelines.mdc)** in sync.
