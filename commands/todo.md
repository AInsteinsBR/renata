---
description: Manages the project's TODO backlog with inline markers in docs reconciled against a central, impact-ordered list, optionally mirrored to a task MCP.
---
# /renata:todo — Backlog of pending items (inline in the doc + central sync)

You manage the project's **TODO backlog**: pending items that do not block the current work but need to be recorded. The backlog lives in `docs/backlog/todos.md`, ordered by **impact on progress**.

Respond to the user and generate content in the user's language (the language they are writing in).

The flow has two sides that reconcile:
- **Inline:** the TODO is born glued to its context, on the originating line inside a doc.
- **Central:** `docs/backlog/todos.md` aggregates everything into a single, prioritizable view.

## Step 0 — Resolve integration (before saving)

The capability for this operation is **`tasks`**. Before any write:

1. Read `integrations:` in `.claude/rules.yaml`. Does the `tasks` capability have an entry?
2. **No entry** → operate 100% locally in `docs/backlog/todos.md` (default behavior). Skip to the normal flow.
3. **Has an entry, but the tools of the declared MCP are NOT available in the session** → warn ("MCP `<name>` declared for `tasks` but unavailable — saving locally only") and operate locally.
4. **Has an entry and the tools are available:**
   a. Save FIRST locally (`docs/backlog/todos.md` + inline marker). Local is the truth.
   b. If `mirror: true` → **ASK**: "Mirror this TODO in `<MCP>` (create/update a card)?". If confirmed → push via MCP, note the external id (e.g. `JIRA-123`) next to the local item. If declined → it stays local only; mirror later.
   c. If `mirror: false` → do not push a write.

> Degradation pattern identical to `etapa-gate.sh` (tool absent → warn, never block). Without an MCP, `/renata:todo` works entirely locally.

## When to use

- You used a provisional number/value in a doc (PRD, persona, metrics) and want to remember to validate it later — without blocking progress.
- You accumulated small scattered pending items and want a central view.
- You want to pull the next relevant pending item to work on.
- You closed a pending item and want to mark it done.

**Use `/renata:todo` for the persistent record of pending items.**
**Use `/renata:triage` when you need to prioritize a whole round in MoSCoW (the triage WON'Ts can become entries here).**
**Use `/renata:bug-report` first for a fresh production bug — it structures the report and can route straight into `add` here.**

## Inline marker convention

In the originating doc, on the very line where the pending item is born:

```markdown
We estimate ~10k users/month. <!-- TODO[2026-05-30][🟡]: validate with real analytics data -->
```

Format: `<!-- TODO[YYYY-MM-DD][impact]: text -->`
Impact is one of: `🔴` (blocks the phase) · `🟡` (does not block but matters) · `⚪` (nice-to-have).

## Modes (reads the first token of `$ARGUMENTS`)

### `add <text>` — adds directly to the central list

Use when the TODO did **not** originate inside a doc (a loose idea, general debt).

1. Ask for the impact if it is not obvious from the text (🔴/🟡/⚪).
2. Generate a short, stable `id`: `t-` + 4 chars of the text's hash (e.g. `t-9f3a`).
3. Add the line to the correct impact section of `docs/backlog/todos.md`, with Origin = `(manual)`, Status = `open`, Created = today's date.
4. Update the counter in the section title (e.g. `🟡 Does not block but matters (3)`).

### `sync` — scans the docs and reconciles with the central list

This is the most important mode. Do it **in this order**:

1. **Scan** all docs for inline markers:
   ```
   grep -rn "<!-- TODO\[" docs/ CLAUDE.md
   ```
2. For each marker found, derive the stable `id` (hash of the TODO text). Build the "present in docs" list.
3. **Add new ones:** a marker in a doc whose `id` is not in the central list → add it to the correct impact section. Origin = `file.md:line` (clickable link). Status = `open`.
4. **Detect orphans:** a central entry with Status `open`/`in-progress` whose `id` **no longer** appears in any doc → the marker disappeared. Do NOT close it automatically. Move the entry to the **⚠️ Orphans** section, recording which file it disappeared from and the detection date.
5. **Ask about each orphan** (one by one, or as a list if there are many):
   > "The TODO `<text>` disappeared from `<file>`. Was it **resolved** (I move it to Done) or **removed by mistake** (I re-insert the marker in the doc)?"
   - Resolved → move to ✅ Done with today's date.
   - By mistake → re-insert the inline marker in the originating doc and return the entry to its impact section.
6. **Do not duplicate:** an id already present and still in the doc → do nothing (unless the text/impact has changed; in that case update the existing line).
7. Update all section counters.
8. Report a summary: `X new · Y orphans detected · Z unchanged`.

### `list [filter]` — shows the backlog

- No filter: shows the entire central list, sections in the order 🔴 → 🟡 → ⚪ → ⚠️.
- `list blocking` / `list important` / `list nice`: filters by impact.
- `list orphans`: only orphans pending a decision.
- Always highlight at the top: if there are open 🔴s, warn "There is a TODO marked as phase-blocking that is open — this should be in /renata:phase-scope, not just in the backlog."

### `done <id>` — closes a TODO

1. Find the entry by its `id`.
2. Move it to ✅ Done with today's date.
3. If the TODO had an inline marker at the origin, **remove the marker from the doc** (or warn to remove it) — otherwise the next `sync` will re-add it.
4. Update counters.

## Quality rules

- ❌ TODO without a defined impact → refuse, ask 🔴/🟡/⚪. "Impact on progress" is the entire sorting axis.
- ❌ A 🔴 that has lived in the backlog for a while → it is not a TODO, it is phase work. Warn to move it to `/renata:phase-scope`.
- ❌ `sync` closing an orphan without asking → **forbidden**. An orphan always goes through human confirmation (Eric's decision).
- ❌ Duplicating an entry that already exists → the hash-based `id` exists precisely to avoid this. Always check before adding.
- ✅ Stable `id`: the same text → the same id, always. That is what makes reconciliation work across runs.

## After any mode

- Confirm in 1 line what changed in `docs/backlog/todos.md`.
- If any 🔴 is open, remind that it competes with the phase gate.
- Suggest the natural next step (e.g. after `sync` with orphans → resolve the orphans; after `add` 🔴 → run `/renata:phase-scope`).

## Arguments

`$ARGUMENTS`: `add <text>` · `sync` · `list [filter]` · `done <id>`. With no argument → assume `list`.
