# SEO, Meta Tags & Social Sharing

## Essential Meta Tags

Every website MUST have these in the `<head>`:

```html
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Page Title — Brand Name</title>
<meta name="description" content="Clear description under 160 characters. Include primary keywords naturally.">
```

## Open Graph Tags (Social Sharing)

These control how the site appears when shared on Facebook, LinkedIn, iMessage, etc.

```html
<meta property="og:title" content="Page Title">
<meta property="og:description" content="Compelling description for social shares.">
<meta property="og:image" content="https://yourdomain.com/og-image.jpg">
<meta property="og:url" content="https://yourdomain.com">
<meta property="og:type" content="website">
<meta property="og:site_name" content="Brand Name">
```

## Twitter Card Tags

```html
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="Page Title">
<meta name="twitter:description" content="Description for Twitter shares.">
<meta name="twitter:image" content="https://yourdomain.com/og-image.jpg">
```

## OG Image Best Practices

- **Size**: 1200x630 pixels (2:1 ratio)
- **Format**: JPG (smaller file size than PNG)
- **File size**: Under 300KB
- **Content**: Brand name, tagline, maybe a photo — readable at thumbnail size
- **URL**: Must be absolute (https://...), not relative
- **Test**: Use Facebook Sharing Debugger or Twitter Card Validator

### Creating OG Images with Python
```python
from PIL import Image, ImageDraw, ImageFont

img = Image.new('RGB', (1200, 630), (5, 5, 5))
draw = ImageDraw.Draw(img)

# Add text overlay
try:
    font = ImageFont.truetype("arial.ttf", 60)
except:
    font = ImageFont.load_default()

draw.text((100, 250), "YOUR TITLE HERE", fill=(255, 255, 255), font=font)
img.save('og-image.jpg', quality=85, optimize=True)
```

## Structured Data (Schema.org)

For business websites, add JSON-LD structured data:

```html
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "Organization",
  "name": "Brand Name",
  "url": "https://yourdomain.com",
  "description": "What the business does",
  "contactPoint": {
    "@type": "ContactPoint",
    "email": "contact@yourdomain.com",
    "contactType": "customer service"
  }
}
</script>
```

## Page Title Formula

```
[Primary Keyword] — [Brand Name]
```
Examples:
- "Professional Web Design — LaunchAndManage"
- "Free Salah Sarsour — Justice Campaign"

Keep under 60 characters for full display in search results.

## SEO Checklist

- [ ] Title tag is descriptive and under 60 characters
- [ ] Meta description is compelling and under 160 characters
- [ ] og:image is set with absolute URL
- [ ] All images have alt text
- [ ] Heading hierarchy is correct (one H1, then H2s, H3s)
- [ ] Page loads fast (compress images, minimize code)
- [ ] Mobile-friendly (responsive design)
- [ ] HTTPS enabled
- [ ] CNAME/domain is properly configured
- [ ] Favicon is set
