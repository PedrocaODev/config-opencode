## Why
The global OpenCode config and installed `house-style` schema currently exist only as local directories. They have no private remote backup, and `~/.config/opencode` mixes reusable workflow assets with secrets, generated dependencies, caches, and other machine-local files. We need safe, repeatable source control for both global assets without publishing private data.

After the repos are published, we also need confidence that the shipped house-style workflow still works in a real project, using `~/projects/CapyBet` as the validation target.

## What Changes
- Curate `~/.config/opencode` into a safe tracked baseline for a private `PedrocaOBanido/config-opencode` repo.
- Initialize and publish the installed `~/.local/share/openspec/schemas/house-style` directory as a private `PedrocaOBanido/house-style-sdd` repo.
- Create both GitHub repos with `gh` CLI, add remotes, and push initial commits from the current local content.
- Smoke-test the published house-style workflow on `~/projects/CapyBet` after both repos are live.

## Capabilities
### New Capabilities
- `global-repo-publishing`: Private publication of the global OpenCode config and house-style schema with safe content curation and downstream workflow validation.

### Modified Capabilities
- None.

## Impact
- `~/.config/opencode` and `~/.local/share/openspec/schemas/house-style` will become separately tracked git repos.
- `config-opencode` must include the house-* workflow and canonical docs, but exclude secrets, caches, logs, backups, receipts, and other machine-local artifacts.
- `house-style-sdd` must mirror the installed schema files from the current local directory.
- CapyBet validation should run on an isolated branch or worktree so workflow smoke testing does not pollute unrelated work.
