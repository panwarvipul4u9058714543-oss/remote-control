# Platform & Host Compatibility Matrix

> **Policy:** No platform, Android version, or connection mode is marked `Verified` without passing hardware and automated acceptance checks. Known platform limits are documented explicitly.

## 1. Android Controller Device Support

| Device / OS Version | Bluetooth HID (`BluetoothHidDevice`) | Wi-Fi (UDP) | USB (ADB / Tethering) | Verification Status & Notes |
| :--- | :--- | :--- | :--- | :--- |
| **Xiaomi Redmi Note 13 Pro 5G (HyperOS / Android 14+)** | Pending Issue #1 | Planned (Issue #6) | Planned (Issue #6) | Primary test device. HyperOS requires Developer Options toggles: *USB debugging*, *Install via USB*, and *USB debugging (Security settings)*. |
| **Generic Android 9+ (API 28+)** | Supported by API | Planned (Issue #6) | Planned (Issue #6) | Hard floor for `BluetoothHidDevice` (Bluetooth Classic HID). Requires `bluetooth.profile.hid.device.enabled=true`. |
| **Android 8.1 and Older (< API 28)** | Unsupported by OS | Planned (Issue #6) | Planned (Issue #6) | Android added `BluetoothHidDevice` in API 28; older versions require Wi-Fi or USB companion transport. |

## 2. Host Target & Application Support

| Host OS | Target App / Environment | Transport | Right-Swipe Camera Mode | Status |
| :--- | :--- | :--- | :--- | :--- |
| **macOS** | Blacknut Mac App | Bluetooth HID | Pending Spike (Issue #1) | First target under test. Note: macOS caches Bluetooth SDP HID descriptors at pair time; descriptor changes require unpairing and re-pairing. |
| **macOS** | Blacknut in Chrome / Safari | Bluetooth HID (W3C Gamepad API) | Planned (Issue #5) | Untested. |
| **macOS** | Native / Cloud Games | Wi-Fi UDP & USB Companion | Planned (Issue #6) | Untested. |
| **Windows 10/11** | PC / Cloud Games | Bluetooth HID / Wi-Fi / USB | Planned (Issue #6) | Note: Bluetooth HID enumerates as DirectInput on Windows; XInput-only games require Steam Input or host companion (ViGEmBus). |
| **Linux** | PC / Cloud Games | Bluetooth HID / Wi-Fi / USB | Planned (Issue #6) | Untested. |
| **Android / Android TV** | Second Android Device / TV | Bluetooth HID | Planned (Issue #6) | Untested. |
