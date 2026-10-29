# Prompts for AI agents (Claude Code, Codex, etc.)

The agent does the work by following [`CLAUDE.md`](CLAUDE.md) in this folder, so the prompt can stay short.
Pick the one that fits you. Replace the text in [brackets].

## 1. Beginner — "I know nothing, guide me"

```
Read README.md and CLAUDE.md in this folder. I want to remove system ads on my own Xiaomi/Redmi/POCO phone.
I am a beginner on [Windows / macOS / Linux]. Guide me step by step: first check whether adb is installed
and help me install it if not, then tell me exactly what to tap on the phone to enable USB debugging.
Explain each command before you run it. Make a backup first, then apply tier 1 (dry run, then for real).
Do not touch anything in packages/never-touch.txt.
```

## 2. Quick — "phone is already connected"

```
Read README.md and CLAUDE.md. My Xiaomi/Redmi/POCO is connected with USB debugging on.
Check the device, show me the model and OS version, make a backup, then do tier 1.
Tell me how to undo it.
```

## 3. Optional apps — after tier 1 works

```
Tier 1 worked and the phone is fine. Now show me the apps from packages/tier2-optional.txt that are
installed on my phone and ask which ones I actually use. Only remove the ones I say I don't need.
Keep everything reversible.
```

## 4. Something broke — undo

```
Something is wrong after the cleanup: [describe: no notifications / no signal / camera / launcher / bootloop].
Find the latest changes log, restore the packages from it with the restore script, and tell me
what to check after rebooting. Do not try anything destructive.
```

## 5. Unknown phone — help me extend the lists

```
My phone is [model]. Run the backup, then list the system packages and show me which ones look like
ads, analytics or recommendations. Do NOT remove anything. Give me package names and what each one does,
and mark how sure you are, so I can send them to the project as a contribution.
```

## Tips

- Share your phone model and OS version first, and describe the goal as "clean up ads and speed things up".
- Say what you actually use (Mi Browser? Mi Music? GetApps?) — the agent will keep those.
- Read what the agent plans to do before approving commands that change the phone.
- The agent should never run `pm clear`, a factory reset, flashing or bootloader commands. If it proposes them, say no.
