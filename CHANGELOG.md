# Changelog

All notable changes to the That SEO Agent plugin are documented here. This
project adheres to [Semantic Versioning](https://semver.org).

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
