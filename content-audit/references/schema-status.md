# Schema & AI-Citation Status

The single source of truth for structured-data deprecations and the evidence on whether schema drives AI citation. When a date or study needs updating, update it **here** — the other skills point to this file instead of restating it.

## Deprecation timeline

| Date | Change |
|------|--------|
| September 2023 | Google removed **HowTo** rich results from desktop. Schema alone no longer triggers them. |
| May 7, 2026 | Google deprecated **FAQPage** rich results for all non-government / non-health sites. Only gov/health sites still get them. |
| May 2026 | Google's official AI-optimization guidance told site owners they can **ignore** AI-specific markup files (e.g. `llms.txt`) for AI Overviews / AI Mode. |
| June 2026 | Google's **Rich Results Test** drops FAQ support. |
| August 2026 | Google's **Search Console API** drops FAQ reporting. |

## The evidence on schema and AI citation

The **Ahrefs 2026 causal study** (1,885 treated pages vs 4,000 controls) found JSON-LD schema produces:

- **No significant AI-citation lift** on Google AI Mode (+2.4%) or ChatGPT (+2.2%)
- A **small significant decline** on Google AI Overviews (−4.6%)

**Takeaway:** schema is not an AI-citation lever. Its job is to **honestly describe the page** for documented rich results. Generic CMS-default schema, or schema that lies about the page (FAQPage on a product page, HowTo with no step content), is exactly the abuse pattern that triggered the FAQ deprecation.

## What still earns documented rich results

`Article`, `Organization`, `BreadcrumbList`, `Product` (with offers/price/SKU), `Review`/`AggregateRating`, `Recipe`, `VideoObject`, `Event`, `LocalBusiness`, `JobPosting`, `NewsArticle`.

## Honest representation over markup

- **FAQ content** → represent with semantic HTML (`<details>`/`<summary>` or `<dl>`). Add FAQPage JSON-LD only if it truthfully matches visible Q&A; some engines (e.g. Bing) still parse it.
- **How-to content** → a visible ordered step list (`<ol>` or "Step N" headings) is the primary representation; schema won't substitute for it.
- **Comparison / "best of"** → a visible ranked `<ol>` or comparison table in the DOM.
