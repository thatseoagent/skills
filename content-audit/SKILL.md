---
name: content-audit
description: Audit and improve page-level SEO — on-page signals (title, meta, headings, canonical), content quality and readability, and structured data (schema/JSON-LD). Use for single-page optimization or diagnosing why a page isn't ranking.
license: MIT
compatibility: Requires the thatseoagent MCP server connected. Get your API key at thatseoagent.com.
metadata:
  author: thatseoagent
  version: "1.4.0"
---

# Content Audit

> **Requires** the thatseoagent MCP connected — [setup instructions](https://thatseoagent.com/en/mcp).

Workflows for analyzing and improving on-page SEO, content quality, and structured data using the thatseoagent MCP.

**Keep the result.** Every tool in this skill answers about a URL and forgets: the `seo_*` and `pagespeed_insights` results live in a temporary cache and are not stored. When the page belongs to a site the user has registered, run `run_page_audit` on it instead — one call covers on-page, content, structured data, crawlability, E-E-A-T, GEO, PageSpeed and per-URL Search Console data, and the result persists, so `get_page_audits` can show it again next week and the change is comparable. Use the individual tools below for a page on a site the user has not registered, or when only one dimension is in question. Say which one you used, in one line, and carry on.

`run_page_audit` also deliberately does **not** register a Site, so it never quietly spends a Site-Limit slot the way `run_site_audit` does. It requires the Site to exist already.



**Gate first.** An audit starts by confirming the URL returns 2xx: a 404 still serves a
body, so the content tools refuse a non-2xx rather than score an error page. A non-2xx is
still answerable — `seo_crawlability_audit` answers whatever the URL returns, and
`seo_robots_validator` and `seo_security_headers` do too, since robots.txt and response
headers do not depend on the page. Run those and name what you ran in one line. Then read
the **Page Kind** the audit identified before relaying a gap: a homepage owes `WebSite` +
`Organization`, not `Article`, and a check marked `n/a` does not apply to that kind rather
than being a gap.

---

## On-Page SEO Analysis

Audit the core on-page signals for any URL: title tag, meta description, headings, canonical, and structured data.

**When to use:** Starting point for any page-level optimization, or to diagnose why a specific page isn't ranking.

**Tool:** `seo_analyze_page`

**What it checks:**
- Title tag — length, keyword placement, uniqueness
- Meta description — length, CTA presence, relevance to content
- Heading structure — H1 presence, heading hierarchy (H2 → H3), keyword coverage
- Canonical tag — presence and format
- Internal and external link counts
- Structured data types detected on the page

**Quick wins from this audit:**
- Title's subject buried at the end → lead with it. Google truncates a title to
  fit the device width, not to a character count, so there is no number to hit;
  what matters is that the page's subject survives being cut short.
- No meta description → write one. Google publishes no length limit and often
  composes the snippet from the page anyway, but leaving it empty means Google
  picks an arbitrary sentence. Uniqueness per page matters more than length.
- No H1 → add one naming the subject. Google states heading order and count do
  not affect ranking, so **do not** report a second H1 as an SEO defect; it is
  an accessibility concern for anyone navigating by headings, and belongs in
  that conversation instead.
- No canonical tag → usually fine. Google: "none of them are required; your site
  will likely do just fine without specifying a canonical preference." Raise it
  only when the page genuinely has duplicates, and then set it explicitly.

**Report the subject, not a character count.** Say whether the page's subject
survives truncation and whether the description is unique to the page; a number
of characters is a claim Google does not make, and the product's own report does
not make it either.

## Content Quality Analysis

Assess readability, depth, heading structure, and link density — signals that affect both rankings and AI citation.

**When to use:** User wants to improve content quality on an existing page, or wants to understand why a page isn't getting cited in AI answers.

**Tool:** `seo_content_analysis`

**What it measures:**
- Word count. **Not a ranking threshold.** Google states there is no minimum
  word count, so report length as an observation ("this page is much shorter
  than the ones ranking for the query") and never as a defect with a number
  attached.
- Readability score (Flesch-Kincaid) — target grade 9–12 for general audiences, grade 12–16 for professional content
- Heading structure — number of H2/H3 sections, ratio to word count
- Internal link density — links per 1,000 words
- External link count — outbound references to authoritative sources

**For AI citation specifically:** Pages scoring at Flesch-Kincaid grade 16 (college level) outperform grade 19+ (PhD level) for AI citation. Complex sentence structure increases model perplexity — simpler subject-verb-object sentences extract better.

**Content structure improvements:**
- Add question-based H2 headings for informational content ("How does X work?")
- Follow each question heading with a direct 1–2 sentence answer (the "answer capsule")
- Increase entity density by naming specific tools, brands, and data points
- Split pages over 2,000 words into focused sub-pages if topics are distinct

## Schema Detection

Find all structured data on a page and validate it — JSON-LD, Microdata, and RDFa. Also flags **schema-content mismatches** (e.g. FAQPage JSON-LD on a page with no visible Q&A pattern, incomplete Product schema, HowTo without step content).

**When to use:** User wants to audit their existing schema markup, wants to know what rich results they're eligible for, or wants to find schema that doesn't honestly describe the page.

**Tool:** `seo_schema_detection`

**What it returns:**
- All schema types detected on the page
- The full JSON-LD markup for each schema block
- Validation issues (missing required properties, incorrect types)
- **Mismatches**: schema types present in JSON-LD that the rendered DOM does not back up (e.g. FAQPage without `<details>`/`<summary>`/`<dl>` or question headings; Product without offers/price/sku or visible commerce signals; HowTo without an ordered step list)
- A documented-feature stack check (`Article` + `Organization` + `BreadcrumbList`) — these are the types Google still rewards with documented rich results

**Key insight:** schema is not an AI-citation lever — it exists to describe the page **honestly** for documented rich results. Generic CMS-default schema, or schema that lies about the page (FAQPage on product pages, etc.), is the abuse pattern platforms punish. Dates, the Ahrefs 2026 causal study, and what still earns rich results: **references/schema-status.md**.

**Audit questions to answer:**
- Is the schema present and valid? (`seo_schema_detection`)
- Does it have all required and recommended properties? (check against schema.org spec)
- Does it **honestly describe** the rendered content? (review the `mismatches` field — schema that doesn't match the DOM is the abuse pattern platforms punish)

## Schema Generation

Generate valid JSON-LD structured data markup ready to paste into a page.

**When to use:** User needs to add or improve schema markup but doesn't want to write it manually.

**Tool:** `seo_schema_generator`

**Parameters:**
- `type` — one of the supported schema types below (exact, case-sensitive enum)
- `data` — an object of type-specific fields; fields left empty fall back to placeholder values like `[ORGANIZATION_NAME]`

**Supported schema types (the only accepted `type` values):**
- `Organization` — with sameAs entity disambiguation links
- `LocalBusiness` — for local SEO
- `Article` — with author, datePublished, dateModified
- `Product` — with pricing, availability, ratings
- `BreadcrumbList` — for site hierarchy
- `WebSite` — site-level entity, supports `potentialAction` (sitelinks search)
- `Person` — for author bio pages
- `Event` — for event pages
- `FAQPage` — only generate when the page is genuinely a FAQ with visible Q&A in the DOM. FAQ rich results are deprecated for non-gov/health sites; some engines (e.g. Bing) still parse it (see references/schema-status.md)
- `Recipe` — for recipe pages

> The generator does **not** accept `BlogPosting`, `Review`, `AggregateRating`, `HowTo`, or `ItemList` as a `type` — passing them rejects the call. Use `Article` in place of `BlogPosting`; embed ratings inside `Product` data rather than a standalone `Review`/`AggregateRating` type.

**Workflow:**
1. Run `seo_schema_detection` to see what's already on the page.
2. Identify missing or incomplete schema types.
3. Run `seo_schema_generator` with `type` set to one of the supported values and `data` carrying the page's fields.
4. Paste the generated JSON-LD into the `<head>` of the page.
5. Validate with Google's Rich Results Test — use it only for types that still produce documented rich results (see references/schema-status.md).

**Priority schema by page type:**

| Page type | Schema to add |
|-----------|--------------|
| Homepage | `Organization` with `sameAs` links |
| Blog post | `Article` with `author`, `datePublished`, `dateModified` |
| FAQ / Support | `FAQPage` only if genuinely a FAQ — use semantic HTML `<details>`/`<summary>` as the primary representation (FAQ rich results deprecated; see references/schema-status.md) |
| Product page | `Product` with pricing and `AggregateRating` |
| Author bio | `Person` with credentials |
| How-to guide | Visible `<ol>` step markup in the DOM (the generator has no `HowTo` type; HowTo desktop rich results were removed — see references/schema-status.md) |
| Local business | `LocalBusiness` with address and hours |


## Content Audit Workflow (Full Page)

Run this sequence for a complete page-level content audit:

```
run_page_audit          → all of the below in one stored call, for a page on a
                          registered site. Read it back later with get_page_audits

— or, for an unregistered site or a single question —

1. seo_analyze_page     → on-page signals: title, meta, headings, canonical
2. seo_content_analysis → content depth, readability, link density
3. seo_schema_detection → existing structured data and validation issues
4. seo_schema_generator → generate missing or improved schema
```

**Prioritize fixes in this order:**
1. Anything that stops the page being indexed or understood at all — no title,
   no meta description, no H1, no mobile viewport
2. Content that does not answer the query it targets. Judge it against what
   ranks, not against a word count
3. Missing high-value schema (Product, Article, Organization). **Not FAQPage or
   HowTo** — Google retired those rich results, so proposing them promises an
   appearance that no longer exists
4. Content structure improvements (answer capsules, entity density, heading questions)

---

## References

- **[Schema & AI-Citation Status](references/schema-status.md)** — the canonical deprecation timeline (FAQ, HowTo), the Ahrefs 2026 causal study on schema vs AI citation, and which types still earn documented rich results. Consult before advising on any structured-data change.
