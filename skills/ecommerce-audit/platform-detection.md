# Platform Detection — Identify Any Ecommerce Stack

Before you audit a site, you need to know what they're running. Here's how to identify any e-commerce platform in under 2 minutes, with near-100% accuracy.

## The 4 Check Methods (do all of them)

### 1. View Source Code
```
Right-click any page → "View Page Source" (or Ctrl+U)
```

### 2. Check HTTP Response Headers
```bash
curl -sI https://example.com | head -20
```

### 3. Check CDN URLs in the HTML
```bash
curl -sL https://example.com | grep -oE "(https?://[^'\"]+\.(com|io|net|cloud)[^'\"]+)" | sort -u | head -30
```

### 4. Check robots.txt and sitemap
```bash
curl -s https://example.com/robots.txt
curl -s https://example.com/sitemap.xml | head -30
```

---

## Platform Signatures

### 🟠 BigCommerce
**Smoking guns:**
- CDN URL: `cdn11.bigcommerce.com/s-XXXXXXXX/` — that `XXXXXXXX` is the **store hash**
- Meta tag: `<meta name='platform' content='bigcommerce.stencil' />`
- JS files referencing `stencil/` path
- robots.txt blocks: `/account.php`, `/cart.php`, `/checkout.php`
- URL parameter: `_bc_fsnf=1`

**Extract store hash:**
```bash
curl -sL https://example.com | grep -oE "s-[a-z0-9]+" | head -1
```

**API base URL:**
```
https://api.bigcommerce.com/stores/{store_hash}/v3/
```

**Auth required:**
- Client ID, Client Secret, Access Token (from Settings → API Accounts)

**Admin URL:**
```
https://store-{store_hash}.mybigcommerce.com/manage/
```

---

### 🟢 Shopify
**Smoking guns:**
- CDN: `cdn.shopify.com`
- Admin subdomain: `.myshopify.com`
- JS variable: `Shopify` or `window.Shopify`
- Meta: `<meta name="generator" content="Shopify">`
- URL with `?_ab=0&_fd=0&_sc=1` (session params)

**API base URL:**
```
https://{shop}.myshopify.com/admin/api/2024-01/
```

**Auth required:**
- Admin API access token (from custom app) OR OAuth token

**Public Storefront API (no auth needed for product data):**
```
https://{shop}.myshopify.com/products.json
https://{shop}.myshopify.com/collections.json
```
These often work even without credentials — use to verify the store exists.

---

### 🔵 WooCommerce (WordPress)
**Smoking guns:**
- Paths: `/wp-content/plugins/woocommerce/`
- JS: `wc_cart_fragments_params`, `wc-add-to-cart`
- Meta generator: `<meta name="generator" content="WooCommerce X.X.X">`
- REST API endpoint: `/wp-json/wc/v3/`

**API base URL:**
```
https://example.com/wp-json/wc/v3/
```

**Auth required:**
- Consumer Key + Consumer Secret (from WooCommerce → Settings → Advanced → REST API)

**Quick check:**
```bash
curl -s https://example.com/wp-json/ | python -m json.tool | head -20
```

---

### 🟣 Magento / Adobe Commerce
**Smoking guns:**
- JS: `Mage.js` or `Magento_Ui`
- Paths: `/skin/frontend/`, `/pub/static/frontend/`
- Forms contain `form_key` hidden input
- Cookie: `form_key`, `mage-cache-storage`
- Meta X-Powered-By: sometimes reveals "PHP/Magento"

**API base URL:**
```
https://example.com/rest/V1/
```

**Auth required:**
- Admin token via OAuth or integration tokens

**Graphql endpoint:**
```
https://example.com/graphql
```

---

### 🟡 Squarespace Commerce
**Smoking guns:**
- CDN: `static1.squarespace.com`
- JS: `Y.use('squarespace')`
- Meta: `<meta name="generator" content="Squarespace">`

**API:** Limited public API. Most data requires scraping or export.

---

### 🔴 Wix Commerce
**Smoking guns:**
- CDN: `static.wixstatic.com`
- Script: `static.parastorage.com/services/`
- Subdomain often `.wixsite.com`

**API:** Requires Wix Developer account + custom app install.

---

### ⚪ Custom / Unknown
If none of the above match, check for:
- **Framework**: `Next.js`, `Nuxt`, `Gatsby`, `Remix` — look for `_next`, `_nuxt`, `static/chunks` in URLs
- **CMS**: `Contentful`, `Sanity`, `Strapi` — check API endpoints
- **Headless commerce**: `Saleor`, `Commerce.js`, `Swell` — check GraphQL
- **Custom**: Look at HTTP response `Server` header, X-Powered-By

---

## Quick Detection Script

```python
import urllib.request
import re

def detect_platform(url):
    try:
        req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
        with urllib.request.urlopen(req, timeout=10) as resp:
            html = resp.read().decode('utf-8', errors='ignore')
            headers = dict(resp.getheaders())
    except Exception as e:
        return f"ERROR: {e}"

    checks = [
        ('BigCommerce', r'cdn11\.bigcommerce\.com|stencil|_bc_fsnf'),
        ('Shopify', r'cdn\.shopify\.com|\.myshopify\.com|Shopify\.theme'),
        ('WooCommerce', r'wp-content/plugins/woocommerce|wc-add-to-cart'),
        ('Magento', r'Mage\.|/pub/static/frontend/|form_key'),
        ('Squarespace', r'static1\.squarespace\.com|squarespace'),
        ('Wix', r'static\.wixstatic\.com|wixsite'),
        ('Next.js', r'/_next/'),
        ('WordPress', r'wp-content|wp-includes'),
    ]

    matches = []
    for platform, pattern in checks:
        if re.search(pattern, html, re.IGNORECASE):
            matches.append(platform)

    # BigCommerce store hash
    bc_hash = re.search(r's-([a-z0-9]{8,12})', html)
    if bc_hash:
        matches.append(f'Store hash: {bc_hash.group(1)}')

    return matches if matches else ['UNKNOWN']

if __name__ == '__main__':
    import sys
    url = sys.argv[1] if len(sys.argv) > 1 else 'https://example.com'
    print(f"Detecting: {url}")
    for m in detect_platform(url):
        print(f"  - {m}")
```

Save as `detect_platform.py`, run with `python detect_platform.py https://any-store.com`.
