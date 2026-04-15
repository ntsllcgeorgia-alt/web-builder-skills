# From Data to Report — Writing Ecommerce Audits That Don't Lie

Once you've pulled real API data, the report should be fact-based, not guesswork. Here's the template.

## The Structure

### 1. Executive Summary (1 page)
3 sentences max per section:
- **What they have** (facts from API)
- **What they're missing** (verified absences)
- **Biggest opportunity** (from facts, not guess)

### 2. Verified Facts Table
Every number has a source column.

| Metric | Value | Source |
|--------|-------|--------|
| Total products | 1,247 | API: `/catalog/products` pagination total |
| Total categories | 171 | API: `/catalog/categories` paginated |
| Top-level categories | 5 | API: categories where parent_id = 0 |
| Orders (last 30d) | 412 | API: `/orders?min_date=30d` |
| Revenue (last 30d) | $52,847 | Sum of `total_inc_tax` |
| Avg order value | $128.26 | Revenue / order count |

**Nothing without a source.**

### 3. Inventory Analysis (facts)
- Products with 0 inventory (exact count)
- Products below warning level (exact count)
- Products with no images (exact count — SEO issue)
- Products with no description (exact count)
- Dead inventory (0 sales in 90 days, from cross-reference)

### 4. Customer Analysis (facts)
- Total customers
- B2B customer groups count
- Top 10 customers by revenue (names + totals)
- New vs returning ratio (last 30d)
- Geographic distribution (top 5 states/countries)

### 5. Product Performance (facts)
- Top 10 best sellers by units (last 30d)
- Top 10 best sellers by revenue (last 30d)
- Categories by revenue contribution
- Products with zero sales in 90 days

### 6. Platform Usage (facts)
- Plan level (from /store endpoint)
- Currency, timezone
- Features enabled (multi-storefront, B2B Edition, etc.)
- Apps installed (if visible via API)

### 7. Gaps (verified absences)
Things clearly MISSING, not subjective:
- No abandoned cart recovery emails configured (check `/abandoned-carts` + marketing endpoints)
- No product reviews visible (check frontend + API)
- No customer reviews schema on pages (check source)
- No blog posts published (check `/blog/posts` count)
- Broken product images (check `/catalog/products/{id}/images` for each)

### 8. Recommendations (clearly opinion)
**Label this section clearly: "RECOMMENDATIONS (based on audit findings)"**

Structure each rec as:
- Observation (fact)
- Recommendation (opinion)
- Expected impact (with source)

Example:
> **Observation:** 412 orders in last 30 days, 0 abandoned cart emails sent (API shows no automation rules).
> **Recommendation:** Install abandoned cart recovery.
> **Expected impact:** 10-15% recovery rate per Baymard Institute research ([source](https://baymard.com/lists/cart-abandonment-rate)). Based on observed order volume and 70% avg cart abandonment rate, this could add ~$5,000-8,000/month revenue.

### 9. 30/60/90 Day Roadmap
Concrete actions with timelines and expected outcomes.

---

## Language Rules

### Words to avoid without data:
- "significantly" → "by X%"
- "major" → specify
- "best" → "highest-selling" (and show data)
- "top-tier" → name the tier
- "industry-leading" → cite benchmark

### Words to use:
- "Measured" / "Verified" / "Confirmed"
- "As of [date, pulled at HH:MM]"
- "Per [source]"
- "Estimate based on [X] — actual may differ"

---

## The Source Line

Every section should end with a source line:

> **Source:** BigCommerce API `/v2/orders`, pulled 2026-04-15 at 14:23 UTC. Time range: 2026-03-16 to 2026-04-15.

This makes the data auditable. If the client questions a number, you can reproduce it.

---

## Red Flags in Your Own Reports

Review your draft and flag yourself if you wrote:
- "probably" / "likely" / "approximately" without a range
- Revenue numbers without the time period
- Growth % without the baseline
- Comparisons without the comparison set
- "Industry average" without a link

Rewrite each of those until they're defensible.

---

## Example: Bad vs Good

### Bad (my earlier mistake)
> "The Enterprise plan runs $15k-30k annually."

Problems:
- No source
- Wrong range (Enterprise can go higher or lower)
- Doesn't explain it's GMV-based
- Implies I know their contract (I don't)

### Good
> "The store is on BigCommerce's Enterprise plan (per API `/v2/store` response, `plan_name: 'Enterprise Store Base Yearly'`). BigCommerce does not publish Enterprise pricing — it's custom-quoted by annual GMV ([source](https://www.bigcommerce.com/enterprise-pricing/)). Third-party estimates put mid-market Enterprise at $1,500-3,000/month ($18k-36k/year), with larger accounts exceeding $10k/month ([Swell analysis](https://www.swell.is/content/bigcommerce-enterprise-pricing)). To estimate this store's actual cost, I'd need to pull 12 months of order data to calculate GMV."

Longer? Yes. Defensible? Yes. That's the tradeoff.
