# Changelog

All notable changes to the That SEO Agent plugin are documented here. This
project adheres to [Semantic Versioning](https://semver.org).

## [1.4.0] — 2026-07-31

Two corrections, both found by validating the MCP server against Google's own
documentation rather than against our assumptions about it.

### Changed
- **`ai-visibility (1.3.0 → 1.4.0)`** — GA4 classifies AI traffic itself. When it
  recognises the referrer as an assistant it assigns `medium = ai-assistant`,
  campaign `(ai-assistant)`, and the **AI Assistant** default channel group.
  `ga4_ai_traffic` now counts that classification first and falls back to a host
  list only for engines Google does not recognise yet, so the skill describes it
  that way and states the split when both contribute. Measured on a live
  property, the old referral-only reading found 2 of 100 AI sessions.
  `references/citations-vs-recommendations.md` updated to match: the visible
  slice is read off Google's channel, and is still a floor.
- **`audit-cadence (1.1.3 → 1.1.4)`** — same correction to the `ga4_ai_traffic`
  one-liner. `ga4_pivot_report` gains the note that GA4 requires every defined
  dimension to be used, so a dimension left out of `pivotFields` is still
  queried rather than rejected.
- **`content-audit (1.2.0 → 1.3.0)`**, **`content-checklist (1.2.0 → 1.3.0)`**
  and **`technical-seo (1.3.0 → 1.3.1)`** — the skills stopped teaching rules the
  analyzers had already dropped. An agent reading them handed the user advice the
  product's own report no longer makes, which is worse than never having done the
  cleanup: the disagreement was internal.

### Removed
- **Character counts for titles and meta descriptions.** Google truncates a title
  to fit the device width, not to a count, and publishes no limit for either. The
  guidance is now to front-load the subject so it survives being cut, and to make
  each description unique — uniqueness is the part Google actually asks for.
- **"Exactly one H1" as an SEO defect.** Google states heading order and count do
  not affect ranking. A missing H1 is still worth raising; a second one is an
  accessibility matter (WCAG 2.2 §1.3.1) and is now labelled as one, as is
  heading hierarchy, which was being sold as SEO.
- **Word-count thresholds** — `< 300 words`, `< 600 words`, and "match the top 3
  ranking pages ± 10%". Google publishes no minimum. Briefs are scoped by the
  sub-topics that have to be covered, and a short page is reported as an
  observation worth a look rather than a defect to fix by adding words.
- **`HowTo` as a rich result to aim for**, joining `FAQPage`. Google retired
  both, so proposing them promised an appearance that no longer exists.
  `content-checklist` already handled `FAQPage` correctly; `HowTo` had been
  missed.

## [1.3.0] — 2026-07-30

### Added
- **Reachability gate guidance** across `site-audit (1.2.2 → 1.3.0)`,
  `technical-seo (1.2.0 → 1.3.0)`, `ai-visibility (1.2.0 → 1.3.0)`,
  `content-audit (1.1.0 → 1.2.0)` and `content-checklist (1.1.0 → 1.2.0)`.
  An audit now starts by confirming the URL returns 2xx; on a non-2xx it reports the
  status and stops. The content tools enforce this themselves, so the guidance
  explains the ordering rather than creating it. `seo_crawlability_audit`,
  `seo_robots_validator` and `seo_security_headers` deliberately still answer on a
  non-2xx, because their subject is not the page's content.
- **Page Kind awareness** in the same five skills. What a page owes now follows what
  the page is: a homepage owes `WebSite` + `Organization` and is not missing
  `Article` (it is not a dated, authored piece) or `BreadcrumbList` (a site root has
  no ancestors to list). A check marked `n/a` does not apply to that kind and is not
  a gap, and GEO scores are normalised per kind so they are not comparable across
  kinds. The publishing entity may be an `Organization` **or** a `Person`.

### Changed
- **Descriptions trimmed in all seven skills.** Dropped the trailing "Uses the
  thatseoagent MCP." — it is already in each skill's `compatibility` field and in the
  body, and a description is the one place that costs context on every turn.
- **`content-audit (1.1.0 → 1.2.0)`** no longer claims "getting cited" as a trigger.
  It collided with `ai-visibility`'s "AI citations", leaving the agent to pick blind
  between two model-invoked skills. Citations belong to `ai-visibility`.
- **`audit-cadence (1.1.2 → 1.1.3)`** and **`gsc-insights (1.3.0 → 1.3.1)`** —
  description trim only.

### Removed
- **The tool count from the plugin and marketplace descriptions and the README.**
  They advertised 57; the registry exposes 58. Rather than correct a number that
  goes stale on the next tool, the count is gone — the same call made for the
  website copy. `docs/mcp.md` in the server repo remains the one place that states
  an exact figure.

## [1.2.0] — 2026-07-16

### Added
- **ai-visibility (1.0.1 → 1.2.0)**
  - New reference `references/citations-vs-recommendations.md` — the AI visibility
    ladder (retrieved → cited → mentioned → recommended), mapped to our L4/L3 layers,
    with the self-promotional-listicle risk and a measurement triad.
  - New "Query Fan-Out" section (cover the topical cluster, not one keyword; tied to
    `gsc_page_query_map` / `gsc_detect_trends`).
  - New "Machine-Readable Files for AI Agents" section (`/pricing.md`, `.well-known`
    catalogs, OKF with the honest no-ranking-signal caveat, agentic accessibility).
  - Page-type-aware and EN/ES language-aware scoring notes across the GEO, E-E-A-T,
    and composite AI Visibility scores.
- **content-audit (1.0.1 → 1.1.0)**
  - New reference `references/schema-status.md` — the canonical structured-data
    deprecation timeline (FAQ, HowTo), the Ahrefs 2026 causal study on schema vs AI
    citation, and which types still earn documented rich results.
- **content-checklist (1.0.1 → 1.1.0)**
  - New reference `references/ai-writing-detection.md` — em dashes and the word/phrase/
    structure patterns that read as AI-generated, with the Spanish "no em dashes" house rule.
  - New "Copy quality" checklist item pointing to it.
- **gsc-insights (1.2.1 → 1.3.0)**
  - New "From Data to Content Plan" section: buyer-stage query mapping, a
    prioritization scoring model (40/30/20/10), and off-GSC ideation sources.
  - `dataState: "all"` early-detection notes across anomaly and lost-query detection;
    bare-domain `siteUrl` auto-resolution; competitor / no-GSC-access guidance.
- **site-audit (1.2.1 → 1.2.2)**
  - Cache-first `run_site_audit` and `create_shared_report` freshness guarantee; explicit
    "Google data not available" declaration when auditing sites without GSC/GA4 access;
    `gsc_sites_health_check` provisional-watch freshness; expanded task-management params.
- **audit-cadence (1.1.1 → 1.1.2)**
  - Early-warning `dataState: "all"` tip on the Days 1–2 pulse; `ga4_check_compatibility`
    guidance; `create_shared_report` freshness note and task-param reminders.
- **technical-seo (1.1.1 → 1.2.0)**
  - New reference `references/international-seo.md` — sourced evidence for hreflang,
    canonical + i18n, international sitemaps, URL structure, and locale content quality
    (the "why" behind `seo_hreflang_validator`, plus the Next.js self-reference caveat).
  - Daily per-site inspection budget, 7-day per-URL cache, and deferred-URL model across
    `gsc_bulk_url_inspection`, `gsc_index_coverage_analysis`, and `gsc_sitemap_url_inspection`;
    new "Traffic by Indexing State", "Crawl Freshness", and "Rich Results" sections.
- README: skills.sh badge.

### Changed
- **Skill review pass (all 7 skills)** — applied the writing-great-skills discipline:
  - Rewrote every `description` to one-trigger-per-branch, dropping the duplicated
    "Use when… / Triggers on…" restatements and the redundant "…skill for That SEO
    Agent MCP" identity opener (kept a short MCP tag for invocation reach).
  - **Single source of truth for schema deprecations**: the FAQ/HowTo/Ahrefs-2026
    timeline now lives only in `content-audit/references/schema-status.md`; the mentions
    in ai-visibility, content-checklist, and gsc-insights were trimmed to minimal
    standalone claims, removing the drifting hard-coded dates.
  - Deduplicated ai-visibility: consolidated the "directional" scoring caveat and removed
    the L4 content-structure fixes that were restated verbatim in the closing checklist.
  - Bumped the plugin to 1.2.0.

## [1.0.0] — 2026-05-31

### Added
- Initial plugin packaging for Claude Code and Claude Cowork.
- Bundled `thatseoagent` MCP server (`.mcp.json`) with OAuth auto-connect — no
  API key entry required; users authenticate in the browser on enable.
- Self-hosted marketplace (`thatseoagent-skills`) for one-line install:
  `/plugin marketplace add thatseoagent/skills` then
  `/plugin install thatseoagent@thatseoagent-skills`.
- All 7 skills exposed under the `thatseoagent` namespace via the manifest
  `skills[]` paths, keeping the existing `npx skills add` distribution intact.
