## Implementation slices

### Slice 1: Curate the `config-opencode` tracked baseline
**Tasks:** 1.1-1.3
**Tests first:** Review the candidate tracked file list before the first commit and treat any secret/junk hit as a failing preflight.
**TDD exception:** Repository curation and ignore-rule setup have no meaningful automated red/green test path; use manual inventory, staged-file review, and secret/junk checks instead.

### Slice 2: Bootstrap local git histories
**Tasks:** 2.1-2.2
**Tests first:** Confirm both source directories are currently non-git and that the staged file lists match the curated baselines before creating the initial commits.
**TDD exception:** `git init`, first-commit bootstrap, and remote wiring are operational setup steps with no meaningful automated TDD harness.

### Slice 3: Create and push the private GitHub repos
**Tasks:** 3.1-3.3
**Tests first:** Verify `gh` auth/owner context and repo-name availability before the first push.
**TDD exception:** GitHub repo creation and push are external bootstrap actions; verify them with `gh repo view`, `git remote -v`, and successful push results.

### Slice 4: Smoke-test on CapyBet
**Tasks:** 4.1-4.3
**Tests first:** On an isolated CapyBet branch or worktree, run `house-adopt` and `house-new <scratch-change>` to prove the published schema and commands work through apply-ready generation.
**TDD exception:** none

## Review checkpoints
- After Slice 1: review the `config-opencode` tracked/ignored set with special attention to secrets, receipts, backups, dependency directories, and other machine-local files.
- After Slice 3: review both remote repos for private visibility, correct `origin` wiring, and expected initial contents before touching CapyBet.
- After Slice 4: review the CapyBet smoke-test diff to confirm only the intended adoption and scratch-change artifacts were created.

## Final verification intent
- `gh repo view PedrocaOBanido/config-opencode --json name,visibility,url`
- `gh repo view PedrocaOBanido/house-style-sdd --json name,visibility,url`
- In `~/.config/opencode`: verify `git status --short`, `git remote -v`, and the tracked file list match the curated safe baseline.
- In `~/.local/share/openspec/schemas/house-style`: verify `git status --short`, `git remote -v`, and the tracked files match the installed schema contents.
- In `~/projects/CapyBet`: verify the scratch change reaches apply-ready state after `house-adopt` / `house-new`, and verify the resulting diff is limited to expected adoption/test files.

## Intended commit grouping
- Commit 1 (`config-opencode`): curated initial private snapshot of the global OpenCode config, workflow files, and canonical docs.
- Commit 2 (`house-style-sdd`): initial private snapshot of the installed global house-style schema.
- No permanent CapyBet commit is planned for the smoke test; keep its validation changes isolated unless a separate intentional CapyBet change is later approved.
