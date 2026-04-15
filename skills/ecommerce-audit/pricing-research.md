# Pricing Research — How to Find Real Platform Costs

The #1 mistake in ecommerce audits is making up prices. Here's how to research actual costs with sources.

## The Rule

**Every pricing claim needs a citation.** If you can't link to a source, don't claim a number.

Bad: "BigCommerce Enterprise is $15k-30k/year"
Good: "BigCommerce Enterprise is custom-quoted by GMV. Third-party estimates range from $1,500-3,000/month for mid-market ($18k-36k/year). Source: [Swell pricing guide](https://www.swell.is/content/bigcommerce-enterprise-pricing)"

## Platform Pricing (verified as of 2026)

### BigCommerce
- **Standard:** $39/mo — up to $50k/year in online sales
- **Plus:** $105/mo — up to $180k/year in sales
- **Pro:** $399/mo — up to $400k/year in sales
- **Enterprise:** Custom quote based on GMV
  - Start: ~$1,000-2,000/month (smaller enterprise)
  - Mid-market typical: $1,500-3,000/month
  - $1M GMV store: ~$3,166/month (per BigCommerce's own TCO calculator)
  - No published cap; high-volume can be $10k+/month

**Sources:**
- [BigCommerce official pricing](https://www.bigcommerce.com/pricing/)
- [BigCommerce Enterprise FAQ](https://www.bigcommerce.com/enterprise-pricing/)
- [Swell pricing analysis](https://www.swell.is/content/bigcommerce-enterprise-pricing)

### Shopify
- **Basic:** $39/mo
- **Shopify:** $105/mo
- **Advanced:** $399/mo
- **Shopify Plus:** Starts at $2,300/mo ($27,600/year) — often higher with custom features

**Sources:**
- [Shopify pricing page](https://www.shopify.com/pricing)
- [Shopify Plus pricing](https://www.shopify.com/plus/pricing)

### Shopify Plus transaction fees
Same as regular tiers BUT 0.15% fee if NOT using Shopify Payments

### WooCommerce
- **Software:** FREE (open source)
- **Real costs:**
  - Hosting: $10-500/mo (SiteGround, Kinsta, WPEngine)
  - SSL: $0-200/year (free with Let's Encrypt)
  - Premium theme: $60-200 one-time
  - Essential plugins: $500-2,000/year combined
  - Developer: $5k-50k for setup, $100-200/hr ongoing
  - **Total:** $1,000-10,000+/year realistic

**Sources:**
- [WooCommerce official](https://woocommerce.com/pricing/)
- [WPEngine eCommerce pricing](https://wpengine.com/plans/ecommerce/)

### Magento / Adobe Commerce
- **Magento Open Source:** FREE
- **Adobe Commerce (Cloud):** $22k-125k+/year based on GMV
  - Tier 1 (~$0-1M GMV): starts ~$22k/year
  - Tier 2 (~$1M-5M): ~$32k-65k/year
  - Tier 3 (~$5M-25M): ~$65k-125k/year
  - Enterprise: $125k+/year

**Sources:**
- [Adobe Commerce pricing (quoted)](https://business.adobe.com/products/magento/magento-commerce.html)

---

## How to Actually Research Pricing

### Step 1: Check the platform's official pricing page
Even if they say "custom quote", they often publish base tiers.

### Step 2: Look for published tier calculators
Some platforms have public cost calculators. BigCommerce has a TCO calculator that estimates real costs.

### Step 3: Search third-party analyses (dated within past 12 months)
Analysts and agencies publish pricing breakdowns. Filter results by recency.

### Step 4: Check G2, Capterra reviews
Users often mention what they pay in reviews.

### Step 5: Check the Wayback Machine
Pricing pages change. Archive.org often preserves old pricing if you need historical data.

### Step 6: Still unknown? Say so.
If you can't verify a number, say: "This is custom-quoted. Without seeing their contract, I can't state the cost. If you share an invoice, I can verify."

---

## Hidden Costs Every Audit Should Flag

Beyond the platform subscription:

1. **Payment processor fees** — typically 2.9% + $0.30 per transaction (Stripe, PayPal, Square)
2. **Additional transaction fees** — some platforms charge extra if you don't use their payment gateway
3. **SSL certificates** — if not included
4. **Theme licenses** — $200-500+ for premium themes
5. **App/plugin subscriptions** — can easily hit $500-2,000/month stacked
6. **Email platform** — Klaviyo, Mailchimp: $20-2,000+/month based on list size
7. **Shipping platform** — ShipStation, EasyShip: $10-200/month
8. **Tax compliance** — Avalara, TaxJar: $200-1,000+/month
9. **Hosting add-ons** — for WooCommerce/Magento, enterprise hosting can be $500-5,000/month
10. **Development/support retainer** — often $2,000-10,000/month

**When auditing, sum these up for true cost of ownership.**

---

## BigCommerce Annual Revenue → Plan Estimate

To guess the plan a store is on without seeing their contract, back-calculate from orders:

```python
# From API: pull 12 months of orders
annual_revenue = sum(order['total_inc_tax'] for order in orders_last_12m)

# Match to published plan GMV caps:
if annual_revenue < 50_000:
    plan = "Standard ($39/mo = $468/yr)"
elif annual_revenue < 180_000:
    plan = "Plus ($105/mo = $1,260/yr)"
elif annual_revenue < 400_000:
    plan = "Pro ($399/mo = $4,788/yr)"
else:
    plan = f"Enterprise (custom — est. ${estimate_enterprise(annual_revenue):,.0f}/yr)"

def estimate_enterprise(gmv):
    # Rough mapping based on BigCommerce's public TCO calculator
    if gmv < 1_000_000:    return 24_000    # ~$2k/mo
    if gmv < 5_000_000:    return 38_000    # ~$3.2k/mo
    if gmv < 10_000_000:   return 60_000    # ~$5k/mo
    if gmv < 25_000_000:   return 90_000    # ~$7.5k/mo
    return 120_000                           # $10k+/mo
```

**Important:** These are estimates, not contracts. Always frame as "estimated based on GMV."

---

## Quick Reference Card

| Platform | Self-Serve Tier | Enterprise | Notes |
|----------|-----------------|------------|-------|
| BigCommerce | $39-399/mo | $1k-10k+/mo | Custom quote, GMV-tied |
| Shopify | $39-399/mo | $2,300+/mo | Plus plan adds features |
| WooCommerce | Free software | $500-5k/mo hosting + dev | Real cost is plugins + hosting |
| Magento Commerce | N/A | $22k-125k+/yr | Quoted by Adobe |
| Squarespace Commerce | $16-52/mo | N/A | Limited enterprise |
| Wix Stores | $17-49/mo | N/A | No enterprise tier |
| Salesforce Commerce | N/A | $150k+/yr | Enterprise-only |
| SAP Commerce | N/A | $250k+/yr | Enterprise-only |
