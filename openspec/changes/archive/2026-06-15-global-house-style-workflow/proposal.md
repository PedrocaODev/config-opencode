## Why

The current global setup already has `~/.config/opencode/` with shared agents, skills, `commands/review.md`, and local `opsx-*` scaffolding from `openspec init`, but it does not yet have a reusable OpenSpec house style. That leaves change structure, implementation discipline, review flow, and archive behavior inconsistent across projects.

We want one global workflow pack that can be installed once and reused anywhere.

## What Changes

- Add a global OpenSpec schema at `~/.local/share/openspec/schemas/house-style/`.
- Add global OpenCode commands at `~/.config/opencode/commands/house-init.md`, `house-adopt.md`, `house-new.md`, `house-apply.md`, and `house-archive.md`.
- Add one shared global skill under `~/.config/opencode/skills/` for the house-style rules.
- Define a house-style artifact set with `proposal`, `design`, `specs`, `tasks`, `plan`, `verify`, and `retrospective`.
- Make implementation start with tests and follow TDD, include review/fix loops until no actionable issues remain, and run final tests after review is clean.
- Make archive finalize retrospective context, group work into coherent commit(s), and sync with `origin`.

## Capabilities

### New Capabilities

- `openspec-house-style`: Global house-style workflow pack for OpenSpec and OpenCode.

### Modified Capabilities

None.

## Impact

- Affects global OpenSpec schema resolution through `~/.local/share/openspec/schemas/house-style/`.
- Affects global OpenCode command and skill behavior under `~/.config/opencode/`.
- Does not require `~/.config/opencode` itself to be a git repository.
- Preserves existing `commands/review.md` and local `.opencode/commands/opsx-*.md` scaffolding by default.
