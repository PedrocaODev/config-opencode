## Code Editing Delegation

The orchestrator NEVER writes or edits code directly. Do not use bash, sed, awk, or any shell tool to modify source files. All code writing and editing must be delegated to @fixer (or another write-capable specialist like @screen-author, @source-author, etc.).

## Blocking User Input

- When immediate user input is required, use the `question` tool when it is available.
- If `question` is absent from the current tool manifest, ask once in a normal response and end the turn. Never use `wait_for_user` as its fallback.
- Use `wait_for_user` only after giving concrete steps for an external manual operation.
- Scheduler reminders and Background Job Board updates are not user answers; do not repeat the question or resume work based only on them.
