---
name: detecting-scope-creep
description: Use whenever the urge to "also add X", "while I'm here", "since I'm already touching this" appears, or a capability not foreseen in the feature spec comes up. Compares the proposal against the IN/OUT scope of the active feature and forces a conscious decision before expanding the work.
---

# Detecting scope-creep before it happens

Scope-creep is the most common way to blow a phase deadline. Each "just one more little thing" costs time, attention, context, and risks the phase gate.

## When this skill activates

Auto-activates when the context involves phrases like:
- "Since I'm already here, I'll also..."
- "While I'm at it, I can add..."
- "It also makes sense to..."
- "I'll just quickly fix..."
- "We also need..."
- The proposal mentions a capability not listed in the active feature spec

## Procedure (3 steps)

### Step 1 — Identify the active feature + read the scope

1. Consult `CLAUDE.md` section 4 — what is the active anchor feature?
2. Read the feature's `docs/features/F<N>-*.md`.
3. Mentally list the IN scope and the OUT scope.

### Step 2 — Classify the proposal

Which category does the newly proposed thing belong to?

- **(A) Within the IN scope of the active feature** — OK. You may proceed.
- **(B) Within the explicit OUT scope** — STOP. Don't do it now.
- **(C) Not mentioned in IN or OUT** — gray area. Decide consciously.

### Step 3 — According to the classification

#### (A) It's in the IN

Proceed. Nothing to do.

#### (B) It's in the explicit OUT

**Decline clearly.** Suggested response:

> "This is marked as OUT scope in `docs/features/F<N>-*.md`. Reason: <cite from the doc>. If you've changed your mind, we can:
> 1. Defer it to the next phase (F<N+1>).
> 2. Open a new feature spec via `/feature-spec` if it has become a priority.
> 3. Consciously update the current feature (move it from OUT to IN with justification).
>
> For now, I'll follow the original scope."

#### (C) Gray area

Present the user with 3 conscious-decision options:

1. **Add it to IN now** — if it's critical for the current phase. Update the feature spec.
2. **Defer to the next phase** — record it via `/todo` or in the project backlog.
3. **Quick spike (`/spike`)** — if the question is "is it even worth it?".

**DO NOT code without an explicit decision.**

## Examples

### ✅ Good

> Eric: "Since I'm going to implement the anchor feature, I might as well also add detailed metrics (capability Z)."
>
> Skill activates: "I checked `docs/features/F1-<slug>.md` § Scope. Instrumentation is indeed listed as a capability. BUT the specific capability Z is not mentioned — F1 only covers the basics. Status: gray area.
>
> Options:
> 1. Keep only the basics in Phase 0 (aligned with the plan).
> 2. Add capability Z now (update the F1 spec first).
>
> I recommend option 1 — capability Z is planned in a later-phase feature (`F7-<slug>.md`). Adding it now turns into scope-creep of a future phase pulled into Phase 0."

### ❌ Bad

> Eric: "While I'm at it, I'll do basic auth at the edge."
>
> Skill **doesn't activate** or activates but is ignored: implementation moves forward.
>
> Result: Phase 0 (which has "no auth" in the OUT scope) gains untested, unreviewed auth code, and Phase 2 will inherit the debt. The Phase 0 gate slips.

### Special case: "preparatory" refactor

Typical phrase: "I'll go ahead and prepare the code for the multi-tenant support coming in Phase 2."

Generally **NO**. It's part of YAGNI discipline:
- Building an abstraction now for the "future" produces unvalidated code.
- By the time Phase 2 arrives, the requirements may have changed.
- The `@architect` would probably reject this in review.

Exception: if the cost of doing it now is trivial AND the cost of doing it later is high (e.g., a column name). Then it's OK, but DECLARE it.

## Anti-patterns of this skill

- ❌ Accepting a gray area as "when in doubt, do it" — force a decision.
- ❌ Confusing a "quality refactor" (within the code you're already touching) with scope-creep (a new capability).
- ❌ Not consulting the active feature spec before classifying.
