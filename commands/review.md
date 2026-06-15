---
description: Launch a thorough code review of the specified code, changes, or files.
agent: reviewer
subtask: true
---

Review the specified code across these dimensions:

- Correctness and regression risk
- Performance — time and space complexity where relevant; note when complexity analysis is not applicable
- Memory usage and allocation patterns
- Security vulnerabilities
- Architecture and design quality — god classes, cohesion, coupling, layering
- Maintainability and readability

$ARGUMENTS

Review only. Do not fix code, do not suggest inline patches, and do not delegate implementation work. Inspect thoroughly, run non-mutating checks if applicable, and report findings with file paths, line numbers, and severity.

If no specific arguments are provided, review the current working context or the most recent changes.
