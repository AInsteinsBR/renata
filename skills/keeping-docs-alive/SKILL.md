---
name: keeping-docs-alive
description: Use whenever you finish a task, pause a session, complete a phase, or change the project status. Ensures the living docs (CLAUDE.md, .claude/sessions/, the active plan) reflect the real state so the next session can resume without loss of context. Auto-activates on "done", "pausing", "completed", "end of phase", "I'm going to stop now".
---

# Keeping docs alive during execution

Living docs are the **nervous system between sessions**. Without them kept up to date, the next session (human or AI) starts from scratch or worse — starts off wrong.

## When this skill activates

Auto-activates when the context involves:
- "Finished task X" / "task X is done"
- "I'm going to pause" / "stopping for today" / "we'll continue tomorrow"
- "Phase X complete"
- "I decided to change the approach to Y"
- "I'm going to open a PR / final commit"
- A plan checkbox being marked as complete

## Procedure (3 mandatory steps)

### Step 1 — Update the active plan

If the current work corresponds to a task in the plan at `docs/superpowers/plans/<plan>.md`:

1. **Check the checkboxes** of the completed steps: `[ ]` → `[x]`.
2. **Add a note** if the task deviated from the plan (e.g., "I had to add X because Y").
3. **Update the count** if there's a "completed: N/M" field in the plan.

### Step 2 — Update `CLAUDE.md`

Section 4 (Feature layer) — if there was a phase/feature change:
- `**Fase ativa:**` should point to the actual phase in progress.
- `**Feature-âncora:**` likewise.

Section 5 (Session layer) — whenever you pause/resume:
- Point to the current session file: `.claude/sessions/<data>-fase-N-<descrição>.md`.

Section 9 (Next steps) — update to reflect what comes next.

### Step 3 — Create/update the session file

`.claude/sessions/<YYYY-MM-DD>-fase-<N>-<descrição>.md`:

```markdown
# Sessão · YYYY-MM-DD · Fase N — <Descrição>

## Estado ao pausar

- **Plano ativo:** `docs/superpowers/plans/<file>.md`
- **Última task completada:** Task N (Step N.M)
- **Próxima ação ao retomar:** <1 frase específica>

## O que foi feito nesta sessão

- ...

## Pegadinhas descobertas

- (se houver)

## Decisões emergentes

- (se houver — pode virar ADR)

## Comandos engatilhados

\`\`\`bash
# Pra retomar:
cd <pasta>
docker compose ...
\`\`\`
```

## When NOT to activate

- ❌ Trivial change (typo, comment) — not worth cluttering the docs.
- ❌ Mid-task ("I just wrote a function") — wait until the whole task is complete.
- ❌ Refactoring that doesn't change the phase/feature/scope.

## Good example

> User: "Finished Task 4. I'm going to pause for today."
>
> Skill activates: "I'll update 3 things:
> 1. `docs/superpowers/plans/2026-05-27-fase-0-spike.md` — mark steps 4.1 through 4.11 as `[x]`.
> 2. `CLAUDE.md` section 5 — point to `.claude/sessions/2026-05-27-fase-0-task5.md`.
> 3. Create `.claude/sessions/2026-05-27-fase-0-task5.md` with 'Last task completed: Task 4 · Next action: implement the Task 5 component'."

## Anti-patterns

- ❌ Updating only the checkboxes and forgetting CLAUDE.md.
- ❌ Creating a session with "did several things" and no actionable detail.
- ❌ Not updating when "I'll continue tomorrow" — tomorrow you'll forget.
