---
name: gsc-insights
description: Google Search Console analysis skill for That SEO Agent MCP. Use this skill when the user asks about keyword performance, traffic drops, ranking opportunities, featured snippets, keyword cannibalization, or search trends. Triggers on tasks involving GSC data, search analytics, click-through rates, impressions, or organic search performance.
license: MIT
compatibility: Requires the thatseoagent MCP server connected. Get your API key at thatseoagent.com/dashboard/settings.
metadata:
  author: thatseoagent
  version: "1.0.0"
---

# GSC Insights

> **Requires** the thatseoagent MCP connected — [setup instructions](https://thatseoagent.com/docs/mcp).

Workflows for extracting actionable insights from Google Search Console data using the thatseoagent MCP.


## Quick Wins

Find high-impression keywords with low CTR — the fastest optimization opportunities on any site.

**When to use:** User wants to know what to fix first, or wants to improve CTR without creating new content.

**Workflow:**
1. Run `gsc_detect_quick_wins` with the site's GSC property URL.
2. The tool returns keywords above an impressions threshold (default: 100) where CTR is underperforming relative to position.
3. For each opportunity: the page ranking, the keyword, current CTR vs expected CTR at that position.
4. Prioritize by impressions × CTR gap — the highest-volume misses come first.

**What to do with the results:** Rewrite title tags and meta descriptions for the top 5–10 pages. The keyword is already getting eyes — the problem is the click.


## Traffic Anomaly Detection

Identify statistically significant traffic drops and spikes — distinguish real problems from noise.

**When to use:** User reports a traffic drop, or wants to audit the last 90 days for unusual patterns.

**Workflow:**
1. Run `gsc_detect_anomalies` with the property URL and a date range (default: last 90 days).
2. The tool uses modified Z-score analysis to flag dates where clicks or impressions deviated significantly from the trend.
3. Drops (negative Z-score) indicate potential indexing issues, algorithm updates, or content problems.
4. Spikes (positive Z-score) may indicate viral content, news mentions, or seasonal demand worth capitalizing on.

**Follow-up:** For drops, cross-reference the anomaly date with `gsc_inspect_url` on the affected pages to check indexing status.


## Keyword Trend Analysis

Find rising and declining keyword trends before they become obvious.

**When to use:** User wants to know which topics are gaining or losing traction in their niche.

**Workflow:**
1. Run `gsc_detect_trends` with the property URL.
2. The tool applies linear regression over the date range to classify keywords as rising, declining, or stable.
3. Rising keywords are opportunities to expand content coverage.
4. Declining keywords may indicate lost rankings, shifting intent, or seasonal decay.

**Action:** Rising keyword clusters → create or expand content. Declining clusters → audit the ranking page for freshness, relevance, and cannibalization.


## Keyword Cannibalization

Find pages competing against each other for the same queries — a hidden ranking killer.

**When to use:** User has multiple pages on similar topics and suspects they're splitting ranking signals.

**Workflow:**
1. Run `gsc_detect_cannibalization` with the property URL.
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
1. Run `gsc_detect_lost_queries` with the property URL and two comparison date ranges.
2. The tool returns keywords where clicks or impressions dropped significantly in the second period.
3. Sort by absolute click loss to prioritize recovery effort.

**Follow-up:** For each lost keyword, run `gsc_inspect_url` on the ranking page to check for indexing or canonical issues.


## Featured Snippet Opportunities

Find queries in positions 2–5 that are prime candidates for a featured snippet.

**When to use:** User wants to win zero-click visibility or jump to position 0 without improving their backlink profile.

**Workflow:**
1. Run `gsc_detect_featured_snippets` with the property URL.
2. The tool filters keywords where the site ranks positions 2–5 — the sweet spot for snippet eligibility.
3. Queries phrased as questions ("how to", "what is", "why does") are highest priority.
4. Review the current page for a direct, concise answer at the top of the relevant section.

**Implementation:** Add a direct answer (40–60 words) immediately after the question heading. Use the exact query phrasing in the heading. Add FAQ schema if multiple Q&A pairs exist on the page.


## SERP Features Gap

Identify missing structured data that's costing rich result eligibility on top-ranking pages.

**When to use:** User wants to improve SERP appearance without changing rankings.

**Workflow:**
1. Run `gsc_serp_features_gap` with the property URL.
2. The tool analyzes top-ranking pages and compares their current schema against what's eligible for the SERP features available in their niche.
3. Returns a prioritized list of missing schema types with estimated CTR uplift.

**Common gaps:** FAQ schema, HowTo schema, Review/AggregateRating, Product schema with pricing. Use `seo_schema_generator` (content-audit skill) to generate the correct JSON-LD.


## Raw Search Analytics

Pull clicks, impressions, CTR, and position data for custom analysis.

**When to use:** User needs a specific date range, dimension, or filter not covered by the detection tools above.

**Tool:** `gsc_search_analytics`

**Key parameters:**
- `siteUrl` — the GSC property (e.g., `https://example.com/`)
- `startDate` / `endDate` — ISO date strings
- `dimensions` — `query`, `page`, `country`, `device` (can combine multiple)
- `rowLimit` — up to 25,000 rows

**List available properties:** `gsc_list_properties` returns all GSC properties the API key has access to, with permission levels.
