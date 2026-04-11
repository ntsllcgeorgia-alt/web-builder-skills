# Late Social Media Posting

Post and schedule content to 13 social media platforms using the Late API.

## Supported Platforms

Twitter/X, Instagram, LinkedIn, TikTok, YouTube, Facebook, Pinterest, Reddit, Threads, Bluesky, Google Business, Telegram, Snapchat

---

## First-Time Setup

### 1. Create a Late Account
Go to **https://getlate.dev** and sign up (free tier available).

### 2. Get Your API Key
Late → Settings → API Keys → Create new key.

Save your key somewhere safe. You'll use it like this:
```
Authorization: Bearer YOUR_API_KEY_HERE
```

### 3. Connect Your Social Accounts
In Late dashboard, connect each platform you want to post to. Each connected account gets an **Account ID**.

### 4. Find Your Account IDs
Run this to see all connected accounts:
```bash
curl -s "https://getlate.dev/api/v1/accounts" \
  -H "Authorization: Bearer YOUR_API_KEY_HERE" | python -m json.tool
```

Or if using Late MCP in Claude:
```
mcp__late__accounts_list
```

Fill in this table with your info:

| Platform | Username | Account ID |
|----------|----------|------------|
| YouTube | | |
| Instagram | | |
| TikTok | | |
| Twitter/X | | |
| LinkedIn | | |
| Facebook | | |

> **Keep this updated** — Claude references it when posting.

---

## CRITICAL: Pre-Post Requirements

Before posting ANY content, you MUST:

1. **Ask for thumbnail** (for YouTube/video content)
2. **Confirm title** with user
3. **Show content package** for review
4. **Get explicit approval** to post

**Never post without user confirmation.**

---

## Posting Workflow

### Step 1: Prepare Content

For each platform, prepare the required fields:

| Platform | Required | Optional |
|----------|----------|----------|
| YouTube | title, content (description), media_url | tags, firstComment |
| LinkedIn | content | media_urls |
| Twitter | content | media_urls |
| Instagram | content, media_url | firstComment, thumbOffset |
| TikTok | content, media_url | privacy_level, cover timestamp |

### Step 2: Ask User for Missing Items

**Always ask for:**
- Thumbnail image (YouTube/video posts)
- Confirmation of title
- Any edits to description/content

### Step 3: Post via Late API

**For YouTube with full features (title, tags, firstComment):**

```bash
curl -s -X POST "https://getlate.dev/api/v1/posts" \
  -H "Authorization: Bearer YOUR_API_KEY_HERE" \
  -H "Content-Type: application/json" \
  -d '{
    "content": "[DESCRIPTION]",
    "mediaItems": [{"url": "[VIDEO_URL]", "type": "video"}],
    "platforms": [{
      "platform": "youtube",
      "accountId": "YOUR_YOUTUBE_ACCOUNT_ID",
      "platformSpecificData": {
        "title": "[VIDEO_TITLE]",
        "visibility": "public",
        "tags": "tag1, tag2, tag3",
        "firstComment": "[FIRST_COMMENT_CTA]"
      }
    }],
    "publishNow": true
  }'
```

**For LinkedIn:**

```bash
curl -s -X POST "https://getlate.dev/api/v1/posts" \
  -H "Authorization: Bearer YOUR_API_KEY_HERE" \
  -H "Content-Type: application/json" \
  -d '{
    "content": "[POST_CONTENT]",
    "platforms": [{
      "platform": "linkedin",
      "accountId": "YOUR_LINKEDIN_ACCOUNT_ID"
    }],
    "publishNow": true
  }'
```

**Or use MCP tools for simple posts:**

```
mcp__late__posts_create with:
- content: [POST_CONTENT]
- platform: youtube / linkedin / twitter
- title: [TITLE] (for YouTube)
- media_urls: [URL] (comma-separated)
- publish_now: true / is_draft: true / schedule_minutes: X
```

---

## YouTube-Specific Fields

When posting to YouTube via REST API, use `platformSpecificData`:

| Field | Description |
|-------|-------------|
| title | Video title (required) |
| visibility | public, private, or unlisted |
| tags | Comma-separated keywords |
| firstComment | Auto-posted comment after publish |
| categoryId | "28" Science&Tech, "22" People&Blogs, "26" Howto&Style, "27" Education |

---

## Media Upload

### Option 1: Already have URL
Use the URL directly in `media_urls` or `mediaItems`.

### Option 2: Need to upload file

1. Get presigned URL:
```bash
curl -s -X POST "https://getlate.dev/api/v1/media/presign" \
  -H "Authorization: Bearer YOUR_API_KEY_HERE" \
  -H "Content-Type: application/json" \
  -d '{"filename": "file.mp4", "contentType": "video/mp4"}'
```

2. Upload file to presigned URL:
```bash
curl -X PUT "[UPLOAD_URL_FROM_STEP_1]" \
  -H "Content-Type: video/mp4" \
  --upload-file "[FILE_PATH]"
```

3. Use the `publicUrl` from step 1 in your post.

---

## Scheduling

| Mode | Parameter |
|------|-----------|
| Publish now | `"publishNow": true` |
| Draft | `"isDraft": true` |
| Schedule | `"scheduledFor": "2026-01-28T15:00:00Z"` |

---

## Twitter/X Threads (Multi-Tweet)

Use `threadItems` in `platformSpecificData`:

```bash
curl -s -X POST "https://getlate.dev/api/v1/posts" \
  -H "Authorization: Bearer YOUR_API_KEY_HERE" \
  -H "Content-Type: application/json" \
  -d '{
    "content": "FIRST_TWEET_TEXT",
    "platforms": [{
      "platform": "twitter",
      "accountId": "YOUR_TWITTER_ACCOUNT_ID",
      "platformSpecificData": {
        "threadItems": [
          {"content": "FIRST_TWEET_TEXT"},
          {"content": "SECOND_TWEET_TEXT"}
        ]
      }
    }],
    "publishNow": true
  }'
```

## Threads (Meta) Multi-Post

Same `threadItems` pattern:

```bash
curl -s -X POST "https://getlate.dev/api/v1/posts" \
  -H "Authorization: Bearer YOUR_API_KEY_HERE" \
  -H "Content-Type: application/json" \
  -d '{
    "content": "FIRST_POST_TEXT",
    "platforms": [{
      "platform": "threads",
      "accountId": "YOUR_THREADS_ACCOUNT_ID",
      "platformSpecificData": {
        "threadItems": [
          {"content": "FIRST_POST_TEXT"},
          {"content": "SECOND_POST_TEXT"},
          {"content": "THIRD_POST_TEXT"}
        ]
      }
    }],
    "publishNow": true
  }'
```

---

## Cross-Posting (Multiple Platforms at Once)

```bash
curl -s -X POST "https://getlate.dev/api/v1/posts" \
  -H "Authorization: Bearer YOUR_API_KEY_HERE" \
  -H "Content-Type: application/json" \
  -d '{
    "content": "[POST_CONTENT]",
    "platforms": [
      {"platform": "linkedin", "accountId": "YOUR_LINKEDIN_ACCOUNT_ID"},
      {"platform": "twitter", "accountId": "YOUR_TWITTER_ACCOUNT_ID"},
      {"platform": "youtube", "accountId": "YOUR_YOUTUBE_ACCOUNT_ID", "platformSpecificData": {"title": "[TITLE]"}}
    ],
    "publishNow": true
  }'
```

---

## Error Handling

| Error | Solution |
|-------|----------|
| "Account not found" | Verify account ID matches connected account |
| "Invalid media" | Check file size (<500MB for video) and format |
| "Rate limited" | Wait and retry |
| "Unauthorized" | Check API key is correct |

---

## Checklist Before Posting

- [ ] Content prepared and reviewed
- [ ] Title confirmed (YouTube)
- [ ] Tags formatted (YouTube)
- [ ] Thumbnail requested/confirmed (YouTube)
- [ ] First comment CTA ready (YouTube)
- [ ] User approved posting
