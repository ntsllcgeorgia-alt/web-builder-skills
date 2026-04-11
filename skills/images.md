# Image Compression & Optimization

## Why This Matters

- Large images (5MB+ PNGs) kill page load times
- GitHub has a 100MB file limit and repos get slow with big files
- Users on mobile are often on slower connections
- Google penalizes slow pages in search rankings

## Auto-Install Pillow

Before using any Python image code, check and install:
```bash
pip install Pillow 2>/dev/null || pip3 install Pillow
```
If Python itself is missing, install it first:
```bash
winget install --id Python.Python.3.12 -e --accept-package-agreements --accept-source-agreements
```

## Python Image Compression

### Basic Compression (PNG → JPG)
```python
from PIL import Image

img = Image.open('photo.png')
img = img.convert('RGB')  # Remove alpha channel for JPG
img.save('photo.jpg', quality=85, optimize=True)
```

### Resize + Compress
```python
from PIL import Image

img = Image.open('huge-photo.png')
img = img.convert('RGB')

# Resize to max 1920px wide (keep aspect ratio)
max_width = 1920
if img.width > max_width:
    ratio = max_width / img.width
    new_size = (max_width, int(img.height * ratio))
    img = img.resize(new_size, Image.LANCZOS)

img.save('optimized.jpg', quality=85, optimize=True)
```

### Batch Compress All Images in a Folder
```python
from PIL import Image
import os

input_dir = 'raw-images/'
output_dir = 'optimized/'
os.makedirs(output_dir, exist_ok=True)

for filename in os.listdir(input_dir):
    if filename.lower().endswith(('.png', '.jpg', '.jpeg', '.bmp')):
        img = Image.open(os.path.join(input_dir, filename))
        img = img.convert('RGB')
        
        # Resize if wider than 1920px
        if img.width > 1920:
            ratio = 1920 / img.width
            img = img.resize((1920, int(img.height * ratio)), Image.LANCZOS)
        
        out_name = os.path.splitext(filename)[0] + '.jpg'
        img.save(os.path.join(output_dir, out_name), quality=85, optimize=True)
        
        # Report size reduction
        orig_size = os.path.getsize(os.path.join(input_dir, filename))
        new_size = os.path.getsize(os.path.join(output_dir, out_name))
        print(f"{filename}: {orig_size//1024}KB → {new_size//1024}KB ({100-new_size*100//orig_size}% smaller)")
```

### Create Thumbnails
```python
from PIL import Image

img = Image.open('photo.jpg')
img.thumbnail((400, 400))  # Max 400x400, keeps aspect ratio
img.save('photo-thumb.jpg', quality=80, optimize=True)
```

### Create OG Image with Text Overlay
```python
from PIL import Image, ImageDraw, ImageFont

# Start with a photo or solid background
img = Image.new('RGB', (1200, 630), (5, 5, 5))
draw = ImageDraw.Draw(img)

# Add text
try:
    font = ImageFont.truetype("arial.ttf", 60)
    small_font = ImageFont.truetype("arial.ttf", 28)
except:
    font = ImageFont.load_default()
    small_font = font

draw.text((100, 240), "YOUR SITE TITLE", fill=(255, 255, 255), font=font)
draw.text((100, 320), "Subtitle or tagline here", fill=(136, 136, 136), font=small_font)

img.save('og-image.jpg', quality=85, optimize=True)
```

### Create ICO Favicon
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

## Quality Guidelines

| Use Case | Max Width | JPG Quality | Target Size |
|----------|-----------|-------------|-------------|
| Hero background | 1920px | 85 | < 300KB |
| Card image | 800px | 80 | < 100KB |
| Thumbnail | 400px | 75 | < 50KB |
| OG image | 1200px | 85 | < 300KB |
| Favicon | 32px | N/A (SVG/ICO) | < 5KB |

## CSS Image Optimization

### Background Images with Overlay
```css
.hero {
  background: linear-gradient(rgba(5,5,5,0.7), rgba(5,5,5,0.9)),
              url('hero-bg.jpg');
  background-size: cover;
  background-position: center;
}
```

### Lazy Loading
```html
<!-- Native lazy loading — no JavaScript needed -->
<img src="photo.jpg" alt="Description" loading="lazy">
```

### Object Fit (Crop Without Distortion)
```css
.card-image {
  width: 100%;
  height: 200px;
  object-fit: cover;
  object-position: center;
  border-radius: 12px;
}
```

### Responsive Images
```html
<!-- Browser picks the best size -->
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

- **Photos of people/places**: JPG at quality 80-85
- **Screenshots with text**: PNG (sharper text edges)
- **Logos and icons**: SVG (scales infinitely)
- **Favicons**: SVG inline or ICO file
- **OG images**: JPG (universal compatibility)
