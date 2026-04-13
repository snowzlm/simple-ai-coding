# Karpathy 启发的 Claude Code 指南（中文优先 / Bilingual）

基于 [Andrej Karpathy 对 LLM 编码常见问题的观察](https://x.com/karpathy/status/2015883857489522876)，这个项目用一个 `CLAUDE.md` 文件，约束并改善 Claude Code 的行为。

---

## 中文版（优先）

## 这个项目解决什么问题？

根据 Andrej 的总结，模型在编码场景常见问题包括：

- 带着错误假设一路写下去，不主动澄清
- 不管理不确定性，不暴露矛盾与权衡
- 倾向过度设计，抽象臃肿，代码膨胀
- 会误改与任务无关的代码/注释

## 方案概览

项目把实践浓缩为 4 条原则，放进一个文件里：

| 原则 | 主要解决的问题 |
|------|----------------|
| **先思考再编码（Think Before Coding）** | 错误假设、隐藏困惑、缺失权衡 |
| **简单优先（Simplicity First）** | 过度工程、抽象膨胀 |
| **手术式改动（Surgical Changes）** | 无关改动、误改邻近代码 |
| **目标驱动执行（Goal-Driven Execution）** | 缺少可验证标准、无法闭环 |

## 四大原则（详细）

### 1) 先思考再编码

**不臆测，不掩饰困惑，先说清权衡。**

- 显式写出假设；不确定就先问
- 有多种解释时先列出，不要悄悄选一种
- 存在更简单路径时要主动指出
- 真不清楚就停下，明确说明卡点并请求澄清

### 2) 简单优先

**用最少代码解决当前问题，不做猜测性扩展。**

- 不加需求外功能
- 单次使用代码不提前抽象
- 不做“也许以后要用”的配置化/灵活性
- 不写不可能发生场景的异常处理
- 如果 200 行能压到 50 行，就重写

### 3) 手术式改动

**只改必须改的；只清理自己造成的冗余。**

- 不顺手“优化”相邻代码、注释、格式
- 不重构未损坏模块
- 遵循当前代码风格
- 看到无关死代码可提示，但不自动删除

当你的修改引入孤儿代码时：

- 清理由“本次改动”造成的未使用 import/变量/函数
- 不清理既有死代码（除非明确要求）

### 4) 目标驱动执行

**先定义成功标准，再循环验证直到通过。**

将“命令式要求”改写为“可验证目标”：

- “加校验” → “先写非法输入测试，再让测试通过”
- “修 Bug” → “先写可复现测试，再修到通过”
- “重构 X” → “改动前后测试都通过”

多步骤任务建议写短计划：

```text
1. [步骤] → 验证: [检查项]
2. [步骤] → 验证: [检查项]
3. [步骤] → 验证: [检查项]
```

## 安装方式

### 方式 A：Claude Code 插件（推荐）

先添加 marketplace：

```text
/plugin marketplace add forrestchang/andrej-karpathy-skills
```

再安装插件：

```text
/plugin install andrej-karpathy-skills@karpathy-skills
```

### 方式 B：项目级 CLAUDE.md

新项目：

```bash
curl -o CLAUDE.md https://raw.githubusercontent.com/forrestchang/andrej-karpathy-skills/main/CLAUDE.md
```

已有项目（追加）：

```bash
echo "" >> CLAUDE.md
curl https://raw.githubusercontent.com/forrestchang/andrej-karpathy-skills/main/CLAUDE.md >> CLAUDE.md
```

## 关键洞见

Andrej 的核心观点：

> LLM 特别擅长“围绕清晰目标循环直到达成”。

因此本项目强调：

- 少说“做什么”
- 多定义“算成功的标准是什么”

## 如何判断它生效了？

- diff 中无关改动明显减少
- 过度设计导致的返工明显减少
- 先问清再实现，而不是先写错再返修
- PR 更干净、范围更聚焦

## 项目结构与定位（简析）

- `CLAUDE.md`：核心行为准则（主产物）
- `skills/karpathy-guidelines/SKILL.md`：技能化封装，便于在支持技能的平台调用
- `.claude-plugin/`：插件元数据（用于 marketplace 安装）
- `EXAMPLES.md`：反例/正例对照，帮助团队落地四原则

这不是“代码框架项目”，而是一个**面向 AI 编码代理的行为约束模板库**：轻量、可复制、可直接嵌入现有项目。

## 可定制建议

你可以把通用准则和项目专属规则合并，例如：

```markdown
## 项目专属规则
- TypeScript 开启 strict
- 所有 API 端点必须有测试
- 错误处理遵循 src/utils/errors.ts 现有模式
```

## 取舍说明

该准则偏向“谨慎优先”，可能牺牲一点速度。对极小改动（如 typo）可适当放宽。

## License

MIT

---

## English Version

# Karpathy-Inspired Claude Code Guidelines

A single `CLAUDE.md` file to improve Claude Code behavior, derived from [Andrej Karpathy's observations](https://x.com/karpathy/status/2015883857489522876) on LLM coding pitfalls.

## The Problems

From Andrej's post:

> "The models make wrong assumptions on your behalf and just run along with them without checking. They don't manage their confusion, don't seek clarifications, don't surface inconsistencies, don't present tradeoffs, don't push back when they should."

> "They really like to overcomplicate code and APIs, bloat abstractions, don't clean up dead code... implement a bloated construction over 1000 lines when 100 would do."

> "They still sometimes change/remove comments and code they don't sufficiently understand as side effects, even if orthogonal to the task."

## The Solution

Four principles in one file that directly address these issues:

| Principle | Addresses |
|-----------|-----------|
| **Think Before Coding** | Wrong assumptions, hidden confusion, missing tradeoffs |
| **Simplicity First** | Overcomplication, bloated abstractions |
| **Surgical Changes** | Orthogonal edits, touching code you shouldn't |
| **Goal-Driven Execution** | Leverage through tests-first, verifiable success criteria |

## The Four Principles in Detail

### 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

LLMs often pick an interpretation silently and run with it. This principle forces explicit reasoning:

- **State assumptions explicitly** — If uncertain, ask rather than guess
- **Present multiple interpretations** — Don't pick silently when ambiguity exists
- **Push back when warranted** — If a simpler approach exists, say so
- **Stop when confused** — Name what's unclear and ask for clarification

### 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

Combat the tendency toward overengineering:

- No features beyond what was asked
- No abstractions for single-use code
- No "flexibility" or "configurability" that wasn't requested
- No error handling for impossible scenarios
- If 200 lines could be 50, rewrite it

**The test:** Would a senior engineer say this is overcomplicated? If yes, simplify.

### 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:

- Don't "improve" adjacent code, comments, or formatting
- Don't refactor things that aren't broken
- Match existing style, even if you'd do it differently
- If you notice unrelated dead code, mention it — don't delete it

When your changes create orphans:

- Remove imports/variables/functions that YOUR changes made unused
- Don't remove pre-existing dead code unless asked

**The test:** Every changed line should trace directly to the user's request.

### 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Transform imperative tasks into verifiable goals:

| Instead of... | Transform to... |
|--------------|-----------------|
| "Add validation" | "Write tests for invalid inputs, then make them pass" |
| "Fix the bug" | "Write a test that reproduces it, then make it pass" |
| "Refactor X" | "Ensure tests pass before and after" |

For multi-step tasks, state a brief plan:

```text
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Strong success criteria let the LLM loop independently. Weak criteria ("make it work") require constant clarification.

## Install

**Option A: Claude Code Plugin (recommended)**

From within Claude Code, first add the marketplace:

```text
/plugin marketplace add forrestchang/andrej-karpathy-skills
```

Then install the plugin:

```text
/plugin install andrej-karpathy-skills@karpathy-skills
```

This installs the guidelines as a Claude Code plugin, making the skill available across all your projects.

**Option B: CLAUDE.md (per-project)**

New project:

```bash
curl -o CLAUDE.md https://raw.githubusercontent.com/forrestchang/andrej-karpathy-skills/main/CLAUDE.md
```

Existing project (append):

```bash
echo "" >> CLAUDE.md
curl https://raw.githubusercontent.com/forrestchang/andrej-karpathy-skills/main/CLAUDE.md >> CLAUDE.md
```

## Key Insight

From Andrej:

> "LLMs are exceptionally good at looping until they meet specific goals... Don't tell it what to do, give it success criteria and watch it go."

The "Goal-Driven Execution" principle captures this: transform imperative instructions into declarative goals with verification loops.

## How to Know It's Working

These guidelines are working if you see:

- **Fewer unnecessary changes in diffs** — Only requested changes appear
- **Fewer rewrites due to overcomplication** — Code is simple the first time
- **Clarifying questions come before implementation** — Not after mistakes
- **Clean, minimal PRs** — No drive-by refactoring or "improvements"

## Customization

These guidelines are designed to be merged with project-specific instructions. Add them to your existing `CLAUDE.md` or create a new one.

For project-specific rules, add sections like:

```markdown
## Project-Specific Guidelines

- Use TypeScript strict mode
- All API endpoints must have tests
- Follow the existing error handling patterns in `src/utils/errors.ts`
```

## Tradeoff Note

These guidelines bias toward **caution over speed**. For trivial tasks (simple typo fixes, obvious one-liners), use judgment — not every change needs the full rigor.

The goal is reducing costly mistakes on non-trivial work, not slowing down simple tasks.

## License

MIT
