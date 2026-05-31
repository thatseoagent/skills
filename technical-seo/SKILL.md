---
name: technical-seo
description: Technical SEO audit skill for That SEO Agent MCP. Use this skill when the user asks about crawlability, indexing, canonical tags, redirect chains, robots.txt, hreflang, security headers, sitemaps, or URL inspection. Triggers on tasks involving site crawls, indexing problems, technical errors, or crawl budget concerns.
license: MIT
compatibility: Requires the thatseoagent MCP server connected. Get your API key at thatseoagent.com.
metadata:
  author: thatseoagent
  version: "1.1.1"
---

# Technical SEO

> **Requires** the thatseoagent MCP connected — [setup instructions](https://thatseoagent.com/en/mcp).

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

**Parameters:** `siteUrl` (the GSC property) and `inspectionUrl` (the page to audit). It needs GSC access because it reads Google's selected canonical from the URL Inspection API.

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

**Parameters:** `url` (the page to validate). Optional: `checkBidirectional` (default `true` — verifies referenced pages link back; slower but thorough), `checkAccessibility` (default `true` — checks every hreflang URL is reachable), and `sitemapUrl` (validate hreflang declared in a sitemap).

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

**Parameters:** `siteUrl` (the GSC property) and `inspectionUrl` (the exact page URL to inspect). Both are required.

**Returns:**
- Coverage state: `SUBMITTED_AND_INDEXED`, `CRAWLED_CURRENTLY_NOT_INDEXED`, `DISCOVERED_CURRENTLY_NOT_INDEXED`, etc.
- Last crawl date and time
- Mobile usability status
- Canonical URL as selected by Google

**Bulk inspection:** For up to 200 URLs at once, use `gsc_bulk_url_inspection` — pass `siteUrl` and `inspectionUrls` (an array of full URLs, max 200). Results are grouped by coverage state for easy triage.


## Rich Results

See the rich result types Google actually detected on a page — and the structured-data issues blocking them.

**When to use:** User added schema markup and wants to confirm Google sees it, or is debugging why a page isn't getting rich results despite having markup.

**Tool:** `gsc_rich_results`

**Parameters:** `siteUrl` (the GSC property) and `inspectionUrl` (the page to check).

**Returns:** The detected rich result types (Product, Review, FAQ, Breadcrumb, etc.) with a verdict per type and any per-item issues (error/warning + message). This is Google's own detection from URL inspection — more authoritative than `gsc_serp_features_gap`, which infers gaps from rankings. Pair them: `gsc_serp_features_gap` to find where schema is missing, `gsc_rich_results` to verify it once added.


## Index Coverage Analysis

Understand why pages aren't getting indexed across a large section of the site.

**When to use:** User reports that new pages aren't appearing in Google, or wants to audit indexing coverage across their sitemap.

**Tool:** `gsc_index_coverage_analysis`

**Parameters:** `siteUrl` plus a required `source` (one of `analytics`, `sitemap`, or `urls`) that selects where the URLs come from. Optional: `sampleSize` (10–200, default 100), `startDate` / `endDate` (for the `analytics` source, default last 30 days), `sitemapUrl` (for the `sitemap` source — auto-discovered from GSC when omitted), and `urls` (the array for the `urls` source).

**Input options (`source`):**
- `analytics` — URLs from GSC analytics (pages that have appeared in search)
- `sitemap` — parse a sitemap and inspect all URLs in it
- `urls` — inspect a manual list passed in `urls`

**Output:** URLs grouped by coverage state, with counts — so you can see at a glance how many pages are indexed, excluded, or not yet discovered.


## Traffic by Indexing State

Cross-reference your top-traffic pages against their live indexing state — to catch pages that earn search traffic but are no longer cleanly indexed.

**When to use:** User wants to confirm their highest-value pages are still `SUBMITTED_AND_INDEXED`, or to spot traffic-earning URLs that have slipped into a "crawled, not indexed" / canonical-elsewhere state before the clicks disappear.

**Tool:** `gsc_search_analytics_by_indexing_state`

**Parameters:** `siteUrl`, plus a required `startDate` / `endDate` (`YYYY-MM-DD`) for the traffic window. Optional `topN` (top URLs by traffic to inspect, 1–100, default 20). It pulls the top pages from search analytics, then runs live URL inspection on each.

**What it does:** Returns each top page alongside its current coverage state, so indexing regressions surface against the traffic they put at risk. Follow up on anything not `SUBMITTED_AND_INDEXED` with `gsc_inspect_url` for the full per-URL detail.


## Crawl Freshness

Find indexed pages Google hasn't crawled in a long time — they may be serving stale content.

**When to use:** User updated content but rankings haven't moved, or wants to know which pages Google is seeing an outdated version of.

**Tool:** `gsc_crawl_freshness`

**Parameters:** `siteUrl` is the only required input. Optional: `sitemapUrl` (auto-discovered from GSC when omitted), `sampleSize` (10–200 URLs to inspect, default 100), and `maxResults` (stalest pages to return, default 25).

**What it does:** Inspects the site's sitemap URLs (auto-discovered from GSC) and ranks pages by oldest last-crawl date. Pages crawled long ago are candidates to refresh and re-promote (internal links) to prompt a re-crawl.


## Sitemap Management

List, inspect, and submit sitemaps to Google Search Console.

**When to use:** After a migration, after publishing new content, or to diagnose sitemap errors.

**Tools:**
- `gsc_list_sitemaps` — list all submitted sitemaps with status and error counts. Param: `siteUrl`.
- `gsc_get_sitemap` — get details on a specific sitemap (last downloaded, URLs submitted vs. indexed). Params: `siteUrl` and `feedpath` (the full sitemap URL, e.g. `https://example.com/sitemap.xml`).
- `gsc_sitemap_url_inspection` — parse the sitemap and bulk-inspect every URL inside it against GSC. Params: `siteUrl` and `sitemapUrl` (the sitemap's URL — note this differs from `gsc_get_sitemap`'s `feedpath`), plus optional `maxUrls` (default 100, max 200).

**Note:** To submit a new sitemap to GSC, do it directly from the Google Search Console UI (Search Index → Sitemaps → Add a new sitemap).

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
