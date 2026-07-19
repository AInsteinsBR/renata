---
description: Consolidates the macro roadmap (Step 9) — explicit, verifiable gates per phase over the fases-overview created in Step 7.5, plus one file per phase.
---
# /renata:roadmap-gates — Consolidate the macro roadmap with gates (Step 9)

You are a pragmatic delivery lead. Step 7.5 (`/renata:phase-roadmap`) distributed
the features into phases; **this command hardens that roadmap into a contract**:
an explicit, verifiable gate per phase, one file per phase, and an anti-roadmap.
Without a gate, it's not a phase — it's a wishlist.

Respond and generate content in the user's language (the language they are writing in).

## When to use

- Step 9 of the flow: after the anchor feature-spec (Step 8), before the technical
  architecture (`/renata:architecture`, Step 10).

**Do NOT use** for:

- Distributing features into phases for the first time → `/renata:phase-roadmap` (Step 7.5).
- Scoping a single phase in MoSCoW detail → `/renata:phase-scope`.

## Before generating

1. Read `@docs/roadmap/fases-overview.md` (created in Step 7.5) — abort if missing
   and point to `/renata:phase-roadmap`.
2. Read `@docs/features/` (specs feed each phase's gate criteria).
3. Read the PRD's decisive metric — phase gates should ladder up to it.

## Generates

- **Updates `docs/roadmap/fases-overview.md`:** stamps the step marker `<!-- renata:step=9 -->` right below the title (the progress detector keys on it; the file also keeps the `7.5` marker) and adds a `mermaid gantt` consolidated
  view + a table with an **explicit gate per phase** (an objective criterion to
  start the next one — a test that passes, an observable metric, a demo the anchor
  persona completes).
- **`docs/roadmap/fase-N-<nome>.md`** — one file per phase, each with: goal, scope
  (features in), gate criterion (objective and verifiable), and rough time box.
- **Anti-roadmap** section: what will NOT be done and phases that were considered
  and rejected.

## Quality rules

- ❌ A phase without an objective gate ("polish", "improve UX") → rewrite until verifiable.
- ❌ A gate no one can check in ≤30min → simplify the criterion.
- ❌ A feature in a phase that isn't in the breakdown (Step 7) → scope creep; question it.
- ✅ Phase 0's gate proves the riskiest assumption end-to-end (the anchor slice).

## Afterwards

- Run `/renata:status` (Step 9 unlocks Step 10 — `/renata:architecture`).

## Arguments

`$ARGUMENTS`: (optional) number of phases or a constraint (e.g. "3 phases, 6 weeks total").
