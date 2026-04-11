# Deployment — GitHub Pages, Domains, DNS, SSL

## Prerequisites (Install These First)

### Git
Check: `git --version`

If not installed:
> Go to https://git-scm.com/download/win — download and run the installer with all default settings. Restart VS Code after installing.

Then set up identity (one-time):
```bash
git config --global user.name "Your Name"
git config --global user.email "your@email.com"
```

### GitHub CLI
Check: `gh --version`

If not installed:
```bash
winget install --id GitHub.cli
```
Then authenticate (one-time):
```bash
gh auth login
```
Select: GitHub.com → HTTPS → Login with browser. Follow the prompts.

### GitHub Account
If the user doesn't have one, tell them:
> Go to https://github.com/signup and create a free account.

---

## Deploying a Website (Step by Step)

### 1. Build the site first
Create a folder for the project and build `index.html` inside it.

### 2. Initialize git
```bash
cd my-website
git init
```

### 3. Set git identity (if not done globally)
```bash
git config user.name "Your Name"
git config user.email "your@email.com"
```

### 4. Stage and commit
```bash
git add index.html
git commit -m "Initial website"
```

### 5. Create GitHub repo and push (one command)
```bash
gh repo create my-website --public --source=. --push
```
This creates the repo on GitHub AND pushes your code in one step.

### 6. Enable GitHub Pages
Tell the user:
> Go to your repo on GitHub → Settings → Pages → Source: Deploy from branch → select "main" → folder: "/ (root)" → Save

### 7. Site is live!
After 1-2 minutes, the site will be at:
```
https://username.github.io/my-website/
```

---

## Custom Domain Setup (Optional)

If the user bought a domain name:

### 1. Add CNAME file to the repo
```bash
echo "yourdomain.com" > CNAME
git add CNAME
git commit -m "Add custom domain"
git push
```

### 2. Configure DNS at registrar
Tell the user to go to their domain registrar (Namecheap, GoDaddy, etc.) and add these DNS records:

**A Records (for apex domain — yourdomain.com):**
```
Type: A    Host: @    Value: 185.199.108.153
Type: A    Host: @    Value: 185.199.109.153
Type: A    Host: @    Value: 185.199.110.153
Type: A    Host: @    Value: 185.199.111.153
```

**CNAME Record (for www.yourdomain.com):**
```
Type: CNAME    Host: www    Value: username.github.io.
```

### 3. Wait for DNS
DNS can take 5 minutes to 48 hours to propagate (usually under 30 minutes).

### 4. Enable HTTPS
Go to repo Settings → Pages → check "Enforce HTTPS"
GitHub auto-provisions a free SSL certificate. Can take up to 24 hours.

---

## Pushing Updates

After making changes to the site:
```bash
git add index.html
git commit -m "Description of what changed"
git push
```
Site updates automatically in 1-2 minutes.

If git push is rejected (remote has changes):
```bash
git pull --rebase
git push
```

---

## Troubleshooting

**"fatal: not a git repository"**
→ You need to `cd` into the project folder first, or run `git init`

**"gh: command not found"**
→ Install GitHub CLI: `winget install --id GitHub.cli` then restart VS Code

**"git: command not found"**
→ Install Git from https://git-scm.com/download/win then restart VS Code

**Site shows 404 on GitHub Pages:**
- Make sure file is named `index.html` (lowercase)
- Make sure GitHub Pages is enabled in Settings → Pages
- Make sure the source branch is `main`
- Wait 2 minutes after pushing

**Custom domain not working:**
- Check CNAME file exists in repo and contains just the domain name
- Verify DNS records are correct at your registrar
- Wait — DNS propagation takes time

**"Not Secure" warning:**
- HTTPS certificate is still being created — wait up to 24 hours
- Make sure "Enforce HTTPS" is checked in Pages settings

**Browser showing old version after pushing:**
- GitHub Pages CDN caches for 10 minutes
- Force refresh: `Ctrl+Shift+R`
- Try incognito/private window
- Add `?v=2` to the URL

---

## Favicon (No Extra Files Needed)

Use an inline SVG favicon — no need to create or host a separate file:
```html
<link rel="icon" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 32 32'><rect width='32' height='32' rx='6' fill='%23050505'/><text x='16' y='22' text-anchor='middle' font-family='Arial' font-weight='700' font-size='14' fill='%236c5ce7'>AB</text></svg>">
```
Replace `AB` with initials. Change colors as needed (`%23` = `#` in URL encoding).
