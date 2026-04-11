# First-Time Setup Guide

This covers everything a brand new user needs to go from zero to building websites.

## Step 1: VS Code Extensions

Install these VS Code extensions (Ctrl+Shift+X to open Extensions panel):

### Required
- **Claude Code** — AI assistant that builds websites for you

### Recommended
- **Live Server** (by Ritwick Dey) — Preview your website locally with auto-refresh
  - After installing: right-click any `.html` file → "Open with Live Server"
  - Your site opens in browser and auto-updates when you save changes

## Step 2: Git

Git tracks your code changes and pushes to GitHub for deployment.

### Check if installed:
```bash
git --version
```

### Install if missing:
1. Go to https://git-scm.com/download/win
2. Download the installer
3. Run it — click Next through everything (default settings are fine)
4. **Restart VS Code** after installing

### Configure (one-time):
```bash
git config --global user.name "Your Name"
git config --global user.email "your@email.com"
```

## Step 3: GitHub Account

1. Go to https://github.com/signup
2. Create a free account
3. Remember your username — you'll need it

## Step 4: GitHub CLI

This lets you create repos and push code from the terminal.

### Install:
Open VS Code terminal (Ctrl+`) and run:
```bash
winget install --id GitHub.cli
```
**Restart VS Code** after installing.

### Authenticate (one-time):
```bash
gh auth login
```
When prompted:
1. Select **GitHub.com**
2. Select **HTTPS**
3. Select **Login with a web browser**
4. Copy the code shown, press Enter
5. Browser opens — paste the code and authorize

## Step 5: You're Ready

Now just tell Claude what to build:
> "Build me a website for my business"

Claude handles everything from there — creating the files, designing the layout, and deploying it live.

## Troubleshooting

### "winget: command not found"
Your Windows might be too old for winget. Instead:
- Git: Download from https://git-scm.com/download/win
- GitHub CLI: Download from https://cli.github.com

### "Permission denied" errors
Right-click VS Code → "Run as administrator"

### Terminal not working
In VS Code: View → Terminal (or Ctrl+`)
If it shows PowerShell, switch to Git Bash:
- Click the dropdown arrow next to the + icon in terminal
- Select "Git Bash"

### Git says "unknown author identity"
Run:
```bash
git config --global user.name "Your Name"
git config --global user.email "your@email.com"
```
