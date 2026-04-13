[中文](./README.md)

# Karpathy-Inspired AI Coding Agent Guidelines

A lightweight ruleset (`AI_RULES.md` + platform adapters) to improve AI coding-agent behavior, derived from [Andrej Karpathy's observations](https://x.com/karpathy/status/2015883857489522876) on LLM coding pitfalls.

## Project Notes

This repository is a lightweight behavior-guidelines toolkit for AI coding agents, using `AI_RULES.md` as the canonical baseline plus platform adapters.

Current coverage:

- **OpenClaw** via `AGENTS.md`
- **Codex** via `AGENTS.md`
- **Claude** via `CLAUDE.md`
- **GitHub Copilot** via `.github/copilot-instructions.md`
- **Other platforms** via `AI_RULES.md`

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

```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Strong success criteria let the LLM loop independently. Weak criteria ("make it work") require constant clarification.

## Install

### Option A: Universal baseline (recommended)

```bash
curl -o AI_RULES.md https://raw.githubusercontent.com/snowzlm/simple-ai-coding/main/AI_RULES.md
```

### Option B: OpenClaw / Codex

```bash
curl -o AGENTS.md https://raw.githubusercontent.com/snowzlm/simple-ai-coding/main/AGENTS.md
```

Note: OpenClaw currently uses `AGENTS.md` or `.skill` package flow, not Claude plugin runtime.

Build local `.skill` package:

```bash
bash scripts/build-openclaw-skill.sh
```

### Option C: Claude

```bash
curl -o CLAUDE.md https://raw.githubusercontent.com/snowzlm/simple-ai-coding/main/CLAUDE.md
```

### Option D: GitHub Copilot

```bash
mkdir -p .github
curl -o .github/copilot-instructions.md https://raw.githubusercontent.com/snowzlm/simple-ai-coding/main/.github/copilot-instructions.md
```

### Option E: Claude plugin (optional)

```text
/plugin marketplace add snowzlm/simple-ai-coding
/plugin install simple-ai-coding@simple-ai-coding
```

## Skill Content Materialization (user-side)

To avoid mixed bilingual `SKILL.md` on user side, use the language materializer:

```bash
# Auto-detect from LANG/LC_ALL
bash scripts/materialize-skill-language.sh auto

# Force Chinese
bash scripts/materialize-skill-language.sh zh-CN

# Force English
bash scripts/materialize-skill-language.sh en
```

After running it, `skills/universal-ai-guidelines/SKILL.md` will be a single-language file.

- Note: this only materializes `SKILL.md` file language and does not globally enforce assistant conversation language.

## Platform Compatibility Tests (verified in this repo)

Run:

```bash
bash scripts/test-platform-compat.sh
```

Covers OpenClaw, Codex, Claude, Copilot, and baseline consistency checks.

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

## Acknowledgements

- Upstream project: [`forrestchang/andrej-karpathy-skills`](https://github.com/forrestchang/andrej-karpathy-skills) (@forrestchang)
- Original inspiration: [Andrej Karpathy's source thread](https://x.com/karpathy/status/2015883857489522876) (@karpathy)
