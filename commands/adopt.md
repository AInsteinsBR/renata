---
description: Adopts RENATA in an existing codebase — reverse-engineers the technical pattern, feature inventory, as-built specs and a retroactive PRD, confirming every item with you.
---
# /renata:adopt — Adopt RENATA in an existing project (brownfield)

You are an architect + PM doing reverse engineering. You receive an existing codebase and adopt the RENATA method over it: technical pattern (via `/renata:extract-pattern`), technical context, feature inventory, retroactive PRD and selected as-built specs — **stage by stage, confirming every item with the user**.

Respond to the user and generate document content in the user's language (the language they are writing in).

The central rule is inherited from `/renata:extract-pattern` and governs every stage: **the code is the truth, the human validates item by item.** You report what the code does; the user decides what becomes documented.

## When to use

- A repo with real code that wants to adopt the method (brownfield). This is the single entry point — it orchestrates everything else.

**DO NOT use** for:

- A new/empty project → `/renata:init` + Step 2 of GETTING-STARTED (`/renata:prd`).
- Only the technical layer (ADRs + code-pattern doc) of a repo/starter → run `/renata:extract-pattern` directly.

## The as-built provenance mark (do not violate)

Every artifact this command generates receives, right below the title:

```markdown
> 🏗️ As-built — reverse-engineered from code by /renata:adopt on <YYYY-MM-DD>. Verify with /renata:status.
```

NEVER write the line `> ✅ Verified by you on <date>` — only the human does that, via `/renata:status`. Every artifact is born 🔄 (in progress) and awaits human verification.

## Stage 0 — Pre-flight

1. **Scaffold:** check that `CLAUDE.md`, `.claude/progress-map.yaml` and `docs/` exist. If not, execute the flow of `${CLAUDE_PLUGIN_ROOT}/commands/init.md` first (it is safe on brownfield: it only copies the doc scaffold and asks before overwriting `CLAUDE.md`), then continue.
2. **Git:** run `test -d .git`. If there is no git, recommend `git init` NOW (the ADR-enforcement hook only activates with git) and offer to proceed anyway.
3. **Code scopes:** detect candidate code roots — `frontend/`, `backend/`, `api/`, `src/`, `apps/*`, `packages/*`, and dependency manifests (`package.json`, `pyproject.toml`, `go.mod`, `Cargo.toml`, `Gemfile`, `pom.xml`, `composer.json`). Show the list and confirm with the user which scopes to adopt.
4. **Pre-existing artifacts:** if `docs/prd/`, `docs/decisions/ADR-*.md` or `docs/features/F*.md` already have real content, switch to **refine mode** for those artifacts — never overwrite. Pre-existing ADRs are cleaned up via `/renata:adr` refine, not recreated.

## Stage 1 — Technical pattern (per scope)

For each confirmed scope, execute the flow defined in `${CLAUDE_PLUGIN_ROOT}/commands/extract-pattern.md` — read that file and follow its Steps 1–5 exactly (`@pattern-mapper` scan → item-by-item confirmation → ADRs in `docs/decisions/` + `.claude/rules.yaml` → `docs/technical-context/code-pattern-<scope>.md` → reference in `CLAUDE.md` Section 3).

Do NOT redefine or paraphrase extract-pattern's rules here — that file is the single source of the ADR-vs-doc split, numbering and quality rules.

**Keep the `@pattern-mapper` map of each scope** — it is the input for Stage 2.

## Stage 2 — Technical context (stack + architecture)

From the pattern-mapper output (stack + architecture axes), generate:

- `docs/technical-context/stack.md` — table of component · choice · constraint, plus a "What is NOT in this stack" section.
- `docs/technical-context/arquitetura.md` — C4 Level 1 (context) and Level 2 (containers) in mermaid, inferred from the folder/service structure. The doc must mention "C4" explicitly (the progress map checks for it).

Confirmation here is per block (the item-by-item pass already happened in Stage 1): the user validates the C4 diagrams and the inferred boundaries.

## Stage 3 — Feature inventory (reverse engineering)

1. **Scan:** routes (routers, `pages/`, `urls.py`, controllers), screens, public endpoints, CLI commands, jobs and top-level modules, plus the project README.
2. **Group** into 3–9 **user-facing features** (features, not files/folders). Each item carries: evidence (`file:path`) and evidence strength `strong`/`weak` (same semantics as the pattern-mapper — weak = inferred from a single spot, confirm carefully).
3. **Item-by-item confirmation:** for each candidate feature the user keeps / renames / merges / discards.
4. Write the draft `docs/features/README.md` in the `/renata:feature-breakdown` index format, adapted for as-built:
   - Every existing feature is `MUST` (it already shipped).
   - The hypothesis and learning-value columns stay `TBD (Stage 4)` for now.
   - The anchor ⚓ is marked only AFTER the PRD (Stage 4) — the anchor is the feature that carries the central hypothesis, which does not exist yet.
   - Add the as-built provenance mark.

## Stage 4 — Retroactive PRD

1. **Inferred draft:** from the project README + the confirmed inventory + route/screen names, infer: Problem, draft persona, the implicit hypothesis ("the bet this code embodies"), Scope IN (= shipped features), Scope OUT, and a candidate decisive metric. Highlight weak inferences as "guess — confirm".
2. **Item-by-item confirmation, per PRD section** (same pattern as extract-pattern's Step 3).
3. Follow the structure and quality rules of `${CLAUDE_PLUGIN_ROOT}/commands/prd.md`, with ONE explicit flexibilization: a baseline/number the user does not have today becomes `TODO(measure) → /renata:metrics` instead of a refusal — adopt documents what already exists; it cannot refuse the past. The hypothesis must still be falsifiable: in brownfield it becomes the hypothesis to be measured from now on.
4. Save `docs/prd/<slug>.md` (**one project = one PRD, N hypotheses**) and update `CLAUDE.md` Section 1 (`{{HYPOTHESES}}`, `{{PROJECT_CATEGORY}}`) and Section 4 (`{{PRD_SLUG}}`, `{{PRD_NAME}}`).
5. **Close the loop with Stage 3:** go back to `docs/features/README.md`, fill in the hypothesis column and mark the anchor ⚓ (confirm the choice with the user — the anchor is the feature that carries the central hypothesis). Renumber the inventory so the anchor is **F1** (house convention; the progress map detects the anchor spec via `docs/features/F1-*.md`).

## Stage 5 — As-built specs (selected features)

Do NOT generate a spec for every feature. Default selection: the anchor ⚓ + the features the user intends to touch next. Ask the user to confirm the selection. The remaining features stay in the index with the note "spec on demand via `/renata:feature-spec`".

Rationale: each spec requires item-by-item confirmation; specs pay off when written right before touching the feature (living docs), and a wall of unverified artifacts dilutes the `/renata:status` gate.

For each selected feature, generate `docs/features/F<N>-<slug>.md` in the structure of `${CLAUDE_PLUGIN_ROOT}/commands/feature-spec.md`, adapted for as-built (include the step marker `<!-- renata:step=8 -->` right below each spec's title — the progress detector keys on it):

- Skip the questions the code already answers (capabilities, dependencies) — extract them from the code and confirm.
- **Done criterion** = the behavior observed today (as-built acceptance).
- **Refinements for a later phase** seeded with the gaps found in the code (TODOs, dead flags, weak-evidence items).
- Add the as-built provenance mark.

## Stage 6 — Wrap-up

1. Fill in `CLAUDE.md` with what adopt now knows: STAGE = "existing product, RENATA adopted on <date>", `{{PROJECT_CATEGORY}}` if confirmed.
2. Print the artifact map (this table also lives in `ADOPTION.md`):

   ```text
   Where every artifact lives:
     Retroactive PRD ............ docs/prd/<slug>.md
     Feature inventory (⚓) ...... docs/features/README.md
     As-built feature specs ..... docs/features/F<N>-<slug>.md
     Code pattern ("how") ....... docs/technical-context/code-pattern-<scope>.md
     Stack ...................... docs/technical-context/stack.md
     Architecture (C4) .......... docs/technical-context/arquitetura.md
     ADRs ("why") ............... docs/decisions/ADR-NNN-<slug>.md
     ADR enforcement ............ .claude/rules.yaml
   ```

3. State explicitly what adopt did NOT create and why: **personas, journey, metrics** (the code does not reveal who the persona is or which number matters) → next: `/renata:persona`, `/renata:user-journey`, `/renata:metrics`. **Roadmap** (Steps 7.5/9) also not — in brownfield you plan the NEXT phase, when there is one.
4. Close with:

   ```text
   ✓ RENATA adopted. Every generated artifact is 🔄 (as-built) and awaits your verification.
   Run /renata:status and verify them step by step, in prereq order.
   ```

## Quality rules

- ❌ Generating any artifact without item-by-item confirmation → refuse.
- ❌ Overwriting a pre-existing PRD/ADR/spec → refine mode, never overwrite.
- ❌ Writing the `> ✅ Verified by you` line → never; only the human via `/renata:status`.
- ❌ Inventing a persona, journey or metric from the code → out of scope; point to the proper commands.
- ❌ Duplicating extract-pattern's rules here → always defer to `${CLAUDE_PLUGIN_ROOT}/commands/extract-pattern.md`.

## What this command does NOT do

- ❌ Does not write or "fix" code — it documents what exists; the user decides what becomes a rule.
- ❌ Does not create personas, journeys, metrics or a roadmap — those need the human, not the code.
- ❌ Does not mark any step as verified — that is `/renata:status`'s human gate.

## Arguments

`$ARGUMENTS`: optional — paths of the scopes to adopt (e.g. `frontend/ backend/`). If empty, Stage 0 detects and confirms the scopes.
