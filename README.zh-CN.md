# Karpathy 启发的 Claude Code 指南（中文）

> 快速跳转： [中文](./README.zh-CN.md) ｜ [English](./README.en.md) ｜ [索引](./README.md)

基于 [Andrej Karpathy 对 LLM 编码常见问题的观察](https://x.com/karpathy/status/2015883857489522876)，这个项目用一个 `CLAUDE.md` 文件，约束并改善 Claude Code 的行为。

---

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
