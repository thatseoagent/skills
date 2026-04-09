---
name: technical-seo
description: Technical SEO audit skill for That SEO Agent MCP. Use this skill when the user asks about crawlability, indexing, canonical tags, redirect chains, robots.txt, hreflang, security headers, sitemaps, or URL inspection. Triggers on tasks involving site crawls, indexing problems, technical errors, or crawl budget concerns.
license: MIT
compatibility: Requires the thatseoagent MCP server connected. Get your API key at thatseoagent.com/dashboard/settings.
metadata:
  author: thatseoagent
  version: "1.0.0"
---

# Technical SEO

> **Requires** the thatseoagent MCP connected — [setup instructions](https://thatseoagent.com/docs/mcp).

Workflows for diagnosing and fixing technical SEO issues using the thatseoagent MCP.


## Full Crawlability Audit

The fastest way to surface critical technical issues: canonical conflicts, redirect chains, noindex tags, and blocked pages.

**When to use:** Starting point for any technical audit, or when a user reports indexing problems.

**Workflow:**
1. Run `seo_crawlability_audit` with the target URL.
2. The tool checks canonical tags (HTML vs. HTTP header), redirect chain length, robots meta directives, and indexability status.
3. `criticalIssues` count — fix these first. `warnings` — fix these second.

**Common critical issues:**
- **Canonical conflict:** HTML says one URL, HTTP header says another. Google picks one; you lose control.
- **Redirect chain > 1 hop:** Each hop adds latency and dilutes signals. Collapse to a single redirect.
- **Noindex on a page that should rank:** Usually a staging leftover. Remove the tag and validate with `gsc_inspect_url`.



## Canonical Audit

Compare the canonical tag in HTML against what Google has actually selected as the canonical.

**When to use:** User suspects Google is ignoring their canonical declarations.

**Tool:** `seo_canonical_audit`

**What it checks:**
- The canonical tag declared in the page's `<head>`
- The Google-selected canonical from GSC's URL Inspection API
- Whether they match — mismatches mean Google disagrees with your canonical signal

**Why this matters:** If Google selects a different canonical than the one you declared, ranking signals accumulate on Google's choice — not yours. Fix by strengthening the canonical signal: consistent internal linking, correct `<link rel="canonical">`, and no conflicting HTTP header.



## Robots.txt Validation

Ensure Google, AI crawlers, and other bots can access the pages you want indexed.

**When to use:** User wants to verify their robots.txt is configured correctly, or after a migration.

**Tool:** `seo_robots_validator`

**What it checks:**
- Whether robots.txt exists and is reachable
- Whether Googlebot is allowed to crawl
- Whether AI crawlers (GPTBot, ClaudeBot, PerplexityBot, etc.) are allowed or blocked
- Site-wide blocking rules that may be unintentionally disallowing content
- Sitemap references in the robots.txt

**AI crawler access:** If AI visibility is a goal, check that `blocksAiCrawlers` is `false`. Blocking GPTBot or PerplexityBot removes those platforms from discovering your content entirely.


## Security Headers Audit

Grade the site's HTTP security headers — a trust signal for both users and AI systems.

**When to use:** User wants to improve their security posture or is failing E-E-A-T checks related to trustworthiness.

**Tool:** `seo_security_headers`

**What it checks:**
- HTTPS / HSTS
- Content-Security-Policy
- X-Frame-Options
- X-Content-Type-Options
- Referrer-Policy
- Permissions-Policy

**Grading:** A/B = good security posture. C/D = missing important headers. F = critical headers absent.

**Quick wins:** `X-Content-Type-Options: nosniff` and `X-Frame-Options: SAMEORIGIN` are one-line server config changes with an immediate grade improvement.


## Hreflang Validation

Validate international SEO hreflang tags for correctness and bidirectional consistency.

**When to use:** User has a multilingual or multi-regional site and suspects hreflang issues.

**Tool:** `seo_hreflang_validator`

**What it checks:**
- Valid language and region codes (ISO 639-1 + ISO 3166-1)
- Self-referencing hreflang tag on each page
- Bidirectional consistency — if page A points to page B, page B must point back to page A
- `x-default` tag presence

**Common failures:**
- Missing self-reference (every page must include a hreflang pointing to itself)
- Broken bidirectional links (page B doesn't return-reference page A)
- Invalid codes like `en-UK` (correct is `en-GB`)


## URL Inspection

Check a single URL's indexing status, coverage state, mobile usability, and last crawl time.

**When to use:** User wants to verify a specific page is indexed, or investigate why a page isn't appearing in search.

**Tool:** `gsc_inspect_url`

**Returns:**
- Coverage state: `SUBMITTED_AND_INDEXED`, `CRAWLED_CURRENTLY_NOT_INDEXED`, `DISCOVERED_CURRENTLY_NOT_INDEXED`, etc.
- Last crawl date and time
- Mobile usability status
- Canonical URL as selected by Google

**Bulk inspection:** For 2–200 URLs at once, use `gsc_bulk_url_inspection`. Results are grouped by coverage state for easy triage.


## Index Coverage Analysis

Understand why pages aren't getting indexed across a large section of the site.

**When to use:** User reports that new pages aren't appearing in Google, or wants to audit indexing coverage across their sitemap.

**Tool:** `gsc_index_coverage_analysis`

**Input options:**
- Analyze URLs from GSC analytics (pages that have appeared in search)
- Parse a sitemap and inspect all URLs in it
- Inspect a manual list of URLs

**Output:** URLs grouped by coverage state, with counts — so you can see at a glance how many pages are indexed, excluded, or not yet discovered.


## Sitemap Management

List, inspect, and submit sitemaps to Google Search Console.

**When to use:** After a migration, after publishing new content, or to diagnose sitemap errors.

**Tools:**
- `gsc_list_sitemaps` — list all submitted sitemaps with status and error counts
- `gsc_get_sitemap` — get details on a specific sitemap (last downloaded, URLs submitted vs. indexed)
- `gsc_submit_sitemap` — submit a new sitemap URL to GSC
- `gsc_sitemap_url_inspection` — parse the sitemap and bulk-inspect every URL inside it against GSC

**Recommended workflow after a migration:**
1. `gsc_list_sitemaps` — confirm the new sitemap is submitted
2. `gsc_sitemap_url_inspection` — inspect all sitemap URLs for indexing status
3. Fix any `CRAWLED_CURRENTLY_NOT_INDEXED` or redirect issues found


## Full Site Crawl

BFS-crawl the site to find broken links, orphaned pages, thin content, and duplicate titles at scale.

**When to use:** User wants a comprehensive technical audit across the full site, not just a single page.

**Tool:** `crawl_site`

**What it finds:**
- Broken internal links (4xx, 5xx responses)
- Pages with thin content (low word count)
- Duplicate or missing title tags
- Pages buried deep in the site architecture (many hops from the homepage)

**Note:** Crawl results are cached for 1 hour. To re-crawl after fixes, simply call the tool again — the cache will refresh automatically after expiry.
