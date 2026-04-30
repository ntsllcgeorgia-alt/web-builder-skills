# Invoice Template

Professional invoice in markdown format. Claude can also output this as a styled PDF using `reportlab` or by converting via pandoc.

---

```
┌────────────────────────────────────────────────────────────┐
│  {{YOUR_BRAND}}                              INVOICE       │
│  {{Your address line 1}}                                   │
│  {{Your address line 2}}                     # {{INV-001}} │
│  {{Your email}} · {{Your phone}}                           │
└────────────────────────────────────────────────────────────┘

Bill to:                              Issue date:   {{YYYY-MM-DD}}
{{Client name}}                        Due date:     {{YYYY-MM-DD}}
{{Client company}}                     Terms:        Net 15
{{Client address}}                     PO #:         {{ref or blank}}
{{Client email}}


┌─────────────────────────────────────────────────────────────────┐
│ #  Description                          Qty    Rate    Amount   │
├─────────────────────────────────────────────────────────────────┤
│ 1  {{Line item}}                         {{n}}  ${{rate}}  ${{}} │
│ 2  {{Line item}}                         {{n}}  ${{rate}}  ${{}} │
│ 3  {{Line item}}                         {{n}}  ${{rate}}  ${{}} │
└─────────────────────────────────────────────────────────────────┘

                                                Subtotal:  ${{}}
                                                Tax ({{%}}): ${{}}
                                                ─────────────────
                                                TOTAL:     ${{}}


PAYMENT METHODS
- Bank transfer:    {{Bank}} · Acct {{****1234}} · Routing {{**6789}}
- Stripe / Card:    {{stripe.com/pay/yourlink}}
- Zelle:            {{phone or email}}
- PayPal:           {{paypal.me/yourname}}

Notes / Terms:
{{Optional - thank you, late fee terms, project notes}}

Questions? {{your email}} · {{your phone}}
```

---

## How to generate as a PDF

```python
# pip install reportlab

from reportlab.lib.pagesizes import letter
from reportlab.lib.styles import getSampleStyleSheet
from reportlab.platypus import SimpleDocTemplate, Table, TableStyle, Paragraph, Spacer
from reportlab.lib import colors

doc = SimpleDocTemplate("invoice.pdf", pagesize=letter, topMargin=40, bottomMargin=40)
styles = getSampleStyleSheet()
story = []

# Header
story.append(Paragraph("<b>YOUR BRAND</b>", styles["Title"]))
story.append(Paragraph("INVOICE #INV-001", styles["Heading2"]))
story.append(Spacer(1, 20))

# Bill to / dates
info = [["Bill to:", "Issue date: 2026-04-30"],
        ["Client Name", "Due date: 2026-05-15"],
        ["Client Co.", "Terms: Net 15"]]
t = Table(info, colWidths=[280, 200])
story.append(t)
story.append(Spacer(1, 30))

# Line items
items = [["#", "Description", "Qty", "Rate", "Amount"],
         ["1", "Website design", "1", "$2,500", "$2,500"],
         ["2", "Logo concepts (3)", "1", "$500", "$500"]]
t = Table(items, colWidths=[30, 250, 60, 70, 70])
t.setStyle(TableStyle([
    ("BACKGROUND", (0,0), (-1,0), colors.black),
    ("TEXTCOLOR", (0,0), (-1,0), colors.white),
    ("FONTNAME", (0,0), (-1,0), "Helvetica-Bold"),
    ("GRID", (0,0), (-1,-1), 0.5, colors.grey),
    ("ALIGN", (2,1), (-1,-1), "RIGHT"),
]))
story.append(t)

# Total
story.append(Spacer(1, 20))
story.append(Paragraph("<b>Total: $3,000</b>", styles["Heading2"]))

doc.build(story)
```

## Brand customization

If the user has brand colors / a logo:
- Replace the black header with their primary color (`colors.HexColor("#E63946")`)
- Add their logo at the top via `Image("logo.png", width=120, height=40)`
- Use their brand font if it's a system-installed TTF

## Best practices

- **Number invoices sequentially.** `INV-001`, `INV-002`. No gaps, no random IDs.
- **Net 15 by default.** Net 30 for enterprise clients only — you're financing them otherwise.
- **Late fee clause:** "1.5% per month on overdue balances" — even if you never enforce it, it makes prompt payment standard.
- **Payment methods first, in order of cheapest to you:** bank transfer (free) > Zelle (free) > Stripe (~3%) > PayPal (~3.5%).
- **Send the PDF as an attachment**, with a 2-line email body. Body says: "Invoice attached for {{project}}. Total ${{X}}, due {{date}}. Thanks — {{name}}."
