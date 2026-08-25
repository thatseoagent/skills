---
name: gsc-insights
description: Extract insights from Google Search Console — quick wins, traffic-drop diagnosis, keyword trends, cannibalization, featured-snippet and SERP-feature opportunities, and query-to-content planning. Use when the user asks about keyword performance, CTR, impressions, or organic search behavior.
license: MIT
compatibility: Requires the thatseoagent MCP server connected. Get your API key at thatseoagent.com.
metadata:
  author: thatseoagent
  version: "1.4.0"
---

# GSC Insights

> **Requires** the thatseoagent MCP connected — [setup instructions](https://thatseoagent.com/en/mcp).

Workflows for extracting actionable insights from Google Search Console data using the thatseoagent MCP.


## Quick Wins

Find high-impression keywords with low CTR — the fastest optimization opportunities on any site.

**When to use:** User wants to know what to fix first, or wants to improve CTR without creating new content.

**Workflow:**
1. Run `gsc_detect_quick_wins` with the site's GSC property URL (`siteUrl`), plus a date range (`startDate` / `endDate`, both `YYYY-MM-DD`).
2. The tool returns keywords above the `minImpressions` threshold (default: 50) where CTR is underperforming relative to position. Narrow the rank band with `positionMin` / `positionMax` if needed.
3. For each opportunity: the query, its impressions, current CTR vs expected CTR at that position, and the potential clicks at the target CTR.
4. Prioritize by impressions × CTR gap — the highest-volume misses come first.

**It returns queries, not pages, and one window, not two.** The pull behind it is `dimensions: ["query"]` over a single `startDate`/`endDate`, so nothing in its output names a URL and nothing in it can tell you what moved. Map a query back to its page with `gsc_page_query_map` before rewriting anything, and use `gsc_detect_trends` or `gsc_detect_lost_queries` for the question about change — those are the tools that take two periods.

**What to do with the results:** Rewrite the title tag and meta description on the page each top query maps to. The keyword is already getting eyes — the problem is the click.


## From Data to Content Plan

GSC tells you which queries exist and how you rank; this turns that raw list into a prioritized content plan. Use it after `gsc_detect_quick_wins`, `gsc_detect_trends`, or a raw `gsc_search_analytics` pull.

### Map each query to a buyer stage

The stage decides the content type and the CTA. Read the query's modifier:

| Stage | Query modifiers | Best content response |
|-------|-----------------|----------------------|
| Awareness | "what is", "how to", "guide to", "why does" | Educational post / guide; answer-first, definition capsule |
| Consideration | "best", "top", "vs", "alternatives", "comparison" | Comparison page or table; honest, structured |
| Decision | "pricing", "reviews", "demo", "trial" | Product/pricing page; specifics, no fluff |
| Implementation | "templates", "examples", "tutorial", "setup", "how to use" | Tutorial / template with standalone value |

A page ranking for queries from *different* stages usually lacks focus — split or re-target it. `gsc_page_query_map` is what shows the spread: it takes a `siteUrl`, not a page, and maps the property's top 15 pages to their queries in one call (`maxPages` raises it, up to 100), so run it once for the site rather than once per page.

### Prioritize the backlog

Score each candidate topic/cluster; act on the top few per cycle. Weighting:

| Factor | Weight | Signal to read |
|--------|:------:|----------------|
| Customer impact | 40% | How often the pain shows up in sales/support, LTV of who has it |
| Content-market fit | 30% | Does it align with what the product solves and where it converts? |
| Search potential | 20% | Impression volume + rank gap from `gsc_search_analytics` / quick-wins |
| Resource cost | 10% | Expertise, data, and assets needed to make it genuinely better than the SERP |

`Priority = 0.4·impact + 0.3·fit + 0.2·search + 0.1·(inverse) resource`. GSC feeds the "search potential" input; the other three come from the business, so ask for them rather than inferring.

### Find demand GSC can't see yet

GSC only shows queries you already get impressions for. For net-new topics, mine where the audience actually talks:
- **Reddit / Quora** — `site:reddit.com [topic]`, `site:quora.com [topic]` for questions, misconceptions, and the exact language customers use.
- **Sales/support transcripts** — recurring questions become FAQ and blog topics; objections become content to address proactively.
- Cross-check any promising topic back in `gsc_search_analytics` — if impressions are already trickling in, it jumps up the priority list.


## Traffic Anomaly Detection

Identify statistically significant traffic drops and spikes — distinguish real problems from noise.

**When to use:** User reports a traffic drop, or wants to audit the last 90 days for unusual patterns.

**Workflow:**
1. Run `gsc_detect_anomalies` with `siteUrl` and a required date range — `startDate` and `endDate` (`YYYY-MM-DD`). Span at least 14 days so the baseline has enough history; ~90 days is a good default to request.
2. The tool uses modified Z-score analysis to flag dates where clicks or impressions deviated significantly from the trend. Tune sensitivity with `zScoreThreshold` (default 3.5; higher = fewer, more extreme anomalies) and pick `metrics` (default `["clicks", "impressions"]`).
3. Drops (negative Z-score) indicate potential indexing issues, algorithm updates, or content problems.
4. Spikes (positive Z-score) may indicate viral content, news mentions, or seasonal demand worth capitalizing on.

**Follow-up:** For drops, cross-reference the anomaly date with `gsc_inspect_url` on the affected pages to check indexing status.

**Catch drops earlier:** `gsc_detect_anomalies` now takes an optional `dataState` param. It defaults to `"final"` (data settled ~2–3 days ago). Pass `dataState: "all"` to include fresh, still-incomplete data and surface a developing drop days before it's finalized. One caveat: with `"all"` the most recent 1–2 days are partial, so the last data point can read as a dip — weight it as provisional, not a confirmed drop.


## Keyword Trend Analysis

Find rising and declining keyword trends before they become obvious.

**When to use:** User wants to know which topics are gaining or losing traction in their niche.

**Workflow:**
1. Run `gsc_detect_trends` with `siteUrl` and a required `startDate` / `endDate` (`YYYY-MM-DD`, at least 7 days apart). Choose the `metric` to trend (`clicks`, `impressions`, `ctr`, or `position` — default `clicks`).
2. The tool applies linear regression over the date range to classify keywords as rising, declining, or stable.
3. Rising keywords are opportunities to expand content coverage.
4. Declining keywords may indicate lost rankings, shifting intent, or seasonal decay.

**Action:** Rising keyword clusters → create or expand content. Declining clusters → audit the ranking page for freshness, relevance, and cannibalization.


## Keyword Cannibalization

Find pages competing against each other for the same queries — a hidden ranking killer.

**When to use:** User has multiple pages on similar topics and suspects they're splitting ranking signals.

**Workflow:**
1. Run `gsc_detect_cannibalization` with `siteUrl` and a required `startDate` / `endDate` (`YYYY-MM-DD`).
2. The tool identifies queries where 2+ URLs each receive impressions — a signal that Google is unsure which page to rank.
3. Review the returned URL pairs and the shared queries.
4. Decide: consolidate into one page (301 redirect), or differentiate intent so Google can distinguish them.

**Resolution options:**
- **Consolidate:** Merge the weaker page into the stronger one via 301. Update internal links.
- **Differentiate:** Rewrite each page to target a distinct search intent (informational vs. transactional, broad vs. specific).


## Lost Queries

Find keywords that dropped significantly between two periods — to diagnose ranking losses.

**When to use:** User wants to understand what drove a traffic decline or wants a period-over-period comparison.

**Workflow:**
1. Run `gsc_detect_lost_queries` with `siteUrl` and the two comparison periods as four separate dates: `previousStartDate`, `previousEndDate`, `currentStartDate`, `currentEndDate` (all `YYYY-MM-DD`).
2. The tool returns keywords where clicks dropped significantly in the current period vs the previous one. Tune with `minPreviousClicks` and `dropThresholdPercentage`. The current period is read with fresh (`dataState: "all"`) data, so a developing loss is caught at the range boundary sooner — and because partial recent data only *adds* clicks to the current aggregate, it never manufactures a false "lost" keyword.
3. Sort by absolute click loss to prioritize recovery effort.

**Follow-up:** For each lost keyword, run `gsc_inspect_url` on the ranking page to check for indexing or canonical issues.


## Featured Snippet Opportunities

Find queries in positions 2–5 that are prime candidates for a featured snippet.

**When to use:** User wants to win zero-click visibility or jump to position 0 without improving their backlink profile.

**Workflow:**
1. Run `gsc_detect_featured_snippets` with the property `siteUrl`. `startDate` / `endDate` are optional (default: last 90 days → today); `limit` caps candidates analyzed (default 10).
2. The tool filters keywords where the site ranks positions 2–5 — the sweet spot for snippet eligibility.
3. Queries phrased as questions ("how to", "what is", "why does") are highest priority.
4. Review the current page for a direct, concise answer at the top of the relevant section.

**Implementation:** Add a direct answer (40–60 words) immediately after the question heading. Use the exact query phrasing in the heading. If you ship multiple Q&A pairs on the page, render them with semantic HTML (`<details>`/`<summary>`) — FAQ rich results are deprecated and schema alone does not lift AI citations.


## SERP Features Gap

Identify missing structured data that's costing rich result eligibility on top-ranking pages.

**When to use:** User wants to improve SERP appearance without changing rankings.

**Workflow:**
1. Run `gsc_serp_features_gap` with the property URL.
2. The tool analyzes top-ranking pages and compares their current schema against what's eligible for the SERP features available in their niche.
3. Returns a prioritized list of missing schema types with estimated CTR uplift.

**Common gaps with active rich-result support:** Product schema with pricing/SKU, Review/AggregateRating, Recipe, VideoObject, Event, LocalBusiness, JobPosting, NewsArticle. Use `seo_schema_generator` (content-audit skill) to generate the correct JSON-LD.

**No longer recommended as SERP gap candidates:**
- FAQPage — FAQ rich results are deprecated for non-gov/health sites.
- HowTo — desktop rich results removed.


## More Search Lenses

Focused analyses on top of search analytics — each slices the same GSC data through a different lens. Reach for them when the user's question matches the angle.

- **`gsc_branded_split`** — branded vs non-branded traffic split (pass `brandTerms`). Use when the user asks how much traffic is brand recognition vs genuine discovery. High branded share → growth depends on non-branded queries; low → brand-awareness opportunity.
- **`gsc_discover_performance`** — Google Discover traffic by page, separate from web search. Use for content/news sites asking about Discover, or to explain traffic that isn't from search queries.
- **`gsc_search_appearance`** — performance broken down by SERP feature (rich result, video, AMP, review snippet…). Use to see which rich results actually drive clicks.
- **`gsc_device_gap`** — queries where the site ranks worse on mobile than desktop. Use when mobile traffic underperforms or for a mobile-first ranking review.
- **`gsc_country_opportunity`** — countries with high impressions but low CTR — untapped international demand. Use for international SEO prioritization.
- **`gsc_page_query_map`** — takes a `siteUrl` and maps the property's top 15 pages (`maxPages`, up to 100) to their top queries (`queriesPerPage`, default 5). Use to spot pages that lack focus (ranking for many unrelated intents) vs well-targeted pages, and to put a page behind a query the query-level tools returned. One call per site, not per page.
- **`gsc_page_changes`** — pages that newly started, or stopped, getting impressions between two periods. Page-level companion to `gsc_detect_lost_queries`; use to catch pages gained or lost after a deploy or migration.


## Raw Search Analytics

Pull clicks, impressions, CTR, and position data for custom analysis.

**When to use:** User needs a specific date range, dimension, or filter not covered by the detection tools above.

**Tool:** `gsc_search_analytics`

**Key parameters:**
- `siteUrl` — a bare domain (e.g. `example.com`), a URL-prefix property (`https://example.com/`), or a domain property (`sc-domain:example.com`). A bare domain is auto-resolved against the account's GSC properties (preferring `sc-domain:` when both exist) — you don't need to pass the exact format. This applies to every `gsc_*` tool in this skill.
- `startDate` / `endDate` — ISO date strings
- `dimensions` — array of `query`, `page`, `country`, `device`, `date`, `searchAppearance` (can combine multiple; default `['query']`)
- `type` — search type: `web` (default), `image`, `video`, `news`, `discover`, `googleNews`
- `rowLimit` — 1–25,000 rows (default 1,000)
- `dataState` — `final` (default) returns only finalized data; `all` includes fresh, still-incomplete data from the last ~2 days. Use `dataState: "all"` for **early detection** of traffic drops before Google finalizes the numbers.

**List available properties:** `gsc_list_properties` returns all GSC properties the API key has access to, with permission levels. (No parameters.)

**Live traffic right now:** `ga4_get_realtime` shows active users currently on the site and what they're viewing — separate from GSC's search-finalized data. Pass the GA4 `propertyId` (numeric, e.g. `123456789`, no `properties/` prefix); optionally override `dimensions` (default `['unifiedScreenName']`) and `metrics` (default `['activeUsers']`). Use it to confirm a spike from `gsc_detect_anomalies` is still happening, or to watch a launch land in real time. To find the right `propertyId`, run `ga4_list_properties` (no parameters) — it returns each GA4 property's ID, name, and site URL.

**Don't have GSC access to a site?** GSC tools only work for properties the account owns. For an unverified site (e.g. a competitor), use the public/technical tools instead — `seo_analyze_page`, `pagespeed_insights`, `seo_crawlability_audit`, `seo_geo_score`, and `crawl_site` need no Google access.
