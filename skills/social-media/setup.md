# Social Media Manager — Setup Guide

This turns Claude into a full social media manager that can post to 13 platforms from the terminal. Here's how to set it up.

## What You Need

1. **A Late account** (free to start)
2. **Your social media accounts** connected to Late
3. That's it. Claude handles everything else.

## Step-by-Step Setup

### 1. Create a Late Account
Go to **https://getlate.dev** and sign up.

### 2. Get Your API Key
- Go to Late → Settings → API Keys
- Click "Create new key"
- Copy the key (starts with `sk_`)
- **Save it somewhere safe** — you'll need it every time you post

### 3. Connect Your Social Accounts
In the Late dashboard, click "Add Account" and connect each platform you want to post to:
- YouTube
- Instagram
- TikTok
- Twitter/X
- LinkedIn
- Facebook
- Threads
- Pinterest
- Reddit
- Bluesky
- Google Business
- Telegram
- Snapchat

### 4. Tell Claude Your API Key
When you first ask Claude to post something, it will ask for your Late API key. Give it the key and Claude will handle the rest.

Or you can update the `late-social-media.md` file and replace `YOUR_API_KEY_HERE` with your actual key.

### 5. Optional: Install Late MCP Server
For faster posting with MCP tools (instead of curl):
```bash
# In VS Code, add to your Claude MCP settings:
# Server name: late
# Command: npx @late-labs/mcp-server
# Env: LATE_API_KEY=your_key_here
```

This gives Claude direct access to `accounts_list`, `posts_create`, `posts_list`, and `media_presign` tools.

## What You Can Do

Once set up, just tell Claude:

- *"Post this to Twitter and LinkedIn"*
- *"Schedule a post for tomorrow at 9am on Instagram"*
- *"Upload this video to YouTube, Instagram Reels, and TikTok"*
- *"Create a full YouTube content package for this video"*
- *"Draft a Twitter thread about [topic]"*
- *"Cross-post this to all my platforms"*

Claude will:
1. Write unique content for each platform (never copy-paste)
2. Show you everything before posting
3. Wait for your approval
4. Post to all platforms in one shot
5. Verify everything went live

## Platform Content Rules

Claude automatically adjusts tone and format per platform:

| Platform | Tone | Length | Hashtags |
|----------|------|--------|----------|
| YouTube | Professional, detailed | 4-6 sentences + links | 3-5 + tags field |
| Instagram | Casual, direct | 1-3 sentences | ~3 |
| TikTok | Punchy, conversational | 1-2 sentences | 3-5 |
| Twitter | Sharp, hook-driven | 280 chars max | 1-2 |
| LinkedIn | Professional, story-driven | 3-5 paragraphs | 3-5 |
| Facebook | Conversational, warm | 2-4 sentences | Optional |
