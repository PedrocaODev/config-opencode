# Global Repo Publishing Specification

## ADDED Requirements

### Requirement: Publish a curated private `config-opencode` repo
The system MUST publish `~/.config/opencode` into a private repo that preserves reusable workflow assets and canonical docs while excluding secrets and machine-local junk.

#### Scenario: Preparing the safe tracked baseline
Given `~/.config/opencode` contains house-* workflow files, OpenSpec docs, and local-only artifacts
When the `config-opencode` baseline is prepared
Then the tracked set MUST start from the current local content
And it MUST include the house-* workflow and canonical docs needed to reconstruct the global setup
And secrets, caches, logs, backups, receipts, vendor/dependency directories, and other machine-local artifacts MUST be excluded from version control
And the ignore policy for those exclusions MUST itself be tracked in the repo

### Requirement: Publish the installed house-style schema as `house-style-sdd`
The system MUST publish the installed global `house-style` schema from `~/.local/share/openspec/schemas/house-style` into its own private repo.

#### Scenario: Preparing the schema repo from installed files
Given `~/.local/share/openspec/schemas/house-style` contains the installed schema
When the `house-style-sdd` repo is prepared
Then the repo MUST start from the current local directory contents
And it MUST track the installed `schema.yaml` and template files needed to reconstruct the schema
And it MUST remain separate from the `config-opencode` repo

### Requirement: Create and push both private GitHub repos with `gh`
The system MUST create the target GitHub repos under `PedrocaOBanido` with private visibility and push the curated initial commits from the local directories.

#### Scenario: Publishing from non-git local directories
Given `~/.config/opencode` is not yet a git repo
And `~/.local/share/openspec/schemas/house-style` is not yet a git repo
And GitHub auth is active as `PedrocaOBanido`
When publishing is executed
Then `config-opencode` and `house-style-sdd` MUST be created under `PedrocaOBanido` with private visibility using `gh` CLI
And each local repo MUST get its own `origin` remote
And each curated initial commit MUST be pushed successfully

### Requirement: Smoke-test the published workflow on CapyBet
After both repos are pushed, the system MUST validate the published house-style workflow on `~/projects/CapyBet`.

#### Scenario: Adopting an existing spec-driven repo for validation
Given `~/projects/CapyBet` is an existing git repo with OpenSpec configured
And its current `openspec/config.yaml` uses `schema: spec-driven`
When post-publish validation runs
Then the validation MUST run on an isolated branch or equivalent workspace
And it MUST adopt CapyBet to `house-style`
And it MUST create a scratch house-style change to apply-ready state
And it MUST confirm the resulting diff is limited to the expected adoption and scratch-change files
