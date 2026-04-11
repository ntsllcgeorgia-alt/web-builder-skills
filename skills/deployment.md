# Deployment — GitHub Pages, Domains, DNS, SSL

## Prerequisites

Claude auto-installs all of these. See `setup.md` for details.
- Git (`winget install --id Git.Git`)
- GitHub CLI (`winget install --id GitHub.cli`)
- GitHub account (https://github.com/signup)

## Deploying a Website (Full Flow)

### 1. Initialize the project
```bash
cd my-website
git init
git config user.name "Your Name"
git config user.email "your@email.com"
```

### 2. Stage and commit
```bash
git add index.html
git commit -m "Initial website"
```

### 3. Create GitHub repo and push
```bash
gh repo create my-website --public --source=. --push
```
This creates the repo on GitHub AND pushes your code — one command.

### 4. Enable GitHub Pages
Go to the repo on GitHub → Settings → Pages:
- Source: Deploy from branch
- Branch: `main`
- Folder: `/ (root)`
- Click Save

### 5. Site goes live
After 1-2 minutes: `https://username.github.io/my-website/`

---

## Custom Domain Setup

### 1. Add CNAME file
```bash
echo "yourdomain.com" > CNAME
git add CNAME && git commit -m "Add custom domain" && git push
```

### 2. Configure DNS at registrar (Namecheap, GoDaddy, etc.)

**A Records (apex domain — yourdomain.com):**
```
Type: A    Host: @    Value: 185.199.108.153
Type: A    Host: @    Value: 185.199.109.153
Type: A    Host: @    Value: 185.199.110.153
Type: A    Host: @    Value: 185.199.111.153
```

**CNAME Record (www subdomain):**
```
Type: CNAME    Host: www    Value: username.github.io.
```

### 3. Wait for DNS propagation
Usually 5-30 minutes, can take up to 48 hours.

### 4. Enable HTTPS
Repo Settings → Pages → check "Enforce HTTPS"
GitHub provisions a free SSL certificate automatically (can take up to 24 hours).

---

## Pushing Updates

```bash
git add index.html
git commit -m "Description of changes"
git push
```

If push is rejected:
```bash
git pull --rebase
git push
```

---

## Troubleshooting

**Site shows 404:**
- File must be named `index.html` (lowercase)
- GitHub Pages must be enabled in Settings → Pages
- Source branch must be `main`
- Wait 2 minutes after pushing

**Custom domain not working:**
- Check CNAME file exists with correct domain
- Verify DNS records at registrar
- Wait for DNS propagation

**"Not Secure" warning:**
- HTTPS cert is still provisioning — wait up to 24 hours
- Check "Enforce HTTPS" in Pages settings
- Try removing and re-adding custom domain in Settings

**CNAME causing redirect before DNS is ready:**
- Remove CNAME file temporarily
- Test with `username.github.io/repo-name`
- Re-add CNAME after DNS propagates

**Browser showing old version:**
- GitHub Pages caches for 10 minutes
- Force refresh: `Ctrl+Shift+R`
- Try incognito window
- Add `?v=2` to URL

---

## Favicon

### Inline SVG Favicon (No Extra Files)
```html
<link rel="icon" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 32 32'><rect width='32' height='32' rx='6' fill='%23050505'/><text x='16' y='22' text-anchor='middle' font-family='Arial' font-weight='700' font-size='14' fill='%236c5ce7'>AB</text></svg>">
```

### SVG Favicon File
```xml
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32">
  <rect width="32" height="32" rx="6" fill="#050505"/>
  <rect y="0" width="32" height="2" rx="1" fill="url(#g)"/>
  <defs>
    <linearGradient id="g" x1="0" y1="0" x2="32" y2="0" gradientUnits="userSpaceOnUse">
      <stop stop-color="#6c5ce7"/>
      <stop offset="1" stop-color="#00cec9"/>
    </linearGradient>
  </defs>
  <text x="16" y="22" text-anchor="middle" font-family="Arial,sans-serif" font-weight="700" font-size="14" fill="#6c5ce7">AB</text>
</svg>
```

### ICO Favicon (Python)
```python
from PIL import Image, ImageDraw, ImageFont
img = Image.new('RGBA', (32, 32), (5, 5, 5, 255))
draw = ImageDraw.Draw(img)
try:
    font = ImageFont.truetype("arial.ttf", 14)
except:
    font = ImageFont.load_default()
draw.text((4, 8), "AB", fill=(108, 92, 231, 255), font=font)
img.save('favicon.ico', format='ICO', sizes=[(32, 32), (16, 16)])
```
