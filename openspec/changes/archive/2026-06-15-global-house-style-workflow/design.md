## Context

This change adds a global workflow layer: the files live in the user's global OpenCode and OpenSpec directories, but the commands operate against whichever project workspace is active.

## Goals / Non-Goals

**Goals:**

- Provide a reusable global schema for house-style OpenSpec changes.
- Provide global commands that bootstrap and drive the workflow across projects.
- Encode TDD-first implementation, review/fix loops, final verification, and archive git closeout as reusable workflow behavior.
- Preserve existing global `review.md` and project-local `opsx-*` scaffolding by default.

**Non-Goals:**

- Replacing the existing global review command.
- Rewriting archived historical changes.
- Making `~/.config/opencode` itself a git repository.

## Decisions

### Separate schema, command, and skill responsibilities

- Schema (`~/.local/share/openspec/schemas/house-style/`) owns the artifact graph, templates, instructions, and apply gates.
- Commands (`~/.config/opencode/commands/house-*.md`) own user-facing entry points, workspace/change selection, and CLI orchestration.
- Skill (`~/.config/opencode/skills/openspec-house-style/`) owns the shared rules for TDD, review loops, verification ordering, and archive discipline.

### Keep the workflow global but execute locally

- The global pack installs once under the user's home directories.
- `house-init` and `house-adopt` configure a target repository to use `house-style` without turning the global config directory into the active target.
- Git checks and `origin` sync in `house-archive` always apply to the active workspace repo, not `~/.config/opencode`.

### Archive ordering: archive → commit → sync origin

- `openspec archive -y` runs first to move the change into the archive.
- Then the staged files are committed into one or more coherent commits.
- Then the branch is pushed to origin.
- This ordering ensures the archive step is complete before any git
  history is created.

### Use `plan` as the apply gate

- `proposal`, `design`, `specs`, and `tasks` stay as the planning foundation.
- `plan` becomes the apply gate so implementation cannot start without task slices, tests-first order, review checkpoints, and intended final verification.
- `verify` and `retrospective` are late-stage artifacts, not apply prerequisites.

### Preserve existing scaffolding by default

- Existing global `commands/review.md` stays in place and is reused by the house-style workflow.
- Existing local `.opencode/commands/opsx-*.md` files from `openspec init` are preserved unless the user explicitly chooses cleanup.
- Avoid `opencode.jsonc` changes unless command validation proves the shared skill cannot be loaded through the intended lane.

## Risks / Trade-offs

- Standardizing workflow behavior does not standardize each repo's real test commands; commands still need to discover project-local validation commands.
- TDD-first is strong policy, but some tasks may need explicit exceptions when no meaningful automated test path exists.
- Archive owns commit/push closeout, which improves consistency but makes archive stricter in repos without clean git/origin setup.
