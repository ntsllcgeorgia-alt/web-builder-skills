import time
import sys
import os

# Fix Windows terminal encoding
if os.name == 'nt':
    os.system('chcp 65001 >nul 2>&1')
    sys.stdout.reconfigure(encoding='utf-8', errors='replace')

def type_out(text, speed=0.03):
    for char in text:
        sys.stdout.write(char)
        sys.stdout.flush()
        time.sleep(speed)
    print()

def type_fast(text):
    type_out(text, 0.015)

def pause(seconds=0.5):
    time.sleep(seconds)

def clear():
    os.system('cls' if os.name == 'nt' else 'clear')

def main():
    clear()
    pause(0.5)

    # Boot sequence
    print()
    type_out("   ______  __    ___   __  __ ____   ______", 0.008)
    type_out("  / ____/ / /   /   | / / / // __ \\ / ____/", 0.008)
    type_out(" / /     / /   / /| |/ / / // / / // __/   ", 0.008)
    type_out("/ /___  / /___/ ___ / /_/ // /_/ // /___   ", 0.008)
    type_out("\\____/ /_____/_/  |_\\____//_____//_____/   ", 0.008)
    pause(0.5)

    print()
    type_out("  =====================================================", 0.01)
    type_out("       PERSONAL AI SYSTEM  //  BUILT BY HAZEM", 0.025)
    type_out("  =====================================================", 0.01)
    pause(0.8)

    print()
    type_out("  > SYSTEM BOOT ....................................... OK", 0.015)
    pause(0.3)
    type_out("  > LOADING AI ENGINE .................................. OK", 0.015)
    pause(0.3)
    type_out("  > CONNECTING TO CLAUDE (Anthropic) ................... OK", 0.015)
    pause(0.3)
    type_out("  > SKILL PACK: WEB BUILDER ........................... LOADED", 0.015)
    pause(0.3)
    type_out("  > SKILL PACK: SOCIAL MEDIA MANAGER .................. LOADED", 0.015)
    pause(0.3)
    type_out("  > SKILL PACK: BUSINESS TOOLS ........................ LOADED", 0.015)
    pause(0.3)
    type_out("  > SKILL PACK: AUTOMATION ............................ LOADED", 0.015)
    pause(0.3)
    type_out("  > SKILL PACK: YOUTUBE SEO ENGINE ..................... LOADED", 0.015)
    pause(0.5)

    print()
    print("  -----------------------------------------------------")
    pause(0.5)

    print()
    type_out("  Yo Faris,", 0.04)
    pause(0.5)
    type_out("  Welcome to your machine.", 0.035)
    pause(0.8)

    print()
    type_out("  This is Claude — an AI built by Anthropic, one of the", 0.025)
    type_out("  most advanced AI systems on the planet. It reads code,", 0.025)
    type_out("  writes code, builds full websites, manages files, and", 0.025)
    type_out("  thinks through problems like a senior engineer.", 0.025)
    pause(0.5)

    print()
    type_out("  Hazem set this up for you personally. Everything you", 0.025)
    type_out("  need is already loaded. You don't need to know how to", 0.025)
    type_out("  code. You just tell it what you want — it handles the rest.", 0.025)
    pause(0.8)

    print()
    type_out("  =====================================================", 0.01)
    type_out("       WHAT YOU CAN DO WITH THIS", 0.03)
    type_out("  =====================================================", 0.01)
    pause(0.5)

    print()
    type_out("  [WEBSITES]", 0.02)
    type_fast("    • Build professional websites from scratch")
    type_fast("    • Dark premium designs with animations & effects")
    type_fast("    • Landing pages, portfolios, business sites, campaigns")
    type_fast("    • Mobile-responsive — works perfect on every phone")
    type_fast("    • Deploy live to the internet for free (GitHub Pages)")
    type_fast("    • Custom domains with SSL (the lock icon)")
    type_fast("    • SEO optimization so Google finds you")
    pause(0.4)

    print()
    type_out("  [SOCIAL MEDIA MANAGER]", 0.02)
    type_fast("    • Post to 13 platforms from one command")
    type_fast("    • YouTube, Instagram, TikTok, Twitter, LinkedIn, Facebook")
    type_fast("    • Threads, Pinterest, Reddit, Bluesky, Telegram, Snapchat")
    type_fast("    • Unique captions per platform (never copy-paste)")
    type_fast("    • Schedule posts, create drafts, cross-post everywhere")
    type_fast("    • YouTube Shorts + Reels + TikTok in one shot")
    type_fast("    • Full YouTube SEO: titles, tags, descriptions, timestamps")
    type_fast("    • Thumbnail concepts and first-comment CTAs")
    type_fast("    • Powered by Late API (getlate.dev)")
    pause(0.4)

    print()
    type_out("  [BUSINESS]", 0.02)
    type_fast("    • Generate business ideas and full brand strategies")
    type_fast("    • Create business plans, pitch decks, proposals")
    type_fast("    • Design logos concepts and brand identity guidelines")
    type_fast("    • Market research and competitor analysis")
    type_fast("    • Social media content strategies")
    pause(0.4)

    print()
    type_out("  [DOCUMENTS]", 0.02)
    type_fast("    • Write and format professional emails")
    type_fast("    • Create PowerPoint presentations")
    type_fast("    • Build Excel spreadsheets with formulas")
    type_fast("    • Write Word documents, reports, contracts")
    type_fast("    • Create CSV files, data tables, invoices")
    pause(0.4)

    print()
    type_out("  [AUTOMATION]", 0.02)
    type_fast("    • Auto-update websites with live news feeds")
    type_fast("    • Batch process and compress images")
    type_fast("    • Web scraping — pull data from any site")
    type_fast("    • File management — organize, rename, sort files")
    type_fast("    • Scheduled tasks that run on their own (GitHub Actions)")
    pause(0.4)

    print()
    type_out("  [CODE & SCRIPTS]", 0.02)
    type_fast("    • Python scripts for anything you can think of")
    type_fast("    • JavaScript, HTML, CSS — full web stack")
    type_fast("    • API integrations (connect to any service)")
    type_fast("    • Database design and management")
    type_fast("    • Debug and fix broken code")
    pause(0.8)

    print()
    type_out("  =====================================================", 0.01)
    type_out("       WHAT'S UNDER THE HOOD", 0.03)
    type_out("  =====================================================", 0.01)
    pause(0.5)

    print()
    type_out("  You're running Claude through VS Code — that's the app", 0.025)
    type_out("  you're looking at right now. VS Code is where developers", 0.025)
    type_out("  at Google, Microsoft, and every tech company write their", 0.025)
    type_out("  code. Now you have it too.", 0.025)
    pause(0.5)

    print()
    type_out("  Python is the programming language that powers most of", 0.025)
    type_out("  the AI world — ChatGPT, Instagram, YouTube, Netflix,", 0.025)
    type_out("  NASA, and now your machine. When Claude needs to crunch", 0.025)
    type_out("  images, scrape the web, or automate tasks — it writes", 0.025)
    type_out("  Python and runs it right here on your computer.", 0.025)
    pause(0.5)

    print()
    type_out("  Git and GitHub are how every developer on Earth ships", 0.025)
    type_out("  code. When you build a website, Claude pushes it to", 0.025)
    type_out("  GitHub and it goes live — instantly, for free.", 0.025)
    pause(0.5)

    print()
    type_out("  If any of these tools aren't installed yet, don't worry.", 0.025)
    type_out("  Claude will detect what's missing and install everything", 0.025)
    type_out("  for you automatically. You literally just talk to it.", 0.025)
    pause(1.0)

    print()
    type_out("  =====================================================", 0.01)
    type_out("       HOW TO USE THIS", 0.03)
    type_out("  =====================================================", 0.01)
    pause(0.5)

    print()
    type_out("  Just type what you want in the Claude panel. Examples:", 0.025)
    pause(0.3)

    print()
    type_fast('    "Build me a website for my barbershop"')
    type_fast('    "Post this video to YouTube, Instagram, and TikTok"')
    type_fast('    "Write a professional email to a client about pricing"')
    type_fast('    "Create a business plan for a clothing brand"')
    type_fast('    "Make me a PowerPoint about my company"')
    type_fast('    "Schedule a post for tomorrow on all my socials"')
    type_fast('    "Compress all the images in my photos folder"')
    type_fast('    "Build me an Excel spreadsheet to track my expenses"')
    type_fast('    "Create a full YouTube content package for this video"')
    type_fast('    "Give me 10 business ideas for someone with $5K"')
    pause(0.8)

    print()
    type_out("  -----------------------------------------------------", 0.01)
    pause(0.3)
    print()
    type_out("  This system was built by Hazem.", 0.035)
    type_out("  Powered by Claude (Anthropic) + Python + VS Code.", 0.03)
    type_out("  No limits. No monthly fees for the tools. Just build.", 0.03)
    pause(0.5)

    print()
    type_out("  Ready when you are, Faris.", 0.04)
    print()
    type_out("  =====================================================", 0.01)
    print()

if __name__ == '__main__':
    main()
