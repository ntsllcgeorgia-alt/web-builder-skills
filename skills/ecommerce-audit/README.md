# Ecommerce Site API Audit

A step-by-step protocol for properly auditing any ecommerce website — identifying the platform, mapping the API, pulling real data, and delivering a strategy report based on **verified facts, not guesses**.

## The Core Rule

**Never state a number you didn't verify.** If you say "their plan costs $X/year", you better have a source. If you don't have a source, say "custom quoted — I can't know without seeing their contract."

This skill exists because guessing pricing, traffic, or volume numbers makes the entire audit worthless.

---

## The 5-Phase Audit Protocol

### Phase 1: Platform Identification (5 min)
Figure out what they're running BEFORE asking for credentials.

### Phase 2: Surface Scan (10 min)
What's visible from the outside — no login required.

### Phase 3: API Connection (5 min)
Verify the credentials work. Pull store info.

### Phase 4: Data Pull (30-60 min)
Pull the real numbers: orders, products, customers, inventory.

### Phase 5: Facts-Only Report (30 min)
Write the audit from verified data only. Clearly separate facts from recommendations.

---

## Skills in This Pack

- `platform-detection.md` — How to identify the e-commerce platform from any URL
- `bigcommerce-audit.md` — Full BigCommerce API audit workflow
- `shopify-audit.md` — Full Shopify audit workflow
- `woocommerce-audit.md` — Full WooCommerce audit workflow
- `magento-audit.md` — Full Magento audit workflow
- `data-to-report.md` — Converting raw API data into executive findings
- `pricing-research.md` — How to research actual platform costs (with sources)
