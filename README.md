# thatseoagent/skills

Agent skills for [That SEO Agent](https://thatseoagent.com) — an MCP server with 44 SEO tools covering Google Search Console, GA4, technical SEO, AI visibility, and content analysis.

## Prerequisites

Connect the MCP server to your agent before using any skill:

```json
{
  "mcpServers": {
    "seo-agent": {
      "command": "npx",
      "args": ["-y", "mcp-remote", "https://thatseoagent.com/api/mcp"],
      "headers": {
        "Authorization": "Bearer sea_YOUR_KEY_HERE"
      }
    }
  }
}
```

Get your API key at [thatseoagent.com/dashboard/settings](https://thatseoagent.com/dashboard/settings).

---

## Skills

| Skill | Install | What it does |
|-------|---------|-------------|
| `gsc-insights` | `npx skills add thatseoagent/skills/gsc-insights` | GSC analysis: quick wins, anomalies, trends, cannibalization, featured snippets |
| `technical-seo` | `npx skills add thatseoagent/skills/technical-seo` | Technical audit: crawlability, indexing, robots, security, hreflang |
| `ai-visibility` | `npx skills add thatseoagent/skills/ai-visibility` | AI search presence: GEO score, E-E-A-T, llms.txt, AI engine traffic |
| `content-audit` | `npx skills add thatseoagent/skills/content-audit` | On-page SEO, content quality, schema detection and generation |
| `site-audit` | `npx skills add thatseoagent/skills/site-audit` | Full site audit, shareable reports, and task management |

### Install all skills at once

```bash
npx skills add thatseoagent/skills
```

---

## License

MIT
