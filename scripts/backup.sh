#!/usr/bin/env bash
# Saves device info and package lists. Run before any change.
set -euo pipefail
command -v adb >/dev/null || { echo "adb not found. Install Android platform-tools."; exit 1; }
[ "$(adb get-state 2>/dev/null || true)" = "device" ] || { echo "No authorized device. Check 'adb devices' and accept the prompt on the phone."; exit 1; }
TS=$(date +%Y%m%d-%H%M%S)
mkdir -p backups
{
  echo "model:   $(adb shell getprop ro.product.model | tr -d '\r')"
  echo "android: $(adb shell getprop ro.build.version.release | tr -d '\r')"
  echo "hyperos: $(adb shell getprop ro.mi.os.version.name | tr -d '\r')"
  echo "miui:    $(adb shell getprop ro.miui.ui.version.name | tr -d '\r')"
  echo "region:  $(adb shell getprop ro.miui.region | tr -d '\r')"
} | tee "backups/device-$TS.txt"
adb shell pm list packages --user 0 | tr -d '\r' | sort > "backups/packages-all-$TS.txt"
adb shell pm list packages -d --user 0 | tr -d '\r' | sort > "backups/packages-disabled-$TS.txt"
echo "Backup saved in backups/ ($TS)"
