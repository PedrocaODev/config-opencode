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

### Final verification

- Final verification runs only after the review loop is clean.
- Record the outcome in `verify.md`.
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
