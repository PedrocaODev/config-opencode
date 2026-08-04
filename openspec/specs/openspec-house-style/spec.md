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

The system MUST provide global OpenCode commands for `house-init`, `house-adopt`, `house-new`, `house-apply`, and `house-archive`, plus the shared global `openspec-house-style` skill. The workflow MUST use project-local `/opsx-explore` for brainstorming and `/opsx-propose` for apply-ready artifact generation. When the active schema is `house-style`, implementation and archive MUST use `/house-apply` and `/house-archive`, not the generated `/opsx-apply` or `/opsx-archive` commands. The higher-priority global `AGENTS.md` rule MUST govern direct `/opsx-propose` use and replace its generated `/opsx-apply` next-step suggestion with `/house-apply`. `house-new` MUST remain a compatibility entry point for the `/opsx-propose` flow.

#### Scenario: Global commands and skill are available

Given the pack is installed
When OpenCode loads global commands and skills
Then `house-init.md`, `house-adopt.md`, `house-new.md`, `house-apply.md`, and `house-archive.md` MUST exist under `~/.config/opencode/commands/`
And one shared skill MUST exist under `~/.config/opencode/skills/`
And the workflow MUST be able to reuse the existing global review entry point instead of duplicating review policy

#### Scenario: Primary lifecycle entry points are available

Given a project was initialized or adopted by the house-style workflow
When OpenCode loads project-local commands and skills
Then `/opsx-explore` MUST be available for brainstorming
And `/opsx-propose` MUST be available for apply-ready artifact generation
And `/house-apply` MUST be available for implementation
And `/house-archive` MUST be available for closeout
And generated opsx apply and archive commands MUST NOT be used for those stages

#### Scenario: Compatibility proposal entry point is used

Given the project-local `opsx-propose` command and `openspec-propose` skill exist
When a user invokes `house-new`
Then `house-new` MUST follow those project-local instructions
And it MUST NOT maintain an independent artifact-generation procedure
And it MUST override only the next-step handoff to direct the user to `/house-apply`

#### Scenario: Compatibility proposal integration is missing

Given either project-local proposal asset is missing
When a user invokes `house-new`
Then the workflow MUST stop
And it MUST direct the user to run `house-init` and restart OpenCode

#### Scenario: Generated skills are project-local

Given project-local OpenSpec generation has passed for fresh and existing roots
When the global skill directory is inspected
Then global copies of `openspec-propose`, `openspec-explore`, `openspec-apply-change`, and `openspec-archive-change` MUST NOT exist
And the global `openspec-house-style` skill MUST remain available

### Requirement: Define the house-style artifact model

The `house-style` schema MUST define artifacts for `proposal`, `design`, `specs`, `tasks`, `plan`, `verify`, and `retrospective`. `/opsx-propose` and the compatible `house-new` entry point MUST generate `proposal`, `design`, `specs`, `tasks`, and `plan` before the change is apply-ready.

#### Scenario: Creating a new house-style change

Given a repository is using the `house-style` schema
When a user creates a change with `/opsx-propose` or compatible `house-new`
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

The workflow MUST support initializing a repository for house-style use and adopting an existing OpenSpec repository without clobbering unrelated local content. `house-init` and `house-adopt` MUST use a supported OpenSpec release to generate project-local OpenCode commands and skills with profile `core` and delivery `both`. This behavior is verified on OpenSpec 1.4.1.

Before generation, each command MUST save the current global `delivery` value. It MUST set `delivery` to `both` only when the saved value differs. It MUST restore the saved value before returning on success or failure. The `--profile core` option MUST remain command-local and MUST NOT change the global profile.

#### Scenario: Initialize a fresh repository

Given a repository does not contain an OpenSpec root
When the user runs `house-init`
Then the workflow MUST run `openspec init . --tools opencode --profile core`
And delivery MUST be `both`
And the workflow MUST set `schema: house-style`
And five OpenSpec-generated OpenCode commands MUST exist in the project
And five OpenSpec-generated OpenCode skill directories MUST exist in the project

#### Scenario: Adopt an existing repository without complete OpenCode integration

Given a repository contains an OpenSpec root
And `.opencode/commands/opsx-propose.md` or `.opencode/skills/openspec-propose/SKILL.md` is missing
When the user runs `house-adopt`
Then the workflow MUST run `openspec init . --tools opencode --profile core` against the existing root
And delivery MUST be `both`
And the workflow MUST set `schema: house-style`
And five OpenSpec-generated OpenCode commands MUST exist in the project
And five OpenSpec-generated OpenCode skill directories MUST exist in the project
And unrelated local files, configuration keys, and existing changes MUST remain unchanged

#### Scenario: Refresh an already configured repository

Given a repository has the selected OpenCode integration
And its proposal command and skill are present
When the user runs `house-init` or `house-adopt`
Then the workflow MUST run `openspec update .`
And it MUST use `openspec update --force .` only if regeneration is required to produce the complete integration
And all five generated commands and five generated skill directories MUST exist after refresh

### Requirement: Enforce tests-first implementation

The apply workflow MUST start implementation with test creation or test adjustment and follow TDD for each behavioral task. After each implementation slice, it MUST delegate planned targeted checks to Runner.

#### Scenario: Implementing a behavioral change

Given a change has pending implementation tasks
When the user runs `house-apply`
Then the workflow MUST direct implementation to begin with an automated test that fails before the code change
And code changes MUST follow only after that failing test exists
And if a task has no meaningful automated test path, the workflow MUST require an explicit recorded exception before proceeding
And Runner MUST execute the planned targeted checks after the slice

#### Scenario: Targeted verification does not pass

Given Runner reports a targeted check as failed or blocked
When `house-apply` processes the report
Then the result MUST be non-passing
And fixes MUST be assigned to build or a narrowly scoped fixer, not Runner
And the affected check MUST be delegated to Runner again after the fix

### Requirement: Provide a framework-agnostic read-only Runner

Runner MUST execute repository-defined unit, integration, build, lint, validation, inspection, and configuration checks without editing source or managed configuration. Runner MUST report results and MUST NOT implement fixes or perform environment preparation. Runner `bash` tool commands MUST require user approval. Edit and task delegation MUST remain denied.

#### Scenario: Runner reports a check

Given Runner receives a repository-defined check
When it executes or determines that the check cannot safely run
Then it MUST report the check type, exact command, exit code, and passed, failed, or blocked outcome
And the check type MUST be unit, integration, build, lint, validation, inspection, or configuration
And a failed or blocked outcome MUST be non-passing

#### Scenario: Runner is asked to fix or prepare

Given a check requires a source fix, formatter, dependency installation, clean command, deployment, release publication, migration, database mutation, or service, container, device, or emulator startup
When Runner evaluates the request
Then Runner MUST NOT perform that action
And it MUST report the check as failed or blocked as applicable

### Requirement: Close the loop on review

The workflow MUST run review/fix loops until no actionable issues remain.

#### Scenario: Review finds issues

Given implementation work for the planned tasks is complete
When the workflow runs its review step
Then each actionable finding MUST be resolved or explicitly dispositioned
And the workflow MUST rerun review after fixes
And the change MUST NOT move to final verification while actionable review findings remain

### Requirement: Run final verification after review

The workflow MUST delegate the final test and verification suite to Runner only after the review loop is clear.

#### Scenario: Review is clean

Given targeted TDD checks passed
And the review loop reports no actionable issues
When the workflow reaches final verification
Then Runner MUST run the planned final test and verification commands
And `verify.md` MUST record every check's type, exact command, exit code, and outcome
And a passing overall outcome MUST require every planned check to pass
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

