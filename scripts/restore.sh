#!/usr/bin/env bash
# Usage: ./scripts/restore.sh backups/changes-YYYYMMDD-HHMMSS.log
set -u
LOG="${1:?usage: restore.sh <changes log>}"
[ -f "$LOG" ] || { echo "Log not found: $LOG"; exit 1; }
while read -r action pkg; do
  [ -z "${pkg:-}" ] && continue
  case "$action" in
    disabled) adb shell pm enable --user 0 "$pkg" ;;
    removed)  adb shell cmd package install-existing "$pkg" ;;
  esac
done < "$LOG"
echo "Restore finished. Reboot the phone."
