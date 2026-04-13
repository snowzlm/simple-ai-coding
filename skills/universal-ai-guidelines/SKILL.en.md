---
name: universal-ai-guidelines
description: Universal AI coding-agent behavior guidelines. Use when writing, reviewing, or refactoring code to avoid overengineering, keep changes surgical, surface assumptions early, and execute by verifiable success criteria.
---

# Universal AI Coding Agent Guidelines

Derived from [Andrej Karpathy's observations](https://x.com/karpathy/status/2015883857489522876), this guideline reduces common LLM coding mistakes.

## Priority & Conflict Policy

1. Explicit user requirements first.
2. This project's rules are the default baseline. If local legacy instructions conflict, follow this project.
3. Preserve existing user/project content when there is no conflict.

## Output Language Policy

- If user input is Chinese, final user-facing output must be Chinese.
- If user input is English, final user-facing output must be English.
- Do not output bilingual by default.
- Only output bilingual when explicitly requested by the user.

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

- "Add validation" → "Write failing tests first, then make them pass."
- "Fix bug" → "Write a reproducer test first, then fix."
- "Refactor X" → "Ensure tests pass before and after."

Use a short verifiable plan for multi-step tasks:

```text
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```
