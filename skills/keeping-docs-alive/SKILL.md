---
name: keeping-docs-alive
description: Use whenever you finish a task, pause a session, complete a phase, or change the project status. Ensures the living docs (the active plan and CLAUDE.md Section 5) reflect the real state so the next session can resume without loss of context. Auto-activates on "done", "pausing", "completed", "end of phase", "I'm going to stop now".
---

# Keeping docs alive during execution

Living docs are the **nervous system between sessions**. Without them kept up to date, the next session (human or AI) starts from scratch or worse — starts off wrong.

There are exactly **two carriers** of resumable state — no third file:

1. **The active plan** (`docs/superpowers/plans/<plan>.md`) — execution truth: `Status:`, checkboxes, deviations.
2. **`CLAUDE.md` Section 5** (session layer) — a short prose block: where we stopped, what comes next.

> Until 0.4.x the method also asked for per-session files in `.claude/sessions/` — field projects proved it dead letter (the folder was never created; the state lived in the plan + Section 5 anyway). The convention was removed in 0.5.0. If you find a legacy `.claude/sessions/`, it's harmless history — don't create new files there.

## When this skill activates

Auto-activates when the context involves:
- "Finished task X" / "task X is done"
- "I'm going to pause" / "stopping for today" / "we'll continue tomorrow"
- "Phase X complete"
- "I decided to change the approach to Y"
- "I'm going to open a PR / final commit"
- A plan checkbox being marked as complete

## Procedure (2 mandatory steps)

### Step 1 — Update the active plan

If the current work corresponds to a task in the plan at `docs/superpowers/plans/<plan>.md`:

1. **Check the checkboxes** of the completed steps: `[ ]` → `[x]`.
2. **Add a note** if the task deviated from the plan (e.g., "I had to add X because Y").
3. **Update the count** if there's a "completed: N/M" field in the plan.

### Step 2 — Update `CLAUDE.md`

Section 4 (Feature layer) — if there was a phase/feature change:
- `**Fase ativa:**` should point to the actual phase in progress.
- `**Feature-âncora:**` likewise.

Section 5 (Session layer) — whenever you pause/resume, refresh the resumable-state block:

```markdown
**Plano ativo:** `docs/superpowers/plans/<file>.md` · **Última task:** Task N (Step N.M)
**Próxima ação:** <1 specific sentence>
**Pegadinhas:** <only if discovered this session — 1-2 lines, or omit>
```

Keep it **short** — Section 5 is loaded into every session. Emerging decisions don't belong here: they become an ADR (`/renata:adr`) or a TODO (`/renata:todo add`).

Section 9 (Next steps) — update to reflect what comes next.

## When NOT to activate

- ❌ Trivial change (typo, comment) — not worth cluttering the docs.
- ❌ Mid-task ("I just wrote a function") — wait until the whole task is complete.
- ❌ Refactoring that doesn't change the phase/feature/scope.

## Good example

> User: "Finished Task 4. I'm going to pause for today."
>
> Skill activates: "I'll update 2 things:
> 1. `docs/superpowers/plans/2026-05-27-fase-0-spike.md` — mark steps 4.1 through 4.11 as `[x]`.
> 2. `CLAUDE.md` Section 5 — 'Plano ativo: fase-0-spike · Última task: Task 4 · Próxima ação: implement the Task 5 component'."

## Anti-patterns

- ❌ Updating only the checkboxes and forgetting CLAUDE.md.
- ❌ Writing "did several things" in Section 5 with no actionable next step.
- ❌ Not updating when "I'll continue tomorrow" — tomorrow you'll forget.
- ❌ Creating `.claude/sessions/` files — that convention is dead; the plan + Section 5 carry everything.
