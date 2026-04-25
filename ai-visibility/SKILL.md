---
name: ai-visibility
description: AI search visibility skill for That SEO Agent MCP. Use this skill when the user asks about appearing in ChatGPT, Perplexity, Google AI Overviews, Claude, or other AI-generated answers. Triggers on tasks involving GEO optimization, E-E-A-T signals, llms.txt, AI engine traffic, generative search, or brand visibility in AI systems.
license: MIT
compatibility: Requires the thatseoagent MCP server connected. Get your API key at thatseoagent.com/dashboard/settings.
metadata:
  author: thatseoagent
  version: "1.0.0"
---

# AI Visibility

> **Requires** the thatseoagent MCP connected — [setup instructions](https://thatseoagent.com/docs/mcp).

Workflows for improving how your brand appears in AI-generated answers (ChatGPT, Perplexity, Google AI Overviews, Claude, Gemini) using the thatseoagent MCP.


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

## GEO Score Audit

Measure content signals correlated with AI citation — a directional heuristic based on available research.

**When to use:** User wants a structured baseline of on-site content and technical factors before making changes.

**Tool:** `seo_geo_score`

**Important caveat:** No AI platform (Google, OpenAI, Anthropic, Perplexity) publishes a citation scoring standard. This score measures proxy signals — structured data, content structure, E-E-A-T signals, crawler access — that peer-reviewed research (Princeton KDD 2024) found correlated with higher inclusion in AI-generated answers. A higher score means you've improved measurable factors; it does not guarantee AI citation.

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

**What llms.txt is:** A format proposed in 2024 that gives AI systems a curated summary of your site's content and structure. None of the major AI platforms (Google, OpenAI, Anthropic, Perplexity) have publicly confirmed they use it for citation decisions. Add it if it's easy — but don't prioritize it over inline citations, structured data, and AI crawler access, which have stronger evidence behind them.

## AI Visibility Score

Get a composite 0–100 score measuring a site's overall AI visibility across the L1 and L4 layers of the stack.

**When to use:** Starting point for any AI visibility engagement — gives a single number and a prioritized action list. Run before any other tool so the score becomes the baseline for tracking progress.

**Tool:** `ai_visibility_score`

**What it measures:**

- **L1 Entity Establishment (Knowledge Graph mechanism)** — Wikidata/Wikipedia presence, Google Knowledge Panel, schema markup (`Organization`, `LocalBusiness`, `Person`, `FAQPage`), directory listing consistency, brand name disambiguation. This is a **gating step, not a ranking step**: AI resolves whether your entity exists before it retrieves anything. A failed L1 limits every other layer.
- **L4 Informational Citation (Retrieval mechanism)** — content structure for AI extraction, AI bot access, structured data quality, content density, freshness signals. Research across 1.2M ChatGPT responses shows 44.2% of citations come from the first 30% of a page. An 800-word page gets 50%+ grounding coverage from AI; a 4,000-word page gets just 13%.

**Why L2 and L3 are off-tool:** L2 (Entity Depth — what AI "knows" about you from training) and L3 (Category Citation — editorial listicles and review sites) require off-site investment. Use `entity_mentions` for a proxy read on L2 footprint.

**What it returns:**
- A 0–100 composite score with per-layer breakdown (L1 and L4 separately)
- Passed and failed checks across both layers
- Prioritized action items ranked by estimated impact

**Target score:** 70+ indicates strong on-site signals. Below 40 suggests significant gaps in entity establishment or content structure. These thresholds are directional — no platform has validated them against actual citation rates.

**Quick self-test:** Ask ChatGPT *"What is [brand name]?"* — if the answer is vague, hedged, or wrong, L1 entity resolution is failing. That's the fastest proxy for a low score before running the tool.

**High-impact fixes after the audit:**
- Add `Organization` or `LocalBusiness` schema to the homepage
- Add `Person` + `sameAs` schema to author bio pages — correlates with 3x higher AI appearance rates
- Ensure consistent entity name across all platforms (no "Brand Inc." vs "Brand LLC" variations)
- Move core content answers to the first 30% of each page
- Keep key pages in the 800–1,500 word range for optimal AI grounding coverage

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
- Sessions from ChatGPT, Perplexity, Gemini, Claude, Copilot, and Bing AI
- Users per AI source
- Time period (configurable, default 28 days)

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
- Target 800–1,500 words per page (the AI grounding budget favors concise, dense pages over long ones)
- Refresh top pages at least monthly for ChatGPT/Perplexity citation recency signals
