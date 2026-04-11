# Image Optimization (No Python Required)

## Why This Matters

- Large images (5MB+ PNGs) kill page load times
- GitHub has a 100MB file limit and repos get slow with big files
- Users on mobile are often on slower connections
- Google penalizes slow pages in search rankings

## Free Online Compression (No Install Needed)

Tell the user to use these free browser-based tools:

### Squoosh (by Google) — Best Option
> Go to **squoosh.app** in your browser. Drag your image in, adjust quality to 80%, download. Done.

- Supports JPG, PNG, WebP
- Shows before/after comparison
- Resize and compress in one step
- No account needed, no upload limits, runs locally in browser

### TinyPNG
> Go to **tinypng.com** in your browser. Drag up to 20 images. Download the compressed versions.

- Great for batch compression
- Free tier: 20 images at a time, 5MB each

## Image Size Guidelines

| Use Case | Recommended Size | Target File Size |
|----------|-----------------|------------------|
| Hero background | 1920px wide | < 300KB |
| Card image | 800px wide | < 100KB |
| Thumbnail | 400px wide | < 50KB |
| OG/social image | 1200x630px | < 300KB |
| Favicon | 32x32px | < 5KB (use SVG) |

## CSS Image Optimization

### Background Images with Dark Overlay
```css
.hero {
  background: linear-gradient(rgba(5,5,5,0.7), rgba(5,5,5,0.9)),
              url('hero-bg.jpg');
  background-size: cover;
  background-position: center;
}
```

### Responsive Images
```css
img {
  max-width: 100%;
  height: auto;
  display: block;
}
```

### Object Fit (Crop Without Distortion)
```css
.card-image {
  width: 100%;
  height: 200px;
  object-fit: cover;      /* Crops to fill, keeps aspect ratio */
  object-position: center; /* Control crop position */
  border-radius: 12px;
}
```

### Lazy Loading (No JavaScript Needed)
```html
<!-- Browser handles it natively — just add loading="lazy" -->
<img src="photo.jpg" alt="Description" loading="lazy">
```

### Responsive Images (Browser Picks Best Size)
```html
<img srcset="photo-400.jpg 400w,
             photo-800.jpg 800w,
             photo-1200.jpg 1200w"
     sizes="(max-width: 768px) 400px, 800px"
     src="photo-800.jpg"
     alt="Description">
```

## Image Formats Cheat Sheet

| Format | Best For | Supports Transparency |
|--------|----------|----------------------|
| JPG | Photos, backgrounds | No |
| PNG | Screenshots, logos with transparency | Yes |
| SVG | Icons, logos, favicons | Yes |
| WebP | Everything (modern browsers) | Yes |

## When to Use Each

- **Photos of people/places**: JPG (compress at squoosh.app)
- **Screenshots with text**: PNG (sharper text edges)
- **Logos and icons**: SVG (scales infinitely, tiny file size)
- **Favicons**: Inline SVG data URI (no extra files needed)
- **OG images**: JPG (universal compatibility)

## Inline SVG Favicon (Zero Files, Zero Dependencies)

Instead of creating a favicon file, embed it directly in the HTML:
```html
<link rel="icon" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 32 32'><rect width='32' height='32' rx='6' fill='%23050505'/><text x='16' y='22' text-anchor='middle' font-family='Arial' font-weight='700' font-size='14' fill='%236c5ce7'>AB</text></svg>">
```
Replace `AB` with the client's initials. Change `%236c5ce7` to match their brand color.
