#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PLUGIN_DIR="$ROOT/plugins/openclaw-universal-ai-guidelines"
PLUGIN_ID="universal-ai-guidelines"
TMP_DIR="$(mktemp -d)"
INSPECT_JSON="$TMP_DIR/inspect.json"

cleanup() {
  openclaw plugins uninstall "$PLUGIN_ID" --force >/dev/null 2>&1 || true
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

inspect_to_json() {
  local out_file="$1"
  local raw_file="$TMP_DIR/inspect.raw"
  openclaw plugins inspect "$PLUGIN_ID" --json > "$raw_file"
  python3 - <<'PY' "$raw_file" "$out_file"
import json,sys
raw = open(sys.argv[1], encoding='utf-8').read()
start = raw.find('{')
end = raw.rfind('}')
if start < 0 or end < start:
    raise SystemExit('inspect json not found in output')
obj = json.loads(raw[start:end+1])
with open(sys.argv[2], 'w', encoding='utf-8') as f:
    json.dump(obj, f)
PY
}

assert_loaded() {
  local json_file="$1"
  python3 - <<'PY' "$json_file"
import json,sys
p = json.load(open(sys.argv[1], encoding='utf-8')).get('plugin', {})
if p.get('id') != 'universal-ai-guidelines':
    raise SystemExit('inspect id mismatch')
if p.get('format') != 'openclaw':
    raise SystemExit('inspect format mismatch')
if p.get('status') != 'loaded':
    raise SystemExit('inspect status mismatch')
print('ok')
PY
}

openclaw plugins uninstall "$PLUGIN_ID" --force >/dev/null 2>&1 || true

# 1) link install acceptance
openclaw plugins install --link "$PLUGIN_DIR" >/dev/null
inspect_to_json "$INSPECT_JSON"
assert_loaded "$INSPECT_JSON"
openclaw plugins uninstall "$PLUGIN_ID" --force >/dev/null

# 2) tgz install acceptance
bash "$ROOT/scripts/build-openclaw-plugin-package.sh" "$PLUGIN_DIR" "$TMP_DIR" >/dev/null
TGZ_FILE="$(ls "$TMP_DIR"/*.tgz | head -n 1)"
openclaw plugins install "$TGZ_FILE" >/dev/null
inspect_to_json "$INSPECT_JSON"
assert_loaded "$INSPECT_JSON"
openclaw plugins uninstall "$PLUGIN_ID" --force >/dev/null

echo "OPENCLAW_PLUGIN_ACCEPTANCE=PASS"
