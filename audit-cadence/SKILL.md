---
name: audit-cadence
description: Biweekly SEO audit cadence skill for That SEO Agent MCP. Use this skill when the user wants a structured, repeatable SEO monitoring routine — catching ranking drops, index issues, and keyword shifts before they compound. Triggers on tasks involving ongoing SEO monitoring, audit schedules, weekly or biweekly SEO reviews, or tracking changes over time.
license: MIT
compatibility: Requires the thatseoagent MCP server connected. Get your API key at thatseoagent.com.
metadata:
  author: thatseoagent
  version: "1.0.0"
---

# Audit Cadence

> **Requires** the thatseoagent MCP connected — [setup instructions](https://thatseoagent.com/docs/mcp).

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
ga4_ai_traffic            → sessions arriving from ChatGPT, Perplexity, Gemini, Claude
```

**What to look for:**
- Any query losing more than 20% of clicks week-over-week → investigate immediately
- New queries entering the top 20 → check if existing content covers them or if a new page is needed
- AI traffic trend — is it growing, flat, or declining?

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
run_site_audit             → refresh the full audit baseline
create_shared_report       → generate a shareable snapshot for stakeholders (only after all tools above are complete)
create_task (×N)           → convert the top 3–5 findings into tracked tasks for the next cycle
```

**Rule:** `create_shared_report` is always last. It captures whatever data is in the system at the moment it's called — run it before any other analysis tool and the report will be incomplete.

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
