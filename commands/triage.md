---
description: Triages an unprioritized list of bugs, debt, and tasks into a full MoSCoW breakdown with justification and an attack order.
---
# /renata:triage — Backlog triage using MoSCoW (bugs, debt, tasks)

You are a pragmatic tech lead. You receive an **unprioritized list of items** (bugs, technical debt, polish tasks, customer requests) and organize them into a **full MoSCoW** breakdown with justification.

Respond to the user and generate content in the user's language (the language they are writing in).

## When to use

- A queue of bugs piled up during a phase and you need to decide what to fix before the release.
- The customer sent a list of requests — you need to separate what goes in immediately.
- Technical debt piled up — you need to prioritize what to pay first.
- Before sprint or cycle planning.

**Use `/renata:triage` (this one) to prioritize ongoing work (MoSCoW gradation).**
**Use `/renata:feature-breakdown` to define the product (binary MUST vs OUT-OF-SCOPE).**
**Use `/renata:phase-scope` to decide what fits in the current phase with a fixed budget.**

## Step 0 — Resolve integration (before saving the triage)

The capability is **`tasks`**. Before saving the triage result:

1. Read `integrations:` in `.claude/rules.yaml`. Does the `tasks` capability have an entry?
2. **No entry** → save the triage locally only (default behavior).
3. **Has an entry but the MCP tools are unavailable** → warn and save locally only.
4. **Has an entry and the tools are available:** save locally first; if `mirror: true`, **ask** before mirroring the prioritized items to `<MCP>` (e.g. create Jira cards for the MUSTs). If confirmed → push + note the ids. If declined → local only.

> Degradation identical to `etapa-gate.sh`: without an MCP, it operates 100% locally.

## Before generating

1. Read `@CLAUDE.md` (active phase, principles).
2. Read `@docs/prd/` (understand what matters for the product).
3. Read `@docs/roadmap/fase-<atual>.md` (the current phase gate — items that threaten the gate are MUST).
4. Ask ONE question at a time:

   - **The list:** which items to triage? (paste text, issue links, or a file path)
   - **Context:** what is happening right now? (release coming up, beta with a customer, spike phase, etc)
   - **Constraint:** deadline or time budget? (affects the MoSCoW cut)

## How to classify (clear rules)

### 🔴 MUST

**Without this, the current phase gate fails OR the product causes harm in prod.**

Signals:
- Blocks the phase's definition of done.
- Bug with data loss/corruption.
- Active security vulnerability.
- Crash affecting > 5% of sessions.
- Public promise / SLA / contract.

### 🟠 SHOULD

**Desirable; if time runs short, the phase still passes but with an asterisk.**

Signals:
- Bug that affects UX but not data.
- Suboptimal performance but within target.
- Important documentation but the team can operate without it.
- Refactor that unlocks the next phase's velocity.

### 🟡 COULD

**Nice to have; if there is time left over between MUST and SHOULD.**

Signals:
- UI polish.
- Rare edge case (<1% of sessions).
- Nice-to-have metric.
- Small quality refactor.

### ⚫ WON'T (this round — explicit)

**Consciously decided that it does NOT go in now. Goes to the formal backlog.**

Signals:
- Out of scope for the current phase.
- Effort disproportionate to the gain.
- Requires an ADR decision first.
- "I know it exists, but not now."

## Quality rules

- ❌ Everything MUST → impossible. Force a gradation. If honestly everything is critical, the problem is the phase scope, not the triage.
- ❌ No WON'T → suspicious. Every real triage has something consciously left out.
- ❌ Classification without a **1-line justification** → refuse. "MUST because" does not count.
- ❌ Item ambiguous between SHOULD and MUST → pull it to SHOULD by default. A MUST has to be indisputable.

## Output structure

Save to `docs/triage/<YYYY-MM-DD>-<contexto>.md` (create the folder if it does not exist):

```markdown
# Triage · {{context}}

> **Date:** {{YYYY-MM-DD}}
> **Context:** {{e.g. accumulated Phase 0 bugs / beta customer requests / pre-release refactor}}
> **Time/budget constraint:** {{e.g. 3 days / 1 sprint / before release X}}
> **Active phase:** {{Phase N}}

---

## 🔴 MUST ({{count}})

> Without this, the phase gate fails or the product causes harm. **Attack first.**

| # | Item | Why MUST | Effort |
|---|------|----------|--------|
| 1 | {{description}} | {{1 line}} | XS/S/M |

---

## 🟠 SHOULD ({{count}})

> Desirable; do it after MUST if time permits.

| # | Item | Why SHOULD | Effort |
|---|------|------------|--------|
| ... | ... | ... | ... |

---

## 🟡 COULD ({{count}})

> Nice to have; left over between MUST and SHOULD.

| # | Item | Why COULD | Effort |
|---|------|-----------|--------|
| ... | ... | ... | ... |

---

## ⚫ WON'T (this round) ({{count}})

> Consciously out. Goes to the formal backlog for the next triage.

| # | Item | Why WON'T now | When to reconsider |
|---|------|---------------|--------------------|
| ... | ... | ... | ... |

---

## Recommended attack order

1. **Today/tomorrow:** MUST #1, MUST #2 (total effort: ...).
2. **Then:** remaining MUSTs.
3. **If there is time left:** SHOULD #1, SHOULD #2.
4. **Do not attack:** COULD this round (next triage).
5. **Formalize:** move the relevant WON'Ts to the persistent backlog with `/renata:todo add <item>` (they go to `docs/backlog/todos.md`, classified by impact) — so they do not get lost between triage rounds.

## Total estimate

- MUST: {{sum}}
- SHOULD: {{sum}}
- COULD: {{sum}}
- Available budget: {{time}}
- Realistic to deliver: {{MUST/SHOULD/COULD as far as it fits}}

## Risks identified in this triage

- {{risk that came up while triaging — e.g. "2 MUSTs depend on the same file, parallelizing is hard"}}
```

## After generating

- Save to `docs/triage/<data>-<contexto>.md`.
- If MUST > budget, warn: "More MUSTs than fit. You need to cut the phase scope or move MUSTs to the next phase."
- If WON'T has things that affect ADRs, suggest: "Item X probably becomes an ADR. Run `/renata:adr` before re-triaging."
- Suggest the next step: start with MUST #1.

## Arguments

`$ARGUMENTS`: the triage context (e.g. "Phase 0 bugs before the gate", "requests from customer XPTO").
