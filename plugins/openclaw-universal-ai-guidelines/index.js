/**
 * Minimal OpenClaw native plugin entry.
 * Scope: expose installable plugin package shape for OpenClaw plugin flow.
 */
export default {
  id: "universal-ai-guidelines",
  name: "Universal AI Guidelines",
  description: "OpenClaw plugin package for universal AI coding guidelines",
  register(api) {
    api.logger?.info?.("universal-ai-guidelines plugin loaded");
  }
};
