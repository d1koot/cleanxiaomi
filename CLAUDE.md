# Instructions for AI agents working in this repo

Goal: help the user remove system ads, analytics and preinstalled junk from THEIR OWN Xiaomi / Redmi / POCO
phone (MIUI / HyperOS) over ADB, safely and reversibly. Never use destructive shortcuts.

## Ground rules

1. Confirm the device belongs to the user and ADB debugging is on. Help with setup from README.md if not.
2. Run `adb devices`. If the state is `unauthorized`, ask the user to accept the prompt on the phone.
3. Collect: model, OS version (`adb shell getprop ro.product.model`, `ro.mi.os.version.name`,
   `ro.miui.ui.version.name`, `ro.build.version.release`). Tell the user what you found.
4. ALWAYS run the backup script first (`scripts/backup.ps1` on Windows, `scripts/backup.sh` on Linux/macOS). Do not continue if it fails.
   On Windows PowerShell, `adb` in the current folder must be called as `.\adb`.
5. Work in tiers, one at a time:
   - `packages/tier1-ads.txt` — ads + analytics. Dry run first, show the list, then `--yes`.
   - `packages/tier2-optional.txt` — only after asking the user which apps they use
     (Music, Mi Video, GetApps, Games, Community, Store, Quick Apps...). Never apply it blindly.
6. NEVER touch anything in `packages/never-touch.txt`. If a user asks, explain the risk and prefer
   a narrower change.
7. Prefer `pm disable-user --user 0`. If it is refused, fall back to `pm uninstall -k --user 0`
   (reversible with `cmd package install-existing`). Never use plain `pm uninstall` without `-k --user 0`,
   never `pm clear` on system packages, never flash or wipe anything.
8. Check each package exists (`pm list packages --user 0`) before acting. Skip missing ones.
   If you want to add a package not in the lists, show the user the package name and ask first.
9. After each tier: ask the user to reboot and test calls, mobile data, notifications, camera, home button,
   and the apps they use. Only then move on.
10. Log what you changed (the scripts do this in `backups/changes-*.log`). Tell the user how to undo it:
    `scripts/restore.ps1 -Log <log file>` (Windows) or `./scripts/restore.sh <log file>`.
11. Do not disable update services or voice/cast features unless the user explicitly wants that.
    Say what they would lose.
12. At the end: guide the user through the no-ADB settings in README.md (Step 2), then turn debugging off
    (README.md Step 3).
13. If anything breaks (bootloop, missing home button, no signal): stop, run restore.sh with the latest log,
    and if the phone does not boot, recommend recovery mode / contacting service rather than guessing.

## Scope

Only ads, analytics/telemetry and optional preinstalled apps on the user's own device. Do not help
remove ads inside third-party apps (YouTube, games, etc.), bypass paid features, or modify another
person's device without their consent.

## Tone

Plain, short, step by step. Always say what you are about to do and how to undo it.
