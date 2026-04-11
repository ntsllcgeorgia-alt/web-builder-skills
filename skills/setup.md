# First-Time Environment Setup

Claude handles all of this automatically. This file is a reference for what gets installed and why.

## What Claude Auto-Installs

When the user asks to build their first website, Claude checks and installs everything needed:

### 1. Git
**What it does**: Tracks code changes, pushes to GitHub for deployment.
**Check**: `git --version`
**Install**: `winget install --id Git.Git -e --accept-package-agreements --accept-source-agreements`
**Manual download**: https://git-scm.com/download/win
**After install**: Restart VS Code terminal, then configure:
```bash
git config --global user.name "Your Name"
git config --global user.email "your@email.com"
```

### 2. Python 3 + Pillow
**What it does**: Image compression, batch processing, automation scripts, web scrapers.
**Check**: `python --version` or `python3 --version`
**Install**: `winget install --id Python.Python.3.12 -e --accept-package-agreements --accept-source-agreements`
**Manual download**: https://python.org/downloads/ (check "Add to PATH" during install!)
**After install**: Restart terminal, then:
```bash
pip install Pillow
```

### 3. GitHub CLI
**What it does**: Create repos, push code, manage GitHub — all from the terminal.
**Check**: `gh --version`
**Install**: `winget install --id GitHub.cli -e --accept-package-agreements --accept-source-agreements`
**Manual download**: https://cli.github.com/
**After install**: Restart terminal, then authenticate:
```bash
gh auth login
```
Select: GitHub.com → HTTPS → Login with browser. Follow prompts.

### 4. GitHub Account
If user doesn't have one: https://github.com/signup (free)

### 5. VS Code Extensions
- **Live Server** (Ritwick Dey) — preview HTML with auto-refresh
  - Install: Ctrl+Shift+X → search "Live Server" → Install
  - Use: Right-click .html file → "Open with Live Server"

## Troubleshooting

### "winget: command not found"
Windows is too old for winget, or it's not in PATH. Use manual download links above.

### "python: command not found" after installing
Python wasn't added to PATH. Either:
1. Reinstall Python and check "Add Python to PATH"
2. Or find Python path and add to system PATH manually

### "pip: command not found"
Try `python -m pip install Pillow` instead of `pip install Pillow`

### "Permission denied" errors
Right-click VS Code → "Run as administrator"

### Terminal shows PowerShell instead of Bash
Click the dropdown arrow (v) next to + in the terminal panel → select "Git Bash"

### "git: unknown author identity"
```bash
git config --global user.name "Your Name"
git config --global user.email "your@email.com"
```

### Git push rejected
```bash
git pull --rebase
git push
```
