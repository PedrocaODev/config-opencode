# Agent journey-evaluation protocol

The installed `android` CLI exposes no `journey` command or runner. This XML is an agent-evaluation protocol only; do not invent a CLI invocation.

```xml
<journey name="My Journey">
  <description>A sample evaluation</description>
  <actions>
    <action>Tap the "Home" icon</action>
    <action>Verify that the app is on its Home screen</action>
  </actions>
</journey>
```

## Evaluation rules

1. Treat the XML as the source of truth and evaluate `<action>` elements sequentially and exactly as written.
2. Split an action containing multiple actions into ordered sub-actions.
3. For an interaction, perform only the specified interaction and check that it completes without unexpected behavior.
4. For actions beginning with “check” or “verify,” inspect the current screen without interacting; every stated expectation must hold.
5. Fail on an impossible/malformed action, unmet expectation, app exit, crash, or freeze. Stop evaluation and mark remaining actions `SKIPPED`.
6. Keep troubleshooting minimal; report suggestions only in the summary.

Use `android layout`, `android screen capture --annotate`, `android screen resolve --screenshot`, and serial-scoped `adb` as described in [interact.md](interact.md).

## Result format

```json
{
  "journey": "My Journey",
  "results": [
    {
      "action": "Tap the Home icon",
      "status": "PASSED",
      "commands": ["adb -s emulator-5554 shell input tap 45 920"],
      "comment": "Home opened"
    },
    {
      "action": "Verify that the app is on its Home screen",
      "status": "FAILED",
      "commands": ["android layout --device=emulator-5554"],
      "comment": "The settings page was shown"
    }
  ]
}
```
