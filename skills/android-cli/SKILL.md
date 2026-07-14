---
name: android-cli
description: Orchestrates Android development tasks including project creation, deployment, SDK management, and environment diagnostics using the `android` command-line tool.
---
# Android CLI Specialist

Installed inventory: `android` 1.0.15498356, syntax `android [-hV] [--sdk=PARAM] [COMMAND]`.

## Preflight

```sh
android --version
android info
adb devices
```

- `android info` prints `sdk`, `version`, and `launcher_version`; a field may be supplied.
- Propagate the selected serial to every device operation: `android ... --device="$SERIAL"` and `adb -s "$SERIAL" ...`.
- If no device is online, start one with `android emulator start <device>` or stop and report the blocker. Do not silently target another device.
- Top-level help/version exit 0. `android help <command>` prints usage but exits 1. Some runtime failures (unknown `info` field, no device) exit 0; verify output and artifacts, not only status.
- Prefer parent help/version checks: some `screen`, `sdk`, and `skills` leaf commands reject `--help` with 2. `docs`, `emulator`, and `studio` leaf help generally exits 0.

## Command inventory

| Command | Operational syntax |
| --- | --- |
| `create` | `android create [--verbose] [--list] [--minSdk=api] --name=NAME [-o=DIR] [template]` |
| `describe` | `android describe [--project_dir=DIR]` reports metadata and artifact JSON paths |
| `docs` | `android docs search <query>`; `android docs fetch <url>` |
| `emulator` | `create [--list-profiles] <profile>`; `start [--cold] <device>`; `stop <device>`; `list [--long]`; `remove [--force] <device>` |
| `info` | `android info [field]` |
| `layout` | `android layout [--diff] [--pretty] [--device=SERIAL] [-o=PATH]` |
| `run` | `android run [--debug] [--activity=NAME] [--device=SERIAL] [--type=TYPE] [--apks=APK[,APK...]]...` |
| `screen` | `capture [-a\|--annotate] [-o=PATH]`; `resolve --screenshot=PATH --string=TEXT` |
| `sdk` | `install [--beta] [--canary] [--force] <package>[@<version>]...`; `update [--beta] [--canary] [--force] <pkg-name>`; `remove <pkg-name>`; `list [--all] [--all-versions] [--beta] [--canary] [pattern]` |
| `skills` | `add` (leaf may say `install`) `[--all] [--agent=NAME] [--project=DIR] <skill>`; `remove [--agent=NAME] [--project=DIR] <skill>`; `list [--long] [--project=DIR]`; `find <keyword>` |
| other | `help`, `init`, `update` |

`studio` is also exposed by `android --help`: optional Android Studio Quail 1+ integration with leaves `find-declaration`, `find-usages`, `open-file`, `check`, `analyze-file`, `render-compose-preview`, and `version-lookup`. `android studio check` is the safe prerequisite check.

## Build → describe → run

```sh
./gradlew :app:assembleDebug
android describe --project_dir=.
android run --device="$SERIAL" --apks=app/build/outputs/apk/debug/app-debug.apk
```

Use the artifact JSON path reported by `describe` when the APK location is not known. Gradle builds/tests; `android` discovers artifacts, manages emulators, deploys, and inspects UI; raw `adb` handles `logcat`, shell/input, files, and other low-level operations. See [interaction guidance](references/interact.md) and the [agent journey-evaluation protocol](references/journeys.md).

## Caveats

- `docs fetch` may print `No document found` and exit 0.
- `emulator list --long` requires ADB and may crash/write a CLI crash report if ADB is unavailable; use plain `list` or restore ADB.
- `layout` no-device failures may exit 0.
- `skills list/find` downloads/caches an approximately 710 KB catalog and may report a download error while returning cached results.
- Confirm before SDK/CLI/skill mutations; do not infer success from status alone.
