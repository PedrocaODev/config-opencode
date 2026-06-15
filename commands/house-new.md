---
description: Create or resume a house-style change and generate artifacts to apply-ready.
---

# house-new

Create a new house-style change or resume an existing one, and drive the
artifact sequence through apply-ready state.

## Steps

1. **Load the skill if available.**
   Attempt to load `openspec-house-style`. If unavailable, proceed with the
   embedded guidance below.

2. **Determine the change name.**
   Use the first argument as the change name. If none provided, ask the user.

3. **Create or resume the change.**
   Run `openspec new change "<name>" --schema house-style` if the change does
   not exist, or `openspec status --change "<name>" --json` to check an
   existing one.

4. **Generate the planning artifacts in order.**
   For each artifact, use `openspec instructions <artifact> --change "<name>" --json`
   to get the generation prompt, then delegate the content generation to build
   (or a repo-local specialist if available):

   - **proposal.md** — why this change matters, what it covers.
   - **design.md** — context, decisions, trade-offs, risks.
   - **specs/** — delta specifications for changed capabilities.
   - **tasks.md** — ordered implementation task list.
   - **plan.md** — implementation plan with:
     - Test-first slices (each slice names the test written before code).
     - TDD exceptions for slices with no meaningful test path.
     - Review checkpoints after selected slices.
     - Final verification intent (commands that run after review is clean).
     - Intended commit grouping.

5. **Mark the change as apply-ready.**
   Once all five planning artifacts exist and the plan includes
   tests-first slices, review checkpoints, and verification intent, the
   change is apply-ready. Use `openspec status --change "<name>" --json` to
   confirm readiness.

6. **Report result.**
   Tell the user the change is ready for `house-apply`.

Delegate file edits to build. Use repo-local specialists when available.
