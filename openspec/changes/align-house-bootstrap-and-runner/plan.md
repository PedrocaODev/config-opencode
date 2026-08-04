## Implementation slices

### Slice 1: Add isolated smoke coverage

**Tasks:** 1.1-1.5
**Tests first:** Add the single smoke script. Its bootstrap mode runs supported OpenSpec operations in disposable config, data, home, and project roots; fingerprints the real OpenSpec config before and after; and inspects bootstrap command contracts. Its Runner and apply modes inspect contracts without invoking a model.
**TDD exception:** Static prompt contracts cannot execute an agent deterministically, so the script verifies their required and prohibited text directly.

### Slice 2: Align workflow contracts

**Tasks:** 2.1-2.8
**Tests first:** Run the relevant smoke mode before and after the command, skill, spec, and deletion changes. Keep only the assertions needed by the requested integration contract.
**TDD exception:** none

### Slice 3: Final verification

**Tasks:** 3.1-3.6
**Tests first:** Run every smoke mode, strict OpenSpec validation, and the diff checks from clean disposable fixture state. Any failed or blocked check is non-passing.
**TDD exception:** This slice records evidence from the behavioral checks created in Slice 1.

## Review checkpoints

- After Slice 1: review isolation, cleanup, generated names, and confirm the script cannot invoke a model.
- After Slice 2: review alias behavior and next-step handoff, house lifecycle routing, Runner boundaries, apply ordering, supported-release wording, and deletion scope. Fix actionable findings before final verification.

## Final verification intent

- `bash -n tests/smoke-house-workflow.sh`
- `tests/smoke-house-workflow.sh all`
- `openspec validate openspec-house-style --type spec --strict --no-interactive`
- `openspec validate align-house-bootstrap-and-runner --type change --strict --no-interactive`
- `openspec status --change align-house-bootstrap-and-runner --json`
- `git diff --check`
- `git status --short`
- `git diff --stat`
- `openspec config get profile`
- `openspec config get delivery`

The final smoke command must print one `bootstrap: PASS`, one `runner: PASS`,
and one `apply: PASS`. The final configuration inspections must confirm the
real global values remain `profile=core` and `delivery=both`; final verification
does not mutate either value.

## Intended commit grouping

No commit is planned because the user explicitly requested no commit.
