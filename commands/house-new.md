---
description: Compatibility alias for the project-local opsx-propose workflow.
---

# house-new

Use the project-local OpenSpec proposal workflow with `$ARGUMENTS`.

Load the project-local `openspec-propose` skill and follow
`.opencode/commands/opsx-propose.md` exactly. Do not duplicate or replace its
artifact-generation instructions. Override only its next-step handoff: direct
the user to `/house-apply`, not `/opsx-apply`, after the artifacts are ready.

If either project-local asset is missing, stop and direct the user to run
`house-init`, then restart OpenCode before invoking `house-new` again.
