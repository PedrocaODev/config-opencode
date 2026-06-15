---
description: Initialize a repository for the global house-style OpenSpec workflow.
---

# house-init

Initialize the active repository to use the global `house-style` OpenSpec schema.

## Steps

1. **Load the skill if available.**
   Attempt to load `openspec-house-style`. If unavailable, proceed with the
   embedded guidance below.

2. **Check if OpenSpec is initialized in this repo.**
   If `openspec/` does not exist in the project root, run `openspec init --tools opencode` to
   create it.

3. **Create or update the local openspec config.**
   Ensure `openspec/config.yaml` sets `schema: house-style`. Do not delete or
   overwrite unrelated local config keys.

4. **Verify the global schema is reachable.**
   Confirm that `~/.local/share/openspec/schemas/house-style/schema.yaml`
   exists. If it does not, stop and tell the user the global house-style pack
   is not installed.

5. **Preserve local scaffolding.**
   Do not remove any existing `.opencode/commands/opsx-*.md` files.

6. **Report result.**
   Tell the user the repo is ready for `house-new`.

Delegate file edits to build. Use repo-local specialists when available.
