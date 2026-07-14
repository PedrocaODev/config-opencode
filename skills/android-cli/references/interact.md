# Device interaction

## Checklist

1. Select one online serial with `adb devices`; use `--device="$SERIAL"` for `android` and `-s "$SERIAL"` for `adb`.
2. Inspect with `android layout --device="$SERIAL" --pretty`; use `--diff` after actions.
3. If layout misses WebView, animation, or visual content, ensure exactly one suitable device is online, run `android screen capture --annotate -o screen.png`, and visually inspect the PNG.
4. Resolve a label with `android screen resolve --screenshot=screen.png --string="tap #3"`.
5. Interact with `adb -s "$SERIAL" shell input ...`, then inspect again.

Use parent help (`android layout --help`, `android screen --help`) because screen leaf help may reject `--help`. A no-device layout failure can exit 0; validate JSON/output files. If the selected device is absent or offline, start/reconnect it or report the blocker—never fall through to another device.

`android screen capture` exposes no `--device` or serial option in this CLI and cannot be serial-scoped. Capture requires exactly one suitable online device; if multiple-device support is required, use a serial-aware raw adb fallback such as `adb -s "$SERIAL" exec-out screencap -p > screen.png`.

## Layout fields

| Field | Meaning |
| --- | --- |
| `text`, `resourceId`, `contentDesc` | Visible/accessibility identity |
| `interactions` | Such as `checkable`, `clickable`, `focusable`, `scrollable`, `long-clickable`, `password` |
| `state` | Such as `checked`, `focused`, `selected` |
| `bounds`, `center` | Tap/gesture coordinates |
| `off-screen` | Present in hierarchy but may require scrolling |

## Input rules

1. Focus text fields before entering text.
2. Scroll a `scrollable` element when content is missing; use a slow fifth duration argument for `adb shell input swipe`.
3. Wait briefly for asynchronous content, then use `layout --diff`.
4. Use element centers for taps: `adb -s "$SERIAL" shell input tap 152 23`.

Example annotated tap:

```sh
adb -s "$SERIAL" shell input $(android screen resolve --screenshot=screen.png --string="tap #34")
```
