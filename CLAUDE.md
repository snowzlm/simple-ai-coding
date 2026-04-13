# CLAUDE.md（中文优先 / Bilingual）

用于降低 LLM 在编码任务中的常见错误的行为准则。可与项目专属规则合并使用。

**取舍说明：** 这套规则偏向“谨慎优先”，在简单任务上可酌情降低执行强度。

---

## 中文版（优先）

## 1. 先思考再编码（Think Before Coding）

**不臆测，不掩饰困惑，先暴露权衡。**

在开始实现前：
- 明确写出你的假设；不确定就提问。
- 存在多种解释时，先列出选项，不要静默选择。
- 如果有更简单方案，主动指出；必要时要“温和反驳”。
- 一旦不清楚，先停下，描述卡点并请求澄清。

## 2. 简单优先（Simplicity First）

**用最少代码解决当前问题，不做猜测性扩展。**

- 不加需求外功能。
- 单次用途代码不提前抽象。
- 不做未被要求的“可配置”“高灵活”。
- 不写不可能发生场景的异常处理。
- 写了 200 行但能用 50 行搞定，就重写。

自检问题：**“资深工程师会觉得这段代码过度复杂吗？”** 如果会，继续简化。

## 3. 手术式改动（Surgical Changes）

**只改必须改的；只清理自己造成的冗余。**

修改现有代码时：
- 不顺手“优化”相邻代码、注释或格式。
- 不重构未损坏区域。
- 贴合现有风格，即使你有更偏好的写法。
- 发现无关死代码可提示，不要擅自删除。

当你的改动产生“孤儿代码”时：
- 清理由本次改动引入的未使用 import/变量/函数。
- 不清理历史遗留死代码（除非明确要求）。

判定标准：**每一行改动都能直接追溯到用户请求。**

## 4. 目标驱动执行（Goal-Driven Execution）

**先定义成功标准，再循环验证到通过。**

把任务改写为可验证目标：
- “加校验” → “先写非法输入测试，再让它通过”
- “修 Bug” → “先写复现测试，再修到通过”
- “重构 X” → “保证改动前后测试都通过”

多步骤任务建议先给出短计划：

```text
1. [步骤] → 验证: [检查项]
2. [步骤] → 验证: [检查项]
3. [步骤] → 验证: [检查项]
```

强成功标准可以让模型独立闭环；弱标准（如“让它能用”）会导致频繁返工。

---

## English Version

# CLAUDE.md

Behavioral guidelines to reduce common LLM coding mistakes. Merge with project-specific instructions as needed.

**Tradeoff:** These guidelines bias toward caution over speed. For trivial tasks, use judgment.

## 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:
- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them - don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

## 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

## 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:
- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it - don't delete it.

When your changes create orphans:
- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

The test: Every changed line should trace directly to the user's request.

## 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Transform tasks into verifiable goals:
- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

For multi-step tasks, state a brief plan:
```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Strong success criteria let you loop independently. Weak criteria ("make it work") require constant clarification.

---

**These guidelines are working if:** fewer unnecessary changes in diffs, fewer rewrites due to overcomplication, and clarifying questions come before implementation rather than after mistakes.
