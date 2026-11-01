# Phase 1 Research & Design Specification

## 1. Product Goal & First Experience
- **Form Factor:** Android APK locked to landscape orientation.
- **Left Thumb:** Movement analog joystick.
- **Right Thumb:** Unclamped touch-swipe surface to turn the game camera directly—no right joystick by default. Camera speed is user-adjustable, prioritizing raw aiming response over extra smoothing. A classical right joystick can be toggled as an optional per-game fallback.
- **Action Controls:** Familiar gamepad buttons (`South/A`, `East/B`, `North/X`, `West/Y`, `L1`, `R1`, `L2`, `R2`, `Select/Back`, `Start/Menu`, `L3`, `R3`).
- **Primary Test Setup:** Xiaomi Redmi Note 13 Pro 5G controlling the Blacknut cloud gaming app on macOS over Bluetooth first, followed by Chrome/Safari, Wi-Fi (UDP), and USB.

## 2. Reference Architecture Analysis

### 2.1 Remote Gamepad (`remotegamepad.com`)
- **Bluetooth Mode (Android 9+ / API 28+):** Uses Android's `BluetoothHidDevice` API over Bluetooth Classic HID to register an SDP record with a raw HID report descriptor and push input reports at up to 100Hz without requiring a host companion app.
- **Wi-Fi & USB Modes:** Uses a lightweight desktop companion app (`remotegamepad.com/pc`) to receive UDP packets over local Wi-Fi or forwarded packets over USB (since unrooted Android 9+ devices cannot expose custom USB HID interfaces directly without a host daemon).

### 2.2 Blacknut on macOS (`blacknut.com`)
- **Input Stack:** Reads standard Bluetooth/USB gamepads on macOS via `IOHIDManager` / `GCController` / SDL (and W3C Gamepad API in Chrome/Safari).
- **Bluetooth HID Camera Swipe Strategies to Verify in Issue #1:**
  1. **Direct Delta-to-Right-Stick Mapping (Controller-Only Cloud Games):** Converts instantaneous frame-to-frame finger delta ($\Delta x, \Delta y \times \text{sensitivity}$) + deadzone step-up directly into Right-Stick axis reports (`Rx, Ry` in `0..255`, centered at `128`), snapping to neutral `(128, 128)` within 1 frame when the finger stops.
  2. **Composite HID (Gamepad + Relative Mouse $\Delta x, \Delta y$):** Publishes both Gamepad and Mouse collections in the Bluetooth HID descriptor for games/hosts that accept native mouse-look alongside gamepad movement.

## 3. Two-Agent Verification Workflow
- **Coding Agent:** Writes minimal, modular code strictly scoped to the active GitHub Issue. Pure math, touch routing, and HID report encoding remain free of Android framework dependencies so they run on the JVM.
- **Test-Only Verifier Agent:** Independently executes unit tests, descriptor byte validation, lint checks, and `adb` hardware checks. Any failure returns to the Coding Agent and is re-verified from scratch before user review.
