# METHOD — RENATA Principles

> 🇧🇷 [Versão em português](METHOD.pt-br.md)

> **Thesis in one sentence:** a decision without anchoring pays interest, and the only way not to pay it is to anchor persona → metric → ADR → code.
>
> **RENATA** = **R**ecord · **E**vidence · **N**ame · **A**nchor · **T**est · **A**utomate. The six verbs of the method: record the why, measure the evidence, name the persona, anchor the decision, test before closing, automate the enforcement.

---

## The 7 principles

### 1. Persona before stack

If you can't name the persona affected by a feature/decision, **the feature is not ready to be built**.

- A persona is not a "user". A persona has a **name, a role, a numeric pain** (hours, %, $).
- Every feature points to the anchor persona in the `Vínculos` field.
- Anti-personas (who it is **not** for) are as important as personas.

### 2. Metric before feature

Every product hypothesis is falsifiable by a **decisive metric** with a baseline + target.

- "Let's improve the UX" is not a hypothesis. "Contained rate goes from 32% to 65%" is.
- A metric without a baseline = fantasy. Always estimate the baseline (even approximately) before building.
- 4 layers: **adoption** (does anyone use it?) · **engagement** (do they use it correctly?) · **value** (does it deliver a result?) · **quality** (product-specific).

### 3. ADR before code

A structural decision (with impact > 1 sprint) becomes an ADR **before** merging related code.

- Michael Nygard format: Context · Decision · Alternatives · Trade-offs · Review trigger · Enforcement.
- Every ADR has a **review trigger**. A decision with no condition to reopen it is religious faith.
- Every ADR has **enforcement** when possible (hook, lint, review checklist).
- Status: `proposed` → `accepted` → `superseded`. No eternal "proposed" (decide or discard within 1 sprint).

### 4. Plan in resumable phases

Every non-trivial feature breaks into **granular, resumable phases**, with a verifiable definition of done.

- Preferred size: **XS-M** (up to a few days). **L** acceptable with justification. **XL must be broken down**.
- Each phase can be paused and resumed without loss of context.
- Definition of done = test passes, hook doesn't block, observable metric.
- The last phase is always "Demo / Delivery prep" — don't end a feature on the technical phase.

### 5. Anti-scope mandatory

Every doc lists what is NOT in. Listing what is not in is **harder and more valuable** than listing what is.

- The PRD has scope IN and scope OUT.
- The roadmap has an anti-roadmap.
- The stack has "what is NOT in this stack".
- Personas have anti-personas.

### 6. Phased delivery with gates

A product is delivered in **sequential phases** (Phase 0/1/2/3), each with an **explicit gate**.

- The next phase doesn't start if the previous one didn't pass the gate.
- Each phase has a **single** objective (not 5).
- Estimates in t-shirt sizes (XS · S · M · L · XL). Weeks only after a detailed implementation plan.

### 7. Living, versioned, opinionated doc

Documentation is not descriptive — it is **opinionated**. "The system uses Postgres" is not a doc; "We use Postgres because X, we discarded Y because Z" is.

- Every doc opens with a 1-paragraph thesis.
- Every decision has an anchor (persona, ADR, operational constraint).
- A history at the end of living docs (the PRD especially) shows the evolution.
- Markdown only. Embedded mermaid diagrams. No dependency on external tools.

---

## The loop closes — Evidence reopens the decision

> The 7 principles above are all of the **Build** type: preconditions that anchor the work *before* moving forward (persona before stack, metric before feature, ADR before code...). Arrows that point forward.
>
> This principle is of a different nature. It is the **arrow that comes back** — the **Measure-Learn** that was missing. Without it, the method takes you from zero to a delivered product with rigor and then the map ends: the hypothesis is born falsifiable and is never falsified, the baseline is born estimated and never becomes measured, the feature is born and is never pruned.

**Principle of return: the loop doesn't close at delivery. Real data has the authority to reopen what was already decided.**

- **Every hypothesis has a verdict.** The PRD's decisive metric exists to be confronted with the real number: ✅ confirmed · ❌ failed · 🤔 inconclusive. A hypothesis that never receives a verdict was not falsifiable — it was faith. (Closed by `/renata:hypothesis-check`.)
- **An estimate is debt until it becomes a measurement.** A guessed baseline unblocks the start, but before declaring a feature *truly done*, the metric needs to be **observable** (instrumented, not guessed). Estimating is leaving a TODO 🟡, not closing the account.
- **Every metric has a number that triggers a decision (kill criteria / tripwire).** A target without a failure threshold is a dashboard, not a management instrument. "If adoption < X% in N days, stop and rethink" is what turns measurement into action. (Defined in `/renata:metrics`.)
- **A risky business assumption is tested before building, not after.** Technical risk has `/renata:spike`. **Value** risk ("does anyone want this?") and **viability** risk ("does it sustain a business?") have `/renata:assumption-test` — the cheapest test that kills the most expensive assumption. (Cagan's 4 risks: value, usability, viability, feasibility.)
- **Evidence reopens PRD, ADR and feature — including to kill them.** A hypothesis that failed can reopen the PRD. Data that contradicts an ADR triggers its review trigger. A delivered feature that didn't move the metric is a **sunset candidate** — pruning is as much product as adding. The method is too additive without this.

> **In one sentence:** the 7 principles prepare the decision; this one keeps it honest after the world has answered.

---

---

`<a id="ordem-alternancia"></a>`

## Why this order? (the "what / how" alternation)

The most common confusion in the method: *"how do I make ADRs before detailing features? Shouldn't I know what I'm going to build first?"*

The answer requires understanding that **"defining the product" has multiple levels of granularity**, and the method **alternates** between "what" and "how" at each level:

| Level    | Step                             | Question               | Result                               |
| -------- | -------------------------------- | ---------------------- | ------------------------------------ |
| Macro    | 2. PRD                           | WHAT at a high level   | Thesis + scope IN + decisive metric  |
| Context  | 3-5. Personas/Journeys/Metrics   | WHY and FOR WHOM       | Anchored constraints                 |
| Macro    | 6. ADRs                          | HOW at a high level    | Stack + strategy                     |
| Mid      | 7. Feature breakdown             | WHAT at a mid level    | Atomic capabilities                  |
| Mid      | 7.5. Phase the system            | WHEN each feature      | All features in phases by time       |
| Mid      | 8. Feature spec (per phase)      | HOW at a mid level     | Plan per feature of the current phase|
| Visual   | 8.5. Screen design (optional)    | HOW the user sees      | Inventory + flow + briefs            |
| Low      | 10. Architecture                 | HOW at a low level     | Technical diagrams                   |
| Micro    | 11. Execution plan               | HOW at a micro level   | Code steps                           |

**Why the alternation works:**

- You **can't detail a feature** without knowing what the stack is (ADRs).
- You **can't decide the stack** without knowing what the product does at a high level (PRD).
- **The PRD already gives you the requirements to open ADRs.** Features only **detail** what the PRD already decided at a high level.

**Concrete example:**

A PRD that says "realtime human avatar with RAG over the company's KB, latency <2s, self-hosted" already **forces** you to open ADRs about:

- Vector DB (because "RAG")
- Transport (because "latency <2s")
- Lip sync model (because "realtime")
- Self-host vs API strategy (because "self-hosted")

None of these ADRs need to wait for the feature spec — they are **prerequisites** for talking about the features.

### ADRs are born at any step

**Step 6** is just the **first concentrated batch** of ADRs (the structural ones that unblock the rest). You will make more in other steps:

- **During Step 7** (looking at features, you realize you need an ADR about something)
- **During Step 10** (architecture reveals an unforeseen structural decision)
- **During Step 12** (execution! you choose a library, a test pattern, etc.)
- **During Step 13 (retro)** — you discover an old decision was wrong → ADR `superseded`

The rule is simple: **if a decision with impact > 1 sprint appears, open `/renata:adr`. It doesn't matter which step you're on.**

### Symptoms of the wrong order

| Sign                                                                       | Diagnosis                                                        |
| -------------------------------------------------------------------------- | ---------------------------------------------------------------- |
| Tried to write ADR-001 and didn't know whether the product is mobile/web   | Shallow PRD. Go back to Step 2 and refine scope IN.              |
| Tried to write feature F1 and realized you needed to decide the stack first| Missing ADR. Pause F1, open `/renata:adr`.                              |
| Wrote 8 ADRs but they don't cover any real feature                         | Detailed too much too early. Go back to features.                |
| The execution plan cites a library no ADR mentioned                        | Missing ADR. Open `/renata:adr` during execution, then continue.        |

### In one sentence

> **The PRD paints the big picture, ADRs decide the colors and techniques, features paint the details.**

---

`<a id="um-prd-vs-n-prds"></a>`

## 1 project = 1 PRD (with N hypotheses)

> **Method rule:** every project has **exactly one PRD**. That PRD can (and usually should) house **N hypotheses**. There is no "N PRDs per project" — if something is separable to the point of asking for its own PRD, that is **another project**, not another PRD inside this one.

The most common doubt when starting from scratch: *"do I make one PRD per hypothesis? One per persona? And when it grows, do I create another PRD? And the ADRs, do they go inside the PRD?"*

The confusion comes from treating the PRD as a **feature catalog**. It is not. The PRD is the **carrier of this project's bet** (Principle 2) — and the bet can have several intertwined hypotheses. The unit is not the feature nor the isolated hypothesis; it is the **project**, and each project has just one PRD.

### When it's a new hypothesis (in the same PRD) vs when it's another project

| Situation | What to do | Why |
|---|---|---|
| New bet on the **same engine/codebase**, reinforces the product, dies along with it if the parent thesis falls | **New hypothesis in the existing PRD** | `/renata:prd` supports "N hypotheses intertwined with N falsification signals". Context in a single place. |
| New capability that only **completes** the product, with no new falsifiable bet | **Feature only** (`docs/features/`) pointing to the PRD | Not every feature is a hypothesis. A feature serves an existing hypothesis; it doesn't create a new verdict. |
| Something that **could be cut/sold separately** without killing this product | **Another PROJECT** (run RENATA from scratch, its own folder) | It's not a new PRD here — it's another product. Shares code via lib/service, not via the PRD. |

> ⚠️ **Don't fragment into "several PRDs" within the project.** If the bet belongs to this product, it's a hypothesis in the existing PRD. If it's genuinely separable, it's **another project** (another docs folder, another CLAUDE.md). The middle ground "N PRDs in the same project" doesn't exist in the method — it scatters the context, which is the opposite of what the method seeks.

### Personas and journeys don't follow the hypotheses — they follow the people

Common mistake: thinking that 1 hypothesis = 1 persona = 1 journey. The real relationship:

- **1 anchor persona** dominates the PRD (Principle 1). There can be secondary ones.
- **N hypotheses** can share the same persona or have different personas. **Don't force parity.**
- **Journeys are per persona**, not per hypothesis. Each real persona gets its own `/renata:user-journey`.
- **The decisive metric is per hypothesis** — each bet has its own number that confirms or kills it.

### ADRs are cross-cutting — they don't live inside the PRD

Another common inversion: *"do I add the ADRs to the PRD?"* **No.**

- ADRs live in `docs/decisions/` (numbered, Nygard) — **never inside the PRD**.
- A structural ADR (e.g. "PostgreSQL as the database") is **cross-cutting to the entire project**: it applies to all features of all hypotheses.
- Features **reference** ADRs via the `Vínculos` field — they don't copy them. The PRD doesn't list ADRs.
- Since there is **one PRD per project**, there is also **a single set of ADRs** governing everything. If a decision only applies to a specific hypothesis, it becomes an ADR with a **declared scope** — but it still lives in `docs/decisions/`, not in the PRD.

### Examples

**Example A — 1 PRD with N hypotheses (the normal case).**
*TaskFlow*, task management for the solo freelancer. Two hypotheses: **H1** "capture in <5s increases retention" and **H2** "smart reminders reduce forgotten tasks by 40%". Same persona (Marina, freelancer), same engine, they reinforce each other (capturing fast only matters if the task isn't forgotten afterwards). → **1 PRD, 2 hypotheses, 2 decisive metrics, 1 anchor persona, 1 journey, 1 set of ADRs** (database, auth, push). H1 and H2 live/die together: if nobody uses TaskFlow, both fall.

**Example B — same persona, new journey → becomes a hypothesis in the same PRD.**
TaskFlow gains **invoice issuance**. Same Marina, but it's another pain (fiscal bureaucracy, ~3h/month) that the PRD didn't map. → run `/renata:user-journey Marina` for the new fiscal flow, it becomes **hypothesis H3 in the same PRD** (a line in the History recording the expansion), reuses the existing ADRs + maybe 1 new one (integration with the city hall's API, an ADR with a declared scope). It's **not** a new PRD — it's the same bet growing.

**Example C — separable product → another PROJECT (not another PRD).**
TaskFlow wants to launch a **team management module** (several freelancers on a team, a dashboard for the manager). Another persona (Rafael, manager), another decisive metric (team productivity), and — crucially — it **could be sold separately** or cut without killing solo TaskFlow. → this is **another project**: run RENATA from scratch in its own folder, with its own PRD, CLAUDE.md, personas and ADRs. Reuse TaskFlow code as a **shared library/service** (not by copying docs). Do **not** turn it into a second PRD inside the TaskFlow project — genuinely separable = a separate project.

### Symptoms of having gotten it wrong

| Sign | Diagnosis |
|---|---|
| PRD with 6 hypotheses that don't talk to each other | Some aren't part of this product. The separable ones become **another project**; the rest stay as hypotheses. |
| Created a second PRD within the same project | There is no N PRDs per project. It's either a hypothesis in the existing PRD, or another project (its own folder). |
| Copied ADRs into the PRD | An ADR doesn't live in the PRD. Move it to `docs/decisions/` and reference it via `Vínculos`. |
| Created a new hypothesis for each feature | Not every feature is a hypothesis. If it has no falsifiable bet of its own, it's **just a feature** pointing to the PRD. |

### In one sentence (1 project = 1 PRD)

> **Each project has 1 PRD with N intertwined hypotheses → personas (per real person) → journeys (per persona) → metrics (per hypothesis) → 1 set of cross-cutting ADRs in `docs/decisions/` → features that reference everything. Did a new bet grow? It becomes a hypothesis in the same PRD. Is it genuinely separable? It becomes another project — never a second PRD here.**


## Canonical doc structure

```
docs/
├── prd/                    ← Living micro PRD (1 page)
├── business-context/       ← personas, journeys, metrics
├── technical-context/      ← anchored stack, macro architecture
├── architecture/           ← detailed diagrams (C4, sequence, ER)
├── features/               ← F1..Fn with phased plan
├── roadmap/                ← macro phases (Phase 0..N)
└── decisions/              ← numbered ADRs (Nygard)
```

---

## CLAUDE.md layers

```
1 · Product identity         (name, category, stage, anchor persona)
2 · Org layer                (non-negotiable principles)
3 · Repo layer               (stack, conventions)
4 · Feature layer            (active PRD, phase, anchor feature)
5 · Session layer            (current session state)
6 · Decisions already made   (ADR index)
7 · How to ask for things    (this project's slash commands)
8 · Anti-patterns            (what NOT to do here)
9 · Next steps
```

---

## Canonical slash commands

### Planning (defining the what)

| Command                  | When to use                                                        | What it generates                               |
| ------------------------ | ------------------------------------------------------------------ | ----------------------------------------------- |
| `/renata:prd <idea>`          | Start of a new product/large feature                              | `docs/prd/<slug>.md`                          |
| `/renata:persona <name>`      | Before any user-focused feature                                   | `docs/business-context/personas.md` (append)  |
| `/renata:user-journey <persona>`   | After persona, before feature                                     | `docs/business-context/jornada.md` (append)   |
| `/renata:metrics`            | After PRD + personas, before features                             | `docs/business-context/metricas.md`           |
| `/renata:adr <decision>`      | When a structural decision is identified                          | `docs/decisions/ADR-NNN-<slug>.md`            |
| `/renata:feature-spec <name>` | Before implementing a feature                                      | `docs/features/F<N>-<slug>.md`                |
| `/renata:feature-breakdown`   | When there are 3+ candidate features                              | `docs/features/README.md` (binary MUST/OUT)  |
| `/renata:phase-roadmap`              | After breakdown — distribute all features into phases by time    | `docs/roadmap/fases-overview.md`              |

### Design (between planning and execution)

| Command      | When to use                                      | What it generates                                        |
| ------------ | ------------------------------------------------ | -------------------------------------------------------- |
| `/renata:screens` | The product has significant UI (between Step 8 and 9) | `docs/design/inventory.md` + `flow.md` + `briefs/` |
| `/renata:extract-pattern <path>` | Distill the pattern of a repo (starter/legacy) into ADRs + a loadable doc (involves `@pattern-mapper`) | `docs/decisions/ADR-*` + `docs/technical-context/code-pattern-<scope>.md` |

### Development (operating within a phase)

| Command                        | When to use                                                                                                    | What it generates                                             |
| ------------------------------ | -------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------- |
| `/renata:plan-phase <phase>`          | Generate a hardened execution plan (involves `superpowers:writing-plans` + `@architect` review)           | `docs/superpowers/specs/<date>-fase-N-plan.md`              |
| `/renata:execute <phase>`           | Execute the phase with an approved plan (involves `superpowers:executing-plans` + done gate + `@qa-tester`) | code + plan marked `running`→done                     |
| `/renata:spike <question>`          | Validate a technical risk before committing                                                                    | `docs/spikes/<date>-<slug>.md`                              |
| `/renata:phase-scope <phase>`        | Decide what fits in the phase with a fixed budget                                                              | `docs/roadmap/fase-N-scope.md` (full MoSCoW)            |
| `/renata:triage <context>`         | Prioritize a backlog of bugs/debts                                                                             | `docs/triage/<date>-<context>.md` (full MoSCoW)        |
| `/renata:todo <add\|sync\|list\|done>` | Record and control pending items that don't block                                                           | `docs/backlog/todos.md` (ordered by impact on progress) |
| `/renata:refactor <target>`           | Guide a disciplined refactor                                                                                   | `docs/refactors/<date>-<slug>.md`                           |
| `/renata:retro [phase]`              | Retrospective at the end of a phase                                                                            | `docs/roadmap/fase-N-retro.md`                              |

### Navigation (cross-cutting — at any step)

| Command         | When to use                                                     | What it generates                                        |
| --------------- | --------------------------------------------------------------- | -------------------------------------------------------- |
| `/renata:status [N]` | Know which step of the flow you're on and what the next step is | On-screen diagnosis (reads `.claude/progress-map.yaml`) |

### Product validation (Measure-Learn — closes the loop)

| Command                           | When to use                                                              | What it generates                                                        |
| --------------------------------- | ------------------------------------------------------------------------ | ------------------------------------------------------------------------ |
| `/renata:assumption-test <assumption>`   | **Before** building: untested value/viability risk                | `docs/assumptions/<date>-<slug>.md`                                    |
| `/renata:hypothesis-check [hypothesis]` | **After** building: confront the PRD's hypothesis with real data  | `docs/hypothesis-checks/<date>-<slug>.md` + a line in the PRD's History |

> These two materialize the **"Evidence reopens the decision"** principle (see "The loop closes"). `/renata:assumption-test` kills the wrong bet before the cost; `/renata:hypothesis-check` issues the verdict (✅/❌/🤔) and triggers action — including the **sunset** of a feature that didn't move the metric.

### When to use binary vs full MoSCoW

- **Binary (MUST / OUT)** in `/renata:feature-breakdown`: to decide what goes into the **product**.
- **Full MoSCoW (MUST / SHOULD / COULD / WON'T)** in `/renata:phase-scope` and `/renata:triage`: to **operate** within the product with a limited budget.

### `/renata:todo` vs `/renata:triage` (don't confuse them)

- **`/renata:triage`** prioritizes a **round** of work in MoSCoW — it's a one-off decision ("what do I tackle now"). It generates a dated snapshot.
- **`/renata:todo`** is the **persistent record** of pending items that don't block, ordered by impact on progress (🔴 blocks the phase / 🟡 matters / ⚪ nice-to-have). It lives in `docs/backlog/todos.md` and is born glued to the context via the inline marker `<!-- TODO[date][impact]: ... -->` in the doc itself, reconciled by `/renata:todo sync`.
- The two talk to each other: the **WON'T** items of a `/renata:triage` are natural candidates to become entries in `/renata:todo` so they don't get lost.

---

## Canonical subagents

- **`@architect`** — reviews a **proposal** for a feature/decision against local ADRs. Doesn't write code.
- **`@code-reviewer`** — reviews **finished code** (diff). Points out bugs, violated patterns, missing tests.
- **`@qa-tester`** — pragmatic QA: runs the real app (Playwright/manual), validates against the PRD/feature acceptance criteria, reports findings in a structured format. Complements TDD; does **not** replace it.
- **`@perf-auditor`** — deep analysis of performance, hot paths, bottlenecks.
- **`@security-reviewer`** — lightweight security review (practical OWASP top 10).
- **`@pattern-mapper`** — sweeps a repo and returns the map of the pattern (4 axes, with evidence strength). Input for `/renata:extract-pattern`. Doesn't write the ADR/doc.

### When to call each agent

| Moment                              | Agent                  | Why                                         |
| ----------------------------------- | ---------------------- | ------------------------------------------- |
| Before coding                       | `@architect`         | Validate the decision against ADRs          |
| Code ready, before the PR           | `@code-reviewer`     | Bugs, patterns, tests                       |
| Before marking a feature as done    | `@qa-tester`         | Real validation against acceptance criteria |
| Latency/throughput below target     | `@perf-auditor`      | Deep hot paths                              |
| Touched auth/sensitive data         | `@security-reviewer` | OWASP top 10                                |

---

## Canonical skills (auto-activatable)

Framework skills that load automatically when the context matches:

- **`respecting-adrs`** — activates on "implement X", "which library to use". Forces reading the accepted ADRs and validating the proposal before coding.
- **`keeping-docs-alive`** — activates on "finished the task", "I'm going to pause", "phase complete". Reminds you to update CLAUDE.md + `.claude/sessions/` + the active plan.
- **`detecting-scope-creep`** — activates on "while I'm at it, I'll also...", "since I'm here...". Compares against the active feature's scope IN/OUT, forces a conscious decision before expanding.

`superpowers:` skills (loaded by Claude Code):

- `brainstorming`, `writing-plans`, `executing-plans`, `subagent-driven-development`
- `test-driven-development`, `systematic-debugging`
- `verification-before-completion` — **it is the done gate of Principle 4**: no task closes (`[x]`) without "test passes + hook doesn't block". Anchored in Step 3 of `/renata:execute`. (The observable metric, the 3rd criterion, is validated at the end of the phase via `@qa-tester` / `/renata:hypothesis-check`.)
- `requesting-code-review`, `receiving-code-review`

### Difference: skill vs agent vs slash command

| Type          | How it activates                               | When to use                                             |
| ------------- | ---------------------------------------------- | ------------------------------------------------------- |
| Skill         | Auto-activates by context (description matching) | Reflex, behavior that**should** be the default |
| Agent         | Invoked explicitly by name (`@name`)         | Persona/role with its own method                        |
| Slash command | The user types `/name`                       | A structured ritual with specific questions/output      |

---

## Canonical hooks

- **`rules-violation.sh`** — reads `.claude/rules.yaml` and blocks commits that violate the declarative rules of the local ADRs.
- **`etapa-gate.sh`** — a PreToolUse hook. Reads `.claude/progress-map.yaml` and **blocks**
  (`exit 2`) the invocation of a step command whose `prereq` are not satisfied.
  It's what makes the canonical order **forced**, not just suggested.
- **`method-status-line.sh`** — a SessionStart hook (`startup` + `resume`). Reads
  `.claude/progress-map.yaml` and shows, when you open/resume the session, which step of the
  flow the project is on and what the next step is. It doesn't block anything — it's guidance.

### Who belongs to what

To avoid confusion between framework artifacts and project content:

| Artifact                                     | Belongs to           | Who writes it                                                     |
| -------------------------------------------- | -------------------- | ----------------------------------------------------------------- |
| `.claude/hooks/rules-violation.sh`         | Framework            | RENATA (generic, the same in every project)                    |
| `.claude/rules.yaml.template`              | Framework            | RENATA (empty schema)                                       |
| **`.claude/rules.yaml`**             | **Project**    | **`/renata:adr`** (each block is born alongside the corresponding ADR) |
| `docs/decisions/_template.md`              | Framework            | RENATA (generic Nygard template)                           |
| `docs/decisions/_adr-frontend-template.md` | Framework            | RENATA (template for a starter ADR)                         |
| `docs/decisions/ADR-NNN-*.md`              | Project              | `/renata:adr` (each file is born from a decision)                     |
| **Starter kit (external repo)**         | **You/Team** | Lives**outside** the framework. Referenced by an ADR.            |
| **`frontend/` (cloned from the starter)** | **Project**    | `init.sh --starter` clones it, then you evolve it                  |

**Principle:** an ADR and its block in `rules.yaml` are **twins**. They are born together via `/renata:adr`. They live together. If an ADR becomes `superseded`, its block in `rules.yaml` is removed (or updated to the ADR that replaced it).

> ⚠️ **Anti-pattern observed in v0.1:** populating `rules.yaml` manually outside the `/renata:adr` flow is technical debt — the YAML loses its anchoring to the ADR. The `/renata:adr` v0.2 writes directly into `rules.yaml` with a quick user confirmation, avoiding this drift.

---

## External integrations (MCP)

The method supports **MCP** (Model Context Protocol) servers — git, Jira, database, etc. — in an **optional and configurable** way. Rules:

- **Local is always the source of truth.** A versioned doc (Principle 7) is the primary truth; the MCP is a **mirror**, never a blind source.
- **Write local first, mirror after confirming.** Nothing goes to Jira/Git before it exists and is correct locally, and the push only happens with explicit confirmation. This protects the external system from provisional data.
- **MCP as a one-off action/read** (open a PR, read an issue, query a database) → low friction, `espelho: false`, doesn't compete with anything.
- **MCP as a mirrored source** (Jira receives the tasks) → **a structural decision: requires `/renata:adr`**, because it changes where the truth mirrors to and can retire a native flow. `/renata:adr` writes the `integrations:` block in `rules.yaml` (the ADR's twin).
- **Graceful fallback mandatory.** Every use of MCP degrades to local if the server is absent/unavailable — identical to `etapa-gate.sh` with `yq`. **With no MCP at all, the framework works in full.**

Configuration in two places: `.mcp.json` (project root) declares the servers; the `integrations:` block in `.claude/rules.yaml` maps capability → MCP. Canonical capabilities: `tarefas` · `pr` · `db` (extensible).

---

## Applicability — when this method is NOT for you

This framework is not the "right way" for everything. Don't use it if:

- ❌ **You're writing throwaway code** (a single-use script, a 1-day proof of concept). Bureaucracy kills speed.
- ❌ **You're in a legacy codebase** with an established method (don't try to impose it).
- ❌ **The team is large (>15 people)** — this method is optimized for solo / small squad (1-6). For large teams, complement it with formal RFCs, sign-offs, etc.
- ❌ **An extremely regulated domain** (banking, healthcare) — add compliance/audit layers that the method doesn't cover.

---

## Declared inspirations

- **Michael Nygard** — the ADR pattern.
- **Marty Cagan / Teresa Torres** — persona/journey/opportunity.
- **Eric Ries** — hypothesis falsifiability.
- **AINSTEINS / AI-Driven Development course** (Eric Luque) — slash commands and CLAUDE.md structure.
- **DDD-lite** — layers (domain → use case → adapter → repo).

---

## Evolution of the method

This method **will change**. Every change is born from real usage friction, not from theory.

When a rule of the method is violated in a project and the result is better without it, **that is data** — update the method.

> The method serves the project. Not the other way around.
