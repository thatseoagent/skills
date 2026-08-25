# Changelog

All notable changes to the That SEO Agent plugin are documented here. This
project adheres to [Semantic Versioning](https://semver.org).

## [1.5.0] — 2026-08-25

Two halves. The first is packaging: the MCP server has been live and reachable
the whole time; what was missing was a manifest each catalogue knows how to read.
Issue #411 in the product repo tracks that plan across both repos — the OAuth
allowlist and the connect-page copy landed there, this is the half that lives
here. The second is a pass over all seven skills, reading each tool's actual
implementation rather than its name, and correcting every place a skill promised
more than the tool delivers.

### Added
- **`.cursor-plugin/plugin.json`** — the Cursor manifest, needed for the
  Marketplace and for Grok Bot, which is Cursor's cloud agent. It declares the
  seven skills by explicit path because they sit at the repo root, and Cursor
  replaces folder discovery when a manifest names paths.
- **`plugin.json`** at the root — the portable [Agent Plugins](https://agent-plugins.org)
  manifest. Deliberately not a copy of `.claude-plugin/plugin.json`, which stays
  where Claude expects it.
- **`mcp.json`** at the root, alongside the existing `.mcp.json`. Cursor
  discovers the former, Claude and Grok Build the latter; both name the same URL
  and neither carries a key.
- **`server.json`** — the descriptor the official MCP Registry publishes from.
  Not submitted by this release: the `com.thatseoagent/seo` namespace needs a DNS
  TXT record proving the domain, which is Ángel's to add.
- **`skills/`, seven symlinks to the folders already at the root.** Cursor,
  Grok Build and the Agent Plugins convention all default to scanning `skills/`.
  Moving the folders there would have broken the Claude plugin, which points at
  `./site-audit/` and its siblings, so the directory is links rather than a move
  and every client finds the same seven skills once.
- **README sections for Grok, Grok Build and Cursor**, including the fallback
  each one offers while the marketplace listings are pending, and the reason not
  to paste an API key into any of them: the server speaks OAuth with dynamic
  client registration, so those clients open a browser instead.
- **README: "What this plugin is, and what reviews it".** The plugin is a thin
  package pointing at a server that is not in this repo, and the marketplaces
  carrying it do not vet third-party plugins. Both facts belong in the README
  rather than in a reviewer's assumptions. The tool list stays in the server card
  so it cannot go stale here.

### Changed

Every skill bumped: `ai-visibility (1.4.0 → 1.5.0)`, `audit-cadence (1.1.4 →
1.2.0)`, `content-audit (1.3.0 → 1.4.0)`, `content-checklist (1.3.0 → 1.4.0)`,
`gsc-insights (1.3.1 → 1.4.0)`, `site-audit (1.3.0 → 1.4.0)`, `technical-seo
(1.3.1 → 1.4.0)`.

- **The reachability gate now says what still answers on a non-2xx**, in all five
  skills that carry it. "Report the status and stop" was too blunt: `seo_robots_validator`
  and `seo_security_headers` do not depend on the page's body and answer anyway,
  alongside `seo_crawlability_audit`. The gate stops the content tools, not the audit.
- **`crawl_site` is a single-page crawl, and `technical-seo` said "Full Site
  Crawl".** The tool fetches exactly one page; its cross-page sections — broken
  links, click depth, duplicate titles and descriptions — report `n/a` at one
  page. The section is renamed, its real value named (it is the only tool that
  returns internal link *targets* rather than a count), and site-wide HTTP health
  is pointed at `gsc_index_coverage_analysis`.
- **`gsc_detect_quick_wins` returns queries, not pages, and reads one window, not
  two** — `gsc-insights` and `audit-cadence` both told the agent to go rewrite
  "the top 5–10 pages" from an output that names no URL. Map the query to its page
  with `gsc_page_query_map` first; ask `gsc_detect_trends` or
  `gsc_detect_lost_queries` what changed.
- **`gsc_page_query_map` takes a `siteUrl`, not a page** — three skills implied
  otherwise, so an agent would call it once per page and re-run the same site-wide
  query each time. It maps the property's top 15 pages (`maxPages`, up to 100) in
  one call.
- **`create_shared_report` is no longer described as a freshness guarantee**, in
  `site-audit` and `audit-cadence`. It refreshes when it can; when the refresh is
  blocked — refresh limit spent, or the site refusing to be read — it publishes
  the last audit that succeeded and states the reason and that audit's date. A
  link is not proof the data behind it is current.
- **`run_site_audit`'s four non-audit answers documented** in `site-audit` and
  `audit-cadence`: refresh in progress, refresh limit spent, the site refusing to
  be read (a WAF answering 403 to our User-Agent is a finding in its own right),
  and the plan's Site Limit. Each is an answer to relay in one line, not an error
  to retry into.
- **Two site-audit dimensions are weaker inside the audit than the tool that owns
  them.** The pipeline calls `seo_hreflang_validator` with `checkBidirectional`
  and `checkAccessibility` off, so an audit cannot speak to reciprocity or whether
  alternates resolve — the two checks most often wrong. Index coverage samples 50
  sitemap URLs, not the tool's default 100. Noted in `site-audit` and
  `technical-seo`.
- **`entity_mentions` has three states per platform, not two** — present, absent,
  and *not evaluated* when the platform refused us (Reddit rate-limits
  unauthenticated search; LinkedIn answers HTTP 999). `ai-visibility` and
  `audit-cadence` now forbid turning a not-evaluated into a missing mention on the
  user's fix list.
- **`seo_eeat_score` scores one page, not a site.** It reads that URL's own
  signals plus whether it *links to* About, contact and privacy — it never opens
  the author or About page to judge what is on it. So "weak expertise" is a verdict
  on the URL scored, and the fix is there.
- **`seo_llms_txt` probes a bounded sample of the links the file declares**, and
  the probed-out-of-declared fraction has to be read before relaying the score. A
  200 is not a pass: a link resolving to the homepage shell is reported broken,
  because a single-page app answers every unknown path that way.
- **`pagespeed_insights` returns the first 10 failed audits only**, with a count of
  the rest, so "10 failed audits" is a floor. A URL with too little Chrome traffic
  gets no field data — an absence of evidence, not a passing grade.
- **`run_page_audit` is now the routed default for a page**, in `site-audit`,
  `content-audit` and `content-checklist`. Three levels exist: a Site audit stored
  per Site, a page audit stored per URL and readable with `get_page_audits`, and
  the individual `seo_*` results, which live in a temporary cache and are gone by
  next week. When the user names a URL, audit the URL. `run_page_audit` also never
  registers a Site, so a question about one page cannot quietly spend a Site-Limit
  slot the way `run_site_audit` does.
- **`gsc_rich_results` added to the content checklist** as the post-publish check
  `seo_schema_detection` cannot make: what Google actually detected on the URL, not
  what the markup declares.
- **`seo_crawlability_audit` prints the redirect chain hop by hop**, not just the
  count — so "which hops?" is answered by reading its output.
- **The em-dash rule split out of the AI-tell checklist item** in
  `content-checklist`, because it is a house rule with two different settings:
  none at all in Spanish copy, rare and deliberate in English.
- **The character-count note in `content-audit` now states the rule instead of
  citing an internal repo path** readers of this plugin cannot open.

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
