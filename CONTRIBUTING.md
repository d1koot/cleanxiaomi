# Contributing: add your device

1. Run the backup script and note the output (model, OS version, region).
2. Apply tier 1 (dry run first). Reboot. Use the phone for a day.
3. Open an issue or PR with:
   - Model + code (e.g. `Redmi Note 11, spring`), OS (MIUI/HyperOS version), Android version, region
   - Which packages were found, which were accepted, which fell back to `uninstall -k --user 0`
   - What broke (if anything) and how you restored it
   - New ad/analytics packages you found (with the package name from `pm list packages`)
4. Do not submit packages from `packages/never-touch.txt`.

Rule of thumb: an entry is `[verified]` only if someone ran it on a real device and the phone kept working.
