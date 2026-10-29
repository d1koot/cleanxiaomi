# Verified devices and package lists

Entries marked `[verified: ...]` were applied on a real device. Everything else is a starting point.
Package names differ between Global / India / China / EEA / RU builds and between OS versions.
The scripts skip packages that are not installed.

## Verified devices

| Device | OS | Android | Region | Applied | Result |
|--------|----|---------|--------|---------|--------|
| Redmi 9 (M2004J19C) | MIUI 12 (V12) | 10 | RU | Tier 1 | `pm disable-user` accepted for `com.miui.msa.global` and `com.miui.analytics` |

Want to add yours? See [CONTRIBUTING.md](../CONTRIBUTING.md).

## How to find candidates on your phone

```bash
adb shell pm list packages -s --user 0        # system packages
adb shell dumpsys package <package>           # details
```
