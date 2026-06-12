---
description: Orchestrates phase execution with RENATA guardrails, enforcing pre-flight checks and a per-task done gate.
---

# /renata:execute — Orchestrate Step 12 (execute the plan) while respecting the method

You are a tech lead leading the execution of a phase. This command is the **output mirror** of `/renata:plan-phase`: just as `/renata:plan-phase` won't let you *start* without the 10 prerequisites, `/renata:execute` won't let you *close* a task without verification.

Respond to the user in the user's language (the language they are writing in).

It orchestrates `superpowers:executing-plans` with the RENATA guardrails, wiring the skills/agents at the right moment of each task. On its own, `executing-plans` does not know our method or our done gate.

## When to use

- To execute a roadmap phase that already has a plan approved by `@architect` (output of Step 11 / `/renata:plan-phase`).

**Do NOT use** for:

- Generating the plan → `/renata:plan-phase`.
- Technical investigation → `/renata:spike`.
- Structural decision → `/renata:adr`.

## Step 1 — Pre-flight (prerequisite validation)

Validate the 4 items below, listing the result of each. If any fails, **abort** and instruct the fix.

| # | Prerequisite | How to validate | Failure → |
|---|---|---|---|
| 1 | An approved plan exists in `docs/superpowers/specs/` | `ls docs/superpowers/specs/*-plan.md` returns ≥1 and CLAUDE.md Section 5 points to it | "Run `/renata:plan-phase <phase>` first." |
| 2 | Plan with no open 🔴 blockers from `@architect` | `grep -c "🔴" docs/superpowers/specs/<plan>` — confirm the 🔴 are marked as resolved | "Resolve the `@architect` blockers first." |
| 3 | No other overlapping `running` plan for the same phase | only 1 plan for the phase with `Status: running` | "Finish or abandon the previous plan first." |
| 4 | `rules.yaml` valid | `bash .claude/hooks/rules-violation.sh` runs without a fatal error | "Run `/renata:adr` in refine mode to populate `rules.yaml`." |

## Step 2 — Load execution context (before the first Edit/Write)

Before touching any code file:

1. Invoke the `respecting-adrs` skill (validates the proposal against accepted ADRs).
2. Read: the active plan, `CLAUDE.md`, the phase's feature-spec in `docs/features/`.

> This step covers in practice the candidate `retrieving-context-before-coding` (see `_framework/SKILL-CANDIDATES.md`) WITHOUT creating the skill — the command forces the reading. If the "started coding without reading context" friction still appears in real use, then promote the candidate to a skill.

## Step 3 — Per-task execution loop

For EACH task in the plan, in this order:

1. **TDD:** invoke `superpowers:test-driven-development` — write the failing test (red) BEFORE the code.
2. **Code:** implement the minimum to pass (green).
3. **Review:** invoke `@code-reviewer` on the task diff. Resolve 🔴 blockers before moving on.
4. **DONE GATE:** invoke `superpowers:verification-before-completion`. Do NOT mark the task as `[x]` without:
   - test green (run it and confirm the output, don't assume);
   - the `rules-violation.sh` hook not blocking.
   - **Granularity:** the per-task gate covers the first two criteria of principle 4 (test passes + hook does not block). The third (observable metric) is at the phase level, validated in Step 4 — don't require an observable metric at every `[x]`.
5. **Scope-creep:** if the task revealed a capability outside the feature-spec, the `detecting-scope-creep` skill should activate — pause and decide (expand the spec via `/renata:feature-spec` or cut it) before continuing.

### When a bug appears

Invoke `superpowers:systematic-debugging` BEFORE proposing a fix (don't guess).

<!-- TODO: when the candidate `ai-pipeline-debugging` is promoted (see SKILL-CANDIDATES.md), complement this hook for AI pipelines (latency, GPU OOM, audio-video drift). -->

## Step 4 — End of phase

When all tasks in the plan are `[x]`:

1. Invoke `@qa-tester` — validates against the PRD/feature-spec acceptance criteria (independent validation, acting as the anchor persona). Resolve blockers before declaring the phase done.
2. Invoke the `keeping-docs-alive` skill — updates CLAUDE.md Section 5, `.claude/sessions/`, and the plan checkboxes.
3. Suggest `/renata:retro <phase>`. If the phase delivered a measurable feature, also suggest `/renata:hypothesis-check`.

## Arguments

`$ARGUMENTS`: number/name of the phase to execute (e.g., `0`, `Phase 0 Spike`). If omitted, infer from the active phase in `CLAUDE.md`.

## Quality rules

- ❌ Pre-flight failed → refuse to start execution.
- ❌ Marking a task `[x]` without passing the done gate (Step 3.4) → refuse.
- ❌ Declaring a phase done without `@qa-tester` (Step 4.1) → refuse.

## What this command does NOT do

- ❌ Does not replace `superpowers:executing-plans` — it invokes/complements it (just as `/renata:plan-phase` does with `writing-plans`).
- ❌ Does not decide architecture (that is `@architect` via `/renata:adr`).
- ❌ Does not run tests via an automated hook — the done gate is the `verification-before-completion` skill, not a hook. If the skill proves weak in real use, promote it to a hook.
