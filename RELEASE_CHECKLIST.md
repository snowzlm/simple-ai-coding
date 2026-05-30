# Release Checklist

用于统一 `AI_RULES.md / AGENTS.md / CLAUDE.md / Copilot / Cursor / OpenClaw plugin pack` 的发布校验，避免单处修改后漏同步。

## 1. 源文件变更确认

- [ ] `AI_RULES.md` 是否为本轮真实源基线
- [ ] 平台适配文件是否同步更新：`AGENTS.md`、`CLAUDE.md`、`CURSOR.md`、`.github/copilot-instructions.md`
- [ ] 如有多语言改动，`README.md` / `README.en.md` / `CLAUDE.zh-CN.md` / `CLAUDE.en.md` 是否同步

## 2. 物化与平台一致性

- [ ] 运行 `bash scripts/materialize-skill-language.sh auto`
- [ ] 运行 `bash scripts/test-platform-compat.sh`
- [ ] 运行 `bash scripts/test-openclaw-plugin-pack.sh`
- [ ] 检查 OpenClaw 插件包目录：`plugins/openclaw-universal-ai-guidelines/`
- [ ] 检查技能目录：`skills/universal-ai-guidelines/`

## 3. OpenClaw plugin pack 专项

- [ ] `plugins/openclaw-universal-ai-guidelines/openclaw.plugin.json` 可解析
- [ ] `plugins/openclaw-universal-ai-guidelines/package.json` 的 `openclaw.extensions` 指向 `./index.js`
- [ ] `plugins/openclaw-universal-ai-guidelines/index.js` 可被 Node import
- [ ] 插件包内技能文件齐全：`SKILL.md` / `SKILL.zh-CN.md` / `SKILL.en.md`

## 4. 发布前人工复核

- [ ] README 中的安装命令仍与当前目录结构一致
- [ ] 没有把 `.claude/`、graphify 缓存、临时产物带进发布变更
- [ ] 如本轮只改文档，无需伪造依赖更新或空构建结果
- [ ] 如要对外发布，再补版本号、CHANGELOG / release notes
