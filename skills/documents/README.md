# Documents & Data Skill Pack

Templates for the everyday documents real businesses need: cold emails, invoices, spreadsheets, contracts.

## What's in here

- `cold-email-sequences.md` — proven outreach sequences (sales, partnership, hiring)
- `excel-cookbook.md` — formulas + chart recipes for common business needs (P&L, finance tracker, lead pipeline)
- `invoice-template.md` — professional invoice template + how to generate as PDF
- `email-templates.md` — common business emails (proposal follow-up, missed-meeting, refund request, etc.)

## How Claude should use this

When the user asks for any document:

1. **Pick the closest template.**
2. **Ask for the specifics in ONE message** (don't drip questions). Example: "I'll draft this — give me the recipient name, what they do, what you're offering, and the action you want them to take."
3. **Output a finished, ready-to-send document.** Not a draft skeleton. Real names, real numbers, ready to copy-paste.
4. **For Excel:** Use Python with `openpyxl` to write `.xlsx` files with real formulas and formatting.
5. **For invoices/contracts:** Output as Markdown OR generate a PDF using `reportlab` or by converting Markdown via pandoc.

## Quality bar

- **Cold emails:** under 80 words, one CTA, never starts with "I hope this email finds you well."
- **Spreadsheets:** include headers in bold, freeze top row, use real formulas (not hardcoded values), add basic conditional formatting.
- **Invoices:** include all 9 standard fields (logo/brand, invoice #, date, due date, bill-to, line items, subtotal, tax, total). Match the user's brand colors if they have any.
- **Contracts:** Claude is not a lawyer. ALWAYS include a line at the top: *"This is a draft. Have a lawyer review before sending."*
