---
name: site-audit
description: Run a full multi-dimension SEO site audit, generate a shareable client report, and manage SEO tasks. Use when the user wants an overall site-health overview, an audit report to share, or to track and close SEO action items. Uses the thatseoagent MCP.
license: MIT
compatibility: Requires the thatseoagent MCP server connected. Get your API key at thatseoagent.com.
metadata:
  author: thatseoagent
  version: "1.2.2"
---

# Site Audit

> **Requires** the thatseoagent MCP connected — [setup instructions](https://thatseoagent.com/en/mcp).

Workflows for running full site audits, generating shareable reports, and managing SEO tasks using the thatseoagent MCP.


## Built-in Prompts

Three orchestration prompts are pre-loaded — use these as shortcuts instead of assembling the tools manually.

| Prompt | What it does |
|--------|-------------|
| `audit_site` | Runs `run_site_audit` + `create_shared_report` and returns a shareable URL |
| `find_quick_wins` | Runs `gsc_detect_quick_wins`, snippet detection, and SERP gap analysis |
| `track_fixes` | Reviews open tasks, runs an audit, and creates tasks for critical issues |

**Example usage:**
- `Run the audit_site prompt for example.com and give me the shareable report URL`
- `Use find_quick_wins on example.com — what are the easiest improvements I can make this week?`

Use these for fully automated workflows. Use the manual sections below when you need fine-grained control over individual steps.


## Full Site Audit

Get a complete SEO audit across 18+ dimensions — performance, technical, content, authority, and AI visibility — in a single call.

**When to use:** Starting point for any new site, onboarding a new client, or running a periodic health check.

**Tool:** `run_site_audit`

**What it returns:** A comprehensive cached audit including:
- PageSpeed scores (mobile + desktop) and Core Web Vitals
- Crawlability issues, canonical status, redirect chains
- E-E-A-T score across all four categories
- GEO score across 10 AI visibility categories
- robots.txt validation and AI crawler access
- Security headers grade
- llms.txt status
- AI traffic from GA4 (if connected)
- Entity mentions across AI platforms
- Hreflang validation (if applicable)
- GSC quick wins, anomalies, and trends (if GSC connected)

**Cache behavior:** Results are cached for 7 days. If the audit is fresh, it returns immediately. If stale or missing, it triggers a background refresh — call again in ~60 seconds to get results.

**Parameters:**
- `siteUrl` (optional) — a bare domain (e.g. `example.com`), a URL-prefix property (`https://example.com/`), or a domain property (`sc-domain:example.com`). A bare domain is auto-resolved against the account's GSC properties — you don't need the exact format. If omitted, uses your first registered site.
- `ga4PropertyId` (optional) — pass when prompted to resolve a GA4 disambiguation.

**Auditing a site you don't have GSC/GA4 access to:** This works. The technical/public checks — PageSpeed, on-page SEO, schema, crawlability, robots/llms.txt, security headers, E-E-A-T, GEO, and the site crawl — run for any reachable URL with no Google connection required. Only the GSC (search analytics, indexing) and GA4 (traffic) sections need access to that specific property. When they can't run, the audit **declares them explicitly** with a "Google data not available" note listing what was skipped and why — instead of silently dropping those sections. So you can audit a competitor or a prospect's site and still get the full technical/content picture.

**For full data coverage:** Connect the site's GSC/GA4 properties with a read-only Google sign-in (the site itself registers automatically the first time a tool runs against it) — that unlocks the search and traffic sections on top of the public checks.


## All-Properties Health Check

Run a health check across every GSC property at once — traffic trends, sitemap errors, and anomalies.

**When to use:** Agencies managing multiple sites, or users who want a morning overview across their entire portfolio.

**Tool:** `gsc_sites_health_check`

**What it checks per property:**
- Week-over-week click change
- Week-over-week impression change
- Sitemap error count
- Anomaly flags (significant drops)

**Freshness:** Anomaly detection reads fresh (`dataState: "all"`) data up to yesterday, but only *complete* days feed the statistical detector — the last ~2 still-settling days can't fire a false anomaly. When a fresh partial day has already fallen below the 14-day low, the property gets a clearly-labeled **provisional** watch (never escalated to critical), so a developing drop shows up in the morning overview days sooner without noise.

**Output:** A ranked list of properties sorted by health status — properties needing attention appear first. Use this to triage which sites need deeper investigation.


## Shareable Report

Generate a public, branded report URL to share with clients or stakeholders.

**When to use:** After completing an audit, to deliver findings to a client without giving them access to your account.

**Tool:** `create_shared_report`

`create_shared_report` builds the report from the site's persisted audit and **guarantees it is fresh**: if the latest audit is missing, older than 7 days, or incomplete (a tool failed, or GSC/GA4 was just connected), it runs a full `run_site_audit` first — respecting the per-site refresh limit — then snapshots the result. If a refresh is already in progress, it returns a "try again in ~60s" message instead of producing a report from stale data. A shared link therefore never reflects an outdated audit, so you can call it directly without running `run_site_audit` yourself first.

**What it creates:**
- A public `/report/[id]` URL at thatseoagent.com
- Contains the full audit data in a clean, client-friendly format
- Expires after 14 days (regenerate as needed)
- Shows the site's open task list at the end of the report

**Recommended workflow:**
1. `run_site_audit` — entry point, persists data to DB (optional; `create_shared_report` triggers this itself when the audit is stale or missing).
2. Supplementary tools as needed — `pagespeed_insights` (mobile + desktop), `seo_analyze_page`, `seo_eeat_score`, `seo_content_analysis`, and any other relevant tools.
3. `create_shared_report` — safe to call at any point; it refreshes first when the audit is stale.
4. Share the returned URL with the client.

**The report includes:** Performance scores, Core Web Vitals, technical health, E-E-A-T breakdown, GEO score, AI visibility checks, open tasks, and recommendations — all in a single shareable page.


## PageSpeed / Core Web Vitals

Run Google PageSpeed Insights for mobile and desktop scores and Core Web Vitals.

**When to use:** User wants current performance data outside of a full audit, or wants to check a specific page (not just the homepage).

**Tool:** `pagespeed_insights`

**Parameters:** `url` (required), `strategy` — `"mobile"` (default) or `"desktop"`

**What it returns:**
- Lighthouse scores: Performance, Accessibility, Best Practices, SEO (0–100)
- Core Web Vitals (field data from CrUX): LCP, CLS, INP, FCP, TTFB with Good/Needs Improvement/Poor ratings
- Failed audits with display values (e.g., "Reduce unused JavaScript — potential savings: 320 KiB")

**Interpreting scores:**
- Performance 90+ → Good. 50–89 → Needs work. < 50 → Critical.
- LCP < 2.5s → Good. CLS < 0.1 → Good. INP < 200ms → Good.
- Field data (CrUX) reflects real users. Lab data (Lighthouse) is a controlled test. Both matter.


## Task Management

Track SEO action items as structured tasks tied to a specific site or page.

**When to use:** After an audit, to convert recommendations into trackable tasks — for yourself or to assign to a team.

**Tools:**
- `get_tasks` — list all open and completed tasks for a site (identify the site by `siteUrl`)
- `create_task` — add a new action item (`siteUrl` + `task`)
- `complete_task` — mark a task as done using its `taskId`
- `delete_task` — permanently remove a task using its `taskId`

**Identifying the site:** the task tools take the same `siteUrl` you already use with `run_site_audit` (e.g. `example.com`) — no UUID lookup needed. A site `siteId` UUID is also accepted as an alternative. If the `siteUrl` doesn't match a registered site, the tool returns the list of your registered sites (it does not create one).

**`create_task` parameters:**
- `siteUrl` (preferred) — the site domain, e.g. `example.com`. Or `siteId` (the site UUID). Provide one.
- `task` (required) — free text description of the action item
- `url` (optional) — page URL to associate the task with a specific page (e.g. `https://example.com/blog/post-1`). Omit for site-wide tasks.

**`get_tasks` parameters:**
- `siteUrl` (preferred) — the site domain. Or `siteId` (the site UUID). Provide one.

**`complete_task` / `delete_task` parameters:**
- `taskId` (required) — the task UUID returned by `get_tasks` or `create_task` (this is the per-task UUID, not the site identifier)

**Examples:**
- Site-wide task: `create_task siteUrl="example.com" task="Fix canonical conflicts across blog section"`
- Page-level task: `create_task siteUrl="example.com" task="Rewrite title tag" url="https://example.com/pricing"`
- Mark done: `complete_task taskId="<task-uuid>"`
- List tasks: `get_tasks siteUrl="example.com"`

Tasks are managed through the MCP task tools (`get_tasks` / `complete_task`) and appear at the end of any shareable report generated for the site.

**Workflow after an audit:**
1. Run `run_site_audit` — review recommendations.
2. Run `create_task` for each high-priority fix — pass the same `siteUrl`, and add `url` when the issue is page-specific.
3. When a fix is deployed, run `complete_task` with the `taskId`.

**Task format:** Each task has a `task` field (description), an optional `url` field (page association), and a `done` status. Per-task UUIDs (used as `taskId` for `complete_task` / `delete_task`) are returned by `get_tasks` and `create_task`.


## Full Audit Workflow

Run this sequence for a new site or client onboarding:

```
Step 1 (sequential):
  run_site_audit                → entry point — persists full audit to DB

Step 2 (all in parallel):
  pagespeed_insights strategy="mobile"    → Core Web Vitals + Lighthouse mobile
  pagespeed_insights strategy="desktop"   → Core Web Vitals + Lighthouse desktop
  seo_analyze_page              → on-page meta, headings, canonical, schema
  seo_eeat_score                → E-E-A-T signals breakdown
  seo_content_analysis          → readability, heading structure, link density
  gsc_sites_health_check        → portfolio health (if managing multiple sites)

Step 3 (sequential — only after Step 2 is fully complete):
  create_shared_report          → generate client-ready shareable URL

Step 4 (after sharing the report):
  create_task (×N)              → convert top recommendations into tracked tasks
                                  (each call needs siteUrl + task; add url for page-level fixes)
```

`create_shared_report` guarantees a fresh audit backs the report — it runs `run_site_audit` itself when the latest is stale or missing — so Steps 1–2 are a recommendation, not a prerequisite.

**After the audit, drill deeper with specialized skills:**
- Technical issues → `technical-seo` skill
- Keyword opportunities → `gsc-insights` skill
- AI visibility gaps → `ai-visibility` skill
- Content improvements → `content-audit` skill
