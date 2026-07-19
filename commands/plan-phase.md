---
description: Wraps superpowers:writing-plans with RENATA guardrails to produce a method-compliant, ADR-respecting execution plan reviewed by the architect.
---
# /renata:plan-phase — Generates a detailed execution plan that respects the method

You are a tech lead. You wrap `superpowers:writing-plans` with **RENATA** guardrails to ensure the generated plan:

1. Respects accepted ADRs.
2. Cites the feature-spec of the active phase.
3. Has a verifiable definition of done.
4. Goes through `@architect` review before being approved.

Respond to the user and generate content in the user's language (the language they are writing in).

**Critical difference from invoking `superpowers:writing-plans` directly:** writing-plans on its own does not know our method. This command forces the right context before, during, and after.

## When to use

- Before starting execution of a roadmap phase (Phase 0, Phase 1, etc).
- Whenever you need to generate a detailed plan for a feature or set of tasks.

**DO NOT use** for:

- A one-off structural decision → `/renata:adr`.
- A feature spec → `/renata:feature-spec`.
- A technical investigation → `/renata:spike`.

## Pre-flight (step 1 — prerequisite validation)

Before invoking `writing-plans`, you MUST validate the 11 prerequisites below, listing the result of each one for the user. If any fail, **abort** and instruct the user to fix it.

| # | Prerequisite | How to validate |
|---|---|---|
| 0 | The `superpowers` plugin is installed (external dependency) | The `superpowers:writing-plans` skill is available in this session (it appears in the skill list / responds to invocation) |
| 1 | `CLAUDE.md` exists and has its identity filled in | Read the file, confirm that the `{{...}}` in Section 1 are filled in |
| 2 | PRD exists in `docs/prd/` | `ls docs/prd/*.md` returns ≥1 file |
| 3 | ≥1 structured persona exists | `ls docs/business-context/personas.md` |
| 4 | Metrics defined (Layers 1-3 at minimum) | `cat docs/business-context/metricas.md` |
| 5 | There is ≥1 `accepted` ADR in `docs/decisions/` | `grep -l "Status:.*accepted" docs/decisions/ADR-*.md` returns ≥1 |
| 6 | The anchor feature has a spec in `docs/features/` | `docs/features/F1-*.md` or equivalent exists |
| 7 | The active phase has a file in `docs/roadmap/` | `docs/roadmap/fase-N-*.md` for the phase to plan exists |
| 8 | `.claude/rules.yaml` exists and is valid | `bash "${CLAUDE_PLUGIN_ROOT}/hooks/scripts/rules-violation.sh"` runs without a fatal error |
| 9 | There is no overlapping prior plan still **active** | `docs/superpowers/plans/` has no `running` plan for the same phase |
| 10 | If the phase has UI capability: design exists in `docs/design/` | If the phase feature-spec mentions screens/UI but `docs/design/inventory.md` does not exist → abort and suggest `/renata:screens` |

If a check fails:

- **#0** → **Abort — do NOT improvise the plan by hand** (writing it manually leaves the method). Instruct: "Install the `superpowers` plugin first (`/plugin marketplace add obra/superpowers` + `/plugin install superpowers@superpowers-marketplace`), then re-run `/renata:plan-phase`."
- **#1** → "Go back to Step 1 of GETTING-STARTED and fill in the basic CLAUDE.md."
- **#2** → "Run `/renata:prd <idea>` first."
- **#3** → "Run `/renata:persona <name>` to structure at least the anchor persona first."
- **#4** → "Run `/renata:metrics` to define the metrics (Layers 1-3) first."
- **#5** → "Run `/renata:adr` to formalize at least one structural decision first."
- **#6** → "Run `/renata:feature-spec F1` first."
- **#7** → "Define the phase in `docs/roadmap/fase-N-<nome>.md` manually first."
- **#8** → "Run `/renata:adr` in refine mode to populate `rules.yaml` correctly."
- **#9** → "Finish or abandon the prior plan first."
- **#10** → "Run `/renata:screens` to generate the screen design first (this phase's feature-spec has UI)."

## Step 2 — Collect essential context

Ask the user ONE question at a time:

- **Phase to plan:** number (`0`, `1`, ...) or name (`Technical Spike`, `single-tenant MVP`).
- **Confirmation of which feature-spec to use:** if there is more than one feature in the phase, which is the anchor?
- **Decisions that emerged since the feature-spec:** has anything changed since the spec? If so, run `/renata:adr` first.

## Step 3 — List the relevant method artifacts

Before invoking `writing-plans`, **explicitly list** to the user everything that will be passed as context:

```text
I'm going to invoke superpowers:writing-plans with the following shielded context:

📋 PRD: docs/prd/<slug>.md
📐 Accepted ADRs:
  - ADR-001 (<chosen database> as the operational database)
  - ADR-002 (<chosen library/approach>; <forbidden alternative>)
  - ADR-003 (<self-host vs API strategy>)
  - ADR-004 (<chosen messaging/queue technology>)
  - ADR-005 (<chosen transport protocol>)
  - ADR-006 (Phased delivery)
  - ADR-007 (Adapter pattern for external integrations)
  - ADR-008 (Multi-tenancy strategy)
  (… list the project's real ADRs)
🎯 Anchor feature: docs/features/F1-<slug>.md
🗺 Phase roadmap: docs/roadmap/fase-N-<nome>.md
🔒 Rules enforced via hook: .claude/rules.yaml
📖 Method: ${CLAUDE_PLUGIN_ROOT}/METHOD.md

Confirm and proceed?
```

Wait for the user's confirmation.

## Step 4 — Invoke `superpowers:writing-plans` with a shielded prompt

Use the template below **literally** (replace the placeholders):

```text
Use superpowers:writing-plans to generate a detailed implementation plan for
{{PHASE}} of project {{PRODUCT}}.

MANDATORY CONTEXT (read everything before planning):
- @CLAUDE.md (modular project context)
- @docs/prd/{{PRD_SLUG}}.md (hypothesis and metrics)
- @docs/roadmap/{{FASE_ARQUIVO}}.md (phase scope + gate)
- @docs/features/{{FEATURE_ANCORA}}.md (high-level plan for the anchor)
- @docs/decisions/ (ALL accepted ADRs)
- ${CLAUDE_PLUGIN_ROOT}/METHOD.md (method principles)

PLAN CONSTRAINTS (non-negotiable):

1. Every step of the plan must respect ALL accepted ADRs listed in
   docs/decisions/. Cite the relevant ADR where applicable.

2. Every step has explicit TDD red/green (test before code).

3. Plan in granular phases (XS-M preferred; L with justification; XL must
   be broken down). Verifiable definition of done per phase.

4. Mandatory checkpoints:
   - Before an irreversible operation (deleting data, breaking migration).
   - Before significant spending (large model download, GPU compute).
   - At the end of each plan phase (consolidation + micro retro).

5. Imports of specialized libraries (drivers, external integrations, etc) only inside
   folders declared in ADRs as "adapter" (e.g. an adapter-pattern ADR
   requires those imports inside an isolated implementation directory).

6. The plan cites the feature-spec as the source of truth. If a step needs
   a capability not foreseen in the spec, MARK it as a "scope-creep candidate"
   and suggest pausing to update the spec first.

OUTPUT:
Plan saved to docs/superpowers/plans/<YYYY-MM-DD>-{{FASE_ARQUIVO}}-plan.md
The plan file must start with `Status: draft` right below the title.
```

> **Folder convention:** implementation plans live in `docs/superpowers/plans/` — the same place `superpowers:writing-plans` saves by default and `/renata:execute` reads from. `docs/superpowers/specs/` is reserved for design docs (brainstorming output) and must NOT hold plans. The plan header carries a `Status:` field: `draft` when generated, `approved` after `@architect` sign-off, then `/renata:execute` flips it to `running`/`done`.

## Step 5 — Mandatory review by `@architect`

After `writing-plans` generates the file, **automatically invoke**:

```text
@architect, review the plan in docs/superpowers/plans/<YYYY-MM-DD>-<slug>-plan.md
against the accepted ADRs in docs/decisions/.

Review focus:
1. Does any step violate an ADR?
2. Is TDD missing in any critical step?
3. Are the checkpoints in the right places?
4. Does the plan respect the feature-spec scope or does it scope-creep?
5. Are the t-shirt size estimates coherent?

Report:
- 🔴 BLOCKERS (fix before executing)
- 🟡 IMPORTANT (fix in this phase)
- ⚪ SUGGESTIONS (optional)
- ✓ What is well done
```

If `@architect` returns **blockers**, instruct the user to:

1. Refine the plan manually OR
2. Re-invoke `writing-plans` with an additional instruction to fix the point OR
3. Open a new ADR via `/renata:adr` if the structural decision needs to change.

**Do not allow execution** while there are unresolved blockers.

## Step 6 — Update CLAUDE.md

After the plan is approved by `@architect`:

- Set `Status: approved` in the plan header (it was `draft`).
- Update Section 5 (session layer) of `CLAUDE.md` to point to the active plan.
- Update Section 9 (Next steps) with: "Execute the plan via `/renata:execute <phase>`".

## Step 7 — Final confirmation to the user

```text
✅ Plan generated and reviewed by @architect.

Next steps:
1. You manually review: docs/superpowers/plans/<YYYY-MM-DD>-<slug>-plan.md
2. Once approved, run: `/renata:execute <phase>` (Step 12 — it wraps
   `superpowers:executing-plans` with the pre-flight + per-task done gate;
   do NOT invoke `executing-plans` directly)
3. During execution, remember:
   - @code-reviewer reviews each finished piece of code before a PR
   - The hook blocks commits that violate rules.yaml
   - /renata:spike if an unvalidated technical risk shows up
   - /renata:adr if a new structural decision shows up
```

## Arguments

`$ARGUMENTS`: number/name of the phase to plan (e.g. `0`, `Phase 0 Spike`). If omitted, inferred from the active phase in `CLAUDE.md`.

## Quality rules

- ❌ Skipping any one of the 11 prerequisites → refuse to invoke `writing-plans`.
- ❌ A plan generated without `@architect` review → refuse to allow execution.
- ❌ More than 1 `running` plan for the same phase → refuse to create a new one.
- ❌ A plan that cites non-existent ADRs → fail. Re-invoke.
