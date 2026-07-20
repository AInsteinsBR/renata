# Reference — RENATA appendices

> 🇧🇷 [Versão em português](REFERENCE.pt-br.md)

> Quick-reference material that used to live at the end of [`GETTING-STARTED.md`](GETTING-STARTED.md). Read the tutorial first; come back here when you need a cheatsheet, an alternative order, or a sanity check.

---

## Appendix A — When NOT to use this method

RENATA is not the right way for everything. Don't use it if:

- ❌ **Throwaway code** — a 1-use script, a demo, a 1-day proof of concept
- ❌ **Legacy codebase with an established method** (don't try to impose it). A legacy codebase **without** a method is different — that's what `/renata:adopt` is for (see [`ADOPTION.md`](ADOPTION.md))
- ❌ **Large team (>15 people)** — optimized for solo/small squad (1-6)
- ❌ **Extremely regulated domain** without compliance/audit supplementation

---

## Appendix B — Method anti-patterns

Warning signs — you're doing it wrong:

| Symptom | Diagnosis |
|---|---|
| A 10-page PRD | It's a Micro PRD. 1 page. Alive. |
| An ADR with 5 alternatives all "rejected for being bad" | Shallow analysis. Force a concrete reason. |
| Persona "every Brazilian dev" | Too vague. Force specific. |
| An anchor feature that nobody depends on | Apply the 4 criteria. If it fails, choose another. |
| Roadmap without gates | Without an objective criterion, it's not a roadmap, it's a wishlist. |
| Hook turned off "temporarily" | A sign of disease. Resolve it or open a superseding ADR. |

---

## Appendix C — Alternative order for different projects

The 0-13 order is canonical, but it can vary:

**Technical project (no clear external persona):**
1, 6 (ADRs first), 10 (architecture), 7 (features), 9 (roadmap), 11, 12, 13.
PRD and personas can be lighter.

**Research/exploration project:**
1, 2 (PRD with a strong hypothesis), 6 (1-2 ADRs about the stack), 11 (plan directly), 12.
Skip 7-9 — refactor if it becomes a product.

**Plugin/library for devs:**
1, 2 (PRD), 3 (persona = dev), 6 (ADRs about the API surface), 7-8 (features = endpoints), 10 (architecture), 12.
Metrics (5) stay light — devs don't answer surveys.

**Existing project (brownfield):**
`/renata:adopt` pre-fills steps 1, 2, 6, 7, 8 and 10 as 🔄 (as-built); you verify them via `/renata:status`, then fill 3-5 (personas, journey, metrics) and plan the NEXT phase. Full guide: [`ADOPTION.md`](ADOPTION.md).

---

## Appendix D — Realistic total time

| Scenario | Time for Steps 0-11 (until you start coding) |
|---|---|
| Solo, new project, knows the domain | 8-12h over 3-5 days |
| Solo, new project, new domain | 15-25h over 1-2 weeks |
| Pair, new project | 12-18h over 1 week (synchronization creates friction) |
| Small team (4-6) | 20-40h over 2 weeks (more discussion per step) |

Step 12 (execute) is always the biggest block — it can be weeks to months.

---

## Appendix E — Quick cheatsheet

For when you've done the tutorial once and want a quick reference.

## Commands (in order of use)

| Step | Command | What it does |
|---|---|---|
| 0.5 | `/renata:adopt [scopes]` | Adopts RENATA in an existing codebase — pattern + features + retroactive PRD, as-built (only for existing projects; see `ADOPTION.md`) |
| 1 | `/renata:init <name>` | Scaffolds `CLAUDE.md` + `docs/` + `.claude/` in the project |
| 1.5 | `/renata:discovery <idea>` | Vague intuition → clear problem (5 whys + JTBD + why-now) (optional) |
| 2 | `/renata:prd <idea>` | Micro PRD in 9 questions |
| 3 | `/renata:persona <name>` | Structured persona in 4 turns |
| 4 | `/renata:user-journey <persona>` | Before/during/after |
| 5 | `/renata:metrics` | 4 layers (adoption, engagement, value, quality) |
| 6 | `/renata:adr <decision>` | Nygard ADR + updates `rules.yaml` |
| 6 | `/renata:extract-pattern <repo>` | Distills an existing repo's pattern into ADRs + code-pattern doc |
| 6.5 | `/renata:landscape` | Competitive research → differentiation gaps (optional) |
| 7 | `/renata:feature-breakdown` | Lists features + identifies the anchor |
| 7.5 | `/renata:phase-roadmap` | Distributes all features into sequential phases (Phase 0 = anchor set) |
| 7.7 | `/renata:feature-behavior <id>` | Feature as observable behavior (stories + Gherkin) before the spec (optional) |
| 8 | `/renata:feature-spec <id>` | Details a feature + phased plan |
| 8.5 | `/renata:screens` | Inventory + flow + screen briefs (optional) |
| gate | `/renata:assumption-test <assumption>` | Test a value/viability risk before building (Measure-Learn loop) |
| gate | `/renata:interview-kit [assumption]` | One-page Mom Test field guide before a problem interview |
| gate | `/renata:interview-debrief <transcript>` | Transcript → verbatim evidence + board + interviewer coaching |
| 9 | `/renata:roadmap-gates` | Hardens the macro roadmap: an explicit, verifiable gate per phase + one file per phase |
| 10 | `/renata:architecture` | Synthesizes accepted ADRs + specs + spikes into `stack.md` + `arquitetura.md` (C4) — decides nothing new |
| 11 | `/renata:plan-phase <phase>` | Armored plan (writing-plans + @architect) |
| 12 | `/renata:execute <phase>` | Orchestrates phase execution: pre-flight checks + per-task done gate (wraps executing-plans) |
| 12 | `/renata:spike <question>` | Risk investigation |
| 12 | `/renata:phase-scope <phase>` | Re-scope with MoSCoW |
| 12 | `/renata:triage <context>` | Prioritize bugs/debts |
| 12 | `/renata:todo <add\|sync\|list\|done>` | Pending-items backlog (inline + central sync) |
| 12 | `/renata:refactor <target>` | Disciplined refactor |
| 13 | `/renata:retro [phase]` | Retrospective (execution learning) |
| 13 | `/renata:hypothesis-check [hypothesis]` | Hypothesis verdict vs real data (✅/❌/🤔 + sunset) |
| 14 | `/renata:bug-report <raw description>` | A fresh production bug → structured, severity-classified, routed |
| 14 | `/renata:incident <description>` | Live coordination of a larger production incident → hands off to `/renata:retro` |
| — | `/renata:status [N]` | Where I am in the flow + the next step (validates the current step with a human gate) |
| — | `/renata:next` | Micro-navigator: only the canonical next step + gaps (runs no step commands) |

## Subagents (call them when in doubt)

You invoke these with `@` when you want a focused second opinion. Each one reads the relevant docs/diff and returns a structured verdict — none of them write product code.

| When | Agent | What it gives back |
|---|---|---|
| Before coding, an architectural question | `@architect` | Reviews a proposal/diff against CLAUDE.md + ADRs; decides and justifies (doesn't code) |
| Code finished, before a PR | `@code-reviewer` | Reads the diff: bugs, violated patterns, missing tests, naming, ADRs not honored in code |
| Before marking a feature as done | `@qa-tester` | Runs the real app (Playwright/manual) against the PRD + feature acceptance criteria, reports findings |
| Latency/throughput below the PRD target | `@perf-auditor` | Deep performance audit: hot paths, N+1, memory leaks, missing cache, sync I/O on an async path |
| Touched auth / permissions / sensitive data | `@security-reviewer` | Practical OWASP top-10, leaked secrets, input validation, cross-tenant authz, basic LGPD |

> **`@pattern-mapper` is the exception — you don't call it directly.** It maps a repo's pattern (4 axes, with evidence strength) and runs **inside** `/renata:extract-pattern` (and `/renata:adopt`, which composes with it), turning its map into ADRs + a loadable doc. If you want a pattern mapped, run the command, not the agent.

## Framework skills (auto-activatable — you don't invoke them)

These three fire on their own when the conversation hits a trigger. You don't call them; they watch for the moment and step in.

- `respecting-adrs` — fires on "I'm going to implement X / which lib / let's refactor". Forces reading the accepted ADRs and validating the proposal against them **before** coding.
- `keeping-docs-alive` — fires on "I finished / I'm going to pause / phase done". Updates CLAUDE.md + `.claude/sessions/` + the active plan, so the docs never drift from the code.
- `detecting-scope-creep` — fires on "while I'm here / it'd also be easy to…". Compares the new idea against the active feature's IN/OUT scope and **offers three options** (do it now / park it as a TODO / open an ADR), forcing a conscious decision instead of silent scope growth.

## Superpowers skills (automatic)

- `superpowers:writing-plans` — execution plan (Step 11)
- `superpowers:executing-plans` / `subagent-driven-development` — executes (Step 12, orchestrated by `/renata:execute`)
- `superpowers:test-driven-development` — during implementation
- `superpowers:systematic-debugging` — when a bug shows up
- `superpowers:verification-before-completion` — before declaring done

## Macro validation per step (summary)

| Step | It's ready when |
|---|---|
| 2 PRD | A falsifiable hypothesis + a decisive metric with a baseline |
| 3 Personas | A primary with a name, numeric pain, a quote + anti-personas |
| 4 Journey | Before/during/after with bound critical points |
| 5 Metrics | 3-4 layers + a decisive metric bound to the hypothesis |
| 6 ADRs | ≥5 accepted + tested hook + each one with a review trigger |
| 7 Features | 3-7 features + the anchor marked with 4 criteria |
| 8 Feature spec | A phased plan XS-M with a verifiable criterion |
| 9 Roadmap | Macro phases + explicit gates + anti-roadmap |
| 10 Architecture | Stack anchored in constraints + C4 level 1 and 2 |
| 11 Execution plan | A plan with TDD + ≥3 checkpoints |
| 12 Execution | Commits pass the hook + green tests |
| 13 Retro | An explicit decision: next phase / repeat / pivot |
| 14 Post-production | Every fresh bug filed; incidents closed only after the resolution checklist; a retro scheduled |

---

## Appendix F — How to evolve the method

The method **will change**. Every change is born from real friction, not theory.

At the end of each project:

1. List 3 moments of friction
2. For each: adjust the method, adjust the tool, or accept the cost
3. If adjusting the method: a PR to RENATA with the change + justification
