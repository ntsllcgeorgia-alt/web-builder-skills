# Deployment — GitHub Pages, Domains, DNS, SSL

## GitHub Pages Deployment (Free Hosting)

### Step-by-Step

1. **Create the repo**
```bash
cd /path/to/your/site
git init
git add index.html
git commit -m "Initial site"
```

2. **Create GitHub repo** (using GitHub CLI)
```bash
gh repo create repo-name --public --source=. --push
```

3. **Enable GitHub Pages**
   - Go to repo Settings → Pages
   - Source: Deploy from branch → `main` → `/ (root)`
   - Save

4. **Site goes live** at `https://username.github.io/repo-name/`

### Custom Domain Setup

1. **Add CNAME file** to repo root:
```bash
echo "yourdomain.com" > CNAME
git add CNAME && git commit -m "Add custom domain" && git push
```

2. **Configure DNS** at your domain registrar (e.g., Namecheap, GoDaddy):

   For apex domain (yourdomain.com):
   ```
   Type: A Record
   Host: @
   Value: 185.199.108.153
   
   Type: A Record
   Host: @
   Value: 185.199.109.153
   
   Type: A Record
   Host: @
   Value: 185.199.110.153
   
   Type: A Record
   Host: @
   Value: 185.199.111.153
   ```

   For www subdomain:
   ```
   Type: CNAME
   Host: www
   Value: username.github.io.
   ```

3. **Wait for DNS propagation** — can take 5 minutes to 48 hours (usually under 30 min)

4. **Enable HTTPS** in repo Settings → Pages → check "Enforce HTTPS"
   - GitHub auto-provisions a Let's Encrypt SSL certificate
   - This can take up to 24 hours after DNS resolves

### Troubleshooting

**Site shows 404:**
- Make sure the file is named `index.html` (not `Index.html`)
- Make sure GitHub Pages source is set to correct branch
- Check that the file is committed and pushed (not just staged)

**Custom domain not working:**
- Check CNAME file exists in repo root and contains just the domain name
- Verify DNS records with: `dig yourdomain.com +short`
- Wait — DNS propagation takes time

**"Not Secure" warning:**
- HTTPS certificate is still provisioning — wait up to 24 hours
- Make sure "Enforce HTTPS" is checked in Pages settings
- If stuck, try removing and re-adding the custom domain in Settings

**CNAME causing redirect before DNS is ready:**
- Temporarily remove CNAME file from repo
- Test with `username.github.io/repo-name` URL
- Re-add CNAME after DNS propagates

**Browser showing old version:**
- GitHub Pages CDN caches for 10 minutes (`max-age=600`)
- Force refresh: `Ctrl+Shift+R`
- Add query string to URL: `?v=2`
- Try incognito/private window
- Clear browser cache

## Git Workflow for Deployments

```bash
# Stage specific files (never use git add . blindly)
git add index.html styles.css images/

# Commit with clear message
git commit -m "Add pricing section and mobile fixes"

# Push to deploy
git push

# Verify deployment
# Wait 1-2 minutes, then check the live URL
```

### Important Git Rules

1. **Never commit secrets** — no API keys, passwords, tokens in code
2. **Stage specific files** — `git add filename` not `git add .`
3. **Always pull before push** if working from multiple machines:
   ```bash
   git pull --rebase && git push
   ```
4. **Check status first**: `git status` before every commit

## Favicon

### Inline SVG Favicon (No Extra Files)
```html
<link rel="icon" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 32 32'><rect width='32' height='32' rx='6' fill='%23050505'/><text x='16' y='22' text-anchor='middle' font-family='Arial' font-weight='700' font-size='14' fill='%236c5ce7'>AB</text></svg>">
```
Replace `AB` with the client's initials. Change `%236c5ce7` to any hex color (use `%23` instead of `#`).

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

### ICO Favicon (for max compatibility)
Generate with Python:
```python
from PIL import Image, ImageDraw, ImageFont
img = Image.new('RGBA', (32, 32), (5, 5, 5, 255))
draw = ImageDraw.Draw(img)
# Add text/shapes as needed
img.save('favicon.ico', format='ICO', sizes=[(32, 32), (16, 16)])
```
