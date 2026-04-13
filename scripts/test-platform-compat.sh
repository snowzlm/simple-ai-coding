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
check_file "plugins/openclaw-universal-ai-guidelines/package.json"
check_file "plugins/openclaw-universal-ai-guidelines/openclaw.plugin.json"
check_file "plugins/openclaw-universal-ai-guidelines/index.js"
check_file "plugins/openclaw-universal-ai-guidelines/skills/universal-ai-guidelines/SKILL.md"
check_file "plugins/openclaw-universal-ai-guidelines/skills/universal-ai-guidelines/SKILL.zh-CN.md"
check_file "plugins/openclaw-universal-ai-guidelines/skills/universal-ai-guidelines/SKILL.en.md"

grep -q "Language Scope Policy" AI_RULES.md && pass "AI_RULES language scope present" || fail "AI_RULES language scope missing"
if grep -q "Language Output Policy" AI_RULES.md; then
  fail "AI_RULES still contains global language output policy"
fi

# 2) OpenClaw/Codex compatibility (AGENTS)
grep -q "Priority & Conflict Policy" AGENTS.md && pass "AGENTS policy section present" || fail "AGENTS policy missing"
grep -q "Language Scope Policy" AGENTS.md && pass "AGENTS language scope present" || fail "AGENTS language scope missing"
if grep -q "Language Output Policy" AGENTS.md; then
  fail "AGENTS still contains global language output policy"
fi

# 3) Claude compatibility (CLAUDE)
grep -q "Priority & Conflict Policy" CLAUDE.md && pass "CLAUDE policy section present" || fail "CLAUDE policy missing"
grep -q "Language Scope Policy" CLAUDE.md && pass "CLAUDE language scope present" || fail "CLAUDE language scope missing"
if grep -q "Language Output Policy" CLAUDE.md; then
  fail "CLAUDE still contains global language output policy"
fi

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
if 'OpenClaw' in (pl.get('description') or ''):
    print('plugin description should not imply OpenClaw plugin runtime'); sys.exit(1)

mk = json.loads(Path('.claude-plugin/marketplace.json').read_text(encoding='utf-8'))
if 'OpenClaw' in ((mk.get('metadata') or {}).get('description') or ''):
    print('marketplace metadata should not imply OpenClaw plugin runtime'); sys.exit(1)
print('ok')
PY
pass "plugin metadata path and scope verified"

# 7) OpenClaw plugin package metadata + entry smoke check
python3 - <<'PY'
import json,sys
from pathlib import Path
pkg = json.loads(Path('plugins/openclaw-universal-ai-guidelines/package.json').read_text(encoding='utf-8'))
exts = ((pkg.get('openclaw') or {}).get('extensions') or [])
if './index.js' not in exts:
    print('openclaw.extensions missing ./index.js'); sys.exit(1)
manifest = json.loads(Path('plugins/openclaw-universal-ai-guidelines/openclaw.plugin.json').read_text(encoding='utf-8'))
if manifest.get('id') != 'universal-ai-guidelines':
    print('openclaw.plugin.json id mismatch'); sys.exit(1)
if './skills' not in (manifest.get('skills') or []):
    print('openclaw.plugin.json skills path mismatch'); sys.exit(1)
print('ok')
PY
pass "openclaw plugin package metadata verified"

node -e "import('./plugins/openclaw-universal-ai-guidelines/index.js').then(m=>{const p=m.default||{};if(p.id!=='universal-ai-guidelines'||typeof p.register!=='function'){throw new Error('plugin entry invalid')}console.log('ok')})" >/dev/null
pass "openclaw plugin entry smoke verified"

# 8) Links check (except acknowledgements)
if grep -RIn "raw\.githubusercontent\.com/forrestchang\|forrestchang/andrej-karpathy-skills" README.md README.en.md | grep -v "上游\|Upstream" >/dev/null; then
  fail "found non-upstream links pointing to old repo"
fi
pass "links point to snowzlm repo (except explicit upstream acknowledgement)"

echo ""
echo "ALL_COMPAT_TESTS=PASS"
