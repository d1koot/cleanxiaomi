#!/usr/bin/env bash
# Usage: ./scripts/apply.sh packages/tier1-ads.txt [--yes]
# Without --yes it only prints what would change (dry run).
set -u
LIST="${1:?usage: apply.sh <package-list> [--yes]}"
YES="${2:-}"
command -v adb >/dev/null || { echo "adb not found."; exit 1; }
[ "$(adb get-state 2>/dev/null || true)" = "device" ] || { echo "No authorized device."; exit 1; }
ls backups/packages-all-*.txt >/dev/null 2>&1 || { echo "Run ./scripts/backup.sh first."; exit 1; }

TS=$(date +%Y%m%d-%H%M%S)
LOG="backups/changes-$TS.log"
INSTALLED=$(adb shell pm list packages --user 0 | tr -d '\r')

while IFS= read -r line; do
  pkg="${line%%#*}"
  pkg="$(echo "$pkg" | tr -d '[:space:]')"
  [ -z "$pkg" ] && continue
  if ! grep -qx "package:$pkg" <<<"$INSTALLED"; then
    echo "skip (not installed): $pkg"; continue
  fi
  if [ "$YES" != "--yes" ]; then
    echo "would change: $pkg"; continue
  fi
  out=$(adb shell pm disable-user --user 0 "$pkg" 2>&1 | tr -d '\r')
  if grep -qi "disabled-user" <<<"$out"; then
    echo "disabled: $pkg"; echo "disabled $pkg" >> "$LOG"
  else
    out2=$(adb shell pm uninstall -k --user 0 "$pkg" 2>&1 | tr -d '\r')
    if grep -q "Success" <<<"$out2"; then
      echo "removed for user 0 (reversible): $pkg"; echo "removed $pkg" >> "$LOG"
    else
      echo "FAILED: $pkg -> $out2"
    fi
  fi
done < "$LIST"

if [ "$YES" = "--yes" ]; then
  echo "Done. Undo with: ./scripts/restore.sh $LOG"
else
  echo "Dry run only. Add --yes to apply."
fi
