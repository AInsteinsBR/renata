# Changelog

> 🇧🇷 [Versão em português](CHANGELOG.pt-br.md)

All notable changes to RENATA are documented here. Format based on [Keep a Changelog](https://keepachangelog.com); versioning follows [SemVer](https://semver.org).

## [Unreleased]

_Nothing yet._

## [0.1.9] — 2026-07-03

**What's new:** the tutorial's bird's-eye view caught up with the method.

### Fixed
- GETTING-STARTED (en+pt): the orientation layer (tutorial mermaid map, "Summary of the steps" table, "Why this order?" table, Views C/D, Appendix E cheatsheet) was missing the optional steps added in 0.1.4-0.1.6 — **1.5 Discovery**, **6.5 Landscape**, **7.7 Feature behavior** — plus the **7.5 Phase the system** row and `/renata:extract-pattern` in the cheatsheet. The step-by-step body was already complete; only the overview artifacts had drifted. All mermaid diagrams render-validated with mmdc.

## [0.1.8] — 2026-07-03

**What's new:** English YAML schema — identifiers in English, ahead of the full localization.

### Changed (⚠️ breaking for projects scaffolded ≤0.1.7)
- `progress-map.yaml` schema keys renamed to English: `etapas`→`steps` · `nome`→`name` · `comando`→`command` · `artefato_glob`→`artifact_glob` · `nao_vazio_se`→`non_empty_if` · `opcional`→`optional` · `validacao`→`validation`. Values (step labels, validation criteria) stay in Portuguese — they are content, covered by the future localization wave.
- `rules.yaml` integrations block: `espelho`→`mirror`; canonical capability `tarefas`→`tasks`.
- Hooks (`method-status-line.sh`, `etapa-gate.sh`) and commands (`/renata:status`, `/renata:adr`, `/renata:todo`, `/renata:triage`) updated to the new schema; both hooks functionally tested against it.
- **Migration for existing projects:** rename the keys above in your `.claude/progress-map.yaml` and `.claude/rules.yaml`. No compatibility shim is shipped.

## [0.1.7] — 2026-07-03

**What's new:** get out of the building — the interview loop and evidence seals.

### Added
- `/renata:interview-kit` — one-page Mom Test field guide for problem interviews (past-and-behavior questions, NEVER-ask list, signals to listen for), made to be read on your phone. 1 kit = 1 assumption.
- `/renata:interview-debrief` — processes a ready transcript (transcript only — audio integration is a future evolution): verbatim quotes per assumption graded 🥇 spontaneous / 🥈 prompted / 🚫 contaminated, aggregate evidence board (`docs/interviews/README.md`), seal promotion/demotion in source docs, and mandatory interviewer coaching.
- **Evidence seals** (🔴 belief · 🟡 anecdote · 🟢 interviewed · ✅ measured) — documented once in METHOD.md; stamped by `/renata:discovery`, moved by `/renata:interview-debrief`, cashed in by `/renata:assumption-test` / `/renata:hypothesis-check`. Seals never block — they force honesty.
- Positioning section in README ("Why RENATA exists") and intellectual lineage in METHOD (Cagan, Torres, Blank, Fitzpatrick, Nygard, Ries).
- `docs/interviews/` (kits + debriefs + board) in the project scaffold.

### Changed
- `/renata:discovery` — stamps evidence seals and seeds the riskiest assumption (4th seed).
- `/renata:assumption-test` — accepts pre-PRD discovery input; the problem-interview catalog row plugs into the interview loop; results cite the evidence board.
- `/renata:status` — suggests `/renata:interview-kit` when the chosen bet carries a weak seal.

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
