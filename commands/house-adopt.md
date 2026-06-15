---
description: Non-destructively adopt an existing OpenSpec repo into the global house-style workflow.
---

# house-adopt

Point an existing OpenSpec repository at the global `house-style` schema
without clobbering local scaffolding.

## Steps

1. **Load the skill if available.**
   Attempt to load `openspec-house-style`. If unavailable, proceed with the
   embedded guidance below.

2. **Verify the global schema exists.**
   Confirm `~/.local/share/openspec/schemas/house-style/schema.yaml` is
   present. If not, stop and explain the pack is not installed.

3. **Locate the repo's openspec config.**
   Find the local `openspec/config.yaml` or equivalent. If none exists,
   run `openspec init --tools opencode` first.

4. **Set the schema to house-style.**
   Update the config to set `schema: house-style`. Preserve all other
   existing config keys.

5. **Leave local opsx files alone.**
   Do not remove or modify existing `.opencode/commands/opsx-*.md` files.
   Cleanup is opt-in only.

6. **Leave existing changes as-is.**
   Do not migrate or rewrite changes already in `openspec/changes/`.
   The user can migrate them explicitly if desired.

7. **Report result.**
   Tell the user the repo now uses house-style for new changes. Existing
   changes are unaffected.

Delegate file edits to build. Use repo-local specialists when available.
