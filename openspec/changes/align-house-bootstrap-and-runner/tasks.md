## 1. Add the minimal smoke harness

- [x] 1.1 Add `tests/smoke-house-workflow.sh` with `bootstrap`, `runner`, `apply`, and `all` modes.
- [x] 1.2 In disposable config, data, home, and project roots, verify profile `core`, delivery `both`, fresh generation, existing-root generation, sentinel preservation, forced regeneration, and the five expected command and skill names without changing the real OpenSpec config.
- [x] 1.3 Verify the `house-new`, Runner, and `house-apply` text contracts without invoking a model.
- [x] 1.4 Verify stale global generated skills and `trace-matrix` are absent.
- [x] 1.5 Statically verify schema assignment, delivery save and restore, direct-propose routing, and rejection of generated apply and archive routes.

## 2. Align the integration contracts

- [x] 2.1 Make `house-new` a thin alias for the project-local `opsx-propose` command and `openspec-propose` skill, with `house-init` and restart guidance when integration is missing.
- [x] 2.2 Route targeted and final checks through Runner, fixes through build or fixer, and affected reruns back through Runner.
- [x] 2.3 Treat failed and blocked checks as non-passing and require `verify.md` to record type, exact command, exit code, and outcome.
- [x] 2.4 Update the shared skill and active and delta specs to require a supported OpenSpec release, noting verification on 1.4.1.
- [x] 2.5 Remove the invalid `trace-matrix` skill and confirm stale global generated skills remain absent.
- [x] 2.6 Route house-style implementation and archive away from generated opsx commands, and make `house-new` override only the proposal handoff to `/house-apply`.
- [x] 2.7 Make global delivery changes temporary and restore the saved value on success or failure; keep profile `core` command-local.
- [x] 2.8 Require Runner `bash` approval while permanently prohibiting formatter, install, clean, deployment, release, migration, database mutation, and service, container, device, or emulator startup commands. Add validation, inspection, and configuration report types.

## 3. Verify the slice

- [ ] 3.1 Run shell syntax and the single `all` smoke mode, which reports bootstrap, Runner, and apply results once.
- [ ] 3.2 Run strict validation for the active spec and change, then inspect change status.
- [ ] 3.3 Run `git diff --check` and review status and diff scope.
- [ ] 3.4 Verify the real global OpenSpec values remain profile `core` and delivery `both` without mutating them.
- [ ] 3.5 Record the final rerun's exact commands, exit codes, types, and outcomes in `verify.md`.
- [x] 3.6 Extend smoke coverage for lifecycle routing and explicit `schema: house-style` setup in `house-init` and `house-adopt`.
