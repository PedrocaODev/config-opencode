# Verification

Every planned check passed. No blocked or failed check is recorded as passing.

| Type | Exact command | Exit code | Outcome |
| --- | --- | ---: | --- |
| integration | `rtk proxy tests/smoke-house-workflow.sh bootstrap` | 0 | PASSED |
| lint | `rtk proxy tests/smoke-house-workflow.sh runner` | 0 | PASSED |
| lint | `rtk proxy tests/smoke-house-workflow.sh apply` | 0 | PASSED |
| integration | `rtk proxy tests/smoke-house-workflow.sh all` | 0 | PASSED |
| lint | `rtk openspec validate openspec-house-style --type spec --strict --no-interactive` | 0 | PASSED |
| lint | `rtk openspec validate align-house-bootstrap-and-runner --type change --strict --no-interactive` | 0 | PASSED |
| lint | `rtk openspec status --change align-house-bootstrap-and-runner --json` | 0 | PASSED |
| lint | `rtk git diff --check` | 0 | PASSED |
| lint | `rtk git status --short` | 0 | PASSED |
| lint | `rtk git diff --stat` | 0 | PASSED |
| configuration | `openspec config profile core` | 0 | PASSED |
| configuration | `openspec config get profile` | 0 | PASSED (`core`) |
| configuration | `openspec config get delivery` | 0 | PASSED (`both`) |

The global profile restoration was performed by the orchestrator after final
verification because Runner is prohibited from mutating managed configuration.
