---
name: site-audit
description: Full site audit, reporting, and task management skill for That SEO Agent MCP. Use this skill when the user asks for a complete SEO audit, wants to generate a shareable report, needs to track SEO action items, or wants an overview of a site's health across all dimensions. Triggers on tasks involving site-wide analysis, audit reports, SEO task lists, or overall site health checks.
license: MIT
compatibility: Requires the thatseoagent MCP server connected. Get your API key at thatseoagent.com/dashboard/settings.
metadata:
  author: thatseoagent
  version: "1.1.0"
---

# Site Audit

> **Requires** the thatseoagent MCP connected — [setup instructions](https://thatseoagent.com/docs/mcp).

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
- `siteUrl` (optional) — domain or GSC property URL (e.g. `example.com`). If omitted, uses your first registered site.
- `ga4PropertyId` (optional) — pass when prompted to resolve a GA4 disambiguation.

**Requires:** The site must be registered in the thatseoagent dashboard and have its GSC/GA4 connections configured for full data coverage.


## All-Properties Health Check

Run a health check across every GSC property at once — traffic trends, sitemap errors, and anomalies.

**When to use:** Agencies managing multiple sites, or users who want a morning dashboard across their entire portfolio.

**Tool:** `gsc_sites_health_check`

**What it checks per property:**
- Week-over-week click change
- Week-over-week impression change
- Sitemap error count
- Anomaly flags (significant drops in the last 7 days)

**Output:** A ranked list of properties sorted by health status — properties needing attention appear first. Use this to triage which sites need deeper investigation.


## Shareable Report

Generate a public, branded report URL to share with clients or stakeholders.

**When to use:** After completing an audit, to deliver findings to a client without giving them dashboard access.

**Tool:** `create_shared_report`

Call this after `run_site_audit` and all supplementary tools have returned results. Calling it earlier produces an incomplete report because the shared URL is generated from whatever data is available at the moment of the call.

**What it creates:**
- A public `/report/[id]` URL at thatseoagent.com
- Contains the full audit data in a clean, client-friendly format
- Expires after 14 days (regenerate as needed)
- Shows the site's open task list at the end of the report

**Correct workflow:**
1. `run_site_audit` — entry point, persists data to DB.
2. All supplementary tools in parallel — `pagespeed_insights` (mobile + desktop), `seo_analyze_page`, `seo_eeat_score`, `seo_content_analysis`, and any other relevant tools.
3. `create_shared_report` — only after all of the above have returned results.
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
- `get_tasks` — list all open and completed tasks for a site
- `create_task` — add a new action item
- `complete_task` — mark a task as done using its UUID
- `delete_task` — permanently remove a task

**`create_task` parameters:**
- `task` (required) — free text description of the action item
- `url` (optional) — page URL to associate the task with a specific page (e.g. `https://example.com/blog/post-1`). Omit for site-wide tasks.

**Examples:**
- Site-wide task: `create_task task="Fix canonical conflicts across blog section"`
- Page-level task: `create_task task="Rewrite title tag" url="https://example.com/pricing"`

Tasks appear in the thatseoagent dashboard and at the end of any shareable report generated for the site.

**Workflow after an audit:**
1. Run `run_site_audit` — review recommendations.
2. Run `create_task` for each high-priority fix, adding `url` when the issue is page-specific.
3. When a fix is deployed, run `complete_task` with the task UUID.

**Task format:** Each task has a `task` field (description), an optional `url` field (page association), and a `done` status. UUIDs are returned by `get_tasks` and `create_task`.


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
```

`create_shared_report` captures a snapshot of all data available when it runs — wait for Step 2 to complete before calling it.

**After the audit, drill deeper with specialized skills:**
- Technical issues → `technical-seo` skill
- Keyword opportunities → `gsc-insights` skill
- AI visibility gaps → `ai-visibility` skill
- Content improvements → `content-audit` skill
