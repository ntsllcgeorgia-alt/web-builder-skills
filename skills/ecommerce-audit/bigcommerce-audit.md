# BigCommerce API Audit — Full Workflow

Complete protocol for auditing any BigCommerce store. Pull real data. Report verified facts only.

## Prerequisites

- Store hash (`neapcqvhn2` style) — find in CDN URL `cdn11.bigcommerce.com/s-{HASH}/`
- Client ID + Client Secret + Access Token (from Settings → API Accounts → Create API Account)
- Recommended scopes for audit: **all read-only scopes** on Orders, Products, Customers, Information, Content, Sites, Checkout

## API Base URLs

```
v3: https://api.bigcommerce.com/stores/{STORE_HASH}/v3
v2: https://api.bigcommerce.com/stores/{STORE_HASH}/v2
```

v3 is preferred. v2 still used for Orders (more complete data on v2).

## Auth Header (every request)

```
X-Auth-Token: {ACCESS_TOKEN}
Content-Type: application/json
Accept: application/json
```

## Rate Limits

BigCommerce Enterprise: **450 API calls per 30 seconds**. If you hit the limit, you get a `429` response with a `X-Rate-Limit-Time-Reset-Ms` header telling you how long to wait.

Plus plan/Standard: **25,000/hour**. Lower plans have tighter limits.

Always inspect response headers: `X-Rate-Limit-Requests-Left` tells you remaining budget.

---

## Phase 1: Store Verification

**First API call should always be this — it tells you who you're connected to:**

```bash
curl -s "https://api.bigcommerce.com/stores/{STORE_HASH}/v2/store" \
  -H "X-Auth-Token: {ACCESS_TOKEN}"
```

**Returns:**
```json
{
  "name": "Store Name",
  "domain": "www.example.com",
  "plan_name": "Enterprise Store Base Yearly",
  "country": "United States",
  "currency": "USD",
  "timezone": {"name": "America/Chicago"},
  "status": "live",
  "order_email": "orders@example.com",
  "features": { ... }
}
```

**What to record:**
- Plan name (tells you tier — Standard, Plus, Pro, Enterprise)
- Currency, timezone, country
- Active features (multi-storefront, B2B Edition, etc.)

---

## Phase 2: Categories

```bash
curl -s "https://api.bigcommerce.com/stores/{STORE_HASH}/v3/catalog/categories?limit=250&page=1" \
  -H "X-Auth-Token: {ACCESS_TOKEN}"
```

**Paginate through all pages.** Response includes `meta.pagination.total_pages`.

**What to extract:**
- Total category count
- Tree depth (max parent chain length)
- Visible vs hidden categories
- Top-level count
- Subcategory count per top-level
- Empty categories (no products assigned)

## Phase 3: Products

```bash
# Count total products
curl -s "https://api.bigcommerce.com/stores/{STORE_HASH}/v3/catalog/products?limit=1&page=1" \
  -H "X-Auth-Token: {ACCESS_TOKEN}" | jq '.meta.pagination.total'

# Pull all products (paginate)
curl -s "https://api.bigcommerce.com/stores/{STORE_HASH}/v3/catalog/products?limit=250&page={PAGE}&include=variants,images,custom_fields" \
  -H "X-Auth-Token: {ACCESS_TOKEN}"
```

**What to extract:**
- Total product count
- Visible vs hidden
- In stock vs out of stock
- Products with images vs without (SEO red flag)
- Products with descriptions vs without
- Inventory tracking on/off ratio
- Variants count (products with 10+ variants = SKU bloat risk)
- Categories per product (avg)

## Phase 4: Orders

**Use v2 for orders — more complete data.**

```bash
# Last 30 days
curl -s "https://api.bigcommerce.com/stores/{STORE_HASH}/v2/orders?limit=250&sort=date_created:desc&min_date_created=2025-03-01T00:00:00Z" \
  -H "X-Auth-Token: {ACCESS_TOKEN}"
```

**Status IDs to filter:**
- 0: Incomplete
- 1: Pending
- 2: Shipped
- 3: Partially Shipped
- 4: Refunded
- 5: Cancelled
- 6: Declined
- 7: Awaiting Payment
- 8: Awaiting Pickup
- 9: Awaiting Shipment
- 10: Completed
- 11: Awaiting Fulfillment
- 12: Manual Verification Required
- 13: Disputed
- 14: Partially Refunded

**What to extract:**
- Orders per day/week/month
- Revenue per period (`total_inc_tax`)
- Average order value
- Top customers by revenue (`customer_id` totals)
- Payment methods breakdown
- Channel (online, POS, API) — tells you B2B vs retail
- Coupon usage
- Discount totals
- Refund rate (status 4 / total)
- Abandoned cart ratio (need to cross-ref with carts endpoint)

### Order line items (per order)

```bash
curl -s "https://api.bigcommerce.com/stores/{STORE_HASH}/v2/orders/{ORDER_ID}/products" \
  -H "X-Auth-Token: {ACCESS_TOKEN}"
```

Gets you product-level data per order → use to calculate best sellers, units sold, etc.

## Phase 5: Customers

```bash
curl -s "https://api.bigcommerce.com/stores/{STORE_HASH}/v3/customers?limit=250&page=1&include=addresses,attributes" \
  -H "X-Auth-Token: {ACCESS_TOKEN}"
```

**What to extract:**
- Total customers
- Customer groups (B2B dealer vs retail)
- New vs returning ratio
- Geographic distribution
- Customer lifetime value
- Companies vs individuals (B2B %)

## Phase 6: Inventory

**Inventory is on the product response:**

```json
{
  "id": 1234,
  "inventory_tracking": "product",
  "inventory_level": 25,
  "inventory_warning_level": 10,
  ...
}
```

**What to flag:**
- Out of stock (`inventory_level == 0` on tracked products)
- Low stock (below `inventory_warning_level` or < 10)
- Dead inventory (0 sales in 90+ days — cross-ref with order line items)
- Over-stocked (high level + low velocity)

## Phase 7: Marketing / Other

### Coupons / Promotions
```bash
curl -s "https://api.bigcommerce.com/stores/{STORE_HASH}/v2/coupons" \
  -H "X-Auth-Token: {ACCESS_TOKEN}"
```

### Abandoned Carts
```bash
curl -s "https://api.bigcommerce.com/stores/{STORE_HASH}/v3/abandoned-carts" \
  -H "X-Auth-Token: {ACCESS_TOKEN}"
```

### Active Widgets / Pages
```bash
curl -s "https://api.bigcommerce.com/stores/{STORE_HASH}/v3/content/pages" \
  -H "X-Auth-Token: {ACCESS_TOKEN}"
```

### Blog Posts
```bash
curl -s "https://api.bigcommerce.com/stores/{STORE_HASH}/v2/blog/posts" \
  -H "X-Auth-Token: {ACCESS_TOKEN}"
```

---

## Phase 8: Report the Facts

### ALWAYS SEPARATE FACTS FROM OPINIONS

**Facts (verified from API):**
- "Store has 171 categories (166 subcategories)"
- "1,247 products, 123 out of stock"
- "42 orders in last 24h totaling $8,492"

**Opinions/recommendations (mark clearly):**
- "We recommend consolidating duplicate categories..."
- "Consider adding abandoned cart recovery..."

### What NOT to do

- **Don't guess pricing.** BigCommerce Enterprise is custom-quoted by GMV. Without seeing their invoice, you don't know. Say "custom-quoted, depends on GMV."
- **Don't estimate traffic.** You can't see Google Analytics from the API. Don't pretend you can.
- **Don't estimate profit margins.** You see revenue, not COGS.
- **Don't claim industry benchmarks without a source.** "10-15% abandoned cart recovery" needs a citation.

### BigCommerce Enterprise Pricing (actual facts)

Per BigCommerce's official pricing page: **pricing is custom-quoted based on GMV.** No published tiers.

Per industry analysis (see pricing-research.md):
- Mid-market start: ~$1,000-2,000/month
- Typical mid-market: $1,500-3,000/month
- $1M GMV store: ~$3,166/month per BigCommerce's own calculator
- High-volume enterprise (>$10M GMV): can exceed $10,000/month

**For a specific store, you can only estimate the real cost by pulling their annual revenue and matching to the GMV bracket.** Always cite the source.

---

## Python Client Template

See the existing `bc_client.py` in any audit project for a working implementation that handles:
- Pagination
- Rate limit backoff
- Error handling
- All the endpoints above

Template location: `D:\Projects\national-truck-parts\scripts\bc_client.py`
