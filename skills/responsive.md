# Mobile-First Responsive Design

## Core Principle

Most visitors are on mobile. Design for phones first, then add complexity for larger screens.

## Breakpoints

```css
/* Mobile first — base styles are for phones (< 768px) */

/* Tablet and up */
@media (min-width: 768px) { }

/* Desktop and up */
@media (min-width: 1024px) { }

/* Large desktop */
@media (min-width: 1400px) { }
```

When fixing mobile issues on an existing desktop-first site, use max-width:

```css
@media (max-width: 768px) {
  /* Mobile overrides */
}

@media (max-width: 480px) {
  /* Small phone overrides */
}
```

## Essential Mobile Patterns

### Viewport Meta Tag (REQUIRED)
```html
<meta name="viewport" content="width=device-width, initial-scale=1.0">
```
Without this, mobile browsers render at desktop width and zoom out.

### Fluid Typography
```css
/* Use clamp() for sizes that scale smoothly */
h1 { font-size: clamp(2rem, 6vw, 5rem); }
h2 { font-size: clamp(1.5rem, 4vw, 3rem); }
p  { font-size: clamp(0.9rem, 2vw, 1.1rem); }
```

### Flexible Grids
```css
/* This single rule handles responsive columns */
.grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 24px;
}

/* On very small screens, force single column */
@media (max-width: 480px) {
  .grid { grid-template-columns: 1fr; }
}
```

### Responsive Images
```css
img {
  max-width: 100%;
  height: auto;
  display: block;
}

/* Background images */
.hero-bg {
  background-size: cover;
  background-position: center;
}
```

### Navigation on Mobile
```css
/* Desktop: horizontal nav links */
.nav-links {
  display: flex;
  gap: 30px;
  list-style: none;
}

/* Mobile: hide nav links (use hamburger or simplify) */
@media (max-width: 768px) {
  .nav-links { display: none; }
  nav { padding: 15px 20px; }
}
```

### Touch Targets
```css
/* Buttons and links need minimum 44px tap target on mobile */
@media (max-width: 768px) {
  .btn {
    padding: 16px 24px;
    min-height: 44px;
    font-size: 1rem;
  }
  a { padding: 8px 0; }
}
```

## Common Mobile Fixes

### Content Overflowing Horizontally
```css
body { overflow-x: hidden; }

/* Find the culprit — usually an element wider than viewport */
* { max-width: 100vw; } /* temporary debug rule */
```

### Inline Styles Blocking Mobile Overrides
Inline styles (`style="..."` on HTML elements) beat `@media` queries. Solutions:
1. **Best**: Remove inline styles, use CSS classes instead
2. **Quick fix**: Use `!important` in media queries (sparingly)

```css
@media (max-width: 768px) {
  .hero-title {
    font-size: 2rem !important;
    padding: 20px !important;
  }
}
```

### Fixed Elements on Mobile
```css
@media (max-width: 768px) {
  /* Reduce fixed nav height */
  nav { padding: 10px 15px; }

  /* Remove cursor glow (no mouse on mobile) */
  .cursor-glow { display: none; }

  /* Reduce section padding */
  section { padding: 60px 15px; }
}
```

### Horizontal Scroll on Cards
```css
/* Option 1: Stack cards vertically */
@media (max-width: 768px) {
  .card-row {
    flex-direction: column;
  }
}

/* Option 2: Horizontal scroll (for image galleries) */
.scroll-row {
  display: flex;
  overflow-x: auto;
  scroll-snap-type: x mandatory;
  -webkit-overflow-scrolling: touch;
}
.scroll-row > * {
  scroll-snap-align: start;
  min-width: 280px;
}
```

## Testing Checklist

Before declaring a site "mobile ready":

1. Test at 375px width (iPhone SE / small phones)
2. Test at 390px width (iPhone 14)
3. Test at 768px width (iPad portrait)
4. Check that no horizontal scrollbar appears
5. Check that all text is readable without zooming
6. Check that all buttons are tappable (44px minimum)
7. Check that images don't overflow their containers
8. Check that modals/popups work and can be closed
9. Check that carousels support touch/swipe
10. Check that fixed elements don't overlap content

## Responsive Design Utilities

```css
/* Hide on mobile */
.desktop-only { display: block; }
@media (max-width: 768px) { .desktop-only { display: none; } }

/* Hide on desktop */
.mobile-only { display: none; }
@media (max-width: 768px) { .mobile-only { display: block; } }

/* Center everything on mobile */
@media (max-width: 768px) {
  .auto-center {
    text-align: center;
    margin-left: auto;
    margin-right: auto;
  }
}
```
