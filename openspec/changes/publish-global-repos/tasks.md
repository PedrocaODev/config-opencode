## 1. Curate the `config-opencode` baseline
- [x] 1.1 Inventory `~/.config/opencode` and classify current content into reusable tracked assets vs secrets/generated/machine-local files.
- [x] 1.2 Update the tracked/ignored baseline so `config-opencode` includes the house-* workflow and canonical docs while excluding secrets, caches, logs, backups, receipts, dependency directories, and other junk.
- [x] 1.3 Review the staged `config-opencode` file list and diff before the first commit to confirm no sensitive or host-specific files slipped in.

## 2. Bootstrap the two local repos
- [x] 2.1 Initialize git in `~/.config/opencode` and create the curated initial `config-opencode` commit.
- [x] 2.2 Initialize git in `~/.local/share/openspec/schemas/house-style` and create the initial `house-style-sdd` commit from the installed schema files.

## 3. Create and push the private GitHub repos
- [x] 3.1 Create `PedrocaOBanido/config-opencode` and `PedrocaOBanido/house-style-sdd` as private repos with `gh`.
- [x] 3.2 Add `origin` remotes and push the initial commit from each local repo.
- [x] 3.3 Verify both remotes have the expected private visibility and published contents.

## 4. Smoke-test the published workflow in CapyBet
- [ ] 4.1 Create an isolated CapyBet branch or worktree and run `house-adopt` against `~/projects/CapyBet`.
- [ ] 4.2 Run `house-new` for a scratch change in CapyBet and confirm `proposal`, `design`, `specs`, `tasks`, and `plan` are generated to apply-ready state.
- [ ] 4.3 Review the CapyBet smoke-test diff to confirm it is limited to the expected adoption and scratch-change files, then record the validation outcome for this change.
