# openspec-house-style Specification

## Purpose

This spec defines the global house-style OpenSpec/OpenCode workflow pack. It covers the global schema, global commands (`house-init`, `house-adopt`, `house-new`, `house-apply`, `house-archive`), the shared skill, TDD-first apply flow, review loops, final verification, and archive-to-commit-to-sync-origin expectations.
## Requirements
### Requirement: Provide a global house-style pack

The system MUST provide a reusable OpenSpec house-style pack installed outside any single project repository.

#### Scenario: Fresh global OpenSpec home

Given `~/.config/opencode` exists
And `~/.local/share/openspec` does not yet exist
When the house-style pack is installed
Then the directory `~/.local/share/openspec/schemas/house-style/` MUST be created
And the pack MUST be usable without requiring `~/.config/opencode` itself to be a git repository

### Requirement: Provide global OpenCode entry points

The system MUST provide global OpenCode commands for `house-init`, `house-adopt`, `house-new`, `house-apply`, and `house-archive`, plus one shared global skill for the house-style rules.

#### Scenario: Global commands and skill are available

Given the pack is installed
When OpenCode loads global commands and skills
Then `house-init.md`, `house-adopt.md`, `house-new.md`, `house-apply.md`, and `house-archive.md` MUST exist under `~/.config/opencode/commands/`
And one shared skill MUST exist under `~/.config/opencode/skills/`
And the workflow MUST be able to reuse the existing global review entry point instead of duplicating review policy

### Requirement: Define the house-style artifact model

The `house-style` schema MUST define artifacts for `proposal`, `design`, `specs`, `tasks`, `plan`, `verify`, and `retrospective`.

#### Scenario: Creating a new house-style change

Given a repository is using the `house-style` schema
When a user creates a change with `house-new`
Then the workflow MUST create the artifacts required before implementation
And `proposal`, `design`, `specs`, `tasks`, and `plan` MUST be complete before the change is apply-ready
And `verify` and `retrospective` MUST remain available for later lifecycle stages

#### Scenario: Preparing an apply-ready plan

Given `proposal`, `design`, `specs`, and `tasks` exist for a change
When the workflow creates `plan`
Then the plan MUST describe implementation slices
And it MUST describe the tests-first order for those slices
And it MUST identify review checkpoints and intended final verification

### Requirement: Support initialization and adoption

The workflow MUST support both initializing a repository for house-style use and adopting an existing OpenSpec repository into the house style without clobbering unrelated local scaffolding by default.

#### Scenario: Adopting a repository with local `opsx-*` scaffolding

Given a repository already contains local `.opencode/commands/opsx-*.md` files from `openspec init`
When the user runs `house-adopt`
Then the workflow MUST prepare the repository to use the global `house-style` schema going forward
And it MUST NOT overwrite those existing local `opsx-*` files unless the user explicitly chooses cleanup

### Requirement: Enforce tests-first implementation

The apply workflow MUST start implementation with test creation or test adjustment and follow TDD for each behavioral task.

#### Scenario: Implementing a behavioral change

Given a change has pending implementation tasks
When the user runs `house-apply`
Then the workflow MUST direct implementation to begin with an automated test that fails before the code change
And code changes MUST follow only after that failing test exists
And if a task has no meaningful automated test path, the workflow MUST require an explicit recorded exception before proceeding

### Requirement: Close the loop on review

The workflow MUST run review/fix loops until no actionable issues remain.

#### Scenario: Review finds issues

Given implementation work for the planned tasks is complete
When the workflow runs its review step
Then each actionable finding MUST be resolved or explicitly dispositioned
And the workflow MUST rerun review after fixes
And the change MUST NOT move to final verification while actionable review findings remain

### Requirement: Run final verification after review

The workflow MUST run the final test and verification suite only after the review loop is clear.

#### Scenario: Review is clean

Given targeted TDD checks passed
And the review loop reports no actionable issues
When the workflow reaches final verification
Then it MUST run the planned final test and verification commands
And it MUST record the outcome in `verify`
And the change MUST NOT be archive-ready until that record exists

### Requirement: Archive completed changes into coherent commits and sync them with origin

The archive workflow MUST group completed work into one or more intentional commits, sync the active repository with `origin`, and capture the closeout artifacts.

#### Scenario: Archiving from a tracked git repository

Given the active workspace is a git repository with an `origin` remote
And the change tasks and verification record are complete
When the user runs `house-archive`
Then the workflow MUST finalize the retrospective
And it MUST run `openspec archive -y` (or equivalent) to move the change to archive
And it MUST then stage and create one or more coherent commits aligned with the completed work
And it MUST then sync the branch with `origin`
And the ordering MUST be archive → commit → sync origin

#### Scenario: Archive precondition is not met

Given the active workspace is not a git repository or has no `origin` remote
When the user runs `house-archive`
Then the workflow MUST stop and explain the missing precondition
And it MUST NOT silently skip the commit or sync steps

