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

3. **Save the global delivery setting.**
   Work from the project root. Save the current global `delivery` value by
   running `openspec config get delivery` and recording its exact output before
   any other OpenSpec operation. `--profile core` is command-local. Do not
   change the global profile.

4. **Ensure OpenSpec generates the project-local OpenCode integration.**
   Treat this step through schema assignment and verification as one guarded
   operation. Temporarily set `delivery` to `both` only if the saved value is
   not `both`. Then choose exactly one path:
   - If `openspec/` does not exist, run
     `openspec init . --tools opencode --profile core`.
   - If either `.opencode/commands/opsx-propose.md` or
     `.opencode/skills/openspec-propose/SKILL.md` is missing, run
     `openspec init . --tools opencode --profile core` against the existing root.
   - Otherwise, run `openspec update .`.

5. **Set the schema to house-style.**
   Update the config to set `schema: house-style`. Preserve all other
   existing config keys.

6. **Verify the generated core integration.**
   Confirm these five commands exist under `.opencode/commands/`:
   `opsx-apply.md`, `opsx-archive.md`, `opsx-explore.md`, `opsx-propose.md`,
   and `opsx-sync.md`. Confirm these five skill directories exist under
   `.opencode/skills/`: `openspec-apply-change`, `openspec-archive-change`,
   `openspec-explore`, `openspec-propose`, and `openspec-sync-specs`. If the
   selected OpenCode integration is still incomplete or stale, run
   `openspec update --force .` once and verify all ten assets again. Do not
   remove or replace unrelated project-local files or generated assets.

7. **Leave existing changes as-is.**
   Do not migrate or rewrite changes already in `openspec/changes/`.
   The user can migrate them explicitly if desired.

8. **Restore the global delivery setting.**
   Restore the saved global `delivery` value before returning on success or failure
   with `openspec config set delivery <saved-value>`. If any guarded
   operation fails, restore the value before reporting that failure. If
   restoration fails, report the restoration failure and do not claim success.

9. **Report result.**
   Tell the user the repo now uses house-style for new changes and existing
   changes are unaffected. Tell the user to restart OpenCode so project-local
   commands and skills are loaded. Report the lifecycle as optional
   brainstorming with `/opsx-explore`, proposal with `/opsx-propose` (or
   compatible `house-new`), implementation with `/house-apply`, and archive
   with `/house-archive`.

Delegate file edits to build. Use repo-local specialists when available.
