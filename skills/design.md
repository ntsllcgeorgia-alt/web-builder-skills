# Visual Design System

## Dark Premium Aesthetic

The default design language for all websites. This creates a modern, high-end look that works for any industry.

### Color Palette

```
Background layers:
  #050505  — primary background (body, hero)
  #0a0a0a  — slightly lighter (alternate sections)
  #111111  — cards, containers, inputs
  #1a1a1a  — borders, dividers (subtle)

Text:
  #ffffff  — headings, primary text
  #e0e0e0  — body text
  #aaaaaa  — secondary text
  #888888  — muted text, subtitles
  #555555  — disabled text, tiny labels

Accent gradient:
  #6c5ce7 → #00cec9  — primary gradient (purple to teal)
  Use at 135deg for diagonal, 90deg for horizontal

Status/semantic:
  #00cec9  — success, positive, checkmarks
  #fd7272  — error, danger, urgent
  #fdcb6e  — warning, stars, highlights
  #6c5ce7  — interactive, links, focus
```

### Typography

```css
/* Heading font — bold, geometric, modern */
font-family: 'Space Grotesk', sans-serif;

/* Body font — clean, readable, professional */
font-family: 'Inter', sans-serif;

/* Alternative heading fonts (when Space Grotesk doesn't fit): */
font-family: 'Oswald', sans-serif;      /* condensed, impactful, great for activism/sports */
font-family: 'Playfair Display', serif;  /* elegant, editorial, luxury brands */
font-family: 'Bebas Neue', sans-serif;   /* ultra bold, poster-style, events */

/* Size scale (using clamp for fluid sizing): */
h1: clamp(2.5rem, 6vw, 5rem)     /* hero headlines */
h2: clamp(2rem, 4vw, 3rem)       /* section titles */
h3: 1.25rem                       /* card titles */
body: 1rem (16px)                  /* base text */
small: 0.85rem                    /* captions, labels */
tiny: 0.75rem                     /* badges, tags */

line-height: 1.1 for headlines, 1.6 for body text
```

### Spacing System

```
Sections:  padding: 100px 20px  (mobile: 60px 15px)
Cards:     padding: 40px 30px
Buttons:   padding: 14px 32px
Inputs:    padding: 14px 16px
Gap:       24px between cards, 16px between small elements
Max-width: 1200px for content, 1000px for narrow content, 600px for text blocks
```

### Border & Shadow

```css
/* Card border */
border: 1px solid rgba(255, 255, 255, 0.06);
border-radius: 16px;

/* Hover glow */
box-shadow: 0 0 30px rgba(108, 92, 231, 0.1);
border-color: rgba(108, 92, 231, 0.3);

/* Button shadow on hover */
box-shadow: 0 10px 30px rgba(108, 92, 231, 0.3);

/* Subtle elevation */
box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
```

## Light Theme Alternative

When a client wants a light design:

```
Background: #ffffff, #f8f9fa, #f0f0f0
Text: #1a1a1a, #333, #666
Cards: #ffffff with border: 1px solid #e0e0e0
Shadows: box-shadow: 0 2px 20px rgba(0,0,0,0.08)
Keep the same accent gradient
```

## Layout Patterns

### Hero Section
- Full viewport height (`min-height: 100vh`)
- Centered content, max-width 800px
- Large headline, subtitle, 1-2 buttons
- Optional: background image with dark overlay

### Cards Grid
- Use `grid-template-columns: repeat(auto-fit, minmax(300px, 1fr))`
- This automatically goes to 1 column on mobile
- Gap: 24px
- Cards get hover transform + glow

### Split Section (text + image)
- Use flexbox with `gap: 60px`
- Text side: max-width 500px
- Image side: border-radius 16px, subtle border
- Reverse alternate rows with `flex-direction: row-reverse`

### Full-width Background Section
- Use a background gradient or image
- Add dark overlay: `background: linear-gradient(rgba(5,5,5,0.8), rgba(5,5,5,0.9)), url('image.jpg')`
- `background-size: cover; background-position: center;`
