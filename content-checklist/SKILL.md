---
name: content-checklist
description: A pre-publish checklist verifying an article, blog post, or landing page meets SEO, content-quality, schema, and copy standards before it goes live. Use when the user is about to publish or wants a final pre-launch review.
license: MIT
compatibility: Requires the thatseoagent MCP server connected. Get your API key at thatseoagent.com.
metadata:
  author: thatseoagent
  version: "1.4.0"
---

# Content Checklist

> **Requires** the thatseoagent MCP connected — [setup instructions](https://thatseoagent.com/en/mcp).

Nothing gets published without passing every item in this list. Run the sections in order — each builds on the one before it. After the manual checks, run the tools in the final section against the live or staging URL.

---


**Gate first.** An audit starts by confirming the URL returns 2xx: a 404 still serves a
body, so the content tools refuse a non-2xx rather than score an error page. A non-2xx is
still answerable — `seo_crawlability_audit` answers whatever the URL returns, and
`seo_robots_validator` and `seo_security_headers` do too, since robots.txt and response
headers do not depend on the page. Run those and name what you ran in one line. Then read
the **Page Kind** the audit identified before relaying a gap: a homepage owes `WebSite` +
`Organization`, not `Article`, and a check marked `n/a` does not apply to that kind rather
than being a gap.

---

## On-page SEO

- [ ] H1 contains the primary keyword exactly as targeted — no paraphrasing
- [ ] Title tag: primary keyword first, year if time-sensitive, benefit or differentiator. Front-load it — Google trims the title to fit the device it's shown on, not to a character count, so write so the subject survives being cut rather than counting to 60
- [ ] Meta description: unique to this page, primary keyword included, specific claim or benefit, CTA verb. Google publishes no length limit and often builds the snippet from the page instead; uniqueness beats length
- [ ] Primary keyword appears within the first 100 words of body text
- [ ] H2 headings use secondary and related keywords naturally — no forced phrasing
- [ ] URL slug: lowercase, hyphenated, keyword-rich, no stop words
- [ ] 2–4 internal links to related pages — use descriptive anchor text, not "click here"
- [ ] 2–3 external links to authoritative sources — primary research, official docs, not other blog posts
- [ ] All images: compressed (WebP preferred, under 200KB), descriptive file names, alt text with keywords where natural

---

## Schema markup

- [ ] Article schema includes: `headline`, `datePublished`, `dateModified`, `author` (with `@type: Person`), `publisher`
- [ ] `Organization` schema with 2+ `sameAs` URLs (LinkedIn, Wikidata, etc.) — entity disambiguation for AI
- [ ] `BreadcrumbList` schema for hierarchy (still triggers Google rich results)
- [ ] For comparison or "best of" articles: present the options as a visible ranked `<ol>` or comparison table in the DOM (the `seo_schema_generator` tool has no `ItemList` type — don't request one)
- [ ] If the page is genuinely a FAQ, use semantic HTML (`<details>`/`<summary>` or `<dl>`) as the primary representation — FAQ rich results are deprecated for non-gov/health sites and schema alone doesn't lift AI citations. Add FAQPage JSON-LD only if it honestly describes the page (some engines like Bing still parse it)
- [ ] For how-to content: visible step pattern (`<ol>` with steps, or "Step N" headings) — schema alone won't trigger HowTo rich results
- [ ] Validate `Article`, `Product`, `Organization`, `BreadcrumbList` schema with Google's Rich Results Test before publishing — for types that still produce documented rich results

---

## Content structure

- [ ] Answer-first format: the main answer appears in the first paragraph, before any background or context
- [ ] Clear heading hierarchy: H1 → H2 → H3, no skipped levels. This is an accessibility practice (WCAG 2.2 §1.3.1), not a ranking factor — Google states heading order and count don't affect ranking, so don't sell it as SEO
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
- [ ] **Em dashes.** Spanish (`es`) copy uses none at all — commas, colons or parentheses instead. English copy keeps them for rare, deliberate emphasis; more than one per page means revise. This is the house rule, and it is the most reliable AI tell there is
- [ ] No other AI-tell patterns — overused verbs, boilerplate openers, empty intensifiers. `references/ai-writing-detection.md` lists each one with its replacement; read it when editing the draft, not when checking it off

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

**A few days after it goes live**, once Google has crawled it: `gsc_rich_results` reports the rich result types Google actually detected on the URL and any structured-data issues per type, from Search Console's own inspection rather than inferred from the markup. That is the check `seo_schema_detection` cannot make — a page can declare valid schema that Google still declines to use.

**Keep the result.** The three tools above answer about the URL and forget: they live in a temporary cache and are not stored, so next month there is nothing to compare against. When the page belongs to a registered site, `run_page_audit` covers the same ground in one call and persists it, and `get_page_audits` reads it back.

---

## References

- **[AI Writing Detection](references/ai-writing-detection.md)** — em dashes and the word/phrase/structure patterns that make copy read as AI-generated, with human alternatives. Run the "Copy quality" AI-tell check against it.

