## Context
`~/.config/opencode` contains the global OpenCode setup: house-* commands, shared skills, agents, plugins, OpenSpec docs, and other reusable files, but it also contains local-only state such as account files, caches/logs, receipts, backups, and dependency directories. `~/.local/share/openspec/schemas/house-style` is smaller and currently contains the installed schema root plus templates. Neither directory is a git repo today.

GitHub auth is already active as `PedrocaOBanido`, and the target repos must be private. `~/projects/CapyBet` is an existing git/OpenSpec repo still using `schema: spec-driven`, so validation should use `house-adopt`, not `house-init`.

## Goals / Non-Goals
**Goals:**
- Publish two private repos: `PedrocaOBanido/config-opencode` and `PedrocaOBanido/house-style-sdd`.
- Use the current local directories as the starting point for both repos.
- Make `config-opencode` safe to share privately by tracking only reusable workflow/docs/config and excluding secrets plus machine-local junk.
- Validate the published house-style workflow on CapyBet after both pushes succeed.

**Non-Goals:**
- Publishing anything publicly.
- Preserving every machine-local file under `~/.config/opencode`.
- Reworking the house-style workflow behavior beyond what safe tracking or smoke-test fixes require.
- Running a full product implementation in CapyBet just to exercise `house-apply` or `house-archive`.

## Decisions
### Decision: Curate `config-opencode` as a safe tracked baseline
Track the reusable global workflow assets and canonical docs from the current directory: house-* commands, shared skills, agents, plugins, OpenSpec docs/specs/changes, and any supporting config or scaffolding files needed to reconstruct the setup. Exclude secrets, caches, logs, backups, receipts, vendor/dependency directories, and other machine-local artifacts. Re-evaluate currently ignored package manifests/locks and keep them only if they are required source for the tracked workflow. The ignore policy itself must be versioned.

### Decision: Initialize both published repos in place
Create separate git histories directly inside `~/.config/opencode` and `~/.local/share/openspec/schemas/house-style`. This keeps each repo aligned with the installed local content and makes later updates a normal commit/push flow rather than a copy/export step.

### Decision: Use `gh` for private repo creation and normal `git` remotes for sync
Create `PedrocaOBanido/config-opencode` and `PedrocaOBanido/house-style-sdd` with `gh repo create ... --private`, then wire each local repo to its own `origin` and push its curated initial commit. The two repos stay independent; this change is an operational umbrella, not a monorepo migration.

### Decision: Validate on CapyBet with a minimal isolated smoke test
Use a dedicated CapyBet branch or worktree. Run `house-adopt` to switch the repo to `house-style`, then run `house-new` for a scratch change and confirm the change reaches apply-ready with `proposal`, `design`, `specs`, `tasks`, and `plan` generated. This exercises the published schema plus command set without forcing an unrelated implementation change in CapyBet.

## Risks / Trade-offs
- Sensitive values may hide inside otherwise normal config files, so the tracked-file review before first push is the highest-risk step.
- In-place git init changes the day-to-day shape of both directories, but it is the simplest way to make the installed copies authoritative.
- This change spans multiple repos plus one validation repo, so commit/archive boundaries are per repo rather than a single linear history.
- CapyBet smoke testing will intentionally create adoption/test diffs; isolation is required to keep them separate from normal project work.
