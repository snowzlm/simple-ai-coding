#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILL_DIR="$ROOT/skills/universal-ai-guidelines"
TARGET="$SKILL_DIR/SKILL.md"

MODE="${1:-auto}"

resolve_lang() {
  local m="$1"
  if [[ "$m" != "auto" ]]; then
    echo "$m"
    return
  fi

  local env_lang="${LC_ALL:-${LANG:-}}"
  env_lang="${env_lang,,}"
  if [[ "$env_lang" == zh* || "$env_lang" == *"_cn"* || "$env_lang" == *"-cn"* ]]; then
    echo "zh-CN"
  else
    echo "en"
  fi
}

LANG_CODE="$(resolve_lang "$MODE")"
SRC=""

case "$LANG_CODE" in
  zh|zh-cn|zh_CN|zh-CN)
    SRC="$SKILL_DIR/SKILL.zh-CN.md"
    ;;
  en|en-us|en_US|en-US|en-gb|en_GB|en-GB)
    SRC="$SKILL_DIR/SKILL.en.md"
    ;;
  *)
    # fallback: zh for CJK-like preference else en
    low="${LANG_CODE,,}"
    if [[ "$low" == zh* ]]; then
      SRC="$SKILL_DIR/SKILL.zh-CN.md"
    else
      SRC="$SKILL_DIR/SKILL.en.md"
    fi
    ;;
esac

cp "$SRC" "$TARGET"
echo "[OK] materialized SKILL.md from $(basename "$SRC")"
