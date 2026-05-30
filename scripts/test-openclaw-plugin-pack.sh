#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
PLUGIN_DIR="$REPO_ROOT/plugins/openclaw-universal-ai-guidelines"

cd "$REPO_ROOT"

node <<'NODE'
const fs = require('fs');
const path = require('path');

const repoRoot = process.cwd();
const pluginDir = path.join(repoRoot, 'plugins', 'openclaw-universal-ai-guidelines');
const manifestPath = path.join(pluginDir, 'openclaw.plugin.json');
const packagePath = path.join(pluginDir, 'package.json');

const manifest = JSON.parse(fs.readFileSync(manifestPath, 'utf8'));
const pkg = JSON.parse(fs.readFileSync(packagePath, 'utf8'));

if (manifest.id !== 'universal-ai-guidelines') {
  throw new Error(`unexpected plugin id: ${manifest.id}`);
}
if (!Array.isArray(manifest.skills) || manifest.skills.length !== 1 || manifest.skills[0] !== './skills') {
  throw new Error(`unexpected skills declaration: ${JSON.stringify(manifest.skills)}`);
}
if (!pkg.openclaw || !Array.isArray(pkg.openclaw.extensions) || pkg.openclaw.extensions[0] !== './index.js') {
  throw new Error('package.json openclaw.extensions is missing ./index.js');
}
NODE

node --input-type=module <<'NODE'
import path from 'node:path';
import { pathToFileURL } from 'node:url';

const pluginEntry = path.resolve('plugins/openclaw-universal-ai-guidelines/index.js');
const mod = await import(pathToFileURL(pluginEntry).href);

if (!mod.default || mod.default.id !== 'universal-ai-guidelines') {
  throw new Error('plugin default export is missing or has wrong id');
}
if (typeof mod.default.register !== 'function') {
  throw new Error('plugin register() hook is missing');
}
NODE

for skill_file in \
  "$PLUGIN_DIR/skills/universal-ai-guidelines/SKILL.md" \
  "$PLUGIN_DIR/skills/universal-ai-guidelines/SKILL.zh-CN.md" \
  "$PLUGIN_DIR/skills/universal-ai-guidelines/SKILL.en.md"
do
  [[ -f "$skill_file" ]] || { echo "missing skill file: $skill_file" >&2; exit 1; }
done

echo "OpenClaw plugin pack smoke passed."
