---
name: simple-ai-coding-guidelines
description: Bilingual coding-behavior guidelines for AI coding agents. Use when writing, reviewing, or refactoring code to avoid overengineering, keep changes surgical, surface assumptions early, and execute by verifiable success criteria.
---

# Simple AI Coding Guidelines（双语）

基于 [Andrej Karpathy 的观察](https://x.com/karpathy/status/2015883857489522876)，用于减少 LLM 编码中的常见错误。

**取舍 / Tradeoff：** 偏向“谨慎优先”而非“速度优先”；极小任务可适当放宽。

## 中文版

### 1) 先思考再编码（Think Before Coding）

- 显式写出假设，不确定就先问。
- 存在多种解释时先列出，不要静默选择。
- 有更简单方案时要主动指出。
- 不清楚就停下并请求澄清。

### 2) 简单优先（Simplicity First）

- 不加需求外功能。
- 单次用途代码不提前抽象。
- 不做未被要求的可配置化。
- 不写不可能场景的错误处理。
- 200 行能压到 50 行就重写。

### 3) 手术式改动（Surgical Changes）

- 只改必须改的行，不顺手改邻近代码/注释/格式。
- 不重构无关模块。
- 贴合现有风格。
- 无关死代码只提示不删除（除非明确要求）。
- 仅清理本次改动引入的未使用代码。

### 4) 目标驱动执行（Goal-Driven Execution）

- “加校验”→“先写非法输入测试，再让测试通过”。
- “修 bug”→“先写复现测试，再让测试通过”。
- “重构 X”→“确保前后测试都通过”。

多步骤任务建议先写计划：

```text
1. [步骤] → 验证: [检查项]
2. [步骤] → 验证: [检查项]
3. [步骤] → 验证: [检查项]
```

---

## English Version

### 1) Think Before Coding

- State assumptions explicitly; ask when uncertain.
- Present multiple interpretations when ambiguity exists.
- Push back when a simpler approach is better.
- Stop and ask if something is unclear.

### 2) Simplicity First

- No features beyond what was requested.
- No abstractions for single-use code.
- No unrequested configurability.
- No error handling for impossible scenarios.
- Rewrite if 200 lines can be 50.

### 3) Surgical Changes

- Change only what is required.
- Do not refactor adjacent/unrelated parts.
- Match existing style.
- Mention unrelated dead code; do not remove unless asked.
- Clean only orphan code created by your change.

### 4) Goal-Driven Execution

- “Add validation” → “Write failing tests first, then make them pass.”
- “Fix bug” → “Write a reproducer test first, then fix.”
- “Refactor X” → “Ensure tests pass before and after.”

Use a short verifiable plan for multi-step tasks:

```text
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```
