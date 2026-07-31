---
name: ai-visibility
description: Improve how a brand appears in AI-generated answers (ChatGPT, Perplexity, Google AI Overviews, Claude, Gemini). Use when the user asks about GEO/generative-engine optimization, AI citations, E-E-A-T signals, llms.txt, AI-crawler access, AI engine traffic, or brand entity visibility.
license: MIT
compatibility: Requires the thatseoagent MCP server connected. Get your API key at thatseoagent.com.
metadata:
  author: thatseoagent
  version: "1.3.0"
---

# AI Visibility

> **Requires** the thatseoagent MCP connected — [setup instructions](https://thatseoagent.com/en/mcp).

Workflows for improving how your brand appears in AI-generated answers (ChatGPT, Perplexity, Google AI Overviews, Claude, Gemini) using the thatseoagent MCP.



**Gate first.** An audit starts by confirming the URL returns 2xx. On a non-2xx,
report the status and stop: the content tools refuse it anyway, and a 404 still
serves a body, so scoring one would describe an error page. Reach for
`seo_crawlability_audit` to diagnose a URL that looks broken — it answers whatever
the URL returns. And read which **Page Kind** the audit identified before relaying
a gap: a homepage owes `WebSite` + `Organization`, not `Article`, and a check
marked `n/a` does not apply to that kind rather than being a gap.

---

## The AI Visibility Stack

AI visibility is a four-layer stack powered by three mechanisms. Each layer compounds the one below it.

| Layer | What it means | Mechanism | Primary tool |
|-------|--------------|-----------|-------------|
| **L1 — Entity Establishment** | AI resolves your brand as a real entity before retrieving anything | Knowledge Graph (K) | `ai_visibility_score`, `seo_eeat_score` |
| **L2 — Entity Depth** | AI describes you confidently from training memory | Training (T) | Earned media (off-tool) |
| **L3 — Category Citation** | AI recommends you for "best X in Y" queries | Retrieval (R) | Editorial/review placements (off-tool) |
| **L4 — Informational Citation** | AI cites your content as a source for topic queries | Retrieval (R) | `ai_visibility_score`, `seo_geo_score` |

**Three mechanisms** power the stack: **K** (Knowledge Graph — structured entity data), **T** (Training — what AI learned at cutoff, permanent), **R** (Retrieval — real-time web search). A single action can trigger multiple mechanisms simultaneously.

This skill audits **L1 and L4** — the layers measurable directly from your site. L2 and L3 require off-site investment (use `entity_mentions` for a proxy read on L2 footprint).

> **Cited ≠ recommended.** L4 (being cited as a source) and L3 (being recommended onto the buyer's shortlist) are governed by different systems: citation by your content's usefulness, recommendation by web-wide consensus you mostly don't control. Conflating them leads emerging brands to publish self-ranked buyer's guides that get cited while the answer recommends competitors. Full breakdown, data, and the measurement ladder: **references/citations-vs-recommendations.md**.

## Query Fan-Out

Google's AI features (AI Overviews / AI Mode) don't just answer the query the user typed — they generate several related queries concurrently under the hood and synthesize across all of them. Google's own example: "how to fix lawns" fans out to herbicides, chemical-free removal, weed prevention, and more.

**Implication for the audit:** targeting one page per exact keyword is weaker than covering the whole **topical cluster**. A page that comprehensively answers a parent topic (sub-questions included) is retrievable for the fan-out variants too.

**How to work it with the MCP:**
- `gsc_page_query_map` — see the full set of queries a page already ranks for (reveals whether one page is trying to cover a whole cluster, or a cluster is scattered across pages).
- `gsc_detect_trends` — surface the rising sub-topics worth folding into the cluster.
- Before optimizing a page, brainstorm the 5–10 related queries the AI is likely to fan out to, and confirm the page (or a linked cluster page) answers each.

## GEO Score Audit

Measure content signals correlated with AI citation — a directional heuristic based on available research.

**When to use:** User wants a structured baseline of on-site content and technical factors before making changes.

**Tool:** `seo_geo_score`

**Important caveat:** this score is **directional**. It measures proxy signals — structured data, content structure, E-E-A-T, crawler access — that peer-reviewed research (Princeton KDD 2024) found correlated with higher inclusion in AI answers. A higher score means improved factors, not guaranteed citation. (Full framing under *AI Visibility Score → How to report the score to the user*.)

**What it measures (10 categories):**
- Structured Data — schema markup that helps AI parse your content
- Content Freshness — how recently the page was updated
- Content Structure — headings, lists, tables — formats AI can extract from
- AI Crawler Access — whether AI bots can reach the page
- Author E-E-A-T — author credentials and expertise signals
- Technical — speed, mobile, Core Web Vitals
- Content Citability — statistics, quotes, definitions AI systems cite
- Citation Signals — external mentions and backlinks from authoritative sources
- Freshness Signals — publication dates, timestamps, recent content
- Query Optimization — how well the page matches conversational queries

**Interpreting results:** The tool returns per-category scores with specific failed checks and recommendations. Fix the lowest-scoring categories with the highest weight first. Re-run monthly and pair with manual testing (run target queries in ChatGPT, Perplexity, and Google AI Overviews to see if your content appears).

**Page-type-aware scoring:** checks that don't apply to the page (e.g. Article freshness on a homepage) are marked N/A and excluded from **both** the numerator and the denominator; the output shows the applicable denominator (`Applicable: X/Y`). A homepage scores lower but honest as a result — if a score dropped after this landed, that's the correction, not a regression.

**Language-aware (EN + ES):** the scorer detects the vertical, page type, entity pages, and content signals (definition patterns, source attribution, statistics, author bylines, listicle/summary structure) in both English and Spanish. A well-optimized Spanish page is scored fairly; a low score reflects a real gap, not an English-only heuristic missing localized copy.

## E-E-A-T Score Audit

Measure the Experience, Expertise, Authoritativeness, and Trustworthiness signals on a page or site.

**When to use:** User is in a YMYL (Your Money, Your Life) niche, or wants to improve AI citation credibility signals.

**Tool:** `seo_eeat_score`

**What it measures:**
- **Experience** — first-hand experience signals (case studies, personal examples, original data)
- **Expertise** — author credentials, bio pages, bylines, professional qualifications
- **Authoritativeness** — external mentions, linked citations, brand presence signals
- **Trustworthiness** — HTTPS, contact information, privacy policy, review signals

**Key fixes that move the needle:**
1. Add a named author with a bio page to every piece of content
2. Include first-party data or original research where possible
3. Add `Person` schema to author bio pages with `sameAs` links to LinkedIn/professional profiles
4. Ensure an About page with named team members exists

> **Localized sites:** About/team, contact, privacy, and press pages are detected schema-first (`AboutPage`/`ProfilePage`/`ContactPage`, `Organization.contactPoint`) and then by multilingual slug/text (`/acerca-de`, `/nuestro-equipo`, `/contacto`, `/prensa`… across EN/ES/FR/DE/PT/IT). A Spanish site does not need to rename its URLs to `/about` to get credit — don't recommend anglicizing them.

## llms.txt Check

Audit and generate the site's `/llms.txt` file — a proposed convention for AI crawler guidance.

**When to use:** User wants to verify, improve, or create an `/llms.txt` file to improve AI crawler access and citation rates.

**Tool:** `seo_llms_txt`

**What it checks:**
- Whether `/llms.txt` exists at the domain root (HTTP 200 vs 404)
- Completeness score (0–100) across four criteria: title heading, description blockquote, 3+ absolute content links, and an `## Optional` section
- Whether `/llms-full.txt` (extended spec variant) also exists
- AI bot access via a reminder to run `seo_robots_validator`

**What it generates:**
When the file is missing OR scores below 40/100, the tool automatically fetches the site's real title, meta description, and sitemap URLs to generate a **ready-to-use `llms.txt`** — not a generic placeholder. URLs are categorized into Key Content, Blog, and Documentation sections.

**Parameters:**
- `url` (required) — the site homepage
- `generate` (optional, boolean) — pass `true` to force a fresh generated template even when an existing file scores ≥ 40/100

**Workflow:**
1. `seo_llms_txt url="https://example.com"` — audit existing file and get score
2. If score < 100: review the issues list and the generated template (auto-shown when score < 40)
3. If score ≥ 40 and you want a new template: `seo_llms_txt url="https://example.com" generate=true`
4. Copy the generated content → save as `/llms.txt` at the site root
5. Run `seo_robots_validator` to confirm AI bots (GPTBot, ClaudeBot, PerplexityBot) are not blocked

**What llms.txt is:** A format proposed by Jeremy Howard / Answer.AI in September 2024 that gives AI systems a curated summary of your site's content and structure. None of the major AI platforms (Google, OpenAI, Anthropic, Perplexity) have publicly confirmed they use it for citation decisions. Google's official AI optimization guide (May 2026) explicitly tells site owners they can **ignore** AI-specific markup files. Add it only if a specific partner integration requests it — do not prioritize it over inline citations, content quality, and AI crawler access, which have stronger evidence behind them.

## Machine-Readable Files for AI Agents

Beyond `llms.txt`, autonomous AI agents increasingly evaluate and compare products *before* a human visits the site. If pricing, specs, or capabilities are locked behind JavaScript rendering or a "contact sales" wall, the agent can't read them and recommends a competitor whose data it can parse.

**Same caveat as llms.txt:** Google says these files are **not required** for AI Overviews / AI Mode. Their value is with non-Google engines (ChatGPT, Claude, Perplexity) and agentic buyers — they don't hurt Google, they're just clean, parseable data.

| File | Purpose |
|------|---------|
| `/pricing.md` (or `/pricing.txt`) | Tiers, limits, and prices in plain text an LLM can parse with no rendering or login. Use consistent units; keep it in sync with the real pricing page. |
| `/.well-known/*` catalogs | Machine-readable capability/entry-point manifests (e.g. an AI/tool catalog derived from the live tool list so it can't drift). |
| **OKF** (`/okf/`) | Open Knowledge Format, Google-backed spec (June 2026) representing site content as cross-linked Markdown with YAML frontmatter. **No confirmed AI-search ranking signal today** — treat it as protocol-layer registration like early schema.org. Optional; skip unless a partner asks. |

**Agentic accessibility (what actually matters most here):** render meaningful content without heavy JS gymnastics, use semantic HTML (`<main>`, `<nav>`, `<article>`, proper heading order, `alt` text), keep a clean accessibility tree, and put anything a buying agent needs — pricing, specs, contact — on a public, indexable page. Confirm AI crawler access with `seo_robots_validator`.

## AI Visibility Score

Get a composite 0–100 score measuring a site's overall AI visibility across the L1 and L4 layers of the stack.

**When to use:** Starting point for any AI visibility engagement — gives a single number and a prioritized action list. Run before any other tool so the score becomes the baseline for tracking progress.

**Tool:** `ai_visibility_score`

**What it measures:**

- **L1 Entity Establishment (Knowledge Graph mechanism)** — Wikidata presence, Google Knowledge Graph entity, `Organization`/`LocalBusiness` schema (with `name`, `url`, and `sameAs` to 2+ identity platforms), vertical directory listings, entity-name consistency across `og:site_name` and schema, and an `/llms.txt` file. This is a **gating step, not a ranking step**: AI resolves whether your entity exists before it retrieves anything. A failed L1 limits every other layer. (Note: `FAQPage` was previously listed here — removed after Google's FAQ deprecation and the Ahrefs 2026 causal study showing no AI citation lift from schema alone.)
- **L4 Informational Citation (Retrieval mechanism)** — content structure for AI extraction, AI bot access, front-loading, definition patterns, question-based headings, statistics density, **named-entity density** (~20.6% in cited text vs ~5–8% normal), and freshness (recency favored within ~60 days for ChatGPT/Perplexity; Google AI Mode tolerates older). Research across 1.2M ChatGPT responses shows 44.2% of citations come from the first 30% of a page. An 800-word page gets 50%+ grounding coverage from AI; a 4,000-word page gets just 13%.

**Language-aware (EN + ES):** vertical detection, entity-page detection (About/team, contact, press), and the L4 content signals work in both English and Spanish, so a localized site is scored fairly rather than defaulting to "generic" / missing.

**Why L2 and L3 are off-tool:** L2 (Entity Depth — what AI "knows" about you from training) and L3 (Category Citation — editorial listicles and review sites) require off-site investment. Use `entity_mentions` for a proxy read on L2 footprint.

**What it returns:**
- A 0–100 composite score with per-layer breakdown (L1 and L4 separately)
- Passed and failed checks across both layers
- Prioritized action items ranked by estimated impact

**Target score:** 70+ indicates strong on-site signals. Below 40 suggests significant gaps in entity establishment or content structure. These thresholds are directional — no platform has validated them against actual citation rates.

**How to report the score to the user — always frame it as directional:**
There is no AI equivalent of Google Search Console or Bing Webmaster Tools. No platform (OpenAI, Google, Anthropic, Perplexity) publishes a citation-scoring standard, so this number is a **best-effort heuristic built from public research, not a measurement of truth**. When you present a score:
- Call it directional/orientative, never definitive. A higher score means improved factors that research *correlates* with citation — not a guarantee.
- Note that weights and thresholds change as the evidence does, so re-running over time matters more than any single number.
- Pair it with **manual testing**: have the user run their real target queries in ChatGPT, Perplexity, and Google AI Overviews and check whether they actually appear. That's the closest thing to ground truth available today.
- For the full methodology, source list, and the honest disclaimer, point them to **thatseoagent.com/how-we-score-ai-visibility**.

**Quick self-test:** Ask ChatGPT *"What is [brand name]?"* — if the answer is vague, hedged, or wrong, L1 entity resolution is failing. That's the fastest proxy for a low score before running the tool.

**High-impact fixes after the audit:**
- Add `Organization` or `LocalBusiness` schema to the homepage
- Add `Person` + `sameAs` schema to author bio pages to strengthen author authority signals
- Build out active review profiles (G2, Trustpilot, Yelp — matched to your vertical) — these correlate with ~3x higher ChatGPT citation (ConvertMate)
- Ensure consistent entity name across all platforms (no "Brand Inc." vs "Brand LLC" variations)

(For the L4 content-structure fixes — first-30% placement, word count, entity density — see the checklist at the end of this skill.)

## Entity Mentions Audit

Check whether the brand is mentioned across the off-site platforms AI systems use as training and grounding sources.

**When to use:** User wants to understand their brand's off-site entity footprint — the L2/L3 layers that are harder to build but compound over time.

**Tool:** `entity_mentions`

**What it checks:**
- **Wikipedia** — article presence and brand mention count
- **Wikidata** — entity node with sameAs links to authoritative identifiers
- **Reddit** — subreddit or community mentions (indicates topical authority)
- **LinkedIn** — company page presence
- **YouTube** — channel or branded video content
- **GitHub** — repository presence (relevant for developer-facing brands)

**What it returns:** A per-platform status (found/not found), mention count where applicable, and the URL discovered.

**Why it matters:** AI systems (ChatGPT, Perplexity, Gemini) pull from Wikipedia, Reddit, and crawled web content. A brand absent from these sources has no grounding layer — even well-optimized on-site content won't get cited if the brand isn't recognized as an entity. Building an off-site entity footprint is the highest-leverage long-term AI visibility investment.

## AI Engine Traffic

Measure how much traffic is arriving from AI platforms — and which platforms are sending it.

**When to use:** User wants to quantify their current AI visibility in terms of actual sessions, or wants to track AI traffic over time.

**Tool:** `ga4_ai_traffic`

**What it measures:**
- Sessions GA4 itself classified as its **AI Assistant** channel. Google assigns
  `medium = ai-assistant` when it recognises the referrer as an assistant, and
  that classification is what the tool counts first.
- Plus referrals from a supplementary list of AI hosts, for engines Google does
  not recognise yet. When both contribute, the report says how many sessions
  came from each, because they are not the same claim.
- Users per AI source
- Time period (configurable, default 28 days)

**Bing web search is not AI traffic.** A referral from `bing.com` says a person
used a search engine, not that they read an AI answer — the referral cannot tell
you which. Copilot has its own hosts and is counted separately.

**Read it as a floor.** Only visits where the assistant passed a referrer are
visible at all; a recommendation acted on later arrives as branded search or
direct. See `references/citations-vs-recommendations.md`.

**Requires:** GA4 connected to the site with a valid property ID.

**Interpreting results:** Low AI traffic + high GEO score → AI is finding but not clicking (citation without traffic). Low AI traffic + low GEO score → AI isn't citing the content at all. High AI traffic from one platform → that platform's citation model is working; replicate the content patterns for others.

## AI Visibility Checklist

Run through this checklist to cover the full L1/L4 baseline:

```
[ ] ai_visibility_score    — composite L1+L4 score and prioritized action list
[ ] entity_mentions        — check off-site brand footprint (Wikipedia, Wikidata, Reddit…)
[ ] seo_geo_score          — run on top 5 pages by organic traffic
[ ] seo_eeat_score         — run on homepage + key landing pages
[ ] seo_llms_txt           — verify /llms.txt exists and is complete
[ ] seo_robots_validator   — confirm AI crawlers are NOT blocked
[ ] ga4_ai_traffic         — establish AI session baseline (requires GA4)
```

**For L4 content structure improvements** (after the audit):
- Move the core thesis to the first 30% of each page
- Add a direct 1–2 sentence answer immediately after each question-based heading
- Increase entity density: name specific tools, brands, people, data points
- Target 800–1,500 words per page (the tool's scored grounding sweet spot — it favors concise, dense pages over long ones)
- Refresh top pages at least monthly for ChatGPT/Perplexity citation recency signals
