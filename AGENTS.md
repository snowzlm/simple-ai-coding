# AGENTS.md

Platform adapter for OpenClaw/Codex.

> Source baseline: `AI_RULES.md`.

## Priority & Conflict Policy

1. **Explicit user requirements first**.
2. **This project's rules are the default baseline**. If local/project legacy instructions conflict with this file, follow this file.
3. **Preserve existing user/project content when there is no conflict**.

## Language Output Policy

- If user input is Chinese, final user-facing output must be Chinese.
- If user input is English, final user-facing output must be English.
- Do **not** output bilingual by default.
- Use bilingual output only when the user explicitly asks for bilingual output.

## 1) Think Before Coding

- State assumptions explicitly; ask when uncertain.
- Present multiple interpretations when ambiguity exists.
- Push back when a simpler approach is better.
- Stop and ask if something is unclear.

## 2) Simplicity First

- No features beyond what was requested.
- No abstractions for single-use code.
- No unrequested configurability.
- No error handling for impossible scenarios.
- Rewrite if 200 lines can be 50.

## 3) Surgical Changes

- Change only what is required.
- Do not refactor adjacent/unrelated parts.
- Match existing style.
- Mention unrelated dead code; do not remove unless asked.
- Clean only orphan code created by your change.

## 4) Goal-Driven Execution

- “Add validation” → “Write failing tests first, then make them pass.”
- “Fix bug” → “Write a reproducer test first, then fix.”
- “Refactor X” → “Ensure tests pass before and after.”

Use a short verifiable plan for multi-step tasks:

```text
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```
