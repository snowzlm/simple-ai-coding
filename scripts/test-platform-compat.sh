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

# 2) OpenClaw/Codex compatibility (AGENTS)
grep -q "Priority & Conflict Policy" AGENTS.md && pass "AGENTS policy section present" || fail "AGENTS policy missing"
grep -q "Language Output Policy" AGENTS.md && pass "AGENTS language policy present" || fail "AGENTS language policy missing"

# 3) Claude compatibility (CLAUDE)
grep -q "Priority & Conflict Policy" CLAUDE.md && pass "CLAUDE policy section present" || fail "CLAUDE policy missing"
grep -q "Language Output Policy" CLAUDE.md && pass "CLAUDE language policy present" || fail "CLAUDE language policy missing"

# 4) Skill schema + language policy
python3 - <<'PY'
from pathlib import Path
import re,sys
p = Path('skills/universal-ai-guidelines/SKILL.md').read_text(encoding='utf-8')
if 'name: universal-ai-guidelines' not in p:
    print('skill name mismatch'); sys.exit(1)
if 'description:' not in p:
    print('skill description missing'); sys.exit(1)
if 'Output Language Policy' not in p and '输出语言策略' not in p:
    print('skill language policy missing'); sys.exit(1)
print('ok')
PY
pass "skill metadata and language policy verified"

# 5) Plugin metadata path check
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

# 6) Links check (except acknowledgements)
if grep -RIn "raw\.githubusercontent\.com/forrestchang\|forrestchang/andrej-karpathy-skills" README.md README.en.md | grep -v "上游\|Upstream" >/dev/null; then
  fail "found non-upstream links pointing to old repo"
fi
pass "links point to snowzlm repo (except explicit upstream acknowledgement)"

echo ""
echo "ALL_COMPAT_TESTS=PASS"
