# Changelog

> 🇧🇷 [Versão em português](CHANGELOG.pt-br.md)

All notable changes to RENATA are documented here. Format based on [Keep a Changelog](https://keepachangelog.com); versioning follows [SemVer](https://semver.org).

## [Unreleased]

## [0.4.0] — 2026-07-19

**What's new:** the plugin's machine dependencies stop being a silent footgun — `/renata:init` (and the standalone `init.sh`) now check for `yq`/`jq`/`git` on first use and offer to install what's missing, instead of letting the ADR enforcement degrade quietly.

### Added
- **Dependency check on `/renata:init` (step 1)** — the init now verifies the plugin's machine dependencies before scaffolding: `yq` (required — without it `rules-violation.sh` validates nothing on commit), `jq`/`python3` (either one; stage gate + status line) and `git`. Missing tools are installed via the detected package manager (`brew`/`apt-get`/`dnf`) as a visible Bash call — the permission prompt is the consent; if there's no manager or the user declines, the init prints the manual command and continues (hooks already degrade with warnings). Plugin installs have no post-install hook in Claude Code, so first-use in `/renata:init` is the earliest reliable moment to check; the SessionStart `yq` warning remains as the safety net for machines that never ran init.
- **Same check in the standalone `init.sh`** — the sync excludes `commands/init.md` (standalone installs via `scripts/init.sh`), so the hand-maintained script got the equivalent block: interactive install prompt via the detected manager; in `--yes` (CI) mode it never installs on its own, only prints the command; always finishes the scaffold either way.

## [0.3.0] — 2026-07-19

**What's new:** the post-0.2.0 static audit round (again from the Avatar field project) — every `artifact_glob`/`non_empty_if` and every cross-reference in the 34 commands was checked. Two flow-breaking bugs fixed (the hook path that aborted `/renata:execute` and `/renata:plan-phase`, and language-dependent progress detection), plus deterministic living-docs updates and a language-neutral step-marker convention.

### Fixed
- **`bash .claude/hooks/rules-violation.sh` was invoked but the file never exists in a plugin project** (the scaffold only copies `progress-map.yaml` + `rules.yaml.template`). Pre-flight #8 of `/renata:plan-phase`, #4 of `/renata:execute` and the post-write validation of `/renata:adr` all hit `No such file or directory` — aborting both execution commands with a misleading remedy. All three now invoke `bash "${CLAUDE_PLUGIN_ROOT}/hooks/scripts/rules-violation.sh"` (the standalone sync rewrites it to `.claude/hooks/`, where the file does exist); the stale comments in `rules.yaml.template` and `progress-map.yaml` were fixed too.
- **Progress detection was language-dependent.** Docs are generated "in the user's language", but five `non_empty_if` needles were single-language prose (`aposta escolhida`, `Soluções encontradas`, `Fase 0`, `Behavior`, `Decisão final`) — in an EN project, Step 7.5 read as placeholder and **blocked `/renata:feature-spec`**; in a PT project Step 7.7 vanished from `/renata:status`. Replaced by the **step-marker convention**: each generating command stamps `<!-- renata:step=N -->` right below the doc title (invisible when rendered) and the map's needles match that marker — language-neutral by construction.
- **Steps 7.5 and 9 shared the same glob and needle-collided** (`fases-overview.md`; 7.5 already emits a `gantt`, which was Step 9's needle) — Step 9 counted as done the moment 7.5 ran, unlocking Step 10 without gates. Now `/renata:phase-roadmap` stamps `renata:step=7.5` and `/renata:roadmap-gates` stamps `renata:step=9` in the same file; each step keys on its own marker.
- **Step 8's glob (`docs/features/F1-*.md`) also matched Step 7.7's file (`F1-*.behavior.md`)** — running the optional behavior refinement marked the anchor spec as present without a spec existing. Step 8 now keys on the `renata:step=8` marker, which `/renata:feature-spec` (and `/renata:adopt`'s as-built specs) stamp and the behavior doc doesn't have.
- **`Status: running` (Step 12 detection + execute pre-flight #3) was never written by any command** — it was implicitly delegated to the external `writing-plans`, which doesn't guarantee it. `/renata:plan-phase` now requires `Status: draft` in the generated plan and sets `approved` after `@architect` sign-off; `/renata:execute` sets `running` on start and `done` at the end of the phase. Step 12 detection moved to the `renata:step=12` marker (stamped at execution start, kept after `done` — so Step 12 no longer "disappears" once the phase closes, which would have blocked `/renata:retro`).
- **`/renata:adr`'s YAML validation was a false validation** — it ran the hook at the nonexistent path and, without `yq`, the hook only warns and validates nothing. The step now uses the plugin path and states explicitly that real validation requires `yq`.
- **`_framework/` purged from the plugin** — it's the workspace layout of the RENATA monorepo, not something a user project has. `plan-phase` (mandatory context), `adr` (template path), `execute` (SKILL-CANDIDATES pointer), `CLAUDE.md.template` (2 mentions) and the `rules-violation.sh` scan excludes now reference `${CLAUDE_PLUGIN_ROOT}/METHOD.md` / neutral wording instead (the standalone sync rewrites the METHOD reference to `.claude/METHOD.md` and ships the file there).
- Cosmetics: `/renata:status` documents that map commands are namespace-less and should be displayed with the `renata:` prefix in the plugin edition; the stage-gate block message cites the METHOD section in both languages ("Why this order?" / "Por que essa ordem?"); the "14-step flow" vs `Etapa X/13` count mismatch fixed (status.md is map-driven, the status line derives the denominator from the map's last step).

### Added
- **Deterministic living-docs updates in `/renata:execute` (R1)** — the resumable state (plan checkboxes, plan `Status`, `CLAUDE.md` Section 5) no longer depends on the `keeping-docs-alive` skill auto-activating: the per-task done gate now includes marking the task `[x]` and refreshing Section 5 as an explicit gate criterion, and end-of-phase sets `Status: done`. The skill remains for the phase-level wrap-up.
- **Strict gate, opt-in (R2 carryover)** — `RENATA_STRICT_GATE=1` makes `etapa-gate.sh` also require the human verification seal (`> ✅ Verificado por você` / `> ✅ Verified by you`) on prerequisite artifacts (done ≠ verified). Off by default so the flow doesn't stiffen.

## [0.2.0] — 2026-07-19

**What's new:** enforcement that actually enforces — field feedback from a real project (Avatar) proved the stage gate was a silent no-op for every real invocation, the pre-commit hook was unusable on repos with vendored dependencies, and the plan folder convention clashed with `superpowers`. All fixed, plus 3 new commands so every step of the flow now has a command and gate coverage.

### Fixed
- **Stage gate was a no-op for namespaced invocations (the real ones).** `etapa-gate.sh` matched the invoked command against the map verbatim, so `/plan-phase` blocked but `/renata:plan-phase` — how users actually invoke it — always passed. The gate now reads `.tool_input.skill` as well (how the Skill tool delivers slash commands) and compares namespace-stripped basenames, so `/plan-phase`, `/renata:plan-phase` and `renata:plan-phase` all hit the gate. Proven by test: `/renata:plan-phase 0` now exits 2 while Step 10 is missing.
- **Pre-commit hook scanned the whole working tree.** `rules-violation.sh` ran `grep -r` over the repo, flagging ADR violations inside gitignored third-party code (e.g. `pt_BR` in a vendored site-packages) and blocking commits with zero real violations. It now scans **only staged files** (`git diff --cached --name-only --diff-filter=ACM`) in pre-commit — honoring `.gitignore` for free — falling back to tracked files (`git ls-files`) for CI/`--all`, and to the old tree scan only outside a git repo.
- **Plan folder collided with the `superpowers` convention.** RENATA wrote/read implementation plans in `docs/superpowers/specs/`, but `superpowers:writing-plans` saves to `docs/superpowers/plans/` (and in superpowers, `specs/` means design docs) — so `/renata:execute` could never find the plan `writing-plans` generated. Standardized on `docs/superpowers/plans/` everywhere (plan-phase, execute, progress-map Steps 11-12, qa-tester, keeping-docs-alive, METHOD, GETTING-STARTED); `specs/` is reserved for design docs.
- **`/renata:plan-phase` handoff skipped `/renata:execute`.** Step 6/7 told the user to invoke `superpowers:executing-plans` directly — leaving the method exactly at the end. Now hands off to `/renata:execute <phase>` (which wraps `executing-plans` with the pre-flight + per-task done gate).
- METHOD (en+pt): the v0.1-era "Declared inspirations" section at the bottom was a stale duplicate of "On whose shoulders (lineage)" (added in 0.1.7) — missing Blank/Fitzpatrick and drifting on the rest. Its two unique items (AINSTEINS / AI-Driven Development course, DDD-lite) were merged into the lineage section and the duplicate removed.

### Added
- `/renata:architecture` — Step 10 gets its slash command (was "(manual)"): synthesizes accepted ADRs + feature-specs + spikes into `stack.md` + `arquitetura.md` (C4 L1/L2), deciding nothing new. With the gate matcher fixed, Step 10 is now gate-covered.
- `/renata:roadmap-gates` — Step 9 gets its slash command (was "(manual)"): hardens the Step 7.5 roadmap with an explicit, verifiable gate per phase + one `fase-N-<nome>.md` per phase + anti-roadmap.
- `/renata:next` — micro-navigator: answers only "what's the canonical next step?" and flags gaps (artifacts existing ahead of an unmet prerequisite). The cheap, frequent complement to `/renata:status`.
- **Proactive gap detector at SessionStart** — `method-status-line.sh` now prints a `⚠ gap no fluxo` line when a later step has artifacts while an earlier mandatory step is empty (the case a per-invocation gate can't catch: work already done ahead of the flow, or plans suggested in prose).
- **`superpowers` declared as an external dependency** — `/renata:plan-phase` and `/renata:execute` gained a pre-flight check #0 (abort with install instructions if the `superpowers` plugin is missing — improvising the plan/loop by hand is explicitly forbidden); README (en+pt) and GETTING-STARTED (en+pt) now document the install.

### Changed
- **Hooks no longer depend on `yq`** — `progress-map.yaml` is parsed by an embedded awk parser (`progress-map-lib.sh`, new file shared by `etapa-gate.sh` and `method-status-line.sh`), so the stage gate and the status line run on any machine. The hook-event JSON needs `jq` *or* `python3` (fallback).
- **Enforcement OFF is now loud** — a silently disabled gate is worse than no gate. If the gate can't run (no `jq`/`python3`) or `rules.yaml` exists but `yq` is missing, SessionStart prints a visible `⚠ RENATA: enforcement OFF`-style warning with the install command; the gate itself also warns on stderr instead of exiting silently.
- `progress-map.yaml`: Steps 9 and 10 now carry `command: "/roadmap-gates"` / `command: "/architecture"` instead of `"(manual) ..."` — no more blind spots in gate coverage; GETTING-STARTED (en+pt) Step 9/10 sections and the steps table point to the new commands; `init.sh` next-steps message updated.

## [0.1.11] — 2026-07-15

**What's new:** brownfield adoption — born from real user feedback: a dev reverse-engineering an existing system ran `/renata:extract-pattern` and had no answer for "where do the tech specs live?". Now there's one command and one guide for the whole path.

### Added
- `/renata:adopt` — the 30th command: adopts RENATA over an existing codebase in 6 confirmed stages — technical pattern (composes with `/renata:extract-pattern` per scope), technical context (`stack.md` + `arquitetura.md` C4), reverse-engineered feature inventory, retroactive PRD, selective as-built specs, wrap-up with the artifact map. Every artifact is born 🔄 with an `> 🏗️ As-built` provenance mark; only the human verifies, via `/renata:status`.
- `ADOPTION.md` (en+pt) — the brownfield guide: stage-by-stage table, **"Where every artifact lives"** (the table that answers the original question), what `/renata:status` shows after a run, pre-existing-ADR cleanup, FAQ.
- `REFERENCE.md` (en+pt) — the six GETTING-STARTED appendices (when NOT to use, anti-patterns, alternative orders, realistic times, cheatsheet, evolving the method), now with a brownfield alternative order and `/renata:adopt` + `/renata:init` in the cheatsheet.
- `/renata:init` detects existing code (dependency manifests / source dirs) and closes pointing to `/renata:adopt` instead of the greenfield Step 2 flow.

### Changed
- GETTING-STARTED (en+pt) slimmed from ~2000 to ~1550 lines: the tutorial-map mermaid, the 4 views (execution loop, responsibility, artifacts) and the "why this order?" essay moved to METHOD.md (deduplicating "Who does what" into View C); appendices moved to REFERENCE.md; the preamble is now ~70 lines with the compass and the steps summary.
- METHOD.md (en+pt) gains "The flow at a glance", "The 4 views of the method", a "Scaffold" command category (`/renata:init`, `/renata:adopt`) and the brownfield nuance in "when NOT to use".

### Fixed
- Step 0.5 "Retrofit" was pre-plugin legacy — manual `cp -R $FW/template` from a cloned framework, with stale validation counts ("18 commands / 5 agents") and no connection to `/renata:extract-pattern`. Replaced by a pointer to `/renata:adopt` + `ADOPTION.md`; the pre-existing-ADR cleanup advice moved to ADOPTION.md.
- Step 1 ordered `git init` (1.4) after `/renata:init` (1.2), so the ADR-enforcement hook — which only activates when git exists — never activated on first run. `git init` now comes first.

## [0.1.10] — 2026-07-09

**What's new:** two new commands close the post-production loop — `/renata:bug-report` structures a single fresh bug report from production; `/renata:incident` coordinates live response to a larger incident and hands off to `/renata:retro` for the post-mortem.

### Added
- `/renata:bug-report` — converts one raw production report (customer complaint, support ticket, self-found bug) into a structured, severity-classified item with a clear next step (hotfix, `/renata:todo`, `/renata:triage`, or escalate to `/renata:incident`).
- `/renata:incident` — coordinates the live response to an active, larger production incident: declares it, keeps a timestamped timeline, tracks external communication, and enforces a resolution checklist before closing — then hands off to `/renata:retro` for the root-cause post-mortem.
- GETTING-STARTED (en+pt): new **Step 14 — Post-production**, covering the cross-cutting loop that starts every time a customer/support/you finds a bug after release — the tutorial's step-by-step previously ended at the Step 13 retro with no path back for a post-release bug. Added to the tutorial map (mermaid), the "Summary of the steps," and the Appendix E cheatsheet.
- METHOD (en+pt): new **Post-production** command category, separate from "Development (operating within a phase)" — bug-report/incident don't belong there since that section is about work still inside an unreleased phase.

### Fixed
- `/renata:bug-report` and `/renata:incident` had been placed in the Step 12 "useful commands during execution" table and under METHOD's "Development" category — both describe work on an unreleased phase, so a post-release bug had no correct home. Moved to the new Post-production section/category above.

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
