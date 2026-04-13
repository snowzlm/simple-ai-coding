#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PLUGIN_DIR="${1:-$ROOT/plugins/openclaw-universal-ai-guidelines}"
OUT_DIR="${2:-$ROOT/dist/plugins}"

if [ ! -f "$PLUGIN_DIR/package.json" ]; then
  echo "[ERR] package.json not found: $PLUGIN_DIR" >&2
  exit 1
fi

mkdir -p "$OUT_DIR"

PKG_NAME="$(cd "$PLUGIN_DIR" && node -p "require('./package.json').name")"
PKG_VERSION="$(cd "$PLUGIN_DIR" && node -p "require('./package.json').version")"

( cd "$PLUGIN_DIR" && npm pack --silent --pack-destination "$OUT_DIR" >/dev/null )

SAFE_NAME="${PKG_NAME#@}"
SAFE_NAME="${SAFE_NAME//\//-}"
PKG_FILE="$OUT_DIR/${SAFE_NAME}-${PKG_VERSION}.tgz"

if [ ! -f "$PKG_FILE" ]; then
  echo "[ERR] expected package not found: $PKG_FILE" >&2
  exit 1
fi

echo "[OK] $PKG_FILE"
