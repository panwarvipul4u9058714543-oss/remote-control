# Remote Control — PUBG-Style Swipe-Camera Android Gamepad

An open-source Android remote gamepad designed for landscape two-thumb play:
- **Left thumb:** Analog movement stick.
- **Right thumb:** 1:1 responsive camera swipe surface (no right joystick by default; immediate delta response with zero extra smoothing, adjustable camera speed, and an optional per-game classical joystick fallback).
- **Familiar action buttons:** Face buttons (`South`, `East`, `North`, `West`), shoulders/triggers (`L1`, `R1`, `L2`, `R2`), center buttons (`Select`, `Start`), and stick clicks (`L3`, `R3`).

## Engineering & Verification Workflow

This project follows a strict step-by-step milestone workflow:
1. **Design & Ticket Gate:** Every milestone is tracked as a public GitHub Issue with explicit, testable acceptance checks.
2. **Coding Agent (Minimal Implementation):** Core math, touch routing, layout scaling, and HID report encoding live in Android-free JVM Kotlin modules with zero bloat.
3. **Test-Only Verifier Agent:** Independently verifies every milestone via JVM unit tests, lint checks, HID descriptor byte verification, and scripted `adb` device tests before pausing for human review.

## Documentation

- [Design Specification & Architecture](docs/design-spec.md)
- [Platform & Host Compatibility Matrix](docs/compatibility-matrix.md)
- [GitHub Issue Bootstrap Script](scripts/create_github_issues.sh)
