# Auto-Backup: Daily Git Push

Automatically commits and pushes all projects in `D:\Projects` every day at 6 PM.

## What It Does

At 6 PM every day (or whenever you schedule it):

1. Scans every git repo in `D:\Projects`
2. If there are uncommitted changes → auto-commits with timestamp message
3. Pushes to GitHub
4. Logs everything to `D:\Projects\.auto-backup.log`

## Safety Features

**It will NOT auto-commit if:**
- Files look like secrets (`.env`, `.key`, `*password*`, `credentials.json`, etc.)
- Merge conflicts are present
- No remote is configured
- The repo isn't clean enough to push cleanly

If any of these trigger, it logs a warning and skips that repo — nothing bad happens.

## Install

1. Make sure `auto-backup.ps1` is at `C:\Users\USERNAME\auto-backup.ps1`
2. Right-click `install-auto-backup.ps1` → **Run with PowerShell**
3. Click Yes on the UAC prompt
4. Done — it's now scheduled daily at 6 PM

## Change Schedule

Open **Task Scheduler** (search it in Start) → **Task Scheduler Library** → find **Auto-Backup-Projects** → right-click → **Properties** → **Triggers** tab → edit.

Common schedules:
- **End of workday**: 6 PM
- **Before sleep**: 11 PM
- **Multiple times**: Add extra triggers (morning + evening)

## Log File

Check `D:\Projects\.auto-backup.log` to see what happened:

```
═══ 2026-04-14 18:00:01 ═══
Found 3 git repos to check

--- launch-and-manage ---
  Clean — nothing to push

--- web-builder-skills ---
  Staging and committing changes...
  Pushing to https://github.com/user/web-builder-skills.git...
  ✓ SUCCESS

--- free-salah-sarsour ---
  Clean — nothing to push
```

## Uninstall

```powershell
Unregister-ScheduledTask -TaskName 'Auto-Backup-Projects' -Confirm:$false
```

## Manual Run

Want to trigger a backup right now without waiting for 6 PM?

```powershell
Start-ScheduledTask -TaskName 'Auto-Backup-Projects'
```

Or just double-click `auto-backup.ps1` anytime.

## Recommended Daily Flow

1. Work on projects throughout the day
2. Make changes, don't worry about committing every time
3. At 6 PM, auto-backup handles it
4. Check the log once a week to make sure everything's pushing cleanly

## Edge Cases

**"I don't want today's changes pushed — I'm mid-refactor":**
- Before 6 PM, run: `schtasks /Change /TN "Auto-Backup-Projects" /DISABLE`
- When you're ready to resume: `schtasks /Change /TN "Auto-Backup-Projects" /ENABLE`

**"A commit got pushed that shouldn't have":**
- It's on GitHub, not in production — just revert or force-reset
- Use `git revert HEAD` to add a revert commit (safest)
- Or `git reset --hard HEAD~1 && git push --force` (destructive but fast)

**"I got a push rejection email from GitHub":**
- Usually means a file had secrets GitHub's scanner caught
- Check the log for the filename
- Add it to `.gitignore`, commit that, then push
