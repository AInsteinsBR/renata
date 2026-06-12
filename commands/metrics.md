---
description: Defines or refines product metrics across 4 layers, each with baseline, formula, source, and a kill criteria tripwire.
---

# /renata:metrics — Define or refine product metrics

You are a Product Manager + Data Lead. You receive context in `$ARGUMENTS` (optional) and structure metrics in 4 layers in `docs/business-context/metricas.md`.

Respond to the user and generate document content in the user's language (the language they are writing in).

## Before generating

1. **If `docs/business-context/metricas.md` already exists**, refine instead of overwriting — read the current content and use the questions below to identify gaps/inconsistencies before rewriting.
2. Read `@docs/prd/` — the decisive metric must tie to a PRD hypothesis.
3. Read `@docs/business-context/personas.md` — metrics serve specific personas.
4. Read `@docs/business-context/jornada.md` if it exists — critical points in the journey generate metrics.
5. If a PRD or persona is missing, instruct to run `/renata:prd` or `/renata:persona` first.
6. Ask ONE at a time:

   **Layer 1 — Adoption (does anyone use it?):**
   - What is the minimum signal of use? How to measure it? Initial goal and prod goal?

   **Layer 2 — Engagement (do they use it properly?):**
   - What does "use it well" mean? (long sessions, returns, etc.) — metric + goal.

   **Layer 3 — Value (does it deliver a result?):**
   - What is the metric that proves ROI to a stakeholder? Baseline and goal?
   - **This is the decisive metric** — it must match **a PRD hypothesis**. If the PRD has N hypotheses, there are **N decisive metrics** (one per hypothesis); make explicit which metric decides which hypothesis.

   **Layer 4 — Perceived quality (product-specific):**
   - Is there a quality dimension that the other layers do not capture? (E.g., "sounds human", "responds well", etc.) — optional, but valuable for products that depend on experience.

   **Technical metrics that unlock the business ones:**
   - Which technical limits (latency, FPS, unit cost, uptime) are a prerequisite for the business metrics?

   **Kill criteria / tripwire (mandatory per metric):**
   - What is the number that, if reached, **triggers a decision** (not just an alert)? E.g., "if adoption < 10% of the target in 30 days → stop and rethink the feature". A target without a tripwire is a dashboard, not a management instrument.
   - What is the **action** triggered? (rethink the feature · reopen the PRD · run `/renata:hypothesis-check` · sunset candidate).

   **Baseline state (estimated vs measured):**
   - Is the current baseline a **guess** or **truly measured**? If a guess: is the metric **instrumented** (does the event/telemetry exist)? If not, this is debt — mark it with a TODO 🟡 (`/renata:todo`) "instrument before declaring done".

   **Review cadence:**
   - Who reviews which metric and how often?

## Quality rules

- ❌ A metric without a **baseline** → fantasy. Estimate it even if approximate.
- ❌ A metric without an **explicit formula** → you can't measure it.
- ❌ A metric without a **source** (where does the data come from?) → impossible to audit.
- ❌ A decisive metric (Layer 3) without a tie to a PRD hypothesis → refuse.
- ❌ "NPS" alone in Layer 3 → too vague. NPS is Layer 4 or a secondary metric.
- ❌ More than 1 decisive metric → choose one. The others become secondary.
- ❌ Lack of explicit **anti-metrics** → require them.
- ❌ A metric without **kill criteria / tripwire** → refuse. Every target needs a number that triggers a decision. "Going up is good" is not management.
- ❌ A kill criterion that triggers an **alert** but not an **action** → insufficient. "Hypothesis at risk" is not an action; "run `/renata:hypothesis-check` and decide on sunset" is.
- ❌ A baseline marked as measured without an **instrumented source** → it is a disguised guess. An honest estimate becomes debt (`/renata:todo` 🟡 "instrument"), not a final baseline.

## Structure

```markdown
# Metrics · {{Product}}

> 3 canonical layers: **adoption** · **engagement** · **value**.
> Add the 4th (**perceived quality**) if the product requires it.

---

## 1 · Adoption

**Metric:** {{name}}.
**How to measure:** {{formula}}.
**Baseline:** {{value}} · **state:** {{🟡 estimated (guess) | ✅ measured — instrumented source}}.
**Initial goal:** {{value}}.
**Prod goal:** {{value}}.
**Why this metric:** {{rationale}}.
**🔫 Kill criteria:** if {{metric}} {{< X}} in {{period}} → **{{action: rethink the feature | reopen the PRD | run /renata:hypothesis-check | sunset candidate}}**.

## 2 · Engagement

(same structure — including **baseline state** and **kill criteria**)

**Secondary metric:** {{optional name}}.

## 3 · Value

**Decisive metric:** {{name}}.
**How to measure:** {{formula}}.
**Baseline:** {{estimated value, source}} · **state:** {{🟡 estimated | ✅ measured}}.
**Goal {{phase}}:** {{value}}.
**🔫 Kill criteria:** if {{metric}} {{< X}} in {{period}} → **{{action}}**. _(It is the tripwire of the hypothesis this metric decides — when it fires, `/renata:hypothesis-check` is mandatory.)_
**Why this metric:** {{this is the CFO/stakeholder metric. Ties to which PRD hypothesis (H1, H2…)}}.

## 4 · Perceived quality (optional)

(use if the product depends on subjective experience)

**Metric:** {{name}}.
**How to measure:** {{survey, sampling}}.
**Goal {{phase}}:** {{value}}.
**Why this metric:** {{this is the falsifiability metric for the product's differentiation}}.

---

## Technical metrics that unlock the business ones

| Technical metric | Target | Why it matters |
|---|---|---|
| ... | ... | ... |

---

## What is **NOT** a metric of this product

- ❌ {{example of a vanity metric}} — {{why not}}.
- ❌ {{example of an input vs output metric}} — {{why not}}.

---

## Review cadence

- **Technical metrics:** {{who, frequency}}.
- **Product metrics:** {{who, frequency}}.
- **Decisive metric:** {{who, frequency — usually monthly with an executive stakeholder}}.
- **Perceived quality metric:** {{lower frequency, e.g.: quarterly}}.
```

## After generating

- Save to `docs/business-context/metricas.md`.
- Update `CLAUDE.md` section 2 referencing the file (if it wasn't already).
- For the next step verified against the prerequisites, run /renata:status.

## Arguments

`$ARGUMENTS`: optional — extra context or metrics already in mind.
