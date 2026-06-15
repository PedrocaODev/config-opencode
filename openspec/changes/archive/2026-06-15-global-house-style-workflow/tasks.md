## 1. Schema foundation

- [x] 1.1 Create `~/.local/share/openspec/schemas/house-style/` and add the schema metadata/root files.
- [x] 1.2 Define the artifact graph and lifecycle gates for `proposal`, `design`, `specs`, `tasks`, `plan`, `verify`, and `retrospective`.

## 2. Artifact instructions

- [x] 2.1 Write templates/instructions for `proposal`, `design`, `specs`, and `tasks`.
- [x] 2.2 Write templates/instructions for `plan`, `verify`, and `retrospective`, including TDD, review-loop, final-verification, and archive expectations.

## 3. Shared workflow skill

- [x] 3.1 Add `~/.config/opencode/skills/openspec-house-style/SKILL.md` with the shared house rules and active-workspace assumptions.
- [x] 3.2 Validate whether the intended command lane can load that skill under the current `opencode.jsonc` permissions; if not, choose and document the fallback before finishing the commands.

## 4. Global commands

- [x] 4.1 Add `~/.config/opencode/commands/house-init.md` for repo initialization against the global `house-style` schema.
- [x] 4.2 Add `~/.config/opencode/commands/house-adopt.md` for non-destructive adoption of existing OpenSpec repos, preserving local `.opencode/commands/opsx-*.md` by default.
- [x] 4.3 Add `~/.config/opencode/commands/house-new.md` to create a change and drive the apply-ready artifacts.
- [x] 4.4 Add `~/.config/opencode/commands/house-apply.md` to enforce TDD, targeted checks, review/fix loops, and post-review final verification.
- [x] 4.5 Add `~/.config/opencode/commands/house-archive.md` to sync specs, finalize `retrospective`, group work into commit(s), and sync with `origin`.

## 5. Dry runs

- [x] 5.1 Dry-run `house-init` and `house-new` in a scratch git repo to confirm the global schema path resolves and the artifact order is correct.
- [x] 5.2 Dry-run `house-adopt` against a repo that already has `.opencode/commands/opsx-*.md` to confirm those files are preserved unless explicitly cleaned up.
- [x] 5.3 Dry-run `house-apply` on a sample change to confirm the sequence is TDD -> targeted checks -> review loop -> final verification.
- [x] 5.4 Dry-run `house-archive` in both a tracked git repo and a non-git/no-`origin` workspace to confirm success behavior and precondition failures.

## 6. Final notes

- [x] 6.1 Add brief usage notes covering the `house-*` commands, the shared skill, and the fact that archive git operations apply to the active project repo, not `~/.config/opencode`.
