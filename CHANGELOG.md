# Changelog

> 🇧🇷 [Versão em português](CHANGELOG.pt-br.md)

All notable changes to RENATA are documented here. Format based on [Keep a Changelog](https://keepachangelog.com); versioning follows [SemVer](https://semver.org).

## [Unreleased]

_Nothing yet._

## [0.1.6] — 2026-06-25

**What's new:** competitive research that finds your differentiation gaps.

### Added
- `/renata:landscape` — post-PRD competitive research: maps similar solutions anchored on the PRD (Perplexity MCP if available, else native web search; sources mandatory), dumps everything for you to read, then co-curates with you to surface differentiation gaps that become candidate features.
- New `research` integration capability (web search source for landscape).

## [0.1.5] — 2026-06-25

**What's new:** the pre-PRD ideation step — for when you don't know yet what you want.

### Added
- `/renata:discovery` — Step 0 of the method: converges a vague intuition into a clear problem using 5-whys + JTBD + why-now, teaching each framework as it goes. Forces 2-3 framings before converging, and seeds clues for persona/journey/metrics.

### Changed
- `/renata:prd` reads a discovery doc as its starting point (and suggests running discovery when you arrive unclear).
- `/renata:persona`, `/renata:user-journey`, `/renata:metrics` read their discovery "seeds" as starting points.

## [0.1.4] — 2026-06-12

**What's new:** an optional behavior layer between feature breakdown and the technical spec — born from real user feedback.

### Added
- `/renata:feature-behavior` — refines a feature as observable user behavior (user stories + Gherkin + business rules + acceptance), with zero technical detail. The clean Product→Engineering handoff.

### Changed
- `/renata:feature-spec` consumes the behavior spec when present (links to it, no duplication).

## [0.1.3] — 2026-06-12

**What's new:** RENATA goes international.

### Changed
- Content of all 22 commands, 6 agents and 3 skills translated to English; each command gets an English `description` in the `/` menu. (File language does not force conversation language — RENATA still replies in the user's language.)

## [0.1.2] — 2026-06-12

**What's new:** cleaner command names.

### Changed
- Commands are invoked with the `/renata:` prefix (plugin namespace).
- `renata-init` renamed to `init` → `/renata:init` (no duplicated "renata").

## [0.1.1] — 2026-06-12

### Fixed
- `hooks.json` format (missing the top-level `hooks` wrapper) that prevented the plugin hooks from loading.

## [0.1.0] — 2026-06-12

**What's new:** RENATA is born — a product method that ties persona → metric → ADR → code, shipped as a Claude Code plugin.

### Added
- 21 commands (planning, design, validation, development, navigation) + the `/renata:init` scaffold.
- 6 agents, 3 auto-activating skills, hooks (stage gate, ADR-violation blocking on commit).
- Bilingual docs (EN + PT-BR): README, METHOD, GETTING-STARTED. MIT © Eric Luque / AInsteins.
