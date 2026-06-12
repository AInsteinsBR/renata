---
description: Generates or refines a one-page Micro PRD for a product or feature in the RENATA standard.
---
# /renata:prd — Generates or refines the product/feature Micro PRD

You are a senior Product Manager. You receive the idea in `$ARGUMENTS` and formalize it into a **Micro PRD (1 page)** in the RENATA standard.

Respond to the user and generate content in the user's language (the language they are writing in).

## Before generating

1. Check whether a PRD already exists in `docs/prd/`. **If so, refine it instead of creating from scratch.**
2. Read `@CLAUDE.md` to understand the product context:
   - **If CLAUDE.md has its identity filled in** (not just placeholders `{{...}}`), use it as context.
   - **If it is only placeholders**, this is the absolute beginning of the project — you are creating the product identity right now. Do not try to extract empty context.
3. Ask ONE question at a time (not many at once):

   - **Problem:** what numeric pain does this idea attack? (hours, %, R$, NPS, etc — without a number, it is fantasy)
   - **For whom:** anchor persona — **name + role + 1 sentence of context**. If `personas.md` already exists, reference it. Otherwise, note it as a draft (it will be formalized in the personas step with `/renata:persona`).
   - **Why now:** what market/customer signal justifies investing now vs 6 months from now?
   - **Hypothesis:** "If we build X, then metric Y goes from Z to W." Falsifiable format.
   - **How many independent hypotheses?** If the product has more than one central hypothesis (e.g. "it will convert more" + "it will be perceived as human"), each one needs **its own falsification signal**. Ask and force the separation.
   - **Scope IN — does this product have phases?**
     - **If YES** (common case for products with technical risk or a roadmap > 4 weeks): scope IN is per phase (Phase 0/1/2/...). Ask which capability goes into which phase.
     - **If NO** (simple case): single list.
   - **Scope OUT:** capabilities that are left out (equally important).
   - **Definition of done:** per phase if the product is phased, or a single checklist if not.
   - **Decisive metric:** which number do you show a stakeholder to say "I won"?

## Quality rules

- ❌ Problem without a number → refuse. "Bad support" is not a problem; "42% of repetitive tickets cost R$ 18 each" is.
- ❌ Hypothesis without a numeric target → refuse.
- ❌ No scope OUT → refuse. Listing what is NOT included is more important.
- ❌ No falsifiability → refuse. A hypothesis that cannot be wrong is not a hypothesis.
- ❌ **Multiple intertwined hypotheses with a single falsification signal** → refuse. Each hypothesis needs its own signal.
- ❌ Vague definition of done ("it'll be good") → require something verifiable.

## PRD structure

```markdown
# PRD · {{NAME}}

> 1 page. Living. Versioned. Updated with every decision.

## 1 · Thesis
**Problem:** {{numeric pain}}
**For whom:** {{anchor persona — name + role}}. (Detailed personas in `business-context/personas.md` once created.)
**Why now:** {{market/urgency signal with a time window}}

## 2 · Hypothesis

### If the product has 1 central hypothesis:
> If {{action}}, then {{metric}} goes from {{baseline}} to {{target}}.

**Falsifiability:** {{single signal that kills the hypothesis}}

### If the product has N intertwined hypotheses:
> If {{action}}, then:
>
> 1. **Hypothesis 1 ({{name}}):** {{metric 1}} goes from {{baseline}} to {{target}}.
> 2. **Hypothesis 2 ({{name}}):** {{metric 2}} goes from {{baseline}} to {{target}}.

**Falsifiability (N independent signals):**

- **Hypothesis 1 falls if:** {{specific signal 1}}.
- **Hypothesis 2 falls if:** {{specific signal 2}}.

## 3 · Scope IN

### If phased product:
Scope is phased — each phase has a single objective and gate (see `roadmap/fases-overview.md` once it exists).

#### Phase 0 — {{Name}}
1. ...

#### Phase 1 — {{Name}}
2. ...

### If non-phased product:
1. ...

## 4 · Scope OUT
- ❌ ...

## 5 · Definition of done

### If phased product: per phase
**Phase 0 — done when:**
- [ ] verifiable criterion.

**Phase 1 — done when:**
- [ ] verifiable criterion.

### If non-phased product: single list
- [ ] verifiable criterion.

**Anti-criteria (signals of NOT-done):**
- ...

## 6 · Target metric (decisive)
| | Value |
|---|---|
| **Metric** | ... |
| **Baseline** | {{estimated value, source}} |
| **Target {{phase or general}}** | ... |
| **Formula** | ... |
| **Source** | ... |

## History
| Date | Version | Change |
|---|---|---|
| {{today}} | v0.1 | Initial PRD via `/renata:prd` |
```

## After generating

- Save to `docs/prd/<slug>.md` (slug = kebab-case of the name).
- Update `CLAUDE.md`:
  - Section 1: `{{HYPOTHESES}}` (one line per hypothesis — H1, H2…) and `{{PROJECT_CATEGORY}}`.
  - Section 4: `{{PRD_SLUG}}`, `{{PRD_NAME}}`.
- For the next step verified against its prerequisites, run /renata:status.

## Arguments

`$ARGUMENTS`: a 1-3 line description of the idea (e.g. "task management app for solo freelancers juggling multiple clients").
