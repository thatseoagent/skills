<p align="center">
    <a href="https://thatseoagent.com?utm_source=github&utm_medium=banner&utm_campaign=that-seo-agent-skills">
      <picture>
        <source media="(prefers-color-scheme: dark)" srcset="assets/logo-lockup-dark.svg">
        <img alt="That SEO Agent — Skills" src="assets/logo-lockup.svg">
      </picture>
    </a>
</p>

[![skills.sh](https://skills.sh/b/thatseoagent/skills)](https://skills.sh/thatseoagent/skills)


# That SEO Agent — Skills

SEO tools for any MCP-compatible AI agent. Connects to Google Search Console, GA4, PageSpeed Insights, and your site's technical layer via the Model Context Protocol.

## Install as a plugin (Claude Code & Claude Cowork)

The fastest path. Bundles all 7 skills plus the That SEO Agent MCP server, and signs you in with OAuth in your browser — **no API key to paste**.

```
/plugin marketplace add thatseoagent/skills
/plugin install thatseoagent@thatseoagent-skills
```

On enable, your browser opens to authenticate with That SEO Agent. Tokens are stored securely and refreshed automatically. Skills are invoked automatically by Claude, or explicitly as `/thatseoagent:site-audit`, `/thatseoagent:gsc-insights`, etc.

## Manual MCP setup (other clients)

If you're not using the plugin, add the server to your MCP client's config:

```json
{
  "mcpServers": {
    "thatseoagent": {
      "type": "http",
      "url": "https://thatseoagent.com/api/mcp",
      "headers": {
        "Authorization": "Bearer sea_YOUR_KEY_HERE"
      }
    }
  }
}
```

Get your API key at [thatseoagent.com](https://thatseoagent.com).

## Built-in prompts

Three orchestration prompts are pre-loaded once the MCP is connected — no skill install required:

- **audit_site** — Runs a full site audit and returns a shareable report URL.

- **find_quick_wins** — Surfaces high-impact, low-effort improvements from your GSC data.

- **track_fixes** — Reviews open tasks, audits the site, and creates tasks for critical issues.

## Install skills individually (npx)

Prefer one skill at a time, or not using the plugin? Each skill installs standalone:

### Audits & monitoring

- **site-audit** — Full site audit across 18+ dimensions, shareable client reports, and page-level task management.

  ```
  npx skills add thatseoagent/skills/site-audit
  ```

- **audit-cadence** — Structured 14-day monitoring cycle: traffic pulse, index health, content gaps, technical checks, and AI visibility.

  ```
  npx skills add thatseoagent/skills/audit-cadence
  ```

### Search & rankings

- **gsc-insights** — GSC analysis workflows: quick wins, traffic anomalies, trends, cannibalization, and featured snippet opportunities.

  ```
  npx skills add thatseoagent/skills/gsc-insights
  ```

### Technical SEO

- **technical-seo** — Crawlability, indexing, canonical tags, robots.txt, hreflang, security headers, and URL inspection.

  ```
  npx skills add thatseoagent/skills/technical-seo
  ```

### Content

- **content-audit** — On-page SEO, content quality, readability, schema detection, and structured data generation.

  ```
  npx skills add thatseoagent/skills/content-audit
  ```

- **content-checklist** — Pre-publish checklist: on-page SEO, schema, content structure, copy quality, and final tool validation before going live.

  ```
  npx skills add thatseoagent/skills/content-checklist
  ```

### AI visibility

- **ai-visibility** — Content signals correlated with AI citation: E-E-A-T, structured data, crawler access, and entity presence. Based on peer-reviewed research — no official AI citation standard exists.

  ```
  npx skills add thatseoagent/skills/ai-visibility
  ```

### Install all skills at once

```
npx skills add thatseoagent/skills
```

---

MIT License
