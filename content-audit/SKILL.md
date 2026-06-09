---
name: content-audit
description: Content and on-page SEO audit skill for That SEO Agent MCP. Use this skill when the user asks about on-page optimization, content quality, readability, heading structure, word count, schema markup, or structured data. Triggers on tasks involving meta tags, title tags, content analysis, JSON-LD, or page-level SEO improvements.
license: MIT
compatibility: Requires the thatseoagent MCP server connected. Get your API key at thatseoagent.com.
metadata:
  author: thatseoagent
  version: "1.0.1"
---

# Content Audit

> **Requires** the thatseoagent MCP connected — [setup instructions](https://thatseoagent.com/en/mcp).

Workflows for analyzing and improving on-page SEO, content quality, and structured data using the thatseoagent MCP.


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
- Title missing primary keyword in first 60 characters → rewrite to lead with the keyword
- No meta description or truncated at 120 chars → expand to 150–160 chars with a clear CTA
- Multiple H1s or no H1 → ensure exactly one H1 that matches the page's primary topic
- No canonical tag → add `<link rel="canonical" href="[self-url]">` to prevent duplicate content issues

## Content Quality Analysis

Assess readability, depth, heading structure, and link density — signals that affect both rankings and AI citation.

**When to use:** User wants to improve content quality on an existing page, or wants to understand why a page isn't getting cited in AI answers.

**Tool:** `seo_content_analysis`

**What it measures:**
- Word count — thin content flags (typically < 300 words for non-commercial pages)
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

**Key insight from research:** The Ahrefs 2026 causal study (1,885 treated pages vs 4,000 controls) found JSON-LD schema produces no significant AI citation lift on AI Mode (+2.4%) or ChatGPT (+2.2%) and a small significant decline on Google AI Overviews (−4.6%). Schema should describe the page **honestly** — it does not function as an AI citation lever. Generic CMS-default schema or schema that lies about the page (FAQPage on product pages, etc.) is exactly the pattern that triggered Google's FAQ rich result deprecation in May 2026.

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
- `FAQPage` — only generate when the page is genuinely a FAQ with visible Q&A in the DOM. Google deprecated FAQ rich results on May 7, 2026 for non-gov/health sites; some other engines (e.g. Bing) still parse it
- `Recipe` — for recipe pages

> The generator does **not** accept `BlogPosting`, `Review`, `AggregateRating`, `HowTo`, or `ItemList` as a `type` — passing them rejects the call. Use `Article` in place of `BlogPosting`; embed ratings inside `Product` data rather than a standalone `Review`/`AggregateRating` type.

**Workflow:**
1. Run `seo_schema_detection` to see what's already on the page.
2. Identify missing or incomplete schema types.
3. Run `seo_schema_generator` with `type` set to one of the supported values and `data` carrying the page's fields.
4. Paste the generated JSON-LD into the `<head>` of the page.
5. Validate with Google's Rich Results Test (note: FAQ support is removed in June 2026 — use the test only for types that still produce documented rich results).

**Priority schema by page type:**

| Page type | Schema to add |
|-----------|--------------|
| Homepage | `Organization` with `sameAs` links |
| Blog post | `Article` with `author`, `datePublished`, `dateModified` |
| FAQ / Support | `FAQPage` (only if the page is genuinely a FAQ — Google deprecated FAQ rich results May 2026; use semantic HTML `<details>`/`<summary>` as the primary representation) |
| Product page | `Product` with pricing and `AggregateRating` |
| Author bio | `Person` with credentials |
| How-to guide | Visible `<ol>` step markup in the DOM (the generator has no `HowTo` type; Google removed HowTo desktop rich results in September 2023) |
| Local business | `LocalBusiness` with address and hours |


## Content Audit Workflow (Full Page)

Run this sequence for a complete page-level content audit:

```
1. seo_analyze_page     → on-page signals: title, meta, headings, canonical
2. seo_content_analysis → content depth, readability, link density
3. seo_schema_detection → existing structured data and validation issues
4. seo_schema_generator → generate missing or improved schema
```

**Prioritize fixes in this order:**
1. Critical on-page issues (missing H1, no canonical, title > 60 chars)
2. Thin content (< 600 words on pages targeting competitive queries)
3. Missing high-value schema (FAQ, Product, Article)
4. Content structure improvements (answer capsules, entity density, heading questions)
