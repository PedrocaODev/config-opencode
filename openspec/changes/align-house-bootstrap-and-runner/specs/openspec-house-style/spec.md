# openspec-house-style Specification

## ADDED Requirements

### Requirement: Provide a framework-agnostic read-only Runner

Runner MUST act as a read-only source verification agent for repositories independent of their application framework or build system. Runner MUST discover commands from repository-owned instructions and configuration. Runner MAY run repository-defined unit tests, integration tests, builds, lint, validation, inspection, and configuration checks. Runner `bash` tool commands MUST require user approval. Runner MUST NOT edit source or managed configuration or delegate tasks.

#### Scenario: Run repository-defined checks

Given a repository defines unit test, integration test, build, and lint commands
When Runner receives a request to verify the repository
Then Runner MUST execute the repository-defined commands in the requested scope
And Runner MUST NOT replace them with framework-specific defaults

#### Scenario: Repository does not define a requested check

Given the repository does not define a command for a requested check
When Runner prepares the verification run
Then Runner MUST report the check as blocked
And Runner MUST NOT invent a command

#### Scenario: Verification preserves the source tree

Given the source tree has a recorded pre-run state
When Runner completes a verification request
Then the source and managed configuration diff MUST match the pre-run state

### Requirement: Prohibit environment-changing Runner commands

Runner MUST NOT run formatters, dependency installation, clean commands, deployment, release publication, migrations, database mutations, or service, container, device, or emulator startup commands, even with approval. If a requested check requires one of these actions, Runner MUST report the required action as an external precondition. Build outputs and test reports remain permitted.

#### Scenario: Requested command is prohibited

Given a repository defines a formatter or dependency installation command
When a verification request includes that command
Then Runner MUST refuse to execute the command
And Runner MUST report the verification item as blocked
And Runner MUST identify the external action required before verification can continue

#### Scenario: Integration tests require a service

Given a repository-defined integration test requires a service that is not running
When Runner cannot execute the test without starting the service
Then Runner MUST NOT start the service
And Runner MUST report the service as an external precondition

### Requirement: Report actionable verification evidence

Runner MUST report the exact command and exit code for each executed command. For each failure, Runner MUST report a failure class, the test or check identifier, `file:line` when the command output provides it, bounded evidence, known cascades, and one next action.

Each report MUST classify its check type as unit, integration, build, lint, validation, inspection, or configuration.

#### Scenario: A test command fails

Given a repository-defined test command exits with a nonzero status
When Runner reports the result
Then the report MUST include the exact command
And the report MUST include the nonzero exit code
And the report MUST classify the failure
And the report MUST identify the failing test or check
And the report MUST include `file:line` when present in output
And the report MUST include a bounded excerpt of failure evidence
And the report MUST state the next action

#### Scenario: One failure causes downstream failures

Given command output identifies one primary failure and later dependent failures or skipped checks
When Runner reports the result
Then Runner MUST identify the primary failure
And Runner MUST list the dependent results as cascades
And Runner MUST NOT present each cascade as an independent root cause

### Requirement: Verify bootstrap and workflow contracts with runnable checks

The house-style workflow MUST provide a runnable smoke script for fresh OpenSpec roots, existing OpenSpec roots, forced regeneration, the Runner contract, and `house-apply` routing without invoking a model. Bootstrap verification MUST execute isolated OpenSpec CLI operations and MUST verify Markdown command behavior through static contract assertions; it MUST NOT claim to execute the Markdown commands.

#### Scenario: Bootstrap verification is isolated

Given the bootstrap smoke check starts
When it creates fresh and existing fixtures
Then it MUST use temporary project roots
And it MUST isolate OpenSpec global configuration from the user's active home
And it MUST remove or leave disposable all created fixture state

#### Scenario: Contract smoke verification

Given the Runner and house command files are installed
When the Runner or apply smoke mode executes
Then it MUST verify Runner's required frontmatter and report fields
And it MUST verify Runner's prohibited responsibilities
And it MUST verify targeted and final check ordering and fix routing
And it MUST NOT invoke Runner or any other model

## MODIFIED Requirements

### Requirement: Provide global OpenCode entry points

The system MUST provide global OpenCode commands for `house-init`, `house-adopt`, `house-new`, `house-apply`, and `house-archive`, plus the shared global `openspec-house-style` skill. The workflow MUST use project-local `/opsx-explore` for brainstorming and project-local `/opsx-propose` for apply-ready artifact generation. When the active schema is `house-style`, implementation and archive MUST use `/house-apply` and `/house-archive`, not the generated `/opsx-apply` or `/opsx-archive` commands. The higher-priority global `AGENTS.md` rule MUST govern direct `/opsx-propose` use and replace its generated `/opsx-apply` next-step suggestion with `/house-apply`. `house-new` MUST remain a compatibility alias for `/opsx-propose`.

#### Scenario: Primary proposal flow is available

Given a project was initialized or adopted by the house-style workflow
When OpenCode loads project-local commands and skills
Then `/opsx-explore` MUST be available for brainstorming
And `/opsx-propose` MUST be available for apply-ready artifact generation
And `house-apply` MUST be available for implementation
And `house-archive` MUST be available for closeout
And generated opsx apply and archive commands MUST NOT be used for implementation or closeout

#### Scenario: Compatibility proposal entry point is used

Given `house-new` is installed
When a user invokes `house-new` for a change
Then `house-new` MUST delegate to the `/opsx-propose` artifact-generation flow
And it MUST NOT maintain an independent artifact-generation procedure
And it MUST override only the next-step handoff to direct the user to `/house-apply`

#### Scenario: Compatibility proposal integration is missing

Given the project-local `opsx-propose` command or `openspec-propose` skill is missing
When a user invokes `house-new`
Then it MUST direct the user to run `house-init`
And it MUST require an OpenCode restart before retrying

#### Scenario: Global generated skill copies are retired

Given project-local OpenSpec command and skill generation has passed for fresh and existing roots
When global generated skills are cleaned up
Then `openspec-propose`, `openspec-explore`, `openspec-apply-change`, and `openspec-archive-change` MUST NOT remain as global skill copies
And the global `openspec-house-style` skill MUST remain available

### Requirement: Define the house-style artifact model

The `house-style` schema MUST define artifacts for `proposal`, `design`, `specs`, `tasks`, `plan`, `verify`, and `retrospective`. `/opsx-propose` and its `house-new` compatibility alias MUST generate `proposal`, `design`, `specs`, `tasks`, and `plan` before the change is apply-ready.

#### Scenario: Creating an apply-ready house-style change

Given a repository uses the `house-style` schema
When a user runs `/opsx-propose` or its `house-new` compatibility alias
Then `proposal`, `design`, `specs`, `tasks`, and `plan` MUST be complete before the change is apply-ready
And `verify` and `retrospective` MUST remain available for later lifecycle stages

#### Scenario: Preparing an apply-ready plan

Given `proposal`, `design`, `specs`, and `tasks` exist for a change
When the workflow creates `plan`
Then the plan MUST describe implementation slices
And it MUST describe the tests-first order for those slices
And it MUST identify review checkpoints
And it MUST identify targeted Runner checks
And it MUST identify final Runner verification

### Requirement: Support initialization and adoption

The workflow MUST support initializing a repository for house-style use and adopting an existing OpenSpec repository without clobbering unrelated local content. `house-init` and `house-adopt` MUST use a supported OpenSpec release to generate project-local OpenCode commands and skills with profile `core` and delivery `both`. This behavior is verified on OpenSpec 1.4.1.

Before generation, each command MUST save the current global `delivery` value. It MUST set `delivery` to `both` only when the saved value differs. It MUST restore the saved value before returning on success or failure. The `--profile core` option MUST remain command-local and MUST NOT change the global profile.

#### Scenario: Initialize a fresh repository

Given a repository does not contain an OpenSpec root
When the user runs `house-init`
Then the workflow MUST initialize OpenSpec for OpenCode with profile `core` and delivery `both`
And the workflow MUST set `schema: house-style`
And five OpenSpec-generated OpenCode commands MUST exist in the project
And five OpenSpec-generated OpenCode skills MUST exist in the project

#### Scenario: Adopt an existing OpenSpec repository without OpenCode integration

Given a repository contains an OpenSpec root
And the repository does not contain the complete project-local OpenCode core integration
When the user runs `house-adopt`
Then the workflow MUST run OpenSpec initialization against the existing root with tool `opencode` and profile `core`
And it MUST ensure delivery `both`
And it MUST set `schema: house-style`
And five OpenSpec-generated OpenCode commands MUST exist in the project
And five OpenSpec-generated OpenCode skills MUST exist in the project
And unrelated local files and existing changes MUST remain unchanged

#### Scenario: Regenerate an incomplete OpenCode integration

Given a house-style repository has a selected OpenCode integration
And one or more generated OpenCode assets are missing or stale
When `house-init` or `house-adopt` repairs the integration
Then the workflow MUST run `openspec update --force <root>` or the supported release's equivalent
And the complete five-command and five-skill core integration MUST exist after the update

### Requirement: Enforce tests-first implementation

The apply workflow MUST start each behavioral implementation task with test creation or adjustment and follow TDD. After each implementation slice, `house-apply` MUST delegate the planned targeted checks to Runner. If Runner reports a source or test failure, `house-apply` MUST return the failure to an implementation agent for correction.

#### Scenario: Implement a behavioral change

Given a change has a pending behavioral task
When the user runs `house-apply`
Then an implementation agent MUST begin with an automated test that fails before the code change
And production code changes MUST follow only after that failing test exists
And Runner MUST execute the planned targeted checks after implementation
And if a task has no meaningful automated test path, the workflow MUST require an explicit recorded exception before proceeding

#### Scenario: Targeted verification fails

Given Runner reports a failed targeted check
When `house-apply` processes the report
Then `house-apply` MUST send the bounded failure evidence to an implementation agent
And Runner MUST NOT apply the fix
And Runner MUST rerun the affected check after the fix

### Requirement: Run final verification after review

The workflow MUST run final verification through Runner only after the review loop is clear. The workflow MUST record Runner's check types, exact commands, exit codes, and outcomes in `verify.md`. Failed and blocked checks MUST be non-passing.

#### Scenario: Review is clean

Given targeted TDD checks passed
And the review loop reports no actionable issues
When the workflow reaches final verification
Then Runner MUST execute the commands listed in the plan's final verification intent
And the workflow MUST record each check's type, exact command, exit code, and outcome in `verify.md`
And the change MUST NOT be archive-ready until `verify.md` records a passing outcome

#### Scenario: Final verification fails

Given Runner reports a final verification failure
When `house-apply` processes the report
Then the workflow MUST return the failure to an implementation agent
And the review and verification gates MUST be repeated as required after the fix
And the workflow MUST NOT record a passing outcome until Runner reports all planned checks passed

## REMOVED Requirements

None.
