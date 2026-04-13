#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILL_DIR="$ROOT/skills/universal-ai-guidelines"
OUT_DIR="${1:-$ROOT/dist}"
OUT_FILE="$OUT_DIR/universal-ai-guidelines.skill"

mkdir -p "$OUT_DIR"

python3 - <<'PY' "$SKILL_DIR" "$OUT_FILE"
import os,sys,zipfile
from pathlib import Path
skill_dir = Path(sys.argv[1]).resolve()
out_file = Path(sys.argv[2]).resolve()
with zipfile.ZipFile(out_file, 'w', zipfile.ZIP_DEFLATED) as z:
    for p in sorted(skill_dir.rglob('*')):
        if p.is_dir():
            continue
        arc = Path(skill_dir.name) / p.relative_to(skill_dir)
        z.write(p, arcname=str(arc))
print(f"[OK] {out_file}")
PY
