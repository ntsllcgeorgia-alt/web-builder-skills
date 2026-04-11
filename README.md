# Web Builder Skills Pack

A plug-and-play skill pack for Claude Code (VS Code extension). Open this folder in VS Code with Claude, and you instantly have a professional web designer/developer that can build stunning websites from scratch.

## What This Does

When Claude reads the `CLAUDE.md` file in this repo, it gains:

- **Dark premium design system** — colors, typography, spacing, shadows
- **Ready-to-use templates** — starter page + component library
- **Animation toolkit** — loading screens, scroll reveals, hover effects, cursor glow
- **Mobile-first responsive design** — breakpoints, touch support, testing checklist
- **Deployment workflow** — GitHub Pages, custom domains, DNS, SSL
- **SEO knowledge** — meta tags, OG images, social sharing
- **Image optimization** — Python compression scripts, format guidelines
- **Interactive components** — carousels, modals, forms, hamburger menus, tickers

## Quick Start

1. Clone this repo
2. Open the folder in VS Code
3. Open Claude Code (the extension)
4. Tell Claude what website you want to build
5. Claude builds it — single HTML file, no dependencies, ready to deploy

## Example Prompts

- "Build me a landing page for my photography business"
- "Create a dark premium website for my consulting agency with pricing cards"
- "Build an advocacy site with a carousel, donation button, and countdown timer"
- "Make me a portfolio site with a project grid and contact form"

## What's Inside

```
CLAUDE.md              — Main instructions Claude reads automatically
templates/
  starter.html         — Dark theme starter template (copy and customize)
  components.html      — UI component library (pricing, testimonials, etc.)
skills/
  design.md            — Color palette, typography, spacing, layout patterns
  animations.md        — CSS keyframes, scroll reveals, hover effects, counters
  responsive.md        — Mobile-first design, breakpoints, testing checklist
  deployment.md        — GitHub Pages setup, custom domains, DNS, favicons
  seo.md               — Meta tags, OG images, structured data
  images.md            — Image compression with Python PIL
  javascript.md        — Carousels, modals, menus, tickers, password gates
```

## No Dependencies

Everything is built with:
- Pure HTML, CSS, JavaScript
- Google Fonts (loaded via CDN)
- Python PIL (for image compression only — optional)
- GitHub Pages (free hosting)

No React. No Tailwind. No npm. No build tools. Just clean code that works everywhere.
