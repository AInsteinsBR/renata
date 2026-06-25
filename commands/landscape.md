---
description: Post-PRD competitive research — maps similar solutions (anchored on the PRD), then co-curates the result with you to surface differentiation gaps that become candidate features. Sources mandatory.
---

# /renata:landscape — Competitive research to find your differentiation gaps

You map the solutions that already exist for the problem in the PRD, and help find **where this product differentiates** — without copying competitors or bloating the solution. You generate/update `docs/research/<date>-landscape.md`.

This is **optional** and runs after the PRD (the hypotheses must be clear). It works in **two phases** and detects which one it's in.

Respond to the user and generate document content in the user's language (the language they are writing in).

## Phase detection

- If there is NO `docs/research/*-landscape.md`, or it exists with raw research only (status `🔬`, no curation table filled) → **Phase 1**.
- If a research dump exists awaiting curation → **Phase 2**.

## Phase 1 — Research + dump (asynchronous)

1. Read `@docs/prd/` (problem, persona, hypotheses). The research is anchored on this.
2. **Resolve the research source (MCP fallback):** read `integrations:` in `.claude/rules.yaml`. If the `research` capability has an MCP configured AND its tools are available in the session (e.g. Perplexity) → use it. Otherwise → use native `WebSearch`/`WebFetch`. Tell the user which source you're using.
3. Research: direct competitors, indirect alternatives, and "how they solve it today without a product". Top 3-5 relevant ones — not a market census.
4. For each solution: what it does well, what's missing, who it's for, pricing — **always with a source (URL)**. No source → don't record as fact (set aside as "unverified" if relevant).
5. Build the capability matrix (you × competitors) and list candidate gaps.
6. **Mark (as a suggestion) the gaps that look most promising** for differentiation, with the why. Clearly a suggestion, not a verdict.
7. **Save everything** to `docs/research/<date>-landscape.md` (status `🔬`) and **STOP**: tell the user "I researched X solutions, found Y candidate gaps — it's all in <file>. Read it at your own pace; when ready, run `/renata:landscape` again and we'll curate it together."

## Phase 2 — Co-curation (interactive)

1. Read the existing dump.
2. Present in **blocks** (competitors first, then gaps). For each block, **actively propose angles** the user may not have seen ("what if this smaller-looking gap solves a problem that stayed hidden in ideation?") and ask: keep / cut / add.
3. The user decides with their domain knowledge (cut false positives, add what the web didn't see).
4. Consolidate: update the artifact with **per-item status** (kept / cut + reason / added by the user), the final matrix, the **prioritized gaps**, and the **candidate features** derived from the gaps. Set status `✅ curated on <date>`.
5. Suggest `/renata:feature-breakdown` as the next step (now with the gap ideas).

## Structure to generate

```markdown
# Landscape · {{product}}

> Competitive research anchored on the PRD. Research source: {{Perplexity MCP | native WebSearch}}.
> Status: {{🔬 raw research (awaiting curation) | ✅ curated on <date>}}

## What we're solving (from the PRD)
{{problem + persona + anchor hypothesis}}

## Solutions found
| Solution | Does well | Missing | For whom | Price | Source |
|---|---|---|---|---|---|
{{each row with a URL in Source}}

## How they solve it today without a product
{{spreadsheet, workaround, manual process — with source if any}}

## Capability matrix (you × competitors)
| Capability | You | Competitor A | B | C | Type |
|---|---|---|---|---|---|
{{Type: 🟢 table stake · 🔵 gap (differentiation) · ⚪ over-engineering}}

## Candidate gaps
- {{gap}} — **💡 my suggestion: promising** because {{...}} | status: {{awaiting curation}}

## Curation (filled in Phase 2)
| Item | Decision | Reason |
|---|---|---|
{{kept / cut / added by user + why}}

## Prioritized gaps → candidate features (post-curation)
- {{chosen gap}} → candidate feature: {{...}} (for /renata:feature-breakdown)

## What we will NOT pursue (and why)
- ❌ {{discarded gap/feature}} — {{reason: doesn't serve a hypothesis / over-engineering}}
```

## Quality rules (what you refuse)

- ❌ A claim about a competitor without a source (URL) → not recorded as fact (set aside as "unverified" if relevant).
- ❌ Suggesting to add EVERYTHING ("complete solution" = bloated) → only gaps that serve a PRD hypothesis; question feature creep.
- ❌ A market census (20 competitors) → focus on the 3-5 relevant to the case.
- ❌ Deciding what's a gap/competitor without the user → in Phase 2 the decision is theirs; you propose, you don't crown.

## After generating

- Phase 1: save the dump (status 🔬) and stop for reading.
- Phase 2: save the curated artifact (status ✅) and suggest `/renata:feature-breakdown`.
- For the next step verified against prerequisites, run `/renata:status`.

## Arguments

`$ARGUMENTS`: optional — extra focus/context for the research (e.g., a competitor to include, a segment).
