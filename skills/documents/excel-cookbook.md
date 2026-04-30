# Excel / Spreadsheet Cookbook

Formulas and recipes for spreadsheets people actually use in business. Claude generates these as `.xlsx` using Python `openpyxl`.

## How Claude builds an Excel file

```python
# Auto-install if missing
# pip install openpyxl

from openpyxl import Workbook
from openpyxl.styles import Font, PatternFill, Alignment, Border, Side
from openpyxl.utils import get_column_letter

wb = Workbook()
ws = wb.active
ws.title = "Sheet name"

# Headers
headers = ["Date", "Item", "Amount", "Category", "Notes"]
ws.append(headers)
for col_num, _ in enumerate(headers, 1):
    cell = ws.cell(row=1, column=col_num)
    cell.font = Font(bold=True, color="FFFFFF")
    cell.fill = PatternFill("solid", fgColor="1F2937")

# Freeze top row
ws.freeze_panes = "A2"

# Add data, formulas, etc.
ws.cell(row=10, column=3, value="=SUM(C2:C9)")

# Auto-width
for col in ws.columns:
    max_len = max(len(str(c.value)) for c in col if c.value)
    ws.column_dimensions[get_column_letter(col[0].column)].width = max_len + 2

wb.save("output.xlsx")
```

---

## Recipe 1: Personal Finance Tracker

**Sheets:** `Income` · `Expenses` · `Summary` · `Budget`

**Key formulas (in Summary sheet):**
```
Total Income     =SUM(Income!C:C)
Total Expenses   =SUM(Expenses!C:C)
Net              =B2-B3
Savings rate %   =B4/B2*100

By category:
=SUMIF(Expenses!D:D, "Food", Expenses!C:C)
=SUMIF(Expenses!D:D, "Rent", Expenses!C:C)
```

**Conditional formatting:**
- Green fill if Net > 0
- Red fill if any category > Budget
- Bar chart of expenses by category

---

## Recipe 2: Lead / Sales Pipeline

**Columns:** `Lead Name | Company | Stage | Value | Probability | Weighted Value | Last Touch | Next Step | Owner`

**Formulas:**
```
Weighted Value     =D2*E2/100
Total pipeline     =SUM(F:F)
By-stage pipeline  =SUMIF(C:C, "Demo", F:F)
Stale leads        =IF(TODAY()-G2 > 14, "STALE", "")
```

**Stage list (Data Validation):** `New, Contacted, Demo, Proposal, Negotiation, Closed Won, Closed Lost`

**Pivot table:** Pipeline value by stage and owner.

---

## Recipe 3: Profit & Loss (Monthly)

**Layout:**
```
                Jan   Feb   Mar   Apr   ...   Total
Revenue
  Product A    1000  1200  1500  ...
  Product B     500   600   700  ...
Total Revenue =SUM(B3:B4)

COGS
  Materials
  Shipping
Total COGS

Gross Profit = Revenue - COGS
Gross Margin % = Gross Profit / Revenue

Operating Expenses
  Rent
  Salaries
  Software
  Marketing
Total OpEx

Net Profit = Gross Profit - OpEx
```

---

## Recipe 4: Inventory Management

**Columns:** `SKU | Name | Cost | Price | Qty on Hand | Reorder Point | Value | Margin %`

**Formulas:**
```
Value           =C2*E2
Margin %        =(D2-C2)/D2*100
Reorder alert   =IF(E2<=F2, "REORDER NOW", "")
Total inventory =SUMPRODUCT(C:C, E:E)
```

---

## Recipe 5: Time Tracker

**Columns:** `Date | Project | Task | Start | End | Hours | Billable | Rate | Amount`

**Formulas:**
```
Hours           =(E2-D2)*24
Amount          =F2*H2
Billable hours  =SUMIF(G:G, "Yes", F:F)
Weekly total    =SUMIFS(F:F, A:A, ">="&A2-7, A:A, "<="&A2)
```

---

## Useful formulas to know

| Need | Formula |
|------|---------|
| Sum if condition | `=SUMIF(range, criteria, sum_range)` |
| Sum if multiple | `=SUMIFS(sum_range, range1, crit1, range2, crit2)` |
| Lookup | `=XLOOKUP(value, lookup_array, return_array)` |
| Count if | `=COUNTIF(range, criteria)` |
| If / else | `=IF(test, value_if_true, value_if_false)` |
| Days between | `=B1-A1` (with date format) |
| Today | `=TODAY()` |
| Concat with separator | `=TEXTJOIN(", ", TRUE, A1:A10)` |
| First N rows of unique | `=UNIQUE(A:A)` |
| Filter rows | `=FILTER(table, table[col]="value")` |
| Sort | `=SORT(range, sort_col, order)` |

---

## Charting essentials (openpyxl)

```python
from openpyxl.chart import LineChart, BarChart, PieChart, Reference

chart = LineChart()
chart.title = "Revenue over time"
data = Reference(ws, min_col=2, min_row=1, max_row=13, max_col=2)
cats = Reference(ws, min_col=1, min_row=2, max_row=13)
chart.add_data(data, titles_from_data=True)
chart.set_categories(cats)
ws.add_chart(chart, "E2")
```

Default to: line for time series, bar for category comparisons, pie ONLY for ≤5 slices that sum to 100%.
