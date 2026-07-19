---
description: Generates a detailed spec for a single feature, including scope, value, dependencies, done criteria, and a phased plan.
---

# /renata:feature-spec — Generate a detailed spec for a feature

You are a tech lead. You receive the name/ID of the feature in `$ARGUMENTS` and generate a spec in `docs/features/F<N>-<slug>.md`.

Respond to the user and generate document content in the user's language (the language they are writing in).

## Before generating

1. Read `@CLAUDE.md`, `@docs/prd/`, `@docs/business-context/`.
2. Read relevant ADRs in `@docs/decisions/`.
3. If the feature has not yet been broken down/prioritized (it does not appear in `docs/features/README.md`), instruct to run `/renata:feature-breakdown` first.
4. **Detect the behavior spec:** check whether `docs/features/F<N>-<slug>.behavior.md` exists.
   - **If it exists:** read it as the source of the "what" (capabilities, scenarios, business rules, acceptance). Add it to the spec's "Links" section and add this note near the top of the generated spec: *"Observable behavior is in `F<N>-<slug>.behavior.md` — this spec covers only the technical how."* Derive the technical acceptance criteria FROM the behavior's Gherkin scenarios. **Do NOT copy** the behavior content into the spec (no duplication).
   - **If it does not exist:** proceed normally (the behavior spec is optional; the feature-spec stands alone).
5. Ask ONE at a time:

   - **Problem:** what pain does this feature attack? Which persona?
   - **Category:** `MUST` (without it a hypothesis falls) or `OUT-OF-SCOPE` (does not enter). Use only these two — intermediate categories (SHOULD/COULD) generate debate without gain. If the feature is not a MUST today, it is out; when it becomes a MUST, open a spec.
   - **Effort:** XS · S · M · L · XL.
   - **Enters in which phase:** Phase 0, 1, 2, ...
   - **Depends on which features?**
   - **IN scope:** capabilities that are included.
   - **OUT scope:** what stays out (refinement for a later phase).
   - **Done criterion:** verifiable for the current phase.

## Structure

> Right after the title line, the generated document MUST carry the step marker `<!-- renata:step=8 -->` (invisible when rendered). The progress detector (`/renata:status`, hooks) keys on it in any language — never remove or translate it.

```markdown
# F<N> · {{Feature name}}

> **Category:** {{MUST|OUT-OF-SCOPE}} · **Effort:** {{size}} · **Enters in:** {{phase}}.
> **Depends on:** {{features}}.

---

## Problem

{{2-3 paragraphs: the persona's pain, the constraint that imposes the feature, why other alternatives do not solve it}}

---

## Scope

### Capabilities

(IN list. Mermaid diagrams if they help.)

### How it works (high level)

(Sequence, state machine, flow — in mermaid if possible.)

---

## Value

(Why this feature matters. Tie it to the PRD's decisive metric if possible.)

---

## Dependencies

- {{other features}}
- {{infrastructure, e.g.: PostgreSQL}}

---

## Links

- PRD: `@docs/prd/<slug>.md` § {{section}}
- ADRs: `ADR-{{N}}` ({{theme}})
- Anchor persona: {{Name}}
- Metric it impacts: {{metric}}

---

## Done criterion ({{phase}})

- [ ] {{verifiable criterion 1}}
- [ ] {{verifiable criterion 2}}

---

## Refinements for a later phase

| Phase | What changes |
|---|---|

---

## Phased plan — F<N> ({{active phase}})

Granular and resumable phases (XS-M preferred; L with justification; XL must be broken down). Each phase with a clear done criterion.

### F<N>.1 · {{Name}} · {{size}}

**Objective:** ...

**Tasks:**

- [ ] ...

**Criterion:** ...

**Depends on:** ...

### F<N>.2 · ...
```

## Quality rules

- ❌ A feature without a cited anchor persona → require it.
- ❌ A feature without relevant cited ADRs → question it.
- ❌ A vague done criterion → require it to be verifiable.
- ❌ No "Refinements for a later phase" → require it; otherwise everything ends up in the current phase.
- ⚠️ A plan phase with size > **M** → question whether it should be broken down (not a hard rule — granular, resumable phases are preferred, but L is acceptable with justification; XL must be broken down).

## After generating

- Save to `docs/features/F<N>-<slug>.md`.
- Update `docs/features/README.md` with a line in the index.
- If it is the anchor feature, mark it ⚓ in the index.
- For the next step verified against the prerequisites, run /renata:status.

## Arguments

`$ARGUMENTS`: the feature name (e.g., "RAG knowledge base") or ID (e.g., "F3").
