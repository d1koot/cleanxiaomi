<p align="center"><img src="assets/banner.png" alt="CleanXiaomi - Your Xiaomi, minus the ads" width="100%"></p>

<p align="center">
  <b>English</b> · <a href="README.ru.md">Русский</a>
</p>

<p align="center">
  <img alt="license" src="https://img.shields.io/badge/license-MIT-c9f7c4?style=flat-square&labelColor=12161c">
  <img alt="root" src="https://img.shields.io/badge/root-not%20needed-c9f7c4?style=flat-square&labelColor=12161c">
  <img alt="reversible" src="https://img.shields.io/badge/changes-reversible-c9f7c4?style=flat-square&labelColor=12161c">
  <img alt="verified devices" src="https://img.shields.io/badge/verified%20devices-1-c9f7c4?style=flat-square&labelColor=12161c">
</p>

Remove system ads, analytics and preinstalled junk from **your own** Xiaomi / Redmi / POCO phone
(MIUI and HyperOS) over ADB. No root, no bootloader unlock, one backup and one-command undo.

Use it two ways:

- **With an AI agent** (Claude Code, Codex, ...): open this folder, paste the prompt from [`PROMPT.md`](PROMPT.md).
- **With plain scripts**: `backup` → `apply` → `restore`, for Windows (PowerShell) or Linux/macOS (bash).

<table align="center">
  <tr>
    <td align="center"><h2>1</h2>VERIFIED DEVICE</td>
    <td align="center"><h2>2</h2>SAFETY TIERS</td>
    <td align="center"><h2>0</h2>ROOT NEEDED</td>
    <td align="center"><h2>2</h2>LANGUAGES</td>
  </tr>
</table>

> **Honest status:** the method is proven on one phone (see [verified devices](#verified-devices)).
> Package names differ by model, region and OS version, so other phones may need small changes.
> Test tier 1 first, and please [add your device](CONTRIBUTING.md).

## Quick start

**1. Prepare the phone (once)**
1. Settings → About phone → tap **MIUI / OS version** 7 times.
2. Settings → Additional settings → Developer options → enable **USB debugging**.
3. Install [Android platform-tools](https://developer.android.com/tools/releases/platform-tools) on your computer.
4. Plug in the phone, accept the prompt on its screen, then run `adb devices` — you should see `device`.

**2. Run (Windows PowerShell)**
```powershell
.\scripts\backup.ps1                                  # saves device info + package list
.\scripts\apply.ps1 -List .\packages\tier1-ads.txt        # dry run: only prints what would change
.\scripts\apply.ps1 -List .\packages\tier1-ads.txt -Yes   # apply tier 1 (ads + analytics)
```
> If PowerShell blocks the script: `Set-ExecutionPolicy -Scope Process Bypass` (this window only).
> If `adb` is not found, run PowerShell inside the platform-tools folder or add it to PATH.

**Run (Linux / macOS)**
```bash
./scripts/backup.sh
./scripts/apply.sh packages/tier1-ads.txt
./scripts/apply.sh packages/tier1-ads.txt --yes
```

**3. Reboot and check** calls, mobile data, notifications, camera. Live with it for a day.

**4. Undo anything**
```powershell
.\scripts\restore.ps1 -Log "$HOME\cleanxiaomi-backups\changes-YYYYMMDD-HHMMSS.log"
```
(bash: `./scripts/restore.sh backups/changes-YYYYMMDD-HHMMSS.log`)

**5. Turn debugging off** when you are done: `adb shell settings put global adb_enabled 0`

## Settings that need no ADB

- Settings → Passwords & security → Privacy → **Ad services** → turn off personalised ads.
- Settings → Passwords & security → Authorization & revocation → revoke **msa** if listed.
- Lock screen → Wallpaper Carousel → off.
- In Security, Themes, GetApps, Music, Browser: turn off "recommendations".

## How it works

There is no magic: Android has the same Android Debug Bridge on every phone. The scripts list installed
packages, skip anything missing, and for each known ad/analytics package run:

1. `pm disable-user --user 0 <package>` — disables it, can be re-enabled.
2. If MIUI refuses, `pm uninstall -k --user 0 <package>` — removes it for the current user only; the system image
   stays intact and `cmd package install-existing <package>` brings it back.

Every change is logged, and `restore` reads that log. A factory reset also restores everything.

| Tier | File | What | Risk |
|------|------|------|------|
| 1 | `packages/tier1-ads.txt` | MSA (system ads), Analytics | Low |
| 2 | `packages/tier2-optional.txt` | GetApps, Games, Mi Music/Video/Browser, App Vault, Quick Apps | Depends on what you use |
| – | `packages/never-touch.txt` | System UI, launcher, security, push, Play services... | **Do not touch** |

## Verified devices

| Device | OS | Android | Region | Applied | Result |
|--------|----|---------|--------|---------|--------|
| Redmi 9 (M2004J19C) | MIUI 12 (V12) | 10 | RU | Tier 1 | `disable-user` accepted for `com.miui.msa.global`, `com.miui.analytics` |

## FAQ

**Will it work on my phone?** The method (ADB + disabling packages) works on most Xiaomi / Redmi / POCO phones,
but package names and ad locations vary. Run the dry run to see what exists on your phone.

**Do ads come back after a system update?** They can. Run `apply` again.

**Is it safe?** Changes are reversible and tier 1 targets only ads and analytics. Still, you do this on your own
device at your own risk. Do not touch `never-touch.txt`.

**Do I need to unlock the bootloader or flash a ROM?** No.

**Does it block ads inside apps (YouTube, games)?** No — only the system ads and tracking of the phone itself.

## Using an AI agent

Open this folder in your agent and paste the prompt from [`PROMPT.md`](PROMPT.md). The agent follows
[`CLAUDE.md`](CLAUDE.md): backup first, tier by tier, asks before optional apps, never touches the
never-touch list.

## Credits

Inspired by the smart-TV debloat projects built with Claude Code:
[tv-vibehack / CleanYourTV](https://github.com/Gathin23/tv-vibehack) (MIT) and
[dumbtv](https://github.com/humblemuzzu/dumbtv). Not affiliated with them.
Not affiliated with Xiaomi. Xiaomi, Redmi, POCO, MIUI and HyperOS are trademarks of their owners.

## Disclaimer

This is an independent open-source tool. It only uses Android's official debugging interface (ADB) on a device you own,
contains no Xiaomi code or files, and does not bypass paid features or access controls. Use it at your own risk;
the software is provided "as is" (see LICENSE). Not legal advice.

## License

MIT — see [LICENSE](LICENSE).
