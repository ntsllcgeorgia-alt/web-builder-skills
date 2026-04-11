# YouTube Content Package

Create complete YouTube video packages with optimized titles, descriptions, keywords, timestamps, and thumbnail concepts.

## Full Workflow

1. **Check video size** — Must be under 500MB
2. **Compress if needed** — FFmpeg or HandBrake
3. **Upload to Late storage** — Get video URL
4. **Extract transcript** — Local transcription or manual
5. **Create content package** — Title, description, tags, etc.
6. **ASK USER FOR THUMBNAIL** — REQUIRED before posting
7. **Get user approval** — Confirm everything
8. **Post via Late API** — Publish with all fields

---

## CRITICAL: Pre-Post Requirements

**NEVER post without:**
1. Asking user for thumbnail image
2. Confirming the title with user
3. Showing complete content package for review
4. Getting explicit approval to post

---

## Step 1: Check & Compress Video

If video is over 500MB, compress it:
```bash
# FFmpeg compression (auto-install if needed: winget install --id Gyan.FFmpeg)
ffmpeg -i "input.mp4" -c:v libx264 -crf 23 -preset medium -c:a aac -b:a 128k "output.mp4"
```

Then upload to Late storage — see `late-social-media.md` → **Media Upload**.

---

## Step 2: Extract Transcript

Use any transcription method:
```bash
# If WhisperX or faster-whisper is available
python transcribe.py "VIDEO_PATH"
```

If no transcription tool is set up, ask the user for key talking points or watch the video yourself.

**Output needed:** Full transcript text + timestamps for chapter markers.

---

## Step 3: Create 5 Title Options

Based on transcript, create 5 titles following these patterns:

1. **How-to:** "How to [Outcome] in [Timeframe] ([Qualifier])"
2. **Curiosity:** "I [Did Something Unexpected] and [Result]"
3. **Direct benefit:** "[Outcome] with [Method/Tool]"
4. **Question:** "Can [Tool/Method] Really [Achieve Outcome]?"
5. **Statement:** "The [Adjective] Way to [Outcome]"

**Title rules:**
- 60 characters max (ideal for display)
- Front-load keywords
- Include power words: Free, New, Proven, Easy, Fast, Simple
- Add parenthetical qualifiers: (Full Demo), (Step-by-Step), (2026)

---

## Step 4: Research Tags

Tags should be **simple, short, and psychologically aligned** with how real people search.

### Tag Structure

| Category | Count | Example |
|----------|-------|---------|
| **Core topic** | 3-5 | "AI sales", "sales campaign" |
| **Outcome** | 2-3 | "get clients", "book appointments" |
| **Identity** | 2-3 | "agency owner", "entrepreneur" |
| **Tool/method** | 2-3 | "AI agent", "automation" |
| **Discovery** | 2-3 | "AI tools", "business growth" |

### Tag Rules
- Keep tags simple: 1-3 words each
- No filler words ("how to use", "best way to")
- No duplicating the title verbatim as a tag
- Prioritize words people actually type
- Total of all tags combined must be under 500 characters

### Late API Format
Tags are a **string array**:
```json
["AI sales", "sales campaign", "AI agent", "get clients", "agency owner"]
```

---

## Step 5: Create Description

**Structure (in order):**

1. **Lead CTA** (first 2 lines — visible before "Show more")
   ```
   [Hook sentence with value proposition]
   [LINK_URL]
   ```

2. **Quick Overview** (100-150 words)
   - Simple, digestible language
   - What they'll learn/see
   - Why it matters

3. **Social Links**
   ```
   My Links:
   Subscribe: YOUR_YOUTUBE_URL
   LinkedIn: YOUR_LINKEDIN_URL
   Instagram: YOUR_INSTAGRAM_URL
   ```

4. **Timestamps** (10-15 key sections)
   ```
   Timestamps:
   0:00 Introduction
   1:23 Setting up the system
   3:45 First results
   ```

5. **Hashtags** (3-5 at the end)
   ```
   #Keyword1 #Keyword2 #Keyword3
   ```

### Description Style Rules
- No em-dashes (use colons or periods instead)
- No emojis unless specifically requested
- Simple, conversational language
- Short paragraphs (2-3 sentences max)
- Blank lines between sections

---

## Step 6: Create First Comment CTA

Engagement-focused comment auto-posted after publish:
```
[Question or hook related to video topic]

[LINK_URL if applicable]

[Brief value statement + call to action]
```

---

## Step 7: ASK FOR THUMBNAIL (REQUIRED)

Ask the user:
1. Do you have a thumbnail ready to upload?
2. Or should I generate a thumbnail concept prompt?

**If user provides thumbnail:**
- Upload to Late storage and get URL
- Include in post

**If user wants a concept, provide this text-to-image prompt template:**
```
Clean minimalist YouTube thumbnail, [BACKGROUND_COLOR] background,
bold [TEXT_COLOR] sans-serif text on the left side reading "[LINE_1]"
with the word "[HIGHLIGHT_WORD]" in [ACCENT_COLOR] with subtle underline,
modern tech aesthetic, professional typography, high contrast, clean layout
with empty space on right side for logo placement, 1280x720 aspect ratio,
no gradients, flat design, editorial style
```

**Phrase guidelines for thumbnails:**
- 4-6 words maximum
- Benefit-focused (what they GET)
- Power words: Free, New, Easy, Fast, Automated, AI
- Avoid: "How to", "Tutorial", generic terms

---

## Step 8: Get Approval & Post

Show user the complete package:
1. Title (confirm selection)
2. Description preview
3. Tags list
4. First comment CTA
5. Thumbnail status

Then post via Late API — see `late-social-media.md` for the full curl command with YouTube-specific fields.

---

## Timestamp Creation Guidelines

From transcript/SRT file, consolidate into 10-15 meaningful sections:

1. **Group related content** — Don't list every topic change
2. **Use clear labels** — "Setting Up X" not "X Setup Process Begins"
3. **Round timestamps** — Use :00, :30 increments when possible
4. **Start with context** — First timestamp explains what video covers
5. **End with value** — Last timestamps highlight key outcomes
