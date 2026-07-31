---
name: audit-cadence
description: A repeatable 14-day SEO monitoring cadence that catches ranking drops, index-coverage errors, cannibalization, and traffic anomalies before they compound. Use when the user wants an ongoing or scheduled SEO review routine, or to track changes over time.
license: MIT
compatibility: Requires the thatseoagent MCP server connected. Get your API key at thatseoagent.com.
metadata:
  author: thatseoagent
  version: "1.1.4"
---

# Audit Cadence

> **Requires** the thatseoagent MCP connected — [setup instructions](https://thatseoagent.com/en/mcp).

A structured 14-day audit cycle for ongoing SEO monitoring. Run this sequence to catch issues before they compound — ranking drops, index coverage errors, cannibalization, and traffic anomalies all move faster than monthly reviews can catch.

---

## The 14-Day Cycle

### Days 1–2 — Traffic and ranking pulse

Run these in parallel at the start of each cycle:

```
gsc_search_analytics      → clicks, impressions, position — compare to prior 14 days
gsc_detect_anomalies      → flag sudden drops in clicks or impressions
gsc_detect_trends         → identify rising and falling queries over 90 days
ga4_run_report            → sessions, engagement rate, conversions by channel
ga4_ai_traffic            → sessions in GA4's own "AI Assistant" channel, by engine
```

**What to look for:**
- Any query losing more than 20% of clicks week-over-week → investigate immediately
- New queries entering the top 20 → check if existing content covers them or if a new page is needed
- AI traffic trend — is it growing, flat, or declining?

**Early-warning tip:** For fresh, still-incomplete data from the last 2–3 days, either add a `gsc_search_analytics` call with `dataState: "all"`, or pass `dataState: "all"` directly to `gsc_detect_anomalies` (it now accepts the param, defaulting to `"final"`). Fresh data surfaces a developing drop days before it's finalized — turning the biweekly pulse into an early-warning signal. Treat the most recent 1–2 days as provisional: they're partial, so the last point can read low even when nothing is wrong.

**GA4 reporting helpers** (use to make `ga4_run_report` precise and outcome-focused):
- `ga4_list_properties` — discover the account's GA4 properties and their IDs. Run this once during setup (or when `run_site_audit` / `ga4_run_report` reports a GA4 disambiguation) to get the `ga4PropertyId` to pass into the audit and report tools.
- `ga4_key_events` — list the events the business marked as conversions, so "conversions by channel" reflects what actually matters for this property.
- `ga4_metadata` — discover the dimensions and metrics available for the property, **including its custom ones**, before composing a report (no more guessing field names).
- `ga4_custom_definitions` — inspect the property's custom dimensions/metrics and their configuration.
- `ga4_check_compatibility` — validate a set of dimensions + metrics **before** running the report. GA4 forbids some field pairings (e.g. mixing certain event-scoped and session-scoped fields), and a bad combo returns an opaque 400. Pass the same `dimensions` and `metrics` you intend to query; it names exactly which fields clash so you fix the request in one step. Best used on custom fields, or before a large or repeated `ga4_run_report` / `ga4_pivot_report` where a failed call is costly.
- `ga4_pivot_report` — cross-tabulate metrics (e.g. channel × date, source × landing page) for clearer comparative views than a flat report. Name in `pivotFields` the dimension(s) you want to group by; every dimension you pass is queried either way, since GA4 requires each defined dimension to be used.
- If `ga4_run_report` rejects a dimension/metric combination it still returns which field is incompatible — but prefer `ga4_check_compatibility` to catch the clash before the report runs.

---

### Days 3–5 — Index and crawl health

```
gsc_index_coverage_analysis    → pages excluded, errors, crawled but not indexed
gsc_bulk_url_inspection        → spot-check key landing pages for index status
seo_robots_validator           → confirm AI bots (GPTBot, ClaudeBot, PerplexityBot) are not blocked
seo_canonical_audit            → catch canonical mismatches introduced by recent deploys
seo_hreflang_validator         → validate hreflang for multilingual sites (if applicable)
```

**What to look for:**
- Pages that should be indexed but aren't — check canonical, noindex, and crawl budget
- Newly blocked paths in robots.txt from recent deploys
- Canonical drift on pages that were recently edited

---

### Days 6–8 — Content and keyword health

```
gsc_detect_quick_wins          → pages just outside top 10 with high impression volume
gsc_detect_cannibalization     → competing pages splitting clicks for the same queries
gsc_detect_featured_snippets   → queries where you're close to or losing a featured snippet
seo_content_analysis           → readability, heading structure, internal link density
```

**What to look for:**
- Quick wins: pages ranking positions 8–15 with 500+ impressions — these need a targeted content pass
- Cannibalization: two or more pages competing for the same query → consolidate or differentiate
- Featured snippet opportunities: queries where you hold position 1–3 but don't own the snippet → restructure the answer

---

### Days 9–11 — Technical and performance

```
pagespeed_insights strategy="mobile"     → Core Web Vitals mobile
pagespeed_insights strategy="desktop"    → Core Web Vitals desktop
seo_crawlability_audit                   → redirect chains, broken links, crawl depth
seo_security_headers                     → security headers grade
```

**What to look for:**
- LCP regression after any recent deploy
- New redirect chains introduced by URL changes
- Security header gaps (X-Frame-Options, CSP, HSTS)

---

### Days 12–13 — AI visibility check

```
seo_geo_score              → run on top 5 pages by organic traffic
seo_eeat_score             → homepage + top landing pages
ai_visibility_score        → composite L1+L4 score
entity_mentions            → brand footprint check across Wikipedia, Wikidata, Reddit
```

**What to look for:**
- GEO score drops on pages you recently edited — check if inline citations or structured data were removed
- Entity mentions: is the brand gaining or losing off-site footprint?

---

### Day 14 — Report and tasks

```
run_site_audit             → refresh the full audit baseline (cache-first: returns the last audit if <7 days old, otherwise triggers a background refresh — call again in ~60s)
create_shared_report       → generate a shareable snapshot for stakeholders (auto-refreshes first if the audit is stale; the public link expires in 14 days)
create_task (×N)           → convert the top 3–5 findings into tracked tasks for the next cycle (each call needs siteUrl + task; add url for page-level fixes)
```

**Note:** `create_shared_report` guarantees a fresh audit backs the report — if the latest is missing, older than 7 days, or incomplete it runs `run_site_audit` itself first, and if a refresh is already in progress it asks you to retry in ~60s rather than snapshotting stale data. Running the cadence's other tools first is still good practice, but the report is never built from an outdated audit.

**Task params reminder:** `create_task` takes `siteUrl` (the same domain you pass to `run_site_audit`, e.g. `example.com`; a site `siteId` UUID also works) plus `task`; `url` is optional for page-specific items. To list or close tasks, `get_tasks` takes `siteUrl`, and `complete_task` / `delete_task` take the per-task `taskId` returned by those calls.

---

## Cycle summary table

| Days | Focus | Tools |
|------|-------|-------|
| 1–2 | Traffic + ranking pulse | `gsc_search_analytics`, `gsc_detect_anomalies`, `gsc_detect_trends`, `ga4_run_report`, `ga4_ai_traffic` |
| 3–5 | Index + crawl health | `gsc_index_coverage_analysis`, `gsc_bulk_url_inspection`, `seo_robots_validator`, `seo_canonical_audit` |
| 6–8 | Content + keyword health | `gsc_detect_quick_wins`, `gsc_detect_cannibalization`, `gsc_detect_featured_snippets`, `seo_content_analysis` |
| 9–11 | Technical + performance | `pagespeed_insights` (×2), `seo_crawlability_audit`, `seo_security_headers` |
| 12–13 | AI visibility | `seo_geo_score`, `seo_eeat_score`, `ai_visibility_score`, `entity_mentions` |
| 14 | Report + task creation | `run_site_audit`, `create_shared_report`, `create_task` |

---

## When to break the cadence

Run an unscheduled audit immediately if:
- A Google algorithm update is announced
- Traffic drops more than 15% in a single day
- A major site change is deployed (new URL structure, CMS migration, significant content removal)
- A competitor launches content targeting your core queries

Use `gsc_detect_anomalies` as the first tool — it flags what changed and narrows where to look.
