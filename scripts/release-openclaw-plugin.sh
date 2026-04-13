#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PLUGIN_DIR="$ROOT/plugins/openclaw-universal-ai-guidelines"
BUMP="${1:-patch}"
OUT_DIR="${2:-$ROOT/dist/plugins}"

if [ ! -d "$PLUGIN_DIR" ]; then
  echo "[ERR] plugin dir missing: $PLUGIN_DIR" >&2
  exit 1
fi

cd "$PLUGIN_DIR"
npm version "$BUMP" --no-git-tag-version >/dev/null
NEW_VERSION="$(node -p "require('./package.json').version")"

echo "[INFO] plugin version => $NEW_VERSION"

cd "$ROOT"
bash scripts/build-openclaw-plugin-package.sh "$PLUGIN_DIR" "$OUT_DIR"

echo "[DONE] release bundle ready (version=$NEW_VERSION)"
