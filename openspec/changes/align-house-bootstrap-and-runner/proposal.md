## Why

The house-style workflow does not currently ensure that each adopted project has the OpenSpec-generated OpenCode commands and skills needed for the standard `opsx-*` lifecycle. It also duplicates proposal behavior in `house-new` and performs verification without a framework-agnostic, read-only source agent.

A supported OpenSpec release provides the required project-local generation and regeneration behavior, verified here on 1.4.1. The house workflow should use those native operations, make the standard `opsx-explore` and `opsx-propose` entry points primary, and route verification through Runner without giving Runner write or environment-management responsibilities.

## What Changes

- Make `house-init` and `house-adopt` save and restore the global delivery value while generating project-local OpenCode core commands and skills with command-local profile `core` and temporary delivery `both`.
- Use `/opsx-explore` for brainstorming and `/opsx-propose` for apply-ready house-style artifacts, followed by `/house-apply` and `/house-archive`, never generated opsx apply or archive commands, for implementation and closeout.
- Keep `house-new` as a compatibility alias for `/opsx-propose` during this change.
- Remove stale global generated copies of the `openspec-propose`, `openspec-explore`, `openspec-apply-change`, and `openspec-archive-change` skills only after project-local generation is verified. Keep the global `openspec-house-style` skill.
- Replace the Android-specific Runner contract with a framework-agnostic, read-only source agent that executes repository-defined tests, builds, lint, validation, inspection, and configuration checks while refusing environment-changing commands.
- Route targeted and final `house-apply` verification through Runner. Route fixes back to implementation agents.
- Add runnable fresh-root, existing-root, regeneration, and Runner smoke verification.

## Capabilities

### New Capabilities

- None.

### Modified Capabilities

- `openspec-house-style`: Align project bootstrap, proposal entry points, generated-skill ownership, and verification routing with supported OpenSpec releases and a read-only Runner.

## Impact

- Affected files during implementation are limited to the global house commands, `agents/runner.md`, the shared `openspec-house-style` skill, stale global generated skill directories, and focused verification scripts or tests.
- Existing projects gain project-local OpenSpec commands and skills without replacing unrelated local content.
- `house-new` remains available, so this change does not require an immediate command migration.
- Runner loses formatter and Android-specific behavior. It must not install dependencies, deploy, start services, or edit files.
- Removal of stale global generated skills is gated on successful project-local generation checks for fresh and existing OpenSpec roots.
