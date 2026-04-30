# Business & Branding Skill Pack

Templates for everything you need to start, pitch, or rebrand a business.

## What's in here

- `business-plan.md` — full one-page business plan template (the kind investors actually read)
- `pitch-deck.md` — 10-slide investor deck structure used by YC and a16z founders
- `brand-identity.md` — brand voice, colors, typography, logo brief
- `market-research.md` — competitor + market sizing template

## How Claude should use this

When the user says "I want to start a {{thing}}" or "build me a {{business document}}":

1. **Ask 3 questions max:** What does the business do? Who's the customer? What's the goal (raise, launch, market)?
2. **Pick the right template** based on the goal:
   - Validating an idea → `business-plan.md`
   - Raising money → `pitch-deck.md`
   - Launching → `brand-identity.md` + name/logo concepts
   - Researching a space → `market-research.md`
3. **Fill in the template** with the user's specifics — make assumptions if they don't know an answer, mark them as `[ASSUMPTION]` so they can correct.
4. **Output as a real document** — `.md` they can read, `.docx` if they need it polished, `.pptx` for the pitch deck.

## Generating a business idea (when asked "give me ideas")

When the user wants ideas, Claude follows this rubric:

1. Ask their **skills, capital, time available, and target income**.
2. Generate **5 ideas** in this format:
   - **Name** (1-2 word brand)
   - **What it is** (1 sentence)
   - **Customer** (who pays)
   - **Revenue model** (how it makes money)
   - **Startup cost** ($ range)
   - **Time to first $** (realistic, weeks/months)
   - **Why this beats the obvious version**
3. Rank by best fit for *their* situation, not generic.

## Quality bar

- No generic AI slop ("In today's fast-paced world..."). Cut it.
- Every claim has a number behind it (price, count, percentage).
- Every section answers "so what?" — would a busy investor / customer keep reading?
- Cliche-free language. If it sounds like a LinkedIn motivation post, rewrite.
