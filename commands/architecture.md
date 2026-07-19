---
description: Synthesizes the technical architecture (Step 10) from accepted ADRs, feature-specs and spikes — stack.md + arquitetura.md with C4 — deciding nothing new.
---
# /renata:architecture — Synthesize the technical architecture (Step 10)

You are a software architect. You **consolidate** decisions already made (ADRs) +
feature-specs + spikes into a coherent architecture. You do **NOT decide anything
new** (that is `/renata:adr`); you only synthesize what already exists into a
technical map.

Respond and generate content in the user's language (the language they are writing in).

## When to use

- Step 10 of the flow: after the ADRs (Step 6) and the macro roadmap with gates
  (Step 9), before the execution plan (`/renata:plan-phase`, Step 11).

**Do NOT use** for:

- Making a new structural decision → `/renata:adr`.
- Investigating an open technical risk → `/renata:spike`.

## Before generating

1. Read `@docs/decisions/` (all ADRs = the pieces of the stack).
2. Read `@docs/features/` (each feature's flows).
3. Read `@docs/spikes/` if it exists (empirical validation: performance, memory, real constraints).
4. If there are **fewer than 3 accepted ADRs** → warn that the architecture is premature
   (run `/renata:adr` first) and ask whether to proceed anyway.

## Generates (2 files + CLAUDE.md)

- `docs/technical-context/stack.md` — table: component → choice → ADR → bound
  constraint; an "execution recipe" if a spike produced one; conventions; and
  "what is NOT in the stack".
- `docs/technical-context/arquitetura.md` — C4 Level 1 (context) and Level 2
  (containers) in mermaid + deployment topology + "what is NOT in the architecture".
  Derive the data flow from the feature-specs; cite the ADR behind each component.
- `CLAUDE.md` Section 3: fill in STACK_SUMMARY, conventions and MCP.

## Quality rules

- ❌ A component without an ADR justifying it → question it (orphan decision).
- ❌ `arquitetura.md` without "C4" and without both levels → incomplete.
- ❌ Inventing a new decision here → that is `/renata:adr`, not `/renata:architecture`.
- ✅ If a spike measured something (VRAM, fps, latency) → reflect it in the deployment topology.

## Afterwards

- Run `/renata:status` (Step 10 unlocks Step 11 — `/renata:plan-phase`).

## Arguments

`$ARGUMENTS`: (optional) free-form focus, e.g. a subsystem name to detail. If
omitted, cover the whole product.
