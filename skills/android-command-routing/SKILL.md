---
name: android-command-routing
description: adb, android-cli, android run, android emulator, gradlew installDebug, connectedDebugAndroidTest. Use ONLY when Android device, emulator, APK, or app-run workflows may be better served by the android CLI than raw adb or direct Gradle commands.
---

# Android Command Routing

Use this skill only for Android command-line work where the choice between raw
`adb`, raw `./gradlew`, and the higher-level `android` CLI affects speed or
reliability.

Typical triggers:

- `adb ...`
- `android ...`
- emulator provisioning or boot checks
- APK install/run flows
- `./gradlew :app:installDebug`
- `./gradlew :app:connectedDebugAndroidTest`
- tasks whose real goal is device interaction rather than compilation

Do not load it for ordinary Kotlin edits or routine build/test commands like
`assembleDebug`, `lintDebug`, or unit tests unless the task is actually about
device/emulator execution.

## Routing rules

### Prefer the `android` CLI when the task is about

- emulator lifecycle
- selecting or targeting a running device
- installing and launching APKs
- screenshots, layout inspection, or UI-driven debugging
- agent-led journey evaluation or other multi-step device workflows
- a Gradle command whose real intent is "get this app running on a device"

Examples:

- Prefer `android emulator ...` over hand-rolled emulator boot orchestration.
- Prefer `android run --apks=...` over low-level install/launch sequences when
  the goal is simply to run the app.
- Prefer `android layout` / `android screen capture` for UI inspection.

### Prefer raw `adb` when the task is about

- a single precise low-level command
- `logcat`
- direct `shell`, `am`, `pm`, or file-copy operations
- commands the `android` CLI does not expose cleanly

Examples:

- `adb devices`
- `adb logcat ...`
- targeted `adb shell ...`

### Prefer raw `./gradlew` when the task is about

- compiling
- assembling APKs/AABs
- lint
- unit tests
- static analysis

Examples:

- `./gradlew :app:assembleDebug`
- `./gradlew :app:lintDebug`
- `./gradlew :app:testDebugUnitTest`

## Mixed workflows

Some tasks should combine tools instead of forcing everything through one:

- Build with `./gradlew`, then install/run with `android run`.
- Inspect UI with `android ...`, then capture detailed logs with `adb logcat`.
- Use Gradle for instrumentation setup, but prefer `android` helpers for
  emulator/device orchestration when they remove manual steps.

## Safe workflow

```sh
android --version
android info
adb devices
./gradlew :app:assembleDebug
android describe --project_dir=.
android run --device="$SERIAL" --apks=app/build/outputs/apk/debug/app-debug.apk
```

- Carry one serial throughout: `android ... --device="$SERIAL"` and `adb -s "$SERIAL" ...`.
- If it is absent/offline, start or reconnect it, or report the blocker; never silently choose another device.
- Use `describe` output when the APK path is unknown.
- Status alone is insufficient: some no-device/runtime errors exit 0, while `android help <command>` exits 1 after printing usage. Validate output/artifacts; prefer parent help when leaf help is rejected.
- The CLI has no journey runner. Journey XML is an agent-evaluation protocol, not an `android` command.

## Decision heuristic

Ask: "Is the user's actual goal build verification, or device/app interaction?"

- If it is build verification, prefer `./gradlew`.
- If it is device/app interaction, strongly consider `android` first.
- If it is a low-level one-off device command, use `adb`.

When choosing raw `adb` or raw Gradle over the `android` CLI in a borderline
case, state the reason briefly.
