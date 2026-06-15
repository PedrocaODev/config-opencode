---
description: Archive a completed house-style change, commit, and sync with origin.
---

# house-archive

Archive a completed house-style change after verification and retrospective
are in order, then commit and sync with origin.

## Prerequisites

- All tasks in `tasks.md` must be checked.
- `verify.md` must exist with a passing outcome.
- The active workspace must be a git repository with an `origin` remote.

## Steps

1. **Load the skill if available.**
   Attempt to load `openspec-house-style`. If unavailable, proceed with the
   embedded guidance below.

2. **Check git preconditions.**
   - Run `git rev-parse --is-inside-work-tree` to confirm it is a git repo.
   - Run `git remote get-url origin` to confirm an `origin` remote exists.
   - If either check fails, stop and explain the missing precondition.
     Do not proceed.

3. **Verify artifacts are complete.**
   Confirm `tasks.md` is fully checked and `verify.md` shows a passing
   outcome. If either is missing or incomplete, stop and tell the user
   what to finish.

4. **Finalize retrospective.**
   If `retrospective.md` is missing, create and draft it. If it exists,
   read it and ensure it has content in all sections (what shipped, what
   went well, what to watch, follow-ups). If it is still a template or
   missing, ask the user to fill it in or delegate a draft to build.

5. **Archive with OpenSpec.**
   Run `openspec archive -y` (or the equivalent native archive flow) to
   move the change into the archive.

6. **Stage and commit.**
   Stage the intended files. Create one or more coherent commits aligned
   with the completed work. Use the repo's commit conventions.

7. **Sync with origin.**
   Push the branch to origin. Do not create a PR; only commit and push.

8. **Report result.**
   Tell the user the change is archived, committed, and synced.

Delegate file edits to build. Use repo-local specialists when available.
