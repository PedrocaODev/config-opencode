---
description: Implement an apply-ready house-style change with test-first slices, review loops, and final verification.
---

# house-apply

Implement a house-style change that is already in apply-ready state.

## Prerequisites

- A change must exist with `proposal.md`, `design.md`, `specs/`, `tasks.md`,
  and `plan.md` all present and complete.
- The plan must include tests-first slices, review checkpoints, and final
  verification intent.

## Steps

1. **Load the skill if available.**
   Attempt to load `openspec-house-style`. If unavailable, proceed with the
   embedded guidance below.

2. **Confirm apply-ready state.**
   Verify all five planning artifacts exist. If any are missing, stop and
   tell the user to run `house-new` first.

3. **Read the plan.**
   Load `plan.md` and identify the ordered slices, review checkpoints,
   and final verification intent.

4. **Implement each slice test-first.**
   For each slice in plan order:

   a. Write or adjust the test first. Confirm it fails (red).
   b. Implement the production code. Confirm the test passes (green).
   c. If the plan records a TDD exception for this slice, proceed without
      the failing-test step and note the exception in the task log.
   d. Run targeted checks (lint, typecheck, unit tests for the affected
      area).

   Delegate all code writing to build. Use repo-local specialists when
   available.

5. **Run review at checkpoints.**
   At each review checkpoint defined in the plan:
   - Use the existing global `/review` command or delegate to the
     reviewer/oracle specialist.
   - Fix every actionable finding or explicitly disposition it.
   - Rerun review after fixes.
   - Do not advance until the review loop is clean.

6. **Run final verification.**
   After the last review loop is clean:
   - Execute the commands listed under "Final verification intent" in the
     plan.
   - Create or update `verify.md` with the outcome, commands run, and
     pass/fail status.

7. **Mark tasks complete.**
   Update `tasks.md` checkboxes as tasks finish. All tasks must be checked
   before archive.

8. **Report result.**
   Tell the user the change is ready for `house-archive`.

Delegate file edits to build. Use repo-local specialists when available.
