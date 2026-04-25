---
name: content-audit
description: Content and on-page SEO audit skill for That SEO Agent MCP. Use this skill when the user asks about on-page optimization, content quality, readability, heading structure, word count, schema markup, or structured data. Triggers on tasks involving meta tags, title tags, content analysis, JSON-LD, or page-level SEO improvements.
license: MIT
compatibility: Requires the thatseoagent MCP server connected. Get your API key at thatseoagent.com.
metadata:
  author: thatseoagent
  version: "1.0.0"
---

# Content Audit

> **Requires** the thatseoagent MCP connected — [setup instructions](https://thatseoagent.com/docs/mcp).

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

Find all structured data on a page and validate it — JSON-LD, Microdata, and RDFa.

**When to use:** User wants to audit their existing schema markup, or wants to know what rich results they're eligible for.

**Tool:** `seo_schema_detection`

**What it returns:**
- All schema types detected on the page
- The full JSON-LD markup for each schema block
- Validation issues (missing required properties, incorrect types)

**Key insight from research:** Generic CMS-default schema (Article, Organization, BreadcrumbList with minimal attributes) can *hurt* AI citation rates (41.6% citation rate vs 59.8% for pages with no schema at all). Only attribute-rich schema — Product with pricing, Review with rating values, FAQ with full answer text — outperforms no schema.

**Audit questions to answer:**
- Is the schema present? (`seo_schema_detection`)
- Does it have all required and recommended properties? (check against schema.org spec)
- Is it attribute-rich or a bare-minimum stub? (stubs may be worse than nothing)

## Schema Generation

Generate valid JSON-LD structured data markup ready to paste into a page.

**When to use:** User needs to add or improve schema markup but doesn't want to write it manually.

**Tool:** `seo_schema_generator`

**Supported schema types (examples):**
- `FAQPage` — for Q&A content, featured snippet eligibility
- `HowTo` — for step-by-step guides
- `Product` — with pricing, availability, ratings
- `Review` / `AggregateRating` — customer reviews
- `Article` / `BlogPosting` — with author, datePublished, dateModified
- `Organization` — with sameAs entity disambiguation links
- `Person` — for author bio pages
- `LocalBusiness` — for local SEO
- `BreadcrumbList` — for site hierarchy

**Workflow:**
1. Run `seo_schema_detection` to see what's already on the page.
2. Identify missing or incomplete schema types.
3. Run `seo_schema_generator` with the schema type and the page's data.
4. Paste the generated JSON-LD into the `<head>` of the page.
5. Validate with Google's Rich Results Test.

**Priority schema by page type:**

| Page type | Schema to add |
|-----------|--------------|
| Homepage | `Organization` with `sameAs` links |
| Blog post | `Article` with `author`, `datePublished`, `dateModified` |
| FAQ / Support | `FAQPage` |
| Product page | `Product` with pricing and `AggregateRating` |
| Author bio | `Person` with credentials |
| How-to guide | `HowTo` with step-by-step markup |
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
