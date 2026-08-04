---
name: openspec-house-style
description: Global house-style workflow pack for OpenSpec and OpenCode. Use when the user invokes any house-* command or explicitly asks for the house-style workflow.
---

# openspec-house-style

Global house-style workflow pack for OpenSpec and OpenCode.

## When to load

Load this skill when the user invokes any `house-*` command or explicitly asks
for the house-style workflow. The skill provides the shared rules that the
commands rely on; if loading fails, the commands contain enough embedded
guidance to operate as a fallback.

## Core rules

### Project bootstrap

- Use a supported OpenSpec release to generate project-local OpenCode
  integration with profile `core` and delivery `both`. This behavior is
  verified on OpenSpec 1.4.1.
- Before bootstrap, save the current global `delivery` value. Temporarily set
  `delivery` to `both` only if needed for generation. Restore the saved value
  before returning on success or failure.
- The `--profile core` option is command-local. Do not change the global
  OpenSpec profile during bootstrap.
- Use `openspec init . --tools opencode --profile core` for a fresh root or an
  existing root missing the OpenCode integration.
- Use `openspec update .` for an already configured root. Use
  `openspec update --force .` only when regeneration is required.
- Preserve unrelated OpenSpec configuration, existing changes, project-local
  files, and generated assets.
- Verify all five core `opsx-*` command files and all five core `openspec-*`
  skill directories exist after bootstrap.
- Bootstrap smoke verification runs isolated OpenSpec CLI operations and checks
  Markdown command contracts statically. It does not execute Markdown commands.

### Primary lifecycle

- Use `/opsx-explore` for optional brainstorming.
- Use `/opsx-propose` for apply-ready proposal generation. `house-new` is a
  thin compatibility alias that follows the project-local `opsx-propose`
  command and `openspec-propose` skill, overriding only their next-step handoff
  to direct the user to `/house-apply` instead of `/opsx-apply`.
- The higher-priority global `AGENTS.md` house-style rule governs direct
  `/opsx-propose` use. Replace the generated `/opsx-apply` next-step suggestion
  with `/house-apply`.
- If those project-local assets are missing, run `house-init` and restart
  OpenCode before proposing a change.
- When the active schema is `house-style`, do not use generated `/opsx-apply`
  or `/opsx-archive`; use `/house-apply` for implementation and
  `/house-archive` for closeout.
- Restart OpenCode after bootstrap so project-local commands and skills load.

### Test-first implementation

- Every behavioral task starts with a test that fails before production code
  is written.
- If a task has no meaningful automated test path, record an explicit TDD
  exception in the plan slice before proceeding.
- Do not skip the failing-test step for convenience.

### Review / fix loops

- After each review checkpoint, fix or explicitly disposition every actionable
  finding.
- Rerun review after fixes.
- Do not advance to final verification while actionable findings remain.

### Runner verification

- Delegate planned targeted checks to Runner after every implementation slice.
- Runner reports results only. Route fixes to build or a narrowly scoped fixer,
  then delegate affected checks to Runner again.
- Treat Runner `FAILED` and `BLOCKED` results as non-passing.

### Final verification

- Final verification runs through Runner only after the review loop is clean.
- In `verify.md`, record every check's type, exact command, exit code (or
  `NOT RUN`), and outcome.
- Record a passing outcome only when every planned check passed.
- The change is not archive-ready until that record exists.

### Archive discipline

- Archive runs after verification and retrospective are complete.
- Archive ordering: `openspec archive -y` → commit → sync origin.
- Do not promise PR creation; only commit and push.

### Active workspace

- Commands operate against the current working directory / active project repo.
- Git checks and `origin` sync always apply to the active workspace, never to
  `~/.config/opencode`.

### Skill availability fallback

- If this skill cannot be loaded (permission, availability, or config issue),
  the commands contain embedded step-by-step guidance that covers the same
  workflow.
- Commands should attempt to load this skill when available but must work
  without it.
