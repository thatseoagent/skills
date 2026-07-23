# Changelog

All notable changes to the That SEO Agent plugin are documented here. This
project adheres to [Semantic Versioning](https://semver.org).

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
