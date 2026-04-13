[English](./README.en.md)

# Karpathy 启发的 AI 编码代理指南

一套轻量规则文件（`AI_RULES.md` + 平台适配文件），用于改进 AI 编码代理的行为。内容基于 [Andrej Karpathy 对 LLM 编码常见问题的观察](https://x.com/karpathy/status/2015883857489522876)。

## 项目说明

这是一个面向 AI 编码代理的行为规范模板库，采用 `AI_RULES.md` 作为统一基线，并提供平台适配文件。

当前覆盖：

- **OpenClaw**：`AGENTS.md`
- **Codex**：`AGENTS.md`
- **Claude**：`CLAUDE.md`
- **GitHub Copilot**：`.github/copilot-instructions.md`
- **其他平台**：优先复用 `AI_RULES.md`

## 问题

来自 Andrej 的原话：

> “模型会替你做错误假设，并在不检查的情况下一路执行。它们不会管理自己的困惑，不会主动澄清，不会暴露不一致，不会给出权衡，也不会在该反驳时反驳。”

> “它们很喜欢把代码和 API 过度复杂化，抽象臃肿，不清理死代码……本来 100 行能搞定，却实现了 1000+ 行的臃肿方案。”

> “它们有时还会改动/删除自己并不真正理解的注释和代码，哪怕这些改动与当前任务无关。”

## 解决方案

把四条原则写进一个文件，直接对齐这些问题：

| 原则 | 解决的问题 |
|------|------------|
| **先思考再编码（Think Before Coding）** | 错误假设、隐藏困惑、缺失权衡 |
| **简单优先（Simplicity First）** | 过度复杂化、抽象膨胀 |
| **手术式改动（Surgical Changes）** | 无关改动、误碰不该改的代码 |
| **目标驱动执行（Goal-Driven Execution）** | 用“测试先行 + 可验证成功标准”提升杠杆 |

## 四条原则详解

### 1. 先思考再编码

**不要臆测，不要掩盖困惑，要暴露权衡。**

LLM 常会默默选择一种理解然后一路写下去。该原则要求显式推理：

- **显式写出假设** —— 不确定时先问，不要猜
- **呈现多种解释** —— 存在歧义时不要静默选一个
- **必要时提出反驳** —— 若有更简单方案，应明确指出
- **困惑时先停下** —— 说清不明确点并请求澄清

### 2. 简单优先

**用最少代码解决问题，不做猜测性扩展。**

对抗过度工程倾向：

- 不做需求之外的功能
- 不为一次性代码提前抽象
- 不做未被要求的“灵活性/可配置性”
- 不为不可能场景写错误处理
- 若 200 行可以写成 50 行，就重写

**自检标准：** 如果资深工程师会认为它过度复杂，就继续简化。

### 3. 手术式改动

**只改必须改的；只清理你自己制造的冗余。**

修改现有代码时：

- 不“顺手优化”邻近代码、注释或格式
- 不重构未损坏部分
- 即使你有偏好，也应匹配现有风格
- 发现无关死代码可以提示，但不要直接删

当你的改动引入孤儿代码时：

- 删除 **你这次改动导致** 未使用的 import/变量/函数
- 不删除历史遗留死代码（除非用户明确要求）

**自检标准：** 每一行改动都应可直接追溯到用户请求。

### 4. 目标驱动执行

**先定义成功标准，再循环到验证通过。**

把命令式任务转成可验证目标：

| 不要只说… | 应转成… |
|-----------|----------|
| “加校验” | “先写非法输入测试，再让测试通过” |
| “修 bug” | “先写可复现测试，再让测试通过” |
| “重构 X” | “确保重构前后测试都通过” |

对多步骤任务，先给简要计划：

```text
1. [步骤] → 验证: [检查项]
2. [步骤] → 验证: [检查项]
3. [步骤] → 验证: [检查项]
```

强成功标准能让 LLM 自主闭环；弱标准（如“让它能用”）会导致频繁澄清。

## 安装

### 方式 A：通用基线（推荐）

```bash
curl -o AI_RULES.md https://raw.githubusercontent.com/snowzlm/simple-ai-coding/main/AI_RULES.md
```

### 方式 B：OpenClaw / Codex

```bash
curl -o AGENTS.md https://raw.githubusercontent.com/snowzlm/simple-ai-coding/main/AGENTS.md
```

说明：OpenClaw 当前可使用 `AGENTS.md`、`.skill` 包，或 OpenClaw 原生插件包；不走 Claude 的插件机制。

生成本地 `.skill` 包：

```bash
bash scripts/build-openclaw-skill.sh
```

### 方式 C：Claude

```bash
curl -o CLAUDE.md https://raw.githubusercontent.com/snowzlm/simple-ai-coding/main/CLAUDE.md
```

### 方式 D：GitHub Copilot

```bash
mkdir -p .github
curl -o .github/copilot-instructions.md https://raw.githubusercontent.com/snowzlm/simple-ai-coding/main/.github/copilot-instructions.md
```

### 方式 E：Claude 插件（可选）

```text
/plugin marketplace add snowzlm/simple-ai-coding
/plugin install simple-ai-coding@simple-ai-coding
```

### 方式 F：OpenClaw 原生插件包（可选）

```bash
# 开发态（link）安装
openclaw plugins install --link ./plugins/openclaw-universal-ai-guidelines

# 打包为 tgz
bash scripts/build-openclaw-plugin-package.sh

# 从 tgz 安装
openclaw plugins install ./dist/plugins/snowzlm-openclaw-universal-ai-guidelines-<version>.tgz
```

> 说明：这是 OpenClaw 的原生插件/扩展包形态，与 Claude 插件机制不同。

#### OpenClaw 插件发布级流程（版本 / 打包 / 验收）

```bash
# 版本升级并打包（patch/minor/major 或显式版本号）
bash scripts/release-openclaw-plugin.sh patch

# 安装验收（link + tgz 两条链路）
bash scripts/acceptance-openclaw-plugin.sh
```

## Skill 文件语言落地（用户端）

为避免用户端出现“中英混合 SKILL.md”，提供按语言落地脚本：

```bash
# 自动按当前系统语言落地（LANG/LC_ALL）
bash scripts/materialize-skill-language.sh auto

# 强制中文
bash scripts/materialize-skill-language.sh zh-CN

# 强制英文
bash scripts/materialize-skill-language.sh en
```

执行后，`skills/universal-ai-guidelines/SKILL.md` 将是单一语言版本。

- 说明：该能力仅决定 `SKILL.md` 文件落地语言，不会全局强制 AI 对话输出语言。

## 平台可用性测试（本仓库已实测）

执行：

```bash
bash scripts/test-platform-compat.sh
```

覆盖：OpenClaw、Codex、Claude、Copilot（以及通用基线文件一致性检查）。

## 关键洞见

Andrej 的观点：

> “LLM 在围绕明确目标持续循环直到达成方面非常强……不要只告诉它做什么，而要给它成功标准。”

“目标驱动执行”正是这个思想：把命令式要求改写成带验证循环的声明式目标。

## 如何判断它生效了

当你看到这些变化时，说明规则在发挥作用：

- **diff 中无关改动更少** —— 基本只出现被请求的改动
- **因过度设计导致的返工更少** —— 首次实现就更简洁
- **实现前先澄清，而不是出错后再补问**
- **PR 更干净、更小、更聚焦** —— 不再有顺手重构/顺手优化

## 自定义

这些规则设计为可与项目专属规则合并。你可以并入现有 `CLAUDE.md`，或新建一个。

例如：

```markdown
## 项目专属规则

- TypeScript 使用 strict 模式
- 所有 API 端点必须有测试
- 错误处理遵循 `src/utils/errors.ts` 的既有模式
```

## 取舍说明

这套规则偏向 **谨慎优先而非速度优先**。对极小改动（如拼写修复、明显单行修改）可适当降低流程强度。

目标不是拖慢简单任务，而是减少中等以上复杂任务中的高成本失误。

## 许可证

MIT

## 致谢

- 上游项目：[`forrestchang/andrej-karpathy-skills`](https://github.com/forrestchang/andrej-karpathy-skills)（@forrestchang）
- 观点来源：[Andrej Karpathy 的原始讨论](https://x.com/karpathy/status/2015883857489522876)（@karpathy）
