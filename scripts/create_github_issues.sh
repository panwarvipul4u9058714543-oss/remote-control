#!/usr/bin/env bash
set -euo pipefail

export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

REPO_NAME="${1:-remote-control}"

if ! gh auth status >/dev/null 2>&1; then
  echo "Error: GitHub CLI (gh) is not authenticated. Run 'gh auth login' first." >&2
  exit 1
fi

# Create public repository if not already linked to a remote
if ! git remote get-url origin >/dev/null 2>&1; then
  echo "Creating public GitHub repository: $REPO_NAME ..."
  gh repo create "$REPO_NAME" --public --source=. --remote=origin --push \
    --description "Android landscape gamepad with right-thumb swipe camera (Bluetooth HID, Wi-Fi, USB)"
else
  git push -u origin main
fi

echo "Creating Milestone GitHub Issues..."

gh issue create \
  --title "Issue #1: Bluetooth HID Feasibility Spike (Redmi Note 13 Pro 5G -> Blacknut Mac App)" \
  --body "## Goal
Verify whether Android \`BluetoothHidDevice\` (Bluetooth Classic HID) on the Redmi Note 13 Pro 5G can pair with macOS and deliver responsive movement, button presses, and right-thumb camera turns directly to the Blacknut Mac app before choosing any workaround.

## Scope
- Build minimal Android 9+ (API 28+) Bluetooth HID spike APK with pure-Kotlin \`GenericHidProfile\` descriptor & 9-byte gamepad report encoder (plus optional Composite Mouse delta test profile).
- Verify \`bluetooth.profile.hid.device.enabled\` on Redmi Note 13 Pro 5G.
- Pair with MacBook and test input detection inside the Blacknut macOS app.
- Record findings in \`docs/compatibility-matrix.md\`.

## Acceptance Checks (Test-Only Verifier Agent)
- [ ] \`adb shell getprop bluetooth.profile.hid.device.enabled\` confirmed \`true\` on Redmi Note 13 Pro 5G.
- [ ] JVM unit test validates exact HID report descriptor byte stream, button bit positions, hat null-state, and axis clamping (\`0..255\`, neutral \`128\`).
- [ ] MacBook pairs over Bluetooth and Blacknut Mac app responds to injected Left Stick, Action Buttons, and Right-Camera reports.
- [ ] Findings documented in \`docs/compatibility-matrix.md\`."

gh issue create \
  --title "Issue #2: Core Touch-to-Camera Math & Multi-Touch Router (Pure JVM Module)" \
  --body "## Goal
Implement the Android-free Kotlin input math and multi-touch routing engine for the left movement joystick, familiar action buttons, and right-thumb camera swipe surface.

## Scope
- Left thumb movement joystick normalization, circular clamping, and deadzone handling.
- Familiar action buttons (\`South\`, \`East\`, \`North\`, \`West\`, \`L1\`, \`R1\`, \`L2\`, \`R2\`, \`Select\`, \`Start\`, \`L3\`, \`R3\`).
- Right-thumb camera swipe engine: immediate frame-to-frame delta (\`dx, dy\`) scaled by user-adjustable camera speed, deadzone step-up compensation, zero extra smoothing lag, and instant neutral reset (\`128, 128\`) when thumb movement stops.
- Optional per-game Right Joystick fallback mode toggle.

## Acceptance Checks (Test-Only Verifier Agent)
- [ ] 100% JVM unit test pass rate on multi-touch pointer binding and release independence (left stick movement never steals or alters right camera swipe).
- [ ] Zero camera drift test: \`0 px\` finger delta outputs exact neutral \`(128, 128)\` within 1 frame.
- [ ] Camera speed multiplier scales linearly and clamps cleanly at \`0..255\` rails without wrap-around or overflow.
- [ ] Per-game fallback toggle switches the right zone cleanly between Trackpad Swipe and Classic Right Joystick."

gh issue create \
  --title "Issue #3: Landscape Android Gamepad UI & Settings HUD" \
  --body "## Goal
Build the full-screen landscape Android controller UI wiring the core touch router and camera swipe engine to \`BluetoothHidDevice\`.

## Scope
- Locked landscape full-screen layout: Left thumb stick, familiar action buttons, and right-half camera swipe zone.
- Top status/settings bar: Bluetooth pairing/connection status, live camera speed slider, and optional per-game Right Joystick fallback toggle.
- Dedicated rate-capped HID send loop (\`<= 10 ms\` minimum interval, skipping duplicate idle reports) and immediate neutral report on focus loss.

## Acceptance Checks (Test-Only Verifier Agent)
- [ ] \`./gradlew test\` and \`./gradlew lintDebug\` pass with 0 errors.
- [ ] Scripted \`adb\` / \`MotionEvent\` multi-touch test verifies simultaneous left-thumb movement + right-thumb camera swipe + action button press.
- [ ] Focus-loss test verifies a neutral HID report (all buttons released, axes centered at \`128\`) is sent immediately when the app loses focus."

gh issue create \
  --title "Issue #4: End-to-End Playtest & Aiming Response Tuning on Blacknut Mac App" \
  --body "## Goal
Validate and tune real-world camera aiming responsiveness from the Redmi Note 13 Pro 5G to the Blacknut Mac app over Bluetooth.

## Scope
- Measure report send-loop timing and tune deadzone compensation / camera speed range for responsive camera turns without extra smoothing.
- Verify gameplay in Blacknut Mac app and document verified per-game settings.

## Acceptance Checks (Test-Only Verifier Agent)
- [ ] Percentile latency probe unit test verifies send-loop interval stays within \`10 ms\` p95.
- [ ] Live verification on Redmi Note 13 Pro 5G -> Blacknut Mac app confirmed by user review."

gh issue create \
  --title "Issue #5: Browser Verification (Chrome & Safari on macOS)" \
  --body "## Goal
Verify Bluetooth HID controller compatibility with Blacknut running inside Chrome and Safari on macOS via the W3C Gamepad API.

## Scope
- Test \`navigator.getGamepads()\` axis and button mapping in macOS Chrome and Safari.
- Resolve any browser-specific mapping differences and update \`docs/compatibility-matrix.md\`.

## Acceptance Checks (Test-Only Verifier Agent)
- [ ] All axes and buttons verified in Chrome and Safari on macOS.
- [ ] Browser compatibility results documented in \`docs/compatibility-matrix.md\`."

gh issue create \
  --title "Issue #6: Wi-Fi (UDP) & USB Transports + Cross-Platform Expansion" \
  --body "## Goal
Add low-latency Wi-Fi (UDP) and USB (ADB/tethering) transports with a lightweight host receiver for raw 1:1 mouse/gamepad injection, and verify compatibility across Windows, Linux, and a second Android device / Android TV.

## Scope
- Compact binary packet framing over UDP (Wi-Fi) and USB tunnel.
- Host receiver daemon for macOS/Windows/Linux.
- Compatibility testing and documentation for older Android versions (< API 28), Windows, Linux, and Android TV.

## Acceptance Checks (Test-Only Verifier Agent)
- [ ] Loopback packet serialization and transport benchmark tests pass (\`< 2 ms\` local overhead, 0 allocations per packet).
- [ ] \`docs/compatibility-matrix.md\` updated with verified test results across each target platform."

echo "All 6 GitHub Issues created successfully!"
