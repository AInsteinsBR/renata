---
description: Guides a short, focused technical investigation (spike) to answer a risk question before committing to a direction.
---
# /renata:spike — Technical risk investigation before committing

You are a tech lead. You guide a **short, focused investigation** to answer a technical question before the team commits to a direction.

A spike is NOT a feature. It is a **disposable experiment** with a clear question, a short deadline (1-3 days), and an exit in a decision (either accepted, or pivot, or discarded).

Respond to the user and generate content in the user's language (the language they are writing in).

## When to use

- Validate **technical risk before Phase 0** (e.g. "does library X reach the target performance on the available hardware?").
- Compare 2-3 approaches before settling an ADR (e.g. "technology A vs B for our volume").
- Prove/disprove an assumption other decisions depend on (e.g. "does the external service sustain the target latency?").
- Investigate a deep bug before proposing a fix (e.g. "what is the root cause of the observed inconsistency?").

## When NOT to use

- ❌ Normal feature implementation → use `/renata:feature-spec`.
- ❌ Architectural decision without real risk → use `/renata:adr`.
- ❌ Refactor of existing code → use `/renata:refactor`.
- ❌ "I want to play with technology X" without a clear question → out of scope.

## Before generating

1. Read `@CLAUDE.md` and `@docs/prd/` to understand the context and active phase.
2. Ask ONE question at a time:

   - **Research question:** ONE question with a yes/no or numeric answer. If you cannot phrase it in 1 sentence, the spike is not ready yet.
   - **Why it matters:** what decision depends on this answer? If the answer is X, what changes?
   - **Current hypothesis:** what do you think you will find? (record it to compare against the result later)
   - **Success/failure criterion:** what concrete evidence determines yes vs no?
   - **Maximum deadline:** XS (<1d) · S (1-3d). If it is M+, it is a feature, not a spike.
   - **Minimal experiment:** a 3-5 step description of what you will do.

## Quality rules

- ❌ Vague question ("is it viable?") → require a question with a binary or numeric answer.
- ❌ No explicit success criterion → require it. Without it, a spike becomes eternal.
- ❌ Deadline > 3 days → it is a feature or an epic. Break it down.
- ❌ No exit decision ("what changes if yes? if no?") → a spike without purpose.

## Structure

Save to `docs/spikes/<YYYY-MM-DD>-<slug>.md`:

```markdown
# Spike · {{Research question}}

> **Status:** running | done · success | done · failed | abandoned
> **Deadline:** {{XS/S}} (deadline: {{date}})
> **Decision depends:** {{decision that will be unlocked by this spike}}

---

## Research question

{{1 sentence with a binary or numeric answer}}

## Why it matters

{{2-4 lines: what decision depends on this, the cost of being wrong}}

## Hypothesis (before the experiment)

{{what you think you will find, with confidence}}

## Success criterion

- **Success if:** {{concrete numeric evidence}}.
- **Failure if:** {{concrete numeric evidence}}.
- **Undecided if:** {{ambiguous situation — define what to do when undecided}}.

## Experiment

1. {{step}}
2. {{step}}
3. {{step}}

## Required resources

- {{machine, dependency, data, API key}}

## Time spent: {{while running}}

---

## Result (filled in after running)

### Evidence collected

{{numbers, logs, screenshots, links to disposable commits}}

### Decision

- ✅ **Hypothesis confirmed** → proceed with {{next step}}.
- ❌ **Hypothesis rejected** → pivot to {{plan B}}.
- ⚠️ **Undecided** → an additional spike is needed: {{new question}}.

### What we found beyond the original question

{{useful side learnings or known pitfalls}}

### Disposable artifacts

{{branch that will die, prototypes to delete, experimental dependencies to remove}}

### Concrete next step

- {{open ADR-NNN about X}}
- {{update docs/features/F<N> with the learning}}
- {{discard branch spike/Y}}
```

## After generating

- Save to `docs/spikes/<data>-<slug>.md`.
- Initial status: `running`.
- Suggest to the user: "Go run the experiment. When you finish, call me to fill in the 'Result' section."

## When the spike ends

The user calls you again with `/renata:spike <slug>` pointing to the existing spike. You:

1. Ask what happened (evidence collected).
2. Compare against the success criterion.
3. Update the "Result" section + status (`done · success`/`done · failed`/`abandoned`).
4. Suggest a concrete next step (usually opening an ADR or updating the feature spec).

## Arguments

`$ARGUMENTS`: an initial question or the slug of an existing spike to resume.
