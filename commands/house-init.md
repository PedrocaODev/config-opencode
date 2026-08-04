---
description: Initialize a repository for the global house-style OpenSpec workflow.
---

# house-init

Initialize the active repository to use the global `house-style` OpenSpec schema.

## Steps

1. **Load the skill if available.**
   Attempt to load `openspec-house-style`. If unavailable, proceed with the
   embedded guidance below.

2. **Save the global delivery setting.**
   Work from the project root. Save the current global `delivery` value by
   running `openspec config get delivery` and recording its exact output before
   any other OpenSpec operation. `--profile core` is command-local. Do not
   change the global profile.

3. **Ensure OpenSpec generates the project-local OpenCode integration.**
   Treat this step through schema assignment and verification as one guarded
   operation. Temporarily set `delivery` to `both` only if the saved value is
   not `both`. Then choose exactly one path:
   - If `openspec/` does not exist, run
     `openspec init . --tools opencode --profile core`.
   - If either `.opencode/commands/opsx-propose.md` or
     `.opencode/skills/openspec-propose/SKILL.md` is missing, run
     `openspec init . --tools opencode --profile core` against the existing root.
   - Otherwise, run `openspec update .`.

4. **Create or update the local openspec config.**
   Ensure `openspec/config.yaml` sets `schema: house-style`. Do not delete or
   overwrite unrelated local config keys.

5. **Verify the global schema is reachable.**
   Confirm that `~/.local/share/openspec/schemas/house-style/schema.yaml`
   exists. If it does not, stop and tell the user the global house-style pack
   is not installed.

6. **Verify the generated core integration.**
   Confirm these five commands exist under `.opencode/commands/`:
   `opsx-apply.md`, `opsx-archive.md`, `opsx-explore.md`, `opsx-propose.md`,
   and `opsx-sync.md`. Confirm these five skill directories exist under
   `.opencode/skills/`: `openspec-apply-change`, `openspec-archive-change`,
   `openspec-explore`, `openspec-propose`, and `openspec-sync-specs`. If the
   selected OpenCode integration is still incomplete or stale, run
   `openspec update --force .` once and verify all ten assets again. Do not
   remove or replace unrelated project-local files or generated assets.

7. **Restore the global delivery setting.**
   Restore the saved global `delivery` value before returning on success or failure
   with `openspec config set delivery <saved-value>`. If any guarded
   operation fails, restore the value before reporting that failure. If
   restoration fails, report the restoration failure and do not claim success.

8. **Report result.**
   Tell the user to restart OpenCode so project-local commands and skills are
   loaded. Report the lifecycle as optional brainstorming with
   `/opsx-explore`, proposal with `/opsx-propose` (or compatible `house-new`),
   implementation with `/house-apply`, and archive with `/house-archive`.

Delegate file edits to build. Use repo-local specialists when available.
