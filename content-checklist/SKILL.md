---
name: content-checklist
description: Pre-publish content checklist skill for That SEO Agent MCP. Use this skill when the user is about to publish a new article, blog post, or landing page and wants to verify it meets SEO and content quality standards before going live. Triggers on tasks involving content publishing, article review, SEO-optimized writing, schema validation, or pre-publish audits.
license: MIT
compatibility: Requires the thatseoagent MCP server connected. Get your API key at thatseoagent.com/dashboard/settings.
metadata:
  author: thatseoagent
  version: "1.0.0"
---

# Content Checklist

> **Requires** the thatseoagent MCP connected — [setup instructions](https://thatseoagent.com/docs/mcp).

Nothing gets published without passing every item in this list. Run the sections in order — each builds on the one before it. After the manual checks, run the tools in the final section against the live or staging URL.

---

## On-page SEO

- [ ] H1 contains the primary keyword exactly as targeted — no paraphrasing
- [ ] Title tag: primary keyword first, year if time-sensitive, benefit or differentiator, under 60 characters total
- [ ] Meta description: primary keyword included, specific claim or benefit, CTA verb, 150–160 characters
- [ ] Primary keyword appears within the first 100 words of body text
- [ ] H2 headings use secondary and related keywords naturally — no forced phrasing
- [ ] URL slug: lowercase, hyphenated, keyword-rich, no stop words
- [ ] 2–4 internal links to related pages — use descriptive anchor text, not "click here"
- [ ] 2–3 external links to authoritative sources — primary research, official docs, not other blog posts
- [ ] All images: compressed (WebP preferred, under 200KB), descriptive file names, alt text with keywords where natural

---

## Schema markup

- [ ] FAQPage JSON-LD included if the article answers 3+ distinct questions
- [ ] Each FAQ answer is self-contained — it must work as a standalone answer without surrounding context
- [ ] Article schema includes: `headline`, `datePublished`, `dateModified`, `author` (with `@type: Person`), `publisher`
- [ ] For comparison or "best of" articles: `ItemList` schema with each option as a `ListItem`
- [ ] For how-to content: `HowTo` schema with numbered steps
- [ ] Validate all schema with Google Rich Results Test before publishing — fix any errors

---

## Content structure

- [ ] Answer-first format: the main answer appears in the first paragraph, before any background or context
- [ ] Clear heading hierarchy: H1 → H2 → H3, no skipped levels
- [ ] Short paragraphs: 2–3 sentences maximum, no walls of text
- [ ] At least one comparison table if the content covers multiple options or tools
- [ ] Bullet or numbered lists for any sequential steps or feature comparisons
- [ ] Visual break every 200–300 words: table, image, list, blockquote, or callout block

---

## Copy quality

- [ ] Every factual claim includes a specific source — name, organization, year. No anonymous "studies show" or "experts say"
- [ ] Every statistic includes: the number, a named source, and a date. "72% of users" is weak. "72% of users abandoned checkout at step 3 (Baymard Institute, 2024 study of 4,000 sessions)" is citable
- [ ] At least one direct quote from a named person with their title and organization
- [ ] No hedging language where a direct statement works — "X is" not "X might be"
- [ ] Hook in the first sentence: a specific result, a number, or a direct claim
- [ ] No keyword stuffing — primary keyword used naturally, not forced into every paragraph

---

## Engagement elements

- [ ] CTA appears once mid-article (contextual, low friction)
- [ ] CTA appears once at the end (direct, specific next step)
- [ ] FAQ section present — 3–5 questions that match real search queries from GSC data
- [ ] Related content links: 3–4 links to other articles in the same cluster at the end

---

## Images

- [ ] At least 2 images per article
- [ ] File names are descriptive (`saas-pricing-comparison.webp`, not `IMG_001.jpg`)
- [ ] OG/thumbnail image: 1280×720, 16:9 ratio
- [ ] At least 1 product screenshot if the article covers a tool or feature

---

## Final check — run these tools before publishing

Run against the staging or live URL after all content and schema edits are in place:

```
seo_analyze_page       → catch on-page issues: meta, headings, canonical, missing schema
seo_schema_detection   → confirm schema is rendering correctly from the live page
pagespeed_insights     → confirm the page doesn't regress Core Web Vitals after publishing
```

If any tool returns a failing check, fix it before the article goes live.
