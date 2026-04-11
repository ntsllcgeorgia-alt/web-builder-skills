# GitHub Actions — Automated Tasks

GitHub Actions lets you run scripts automatically on a schedule or when code is pushed. Free for public repos.

## Auto News Updater (Fetch & Display Latest News)

This fetches news from Google RSS and updates your website automatically.

### 1. Create the update script

Create `scripts/update_news.py`:
```python
import urllib.request
import xml.etree.ElementTree as ET
import re
import html
import os

# Search query — customize this
QUERY = "your search term"
RSS_URL = f"https://news.google.com/rss/search?q={QUERY.replace(' ', '+')}&hl=en-US&gl=US&ceid=US:en"

def fetch_news(max_articles=6):
    req = urllib.request.Request(RSS_URL, headers={'User-Agent': 'Mozilla/5.0'})
    with urllib.request.urlopen(req, timeout=15) as resp:
        data = resp.read()
    root = ET.fromstring(data)
    articles = []
    for item in root.findall('.//item')[:max_articles]:
        title = html.unescape(item.find('title').text or '')
        link = item.find('link').text or ''
        pub_date = item.find('pubDate').text or ''
        # Extract source from title (Google News format: "Title - Source")
        source = title.rsplit(' - ', 1)[-1] if ' - ' in title else 'News'
        clean_title = title.rsplit(' - ', 1)[0] if ' - ' in title else title
        articles.append({'title': clean_title, 'link': link, 'source': source, 'date': pub_date})
    return articles

def update_html(articles):
    html_path = os.path.join(os.path.dirname(os.path.dirname(__file__)), 'index.html')
    with open(html_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Build ticker HTML
    ticker_items = ' &nbsp;&nbsp;|&nbsp;&nbsp; '.join(
        f'<a href="{a["link"]}" target="_blank" style="color:#00cec9;">{a["title"]}</a> ({a["source"]})'
        for a in articles[:4]
    )
    
    # Replace ticker content between markers
    content = re.sub(
        r'(<!--NEWS-TICKER-START-->).*?(<!--NEWS-TICKER-END-->)',
        f'\\1{ticker_items}\\2',
        content, flags=re.DOTALL
    )
    
    with open(html_path, 'w', encoding='utf-8') as f:
        f.write(content)
    print(f"Updated {len(articles)} articles")

if __name__ == '__main__':
    articles = fetch_news()
    if articles:
        update_html(articles)
```

### 2. Add markers in your HTML

In your `index.html`, add these comment markers where the news should appear:
```html
<div class="news-ticker">
  <!--NEWS-TICKER-START-->Breaking news will appear here automatically<!--NEWS-TICKER-END-->
</div>
```

### 3. Create the GitHub Action

Create `.github/workflows/update-news.yml`:
```yaml
name: Update News
on:
  schedule:
    - cron: '0 */6 * * *'  # Every 6 hours
  workflow_dispatch:        # Manual trigger button

permissions:
  contents: write

jobs:
  update:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - uses: actions/setup-python@v5
        with:
          python-version: '3.12'
      
      - name: Run news updater
        run: python scripts/update_news.py
      
      - name: Commit changes
        run: |
          git config user.name "github-actions[bot]"
          git config user.email "github-actions[bot]@users.noreply.github.com"
          git add -A
          git diff --staged --quiet || git commit -m "Auto-update news ticker"
          git push
```

### 4. Enable the Action
- Push the workflow file to GitHub
- Go to repo → Actions tab → the workflow should appear
- Click "Run workflow" to test it manually
- After that, it runs every 6 hours automatically

## Scheduled Content Updates

Same pattern works for any automated update:

### Auto-Update a Counter/Timer
```yaml
name: Update Counter
on:
  schedule:
    - cron: '0 0 * * *'  # Daily at midnight
  workflow_dispatch:

permissions:
  contents: write

jobs:
  update:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: '3.12'
      - name: Update counter
        run: python scripts/update_counter.py
      - name: Commit
        run: |
          git config user.name "github-actions[bot]"
          git config user.email "github-actions[bot]@users.noreply.github.com"
          git add -A
          git diff --staged --quiet || git commit -m "Auto-update counter"
          git push
```

## Cron Schedule Cheat Sheet

```
┌───────── minute (0-59)
│ ┌─────── hour (0-23)
│ │ ┌───── day of month (1-31)
│ │ │ ┌─── month (1-12)
│ │ │ │ ┌─ day of week (0-6, Sun=0)
│ │ │ │ │
* * * * *

Examples:
'0 */6 * * *'    — Every 6 hours
'0 0 * * *'      — Daily at midnight UTC
'0 */2 * * *'    — Every 2 hours
'30 9 * * 1-5'   — Weekdays at 9:30 AM UTC
'0 0 * * 0'      — Weekly on Sunday
'0 0 1 * *'      — Monthly on the 1st
```

## Important Notes

- GitHub Actions are **free** for public repos
- Scripts run on GitHub's servers (Ubuntu), not your computer
- The `workflow_dispatch` trigger adds a manual "Run" button in the Actions tab
- `permissions: contents: write` is required for the bot to commit changes
- Python scripts should use only standard library (no pip installs needed for basic tasks)
- If you need pip packages, add a step: `run: pip install package-name`
