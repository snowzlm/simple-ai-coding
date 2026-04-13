#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

pass() { echo "[PASS] $1"; }
fail() { echo "[FAIL] $1"; exit 1; }

check_file() {
  local f="$1"
  [ -f "$f" ] && pass "file exists: $f" || fail "missing file: $f"
}

# 1) Universal/base files
check_file "AI_RULES.md"
check_file "AGENTS.md"
check_file "CLAUDE.md"
check_file ".github/copilot-instructions.md"
check_file "README.md"
check_file "README.en.md"
check_file "skills/universal-ai-guidelines/SKILL.md"
check_file "skills/universal-ai-guidelines/SKILL.zh-CN.md"
check_file "skills/universal-ai-guidelines/SKILL.en.md"
check_file "scripts/materialize-skill-language.sh"

# 2) OpenClaw/Codex compatibility (AGENTS)
grep -q "Priority & Conflict Policy" AGENTS.md && pass "AGENTS policy section present" || fail "AGENTS policy missing"
grep -q "Language Output Policy" AGENTS.md && pass "AGENTS language policy present" || fail "AGENTS language policy missing"

# 3) Claude compatibility (CLAUDE)
grep -q "Priority & Conflict Policy" CLAUDE.md && pass "CLAUDE policy section present" || fail "CLAUDE policy missing"
grep -q "Language Output Policy" CLAUDE.md && pass "CLAUDE language policy present" || fail "CLAUDE language policy missing"

# 4) Skill schema + language policy (source templates)
python3 - <<'PY'
from pathlib import Path
import sys
for fn in ['skills/universal-ai-guidelines/SKILL.zh-CN.md','skills/universal-ai-guidelines/SKILL.en.md']:
    p = Path(fn).read_text(encoding='utf-8')
    if 'name: universal-ai-guidelines' not in p:
        print(f'{fn}: skill name mismatch'); sys.exit(1)
    if 'description:' not in p:
        print(f'{fn}: description missing'); sys.exit(1)
print('ok')
PY
pass "skill templates metadata verified"

# 5) Skill language materialization behavior
bash scripts/materialize-skill-language.sh zh-CN >/dev/null
if grep -q "## English Version" skills/universal-ai-guidelines/SKILL.md; then
  fail "zh materialization should not include bilingual mixed markers"
fi
grep -q "# 通用 AI 编码代理规范" skills/universal-ai-guidelines/SKILL.md && pass "zh materialization verified" || fail "zh materialization mismatch"

echo "[INFO] testing EN materialization"
bash scripts/materialize-skill-language.sh en >/dev/null
if grep -q "## 中文版" skills/universal-ai-guidelines/SKILL.md; then
  fail "en materialization should not include bilingual mixed markers"
fi
grep -q "# Universal AI Coding Agent Guidelines" skills/universal-ai-guidelines/SKILL.md && pass "en materialization verified" || fail "en materialization mismatch"

# restore default zh for repo
bash scripts/materialize-skill-language.sh zh-CN >/dev/null

# 6) Plugin metadata path check
python3 - <<'PY'
import json,sys
from pathlib import Path
pl = json.loads(Path('.claude-plugin/plugin.json').read_text(encoding='utf-8'))
skills = pl.get('skills') or []
if './skills/universal-ai-guidelines' not in skills:
    print('plugin skills path mismatch'); sys.exit(1)
print('ok')
PY
pass "plugin metadata path verified"

# 7) Links check (except acknowledgements)
if grep -RIn "raw\.githubusercontent\.com/forrestchang\|forrestchang/andrej-karpathy-skills" README.md README.en.md | grep -v "上游\|Upstream" >/dev/null; then
  fail "found non-upstream links pointing to old repo"
fi
pass "links point to snowzlm repo (except explicit upstream acknowledgement)"

echo ""
echo "ALL_COMPAT_TESTS=PASS"
