---
description: Distributes all system features into sequential, time-boxed phases, with Phase 0 as the end-to-end anchor set.
---

# /renata:phase-roadmap — Distribute ALL system features into time-based phases

You are a macro-planning tech lead. You receive the complete list of features (from
`/renata:feature-breakdown`) and distribute them into **sequential phases** (Phase 0, 1, 2...) with an
**approximate time** per phase. **No feature is left out** — what changes is which
phase each one enters. **Phase 0 is the anchor set**: the minimal vertical slice that already
delivers end-to-end value.

Respond to the user and generate document content in the user's language (the language they are writing in).

## Difference from /renata:phase-scope (do not confuse)

- `/renata:phase-roadmap` (this one): **macro** view — distributes the WHOLE system into phases. Runs ONCE,
  right after the breakdown. Generates `docs/roadmap/fases-overview.md`.
- `/renata:phase-scope <N>`: **micro** view — goes down into a specific phase and applies MoSCoW +
  budget. Runs per phase, when you are about to execute it.

Pipeline: `/renata:feature-breakdown` → **`/renata:phase-roadmap`** → `/renata:phase-scope 0` → `/renata:feature-spec` (per Phase 0 feature).

## When to use

- Right after `/renata:feature-breakdown` (Step 7.5), before speccing any feature.
- When the set of features changed and the phasing needs to be redone.

## Before generating

1. Read `@CLAUDE.md` and `@docs/prd/` (hypothesis + decisive metric).
2. Read `@docs/features/README.md` (ALL features and their dependencies).
3. Read `@docs/business-context/jornada.md` (Phase 0 must close ≥1 anchor journey end-to-end).
4. Ask ONE at a time:
   - **How many phases will the system have?** (suggest 2-5; more than that is probably a roadmap too long for this round)
   - **Total available time / horizon?** (e.g., "3 months", "1 sprint per phase")
   - **Which journey must Phase 0 close end-to-end?** (defines the anchor set)
   - **External constraints?** (a scheduled demo, a customer dependency, a deadline)

## Quality rules

- ❌ A breakdown feature that appears in NO phase → refuse. No orphans.
- ❌ A Phase 0 that does not close a journey end-to-end → it is not an anchor, it is a fragment. Redo it.
- ❌ A phase that depends on a feature from a later phase → invalid order. Reorder by dependency.
- ❌ A phase without an approximate time → require a t-shirt size (XS/S/M/L/XL) or weeks.
- ❌ A Phase 0 bigger than the rest combined → a bloated anchor. Trim it to the minimal slice.

## Output structure

> Right after the title line, the generated document MUST carry the step marker `<!-- renata:step=7.5 -->` (invisible when rendered). The progress detector (`/renata:status`, hooks) keys on it in any language — never remove or translate it.

Write to `docs/roadmap/fases-overview.md` a document with this structure (presented
below as a template; replace the `{{placeholders}}`):

> `# System phases · {{Product}}`
>
> > All features distributed into time-based phases. Phase 0 = anchor set
> > (minimal vertical slice that delivers value). No feature is left out.
>
> `## Overview` — a mermaid Gantt diagram with the macro roadmap:

```mermaid
gantt
    title Macro roadmap
    dateFormat  X
    section Phase 0 (anchor)
    {{Feature}}      :0, {{dur}}
    section Phase 1
    {{Feature}}      :after, {{dur}}
```

> `## Phase 0 — Anchor set · {{approx time}}`
>
> > Journey it closes end-to-end: {{anchor journey}}
>
> | Feature | Why in Phase 0 | Effort | Depends |
> |---|---|---|---|
> | F1 {{name}} | {{closes journey X}} | L | — |
> | F2 {{name}} | {{ditto}} | M | F1 |
>
> `## Phase 1 — {{name}} · {{approx time}}`
>
> | Feature | Why in this phase | Effort | Depends |
> |---|---|---|---|
> | ... | ... | ... | ... |
>
> (repeat per phase)
>
> `## Coverage check`
>
> > Every breakdown feature appears above. Checklist:
>
> | Feature (from the README) | Assigned phase |
> |---|---|
> | F1 | 0 |
> | F2 | 0 |
> | F3 | 1 |
> | ... | ... |
>
> `## Anti-phasing`
>
> - ❌ {{What consciously does NOT enter any phase this round}}

## After generating

1. Save `docs/roadmap/fases-overview.md`.
2. Update `CLAUDE.md` Section 4: `**Active phase:** Phase 0 (anchor set)`.
3. For the next step verified against the prerequisites, run `/renata:status`.

## Arguments

`$ARGUMENTS`: optional — time horizon (e.g., "3 months") or desired number of phases.
