# Interview Loop + Positioning Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add the Steve Blank / Mom Test interview loop to RENATA (2 new commands + evidence seals + integrations) and the positioning/lineage sections to README/METHOD, releasing as v0.1.7.

**Architecture:** RENATA is a Claude Code plugin: commands are markdown prompt files in `commands/`, the scaffold lives in `template/`, and docs are bilingual (`*.md` English + `*.pt-br.md` Portuguese). There is no automated test suite — verification is done with grep checks and reading the rendered output. Spec: `docs/superpowers/specs/2026-07-03-interview-loop-design.md`.

**Tech Stack:** Markdown command prompts, YAML (progress-map), git.

## Global Constraints

- **Repo:** all paths relative to `/Users/ericluque/projetos/AIginite/_renata-plugin`.
- **Command files are written in ENGLISH** (like `discovery.md`, `assumption-test.md`), each containing the line: `Respond to the user and generate document content in the user's language (the language they are writing in).`
- **Identifiers in English** (command names, file names); user-facing scaffold content (template/) in Portuguese.
- **Bilingual docs:** every edit to `README.md`, `METHOD.md`, `GETTING-STARTED.md`, `CHANGELOG.md` must have the equivalent edit in its `.pt-br.md` twin.
- **Commit messages: NEVER add `Co-Authored-By: Claude` or any Claude/Anthropic attribution.** (Explicit standing request from Eric.)
- **Evidence seal scale (canonical, used verbatim everywhere):** 🔴 belief · 🟡 anecdote · 🟢 interviewed (N≥3, spontaneous) · ✅ measured. Seals **never block** — they force honesty.
- **v1 accepts ready transcripts ONLY** — an audio file path is politely refused.
- **Version:** bump `0.1.6` → `0.1.7` (pattern: 0.1.5 and 0.1.6 were also single-feature command additions).
- Markdown tables in commands use the repo's compact style (`|---|`); ignore MD060 linter warnings.

---

### Task 1: Create `commands/interview-kit.md`

**Files:**
- Create: `commands/interview-kit.md`

**Interfaces:**
- Produces: the command `/renata:interview-kit`; output artifact `docs/interviews/kits/<YYYY-MM-DD>-<slug>.md` (Task 2's debrief reads these kits; Tasks 4-9 reference the command by name).

- [ ] **Step 1: Write the file**

Create `commands/interview-kit.md` with exactly this content:

````markdown
---
description: Generates a one-page Mom Test field guide for a problem interview, anchored on one risky assumption — made to be read on your phone on the way to the interview.
---

# /renata:interview-kit — The field guide for a problem interview

You are a Product Discovery lead (Steve Blank / Rob Fitzpatrick school — Customer Development + The Mom Test). You take **one risky assumption** and generate a **one-page field guide** the user can read on their phone on the way to the interview. The interview itself happens away from the computer — the kit is everything they carry.

Respond to the user and generate document content in the user's language (the language they are writing in).

It is the *before* half of the interview loop (`/renata:interview-debrief` is the *after*). It materializes "get out of the building": the evidence seals (🔴 belief → 🟡 anecdote → 🟢 interviewed → ✅ measured — see `METHOD.md` › "The evidence seals") only advance with real-world contact.

## When to use

- The discovery's chosen bet (or a PRD hypothesis) carries a 🔴 belief / 🟡 anecdote seal and you are about to invest on top of it.
- `/renata:assumption-test` chose "problem interview" as the cheapest test.
- You have an interview scheduled and don't want to improvise the questions.

## Before generating

1. Read `docs/assumptions/*.md` (preferred) or `docs/discovery/*.md` (fallback) — find the assumption to test and its falsification signal. `$ARGUMENTS` may name it directly.
2. Read `docs/business-context/personas.md` (if it exists) or the discovery's persona seed — who to interview.
3. Ask ONE at a time (only what is missing):
   - **Which assumption is this interview for?** (1 kit = 1 assumption — focus)
   - **Who are you meeting?** (profile/role, not name)

## Kit structure

Write to `docs/interviews/kits/<YYYY-MM-DD>-<slug>.md` — **create the folders if they do not exist** (projects scaffolded before this version don't have `docs/interviews/`).

**ONE page, mobile-first:** short lists, short lines, no wide tables. It will be read on a phone screen minutes before the conversation.

```markdown
# Interview Kit · {{assumption-slug}}

> 🎯 **Testing:** {{the assumption, one line}}
> ❌ **FALSE if:** {{falsification signal, one line}}
> 👤 **Interviewing:** {{profile}}

## Opening (no pitch — ever)

- Honest context: "I'm researching how people deal with {{problem area}} — I want to learn from your experience, I'm not selling anything."
- Ask permission to record: "Mind if I record so I don't have to take notes?"

## The questions (past & behavior — never future & opinion)

1. "Tell me about the last time you {{faced the problem}}."
2. "What did you do about it? Walk me through it."
3. "What have you already tried? What did that cost you (time/money)?"
4. "How often does this happen? When was the time before last?"
5. "Who else was involved / affected?"
6. {{1-2 more, specific to the assumption}}

## NEVER ask

- "Would you use...?" · "Would you pay...?" · "Do you like the idea?"
- Anything starting with "imagine if" or "in the future".
- If you catch yourself pitching → stop, go back to their past.

## Listen for

- 🥇 **Gold:** pain told spontaneously · a workaround they built · money/time already spent.
- 🚮 **Noise:** compliments · hypotheticals · polite answers ("sounds great!").

## Closing

- "Who else do you know that deals with this?" (referrals = earlyvangelist detection)
- "Can I get back to you when I have something?" (a real yes is a signal)
```

## Quality rules (what you refuse)

- ❌ A future/hypothetical/opinion question in the script → rewrite it to past/behavior before saving.
- ❌ A kit without a target assumption linked to a doc → require the origin (discovery or assumption doc).
- ❌ More than 1 assumption per kit → split; each interview tests one thing.
- ❌ Any pitch before the questions → the opening states context, never the solution.

## After generating

- Save the kit and tell the user: **record the interview** — the phone recorder, Meet or Zoom already transcribe for you.
- On return: run `/renata:interview-debrief` with the transcript. After N≥3 interviews with a clear pattern, `/renata:assumption-test` issues the verdict.

## Arguments

`$ARGUMENTS`: optional — the assumption to test (text or slug) and/or who will be interviewed. With no argument, lists the assumptions found in `docs/assumptions/` / `docs/discovery/` and helps choose the riskiest one.
````

- [ ] **Step 2: Verify structure matches sibling commands**

Run: `grep -c "Respond to the user" commands/interview-kit.md && head -3 commands/interview-kit.md`
Expected: `1` and a frontmatter block starting with `---` and a `description:` line.

- [ ] **Step 3: Commit**

```bash
git add commands/interview-kit.md
git commit -m "feat: add /renata:interview-kit — Mom Test field guide for problem interviews"
```

---

### Task 2: Create `commands/interview-debrief.md`

**Files:**
- Create: `commands/interview-debrief.md`

**Interfaces:**
- Consumes: kits at `docs/interviews/kits/*.md` (Task 1); evidence seal scale (Global Constraints).
- Produces: the command `/renata:interview-debrief`; artifacts `docs/interviews/<YYYY-MM-DD>-<slug>.md` (one per interview) and `docs/interviews/README.md` (aggregate evidence board). Tasks 4-9 reference the command by name.

- [ ] **Step 1: Write the file**

Create `commands/interview-debrief.md` with exactly this content:

````markdown
---
description: Processes an interview transcript — extracts verbatim signals per assumption, updates the evidence board and seals, and coaches the interviewer against Mom Test rules.
---

# /renata:interview-debrief — From transcript to evidence (and better questions next time)

You are an honest, skeptical researcher (Mom Test school). You take a **ready transcript** of a problem interview and turn it into evidence: verbatim quotes classified by strength, an updated evidence board, promoted (or demoted) evidence seals — plus **mandatory coaching** on the interviewer's own questions, so the next interview is better than this one.

Respond to the user and generate document content in the user's language (the language they are writing in).

It is the *after* half of the interview loop (`/renata:interview-kit` is the *before*). The verdict on the assumption itself belongs to `/renata:assumption-test` — this command only accumulates and grades the evidence.

## Input rule (hard)

- **Ready transcript ONLY**: pasted text or a path to a text/markdown file.
- If given an **audio/video file path** (.mp3, .m4a, .wav, .mp4, .ogg): politely refuse — *"Give me the transcript — your recorder/Meet/Zoom already produces one."* Raw-audio integration is a declared future evolution, not a v1 gap to work around.

## Before generating

1. Get the transcript (`$ARGUMENTS` = text or file path; if missing, ask for it).
2. Read `docs/interviews/kits/*.md` — find the matching kit (ask if ambiguous). No kit is acceptable (interview happened before the kit existed) — then ask which assumption(s) it targets.
3. Read the source docs the kit points to (`docs/assumptions/*.md` / `docs/discovery/*.md`).
4. Ask ONE at a time (only what is missing): **who was interviewed** (profile/role, not name — keep transcripts pseudonymous) and **when**.

## Signal classification (the core)

Every signal is a **verbatim quote** — paraphrase is NOT evidence. Classify each:

| Class | Meaning | Counts as evidence? |
|---|---|---|
| 🥇 spontaneous | the person brought it up unprompted | Yes — strongest |
| 🥈 prompted | direct answer to a question | Weak — supporting only |
| 🚫 contaminated | came after a pitch / leading question | No — discard, and flag it in coaching |

## What it produces (three things, always)

### 1. The individual debrief

Write to `docs/interviews/<YYYY-MM-DD>-<slug>.md` — **create the folder if it does not exist**:

```markdown
# Interview Debrief · {{profile}} · {{YYYY-MM-DD}}

> **Kit:** {{link or "none — pre-kit interview"}} · **Assumption(s):** {{list}}
> **Interviewed:** {{profile/role}} · **Window:** {{duration if known}}

## Signals per assumption

### {{assumption A}}
| Class | Verbatim quote | Reading |
|---|---|---|
| 🥇 | "{{exact words}}" | {{supports / weakens — why}} |
| 🥈 | "{{exact words}}" | {{...}} |
| 🚫 | "{{exact words}}" | discarded — came after {{pitch/leading question}} |

## Surprises (things no assumption predicted)
- {{spontaneous signal that fits no current assumption — candidate for a new one}}

## Interviewer coaching (mandatory)
- ✅ {{what worked — question that opened a story}}
- ⚠️ {{question X was a pitch/future question → the following answer is contaminated; ask "{{rewritten version}}" next time}}
```

### 2. The evidence board

Update `docs/interviews/README.md` (**create it if it does not exist**) — one row per assumption:

```markdown
# Evidence Board · Interviews

> Verdict lives in /renata:assumption-test. This board only accumulates graded evidence.

| Assumption | Interviews | 🥇 for | 🥇 against | Current seal | Debriefs |
|---|---|---|---|---|---|
| {{A}} | {{N}} | {{n}} | {{n}} | {{🔴/🟡/🟢}} | {{links}} |
```

### 3. The seal updates

Promote/demote the evidence seal **in the source docs** (discovery / assumption):

- 🔴 belief → 🟡 anecdote: 1-2 interviews with a 🥇 signal.
- 🟡 → 🟢 interviewed: consistent 🥇 pattern in **N≥3** interviews.
- **Demotion is real:** if interviews contradict the assumption, say so — 🟢 does not mean "confirmed", it means "we actually listened". The ❌ verdict belongs to `/renata:assumption-test`.

## Quality rules (what you refuse)

- ❌ Issuing a verdict on the assumption → that is `/renata:assumption-test`'s job, with N≥3 interviews.
- ❌ Paraphrase as evidence → verbatim quotes only.
- ❌ Skipping the coaching → mandatory in every debrief, even a clean one (reinforce what worked).
- ❌ Accepting audio → transcript only (v1).
- ❌ Counting 🚫 contaminated quotes in the board → they exist only as coaching material.

## After generating

- Save the debrief, update the board, update the seals in the source docs.
- If the board reaches **N≥3 with a clear pattern**: suggest `/renata:assumption-test` for the verdict.
- If signals contradict the discovery's chosen bet: say it plainly — evidence reopens decisions (see `METHOD.md` › "The loop closes").
- If "Surprises" surfaced a new candidate assumption: suggest recording it via `/renata:assumption-test`.

## Arguments

`$ARGUMENTS`: the transcript (pasted text) or a path to a transcript file. Optionally prefixed by the kit/assumption slug. With no argument, asks for the transcript.
````

- [ ] **Step 2: Verify**

Run: `grep -c "Respond to the user" commands/interview-debrief.md && grep -c "N≥3" commands/interview-debrief.md`
Expected: `1` and ≥3 occurrences of `N≥3`.

- [ ] **Step 3: Commit**

```bash
git add commands/interview-debrief.md
git commit -m "feat: add /renata:interview-debrief — transcript to graded evidence + interviewer coaching"
```

---

### Task 3: Template scaffold (`docs/interviews/` for new projects + template docs)

**Files:**
- Create: `template/docs/interviews/.gitkeep`
- Create: `template/docs/interviews/kits/.gitkeep`
- Modify: `template/docs/README.md` (folders table)
- Modify: `template/CLAUDE.md.template` (validation commands section, lines ~92-95)

**Interfaces:**
- Consumes: command names from Tasks 1-2.
- Produces: scaffold folders copied by `/renata:init` (`cp -R template/. .`).

- [ ] **Step 1: Create the .gitkeep files**

```bash
mkdir -p template/docs/interviews/kits
touch template/docs/interviews/.gitkeep template/docs/interviews/kits/.gitkeep
```

- [ ] **Step 2: Add the folder to `template/docs/README.md`**

In the `## Pastas` table, after the row for `roadmap/`, add:

```markdown
| `interviews/` | Kits de entrevista (roteiros Mom Test) + debriefs + board de evidência. | Antes de sair pra campo e ao voltar de uma entrevista. |
```

- [ ] **Step 3: Add the commands to `template/CLAUDE.md.template`**

In the section `### Slash commands de validação de produto (Measure-Learn — fecha o loop)`, after the `/assumption-test` line and before `/hypothesis-check`, add:

```markdown
- `/interview-kit [premissa]` — roteiro Mom Test de 1 página pra entrevista de problema (lido no celular a caminho)
- `/interview-debrief <transcrição>` — processa a transcrição: evidência verbatim por premissa + board + coaching do entrevistador
```

- [ ] **Step 4: Verify**

Run: `ls template/docs/interviews/kits/.gitkeep && grep -c "interview" template/CLAUDE.md.template template/docs/README.md`
Expected: the .gitkeep path, and count ≥2 in CLAUDE.md.template, ≥1 in template/docs/README.md.

- [ ] **Step 5: Commit**

```bash
git add template/
git commit -m "feat: scaffold docs/interviews (kits + board) and list interview commands in template"
```

---

### Task 4: Evidence seals + 4th seed in `commands/discovery.md` (+ progress-map)

**Files:**
- Modify: `commands/discovery.md`
- Modify: `template/.claude/progress-map.yaml` (step 1.5 `validacao`)

**Interfaces:**
- Consumes: seal scale (Global Constraints); command names from Tasks 1-2.
- Produces: discovery docs that carry seals and a 4th seed — `interview-debrief` (Task 2) edits these seals.

- [ ] **Step 1: Add the seal teaching to the procedure**

In `commands/discovery.md`, after the `### 6. Converge` block, replace:

```markdown
### 7. Seed (clues, NOT artifacts)
Record clues for the next steps — but do NOT formalize them (that's the dedicated commands' job):
- **Persona candidate** (clue for `/renata:persona`)
- **How they solve it today** (clue for `/renata:user-journey`)
- **Imagined success signal** (clue for `/renata:metrics`)
```

with:

```markdown
### 7. Stamp the evidence (teach it)
Say one line first: *"Everything we just produced is hypothesis, not fact — let's stamp each piece with its real evidence level, so nobody mistakes conviction for confirmation."* Stamp the real pain, the JTBD and the why-now with the evidence seal (see `METHOD.md` › "The evidence seals"): 🔴 belief (founder only) · 🟡 anecdote (1-2 informal reports) · 🟢 interviewed (pattern heard in N≥3 interviews) · ✅ measured. The seal does NOT block converging — it forces honesty about what the bet stands on.

### 8. Seed (clues, NOT artifacts)
Record clues for the next steps — but do NOT formalize them (that's the dedicated commands' job):
- **Persona candidate** (clue for `/renata:persona`)
- **How they solve it today** (clue for `/renata:user-journey`)
- **Imagined success signal** (clue for `/renata:metrics`)
- **Riskiest assumption** (clue for `/renata:assumption-test` / `/renata:interview-kit` — the cheapest way to move a 🔴 seal is to get out of the building)
```

- [ ] **Step 2: Update the output structure**

In the `## Structure to generate` block of `commands/discovery.md`, apply these three edits:

Replace `## The real pain (5 whys)` with:

```markdown
## The real pain (5 whys)
> Evidence: {{🔴 belief | 🟡 anecdote | 🟢 interviewed | ✅ measured}}
```

(apply the same `> Evidence:` line under `## The job-to-be-done` and `## Why now`), replace:

```markdown
## The chosen bet
{{the clear problem + audience + direction — ready for the PRD}}
```

with:

```markdown
## The chosen bet
> Evidence level of this bet: {{worst seal among pain/JTBD/why-now}} {{if 🔴/🟡: "— consider /renata:interview-kit before the PRD"}}

{{the clear problem + audience + direction — ready for the PRD}}
```

and replace the seeds block:

```markdown
## 🌱 Seeds for the next steps
- **Persona candidate:** {{who suffers — clue for /renata:persona}}
- **How they solve it today:** {{clue for /renata:user-journey}}
- **Imagined success signal:** {{clue for /renata:metrics}}
```

with:

```markdown
## 🌱 Seeds for the next steps
- **Persona candidate:** {{who suffers — clue for /renata:persona}}
- **How they solve it today:** {{clue for /renata:user-journey}}
- **Imagined success signal:** {{clue for /renata:metrics}}
- **Riskiest assumption:** {{what must be true for the bet to work — clue for /renata:assumption-test or /renata:interview-kit}}
```

- [ ] **Step 3: Add the quality rule**

In `## Quality rules (what you refuse)` of `commands/discovery.md`, add as a new last bullet:

```markdown
- ❌ A chosen bet without a declared evidence seal → require the stamp; 🔴 is a valid answer, hiding it is not.
```

- [ ] **Step 4: Update the progress-map validation**

In `template/.claude/progress-map.yaml`, step `1.5`, replace:

```yaml
      - "Sementes pra persona/jornada/métrica registradas"
```

with:

```yaml
      - "Sementes pra persona/jornada/métrica + premissa mais arriscada registradas"
      - "Aposta escolhida tem selo de evidência declarado (🔴/🟡/🟢/✅)"
```

- [ ] **Step 5: Verify**

Run: `grep -c "Evidence" commands/discovery.md && grep -c "selo" template/.claude/progress-map.yaml`
Expected: ≥5 in discovery.md, 1 in progress-map.yaml.

- [ ] **Step 6: Commit**

```bash
git add commands/discovery.md template/.claude/progress-map.yaml
git commit -m "feat: evidence seals + riskiest-assumption seed in /renata:discovery"
```

---

### Task 5: Integrate the loop into `commands/assumption-test.md`

**Files:**
- Modify: `commands/assumption-test.md`

**Interfaces:**
- Consumes: `/renata:interview-kit`, `/renata:interview-debrief`, board path `docs/interviews/README.md` (Tasks 1-2).
- Produces: pre-PRD entry point for validation.

- [ ] **Step 1: Allow discovery as input (pre-PRD)**

In `## When to use`, add as a new first bullet:

```markdown
- **Pre-PRD:** the discovery's chosen bet carries a 🔴/🟡 evidence seal and you want to test it before writing the PRD (get out of the building first).
```

In `## Before generating`, replace step 1:

```markdown
1. Read `@docs/prd/` — the hypotheses (each one and its falsification signal), IN scope, anchor persona.
```

with:

```markdown
1. Read `@docs/prd/` — the hypotheses (each one and its falsification signal), IN scope, anchor persona. **If there is no PRD yet** (pre-PRD validation), read `@docs/discovery/*.md` instead — the chosen bet, its evidence seals and the "riskiest assumption" seed.
```

- [ ] **Step 2: Point the catalog to the interview loop**

In the `## Test catalog` table, replace the row:

```markdown
| Problem interview (5-8 people) | Value (does the pain exist?) | XS | Do they describe the pain without you suggesting it? |
```

with:

```markdown
| Problem interview (5-8 people) — script via `/renata:interview-kit`, each transcript via `/renata:interview-debrief` | Value (does the pain exist?) | XS | Do they describe the pain without you suggesting it? (🥇 spontaneous signals on the board) |
```

- [ ] **Step 3: Accept the board as evidence in the Result section**

In the output structure, replace:

```markdown
## Result (filled in after running)

- **Evidence:** {{what actually happened}}
```

with:

```markdown
## Result (filled in after running)

- **Evidence:** {{what actually happened — for interviews, cite the evidence board `docs/interviews/README.md` (N interviews, 🥇 balance)}}
```

- [ ] **Step 4: Verify**

Run: `grep -c "interview-kit\|interview-debrief" commands/assumption-test.md`
Expected: ≥2.

- [ ] **Step 5: Commit**

```bash
git add commands/assumption-test.md
git commit -m "feat: assumption-test accepts pre-PRD discovery input and plugs into the interview loop"
```

---

### Task 6: Contextual suggestion in `commands/status.md`

**Files:**
- Modify: `commands/status.md` (Product-validation reminder block, lines ~90-94)

- [ ] **Step 1: Add the reminder bullet**

In the `**Product-validation reminder**` list, after the bullet about "PRD ready but with an untested business assumption", add:

```markdown
- Discovery's chosen bet carries a 🔴 belief / 🟡 anecdote seal → suggest `/renata:interview-kit` (get out of the building) before or right after the PRD; each transcript comes back through `/renata:interview-debrief`.
```

- [ ] **Step 2: Verify**

Run: `grep -c "interview-kit" commands/status.md`
Expected: `1`.

- [ ] **Step 3: Commit**

```bash
git add commands/status.md
git commit -m "feat: status suggests interview-kit when the chosen bet has a weak evidence seal"
```

---

### Task 7: METHOD.md + METHOD.pt-br.md — seals section, lineage, command table

**Files:**
- Modify: `METHOD.md`
- Modify: `METHOD.pt-br.md` (same edits, in Portuguese — locate the equivalent anchors; the file mirrors METHOD.md's structure)

- [ ] **Step 1: Add "The evidence seals" section to METHOD.md**

Right after the line `> **In one sentence:** the 7 principles prepare the decision; this one keeps it honest after the world has answered.` (end of "The loop closes"), add:

```markdown
### The evidence seals

Every product claim in the method (a pain, a JTBD, a why-now, an assumption) carries a seal stating what it stands on:

| Seal | Level | Meaning |
|---|---|---|
| 🔴 | belief | Founder conviction — zero external evidence |
| 🟡 | anecdote | 1-2 informal reports, unstructured |
| 🟢 | interviewed | Pattern heard spontaneously in N≥3 interviews |
| ✅ | measured | Real measured number (instrumentation/data) |

The seal **never blocks** progress — it forces honesty ("you are betting on 🔴 — declare it and move, or test it for XS now"). Seals are stamped in `/renata:discovery`, promoted by `/renata:interview-debrief` (verbatim evidence only), and cashed in by `/renata:assumption-test` (verdict) and `/renata:hypothesis-check` (✅ measured). It is the **E of RENATA — Evidence — made visible.**
```

- [ ] **Step 2: Add the two commands to METHOD.md's validation table**

In the `### Product validation (Measure-Learn — closes the loop)` table, after the `/renata:assumption-test` row, add:

```markdown
| `/renata:interview-kit [assumption]`      | **Before an interview:** one-page Mom Test field guide (read on the phone) | `docs/interviews/kits/<date>-<slug>.md`                              |
| `/renata:interview-debrief <transcript>`  | **After an interview:** verbatim signals per assumption + evidence board + interviewer coaching | `docs/interviews/<date>-<slug>.md` + `docs/interviews/README.md` (board) + seal updates |
```

- [ ] **Step 3: Add the lineage section to METHOD.md**

At the end of the "The loop closes" area, right after the new "The evidence seals" section, add:

```markdown
### On whose shoulders (lineage)

RENATA does not invent its parts — it assembles proven ones and adds enforcement:

- **Marty Cagan** (SVPG, *Inspired*) — the 4 product risks (value, usability, viability, feasibility) that `/renata:assumption-test` and `/renata:spike` split between them.
- **Teresa Torres** (*Continuous Discovery Habits*) — discovery as a weekly habit, not a phase; the school behind `/renata:discovery` and `/renata:persona`.
- **Steve Blank** (Customer Development) & **Rob Fitzpatrick** (*The Mom Test*) — "get out of the building" and how to interview without poisoning the answers; operationalized by `/renata:interview-kit` + `/renata:interview-debrief`.
- **Michael Nygard** — the ADR format that `/renata:adr` enforces down to the commit hook.
- **Eric Ries / Lean Startup** — build-measure-learn; the loop `/renata:hypothesis-check` closes.

**RENATA's own contribution:** the binding with automated enforcement — persona → metric → ADR → code in a single AI-operated flow, where the *why* survives into the implementation because hooks and gates refuse to let it die.
```

- [ ] **Step 4: Mirror all three edits in METHOD.pt-br.md**

Same three insertions, in Portuguese, at the equivalent anchors ("Numa frase" closing line of "O loop fecha"; validation commands table; after the seals section). Portuguese text:

```markdown
### Os selos de evidência

Toda afirmação de produto no método (uma dor, um JTBD, um why-now, uma premissa) carrega um selo dizendo em que ela se apoia:

| Selo | Nível | Significado |
|---|---|---|
| 🔴 | crença | Convicção do fundador — zero evidência externa |
| 🟡 | anedota | 1-2 relatos informais, não estruturados |
| 🟢 | entrevistado | Padrão ouvido espontaneamente em N≥3 entrevistas |
| ✅ | medido | Número real medido (instrumentação/dados) |

O selo **nunca bloqueia** o avanço — ele força honestidade ("você está apostando em 🔴 — declare e siga, ou teste por XS agora"). Os selos são carimbados no `/renata:discovery`, promovidos pelo `/renata:interview-debrief` (só evidência verbatim) e cobrados pelo `/renata:assumption-test` (veredicto) e `/renata:hypothesis-check` (✅ medido). É o **E do RENATA — Evidence — tornado visível.**
```

```markdown
| `/renata:interview-kit [premissa]`        | **Antes de uma entrevista:** roteiro Mom Test de 1 página (lido no celular) | `docs/interviews/kits/<data>-<slug>.md`                              |
| `/renata:interview-debrief <transcrição>` | **Depois de uma entrevista:** sinais verbatim por premissa + board de evidência + coaching do entrevistador | `docs/interviews/<data>-<slug>.md` + `docs/interviews/README.md` (board) + atualização de selos |
```

```markdown
### Sobre os ombros de quem (linhagem)

O RENATA não inventa as suas partes — ele monta peças comprovadas e adiciona enforcement:

- **Marty Cagan** (SVPG, *Inspired*) — os 4 riscos de produto (valor, usabilidade, viabilidade, factibilidade) que `/renata:assumption-test` e `/renata:spike` dividem entre si.
- **Teresa Torres** (*Continuous Discovery Habits*) — discovery como hábito semanal, não fase; a escola por trás do `/renata:discovery` e do `/renata:persona`.
- **Steve Blank** (Customer Development) & **Rob Fitzpatrick** (*The Mom Test*) — o "saia do prédio" e como entrevistar sem envenenar as respostas; operacionalizados por `/renata:interview-kit` + `/renata:interview-debrief`.
- **Michael Nygard** — o formato de ADR que o `/renata:adr` cobra até o hook de commit.
- **Eric Ries / Lean Startup** — build-measure-learn; o loop que o `/renata:hypothesis-check` fecha.

**A contribuição própria do RENATA:** a amarração com enforcement automatizado — persona → métrica → ADR → código num fluxo único operado com IA, onde o *porquê* sobrevive à implementação porque hooks e gates se recusam a deixá-lo morrer.
```

- [ ] **Step 5: Verify**

Run: `grep -c "evidence seals\|selos de evidência" METHOD.md METHOD.pt-br.md && grep -c "interview-kit" METHOD.md METHOD.pt-br.md`
Expected: ≥1 per file on both greps.

- [ ] **Step 6: Commit**

```bash
git add METHOD.md METHOD.pt-br.md
git commit -m "docs: evidence seals scale, interview commands and intellectual lineage in METHOD (en+pt)"
```

---

### Task 8: README.md + README.pt-br.md — positioning section + command count

**Files:**
- Modify: `README.md` (line ~19-21 opening area + line 42 command list)
- Modify: `README.pt-br.md` (equivalent anchors)

- [ ] **Step 1: Add the positioning section to README.md**

After the line `> Created by **Eric Luque** · **AInsteins** — https://www.ainsteins.com.br` and before `---` / `## Install`, add:

```markdown
## Why RENATA exists

RENATA lives at an intersection nobody else occupies:

1. **Product frameworks** (Cagan, Torres, Lean) teach you to decide what to build — but stop at the code's border. The decision becomes a slide; the code is born orphaned from its why.
2. **AI coding / vibe-coding tools** generate code fast — but with no method: no persona, no metric, no recorded decision. Speed accruing interest.
3. **RENATA is the bridge, with enforcement:** the product method reaches *inside* the code — the ADR blocks the commit that violates it, the hook collects the gate, the hypothesis comes back to be falsified. The why survives the implementation.

**Who it's for:** a solo founder or a small PM+dev team building with AI, who wants product rigor without a product org.
**What it is NOT:** not project management (it doesn't replace your team's Scrum/kanban), not a code generator, not a product course — it's the method between your idea and your AI-written code.
```

- [ ] **Step 2: Update the command list in README.md**

In the `- **25 commands**` line, change `25 commands` → `27 commands` and change the validation group from:

```markdown
validation (`/renata:assumption-test`, `/renata:hypothesis-check`),
```

to:

```markdown
validation (`/renata:assumption-test`, `/renata:interview-kit`, `/renata:interview-debrief`, `/renata:hypothesis-check`),
```

- [ ] **Step 3: Mirror both edits in README.pt-br.md**

Positioning section in Portuguese (same anchor, after the "Criado por Eric Luque" line):

```markdown
## Por que o RENATA existe

O RENATA vive numa interseção que ninguém mais ocupa:

1. **Frameworks de produto** (Cagan, Torres, Lean) ensinam a decidir o que construir — mas param na fronteira do código. A decisão vira slide; o código nasce órfão do porquê.
2. **Ferramentas de AI coding / vibe-coding** geram código rápido — mas sem método: sem persona, sem métrica, sem decisão registrada. Velocidade acumulando juros.
3. **O RENATA é a ponte, com enforcement:** o método de produto vai *até dentro* do código — a ADR bloqueia o commit que a viola, o hook cobra o gate, a hipótese volta pra ser falsificada. O porquê sobrevive à implementação.

**Pra quem é:** founder solo ou time pequeno PM+dev construindo com IA, que quer rigor de produto sem ter uma organização de produto.
**O que NÃO é:** não é gestão de projeto (não substitui o Scrum/kanban do time), não é gerador de código, não é curso de produto — é o método entre a sua ideia e o código que a IA escreve.
```

Command list: `25 comandos` → `27 comandos`; `validação (\`/renata:assumption-test\`, \`/renata:hypothesis-check\`)` → `validação (\`/renata:assumption-test\`, \`/renata:interview-kit\`, \`/renata:interview-debrief\`, \`/renata:hypothesis-check\`)`.

- [ ] **Step 4: Verify**

Run: `grep -c "27 com" README.md README.pt-br.md && grep -c "Why RENATA exists\|Por que o RENATA existe" README.md README.pt-br.md`
Expected: 1 per file on both greps.

- [ ] **Step 5: Commit**

```bash
git add README.md README.pt-br.md
git commit -m "docs: positioning section and 27-command list in README (en+pt)"
```

---

### Task 9: GETTING-STARTED.md + .pt-br — interview loop in the walkthrough

**Files:**
- Modify: `GETTING-STARTED.md` (Step 1.5 section ~line 536-544; section 12.8 ~line 1702-1713; command table ~line 1836)
- Modify: `GETTING-STARTED.pt-br.md` (same anchors — the files mirror each other line-for-line)

- [ ] **Step 1: Extend Step 1.5 in GETTING-STARTED.md**

After the paragraph ending `...and seeds clues for persona, journey and metrics.` (line ~542), add:

```markdown
The discovery also **stamps every claim with an evidence seal** (🔴 belief · 🟡 anecdote · 🟢 interviewed · ✅ measured). A bet stamped 🔴 is allowed — but the honest move is to get out of the building first: `/renata:interview-kit` generates a one-page Mom Test script (read it on your phone on the way), you record the conversation, and `/renata:interview-debrief` turns each transcript into graded evidence — moving the seal for real.
```

- [ ] **Step 2: Extend section 12.8 in GETTING-STARTED.md**

After the `**/renata:assumption-test <assumption>** — *before* building.` paragraph, add:

```markdown
**`/renata:interview-kit` + `/renata:interview-debrief` — the interview loop inside the cheapest test.**
When the cheapest test is a problem interview, these two carry it: the **kit** is a one-page Mom Test field guide (past-and-behavior questions, a NEVER-ask list, signals to listen for) made to be read on your phone — because you won't be at the computer. You record the conversation (your recorder/Meet already transcribes). Back home, the **debrief** takes the transcript and extracts **verbatim** quotes per assumption — spontaneous 🥇 counts, prompted 🥈 barely counts, contaminated 🚫 (said after you pitched) doesn't count — updates the evidence board, and **coaches your questions** so the next interview is better. After N≥3 with a clear pattern, `assumption-test` issues the verdict.
```

- [ ] **Step 3: Add the rows to the command reference table (~line 1836)**

After the `| gate | /renata:assumption-test ... |` row, add:

```markdown
| gate | `/renata:interview-kit [assumption]` | One-page Mom Test field guide before a problem interview |
| gate | `/renata:interview-debrief <transcript>` | Transcript → verbatim evidence + board + interviewer coaching |
```

- [ ] **Step 4: Mirror all three edits in GETTING-STARTED.pt-br.md**

Portuguese versions at the same anchors:

Step 1.5 addition:

```markdown
O discovery também **carimba cada afirmação com um selo de evidência** (🔴 crença · 🟡 anedota · 🟢 entrevistado · ✅ medido). Uma aposta carimbada 🔴 é permitida — mas o movimento honesto é sair do prédio antes: `/renata:interview-kit` gera um roteiro Mom Test de 1 página (leia no celular a caminho), você grava a conversa, e `/renata:interview-debrief` transforma cada transcrição em evidência graduada — movendo o selo de verdade.
```

Section 12.8 addition:

```markdown
**`/renata:interview-kit` + `/renata:interview-debrief` — o loop de entrevista dentro do teste mais barato.**
Quando o teste mais barato é uma entrevista de problema, esses dois a carregam: o **kit** é um roteiro de campo Mom Test de 1 página (perguntas de passado-e-comportamento, lista do que NUNCA perguntar, sinais pra escutar) feito pra ler no celular — porque você não vai estar no computador. Você grava a conversa (seu gravador/Meet já transcreve). De volta, o **debrief** pega a transcrição e extrai citações **verbatim** por premissa — espontânea 🥇 conta, provocada 🥈 conta pouco, contaminada 🚫 (dita depois de você pitchear) não conta —, atualiza o board de evidência e **critica as suas perguntas** pra próxima entrevista ser melhor. Depois de N≥3 com padrão claro, o `assumption-test` dá o veredicto.
```

Table rows:

```markdown
| gate | `/renata:interview-kit [premissa]` | Roteiro Mom Test de 1 página antes de uma entrevista de problema |
| gate | `/renata:interview-debrief <transcrição>` | Transcrição → evidência verbatim + board + coaching do entrevistador |
```

- [ ] **Step 5: Verify**

Run: `grep -c "interview-kit" GETTING-STARTED.md GETTING-STARTED.pt-br.md`
Expected: ≥3 per file.

- [ ] **Step 6: Commit**

```bash
git add GETTING-STARTED.md GETTING-STARTED.pt-br.md
git commit -m "docs: interview loop in the walkthrough — step 1.5 seals + section 12.8 + reference table (en+pt)"
```

---

### Task 10: Release v0.1.7 — CHANGELOG, version bump, final checks

**Files:**
- Modify: `CHANGELOG.md`, `CHANGELOG.pt-br.md`
- Modify: `.claude-plugin/plugin.json` (`"version": "0.1.6"` → `"0.1.7"`)
- Verify only: `.claude-plugin/marketplace.json`, `hooks/scripts/*.sh`

- [ ] **Step 1: Check the files that may not need changes**

Run: `grep -n "0.1.6\|25 command\|25 comando" .claude-plugin/marketplace.json; grep -rn "interview\|assumption" hooks/ | grep -v Binary`
Expected: if marketplace.json pins a version or command count, update it to match (0.1.7 / 27); if hooks don't reference command lists (they shouldn't — they read progress-map), no change.

- [ ] **Step 2: Write the CHANGELOG entries**

In `CHANGELOG.md`, replace `_Nothing yet._` under `## [Unreleased]` with `_Nothing yet._` kept, and add below the Unreleased block:

```markdown
## [0.1.7] — {{release date}}

**What's new:** get out of the building — the interview loop and evidence seals.

### Added
- `/renata:interview-kit` — one-page Mom Test field guide for problem interviews (past-and-behavior questions, NEVER-ask list, signals to listen for), made to be read on your phone. 1 kit = 1 assumption.
- `/renata:interview-debrief` — processes a ready transcript (transcript only — audio integration is a future evolution): verbatim quotes per assumption graded 🥇 spontaneous / 🥈 prompted / 🚫 contaminated, aggregate evidence board (`docs/interviews/README.md`), seal promotion/demotion in source docs, and mandatory interviewer coaching.
- **Evidence seals** (🔴 belief · 🟡 anecdote · 🟢 interviewed · ✅ measured) — documented once in METHOD.md; stamped by `/renata:discovery`, moved by `/renata:interview-debrief`, cashed in by `/renata:assumption-test` / `/renata:hypothesis-check`. Seals never block — they force honesty.
- Positioning section in README ("Why RENATA exists") and intellectual lineage in METHOD (Cagan, Torres, Blank, Fitzpatrick, Nygard, Ries).
- `docs/interviews/` (kits + debriefs + board) in the project scaffold.

### Changed
- `/renata:discovery` — stamps evidence seals and seeds the riskiest assumption (4th seed).
- `/renata:assumption-test` — accepts pre-PRD discovery input; the problem-interview catalog row plugs into the interview loop; results cite the evidence board.
- `/renata:status` — suggests `/renata:interview-kit` when the chosen bet carries a weak seal.
```

Mirror in `CHANGELOG.pt-br.md` (same structure, in Portuguese — translate the entry faithfully).

- [ ] **Step 3: Bump the version**

In `.claude-plugin/plugin.json`: `"version": "0.1.6"` → `"version": "0.1.7"`.

- [ ] **Step 4: Full-repo consistency check**

Run: `grep -rn "26 command\|26 comando\|25 command\|25 comando" --include="*.md" . | grep -v superpowers | grep -v .git`
Expected: no output (all counts updated to 27).

Run: `grep -c "interview-kit" commands/*.md METHOD.md README.md GETTING-STARTED.md template/CLAUDE.md.template`
Expected: non-zero in interview-kit.md, interview-debrief.md, discovery.md, assumption-test.md, status.md, METHOD.md, README.md, GETTING-STARTED.md, template/CLAUDE.md.template.

- [ ] **Step 5: Commit**

```bash
git add CHANGELOG.md CHANGELOG.pt-br.md .claude-plugin/plugin.json .claude-plugin/marketplace.json
git commit -m "release: v0.1.7 — interview loop, evidence seals, positioning"
```

- [ ] **Step 6: STOP — tag and GitHub Release only on Eric's explicit go**

The canonical release sequence (push, `git tag -a v0.1.7`, push tags, GitHub Release, marketplace update + reinstall) is **not** executed by this plan. Ask Eric before pushing anything.

---

## Self-review notes

- **Spec coverage:** Componente 1 → Task 1 · Componente 2 → Task 2 · Componente 3 → Tasks 4-6 · Componente 4 → Tasks 7-8 · scaffold/templates → Task 3 · GETTING-STARTED → Task 9 · release/inventário → Task 10. Runtime folder creation is inside both command files (Tasks 1-2).
- **Consistency:** seal scale identical in Tasks 1, 2, 4, 7, 9, 10; classification 🥇/🥈/🚫 identical in Tasks 2, 5, 9; board path `docs/interviews/README.md` identical in Tasks 2, 5, 7, 10.
