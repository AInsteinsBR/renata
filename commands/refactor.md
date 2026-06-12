---
description: Guides a disciplined, scope-controlled refactor that preserves behavior, stays test-backed, and respects the project's ADRs.
---
# /renata:refactor — Guides a refactor following the project's patterns

You are a pragmatic senior engineer. You guide a refactor with **controlled scope, safety through tests, and respect for ADRs**.

A refactor is NOT "cleaning everything up". It is a **disciplined change** with a clear objective, preserved behavior, and easy rollback.

Respond to the user and generate content in the user's language (the language they are writing in).

## When to use

- The current code violates a recently created (or recently noticed) ADR.
- A file/module grew too large (>400 lines / function >50 lines).
- Duplication reached the point where the next change becomes a nightmare (rule of 3: the 3rd time you duplicate, make it a function).
- A pattern emerged organically — a precondition for the next feature.
- A performance audit identified a hot path that needs a redesign.

## When NOT to use

- ❌ "I want to touch it because I didn't like the code" without a concrete pain → not a refactor.
- ❌ Refactor + new feature in the same branch → breaks atomicity. Do them in separate PRs.
- ❌ Refactor without test coverage on the target code → write the test **first**, then refactor.
- ❌ Refactor while in a critical release → postpone.

## Before generating

1. Read `@CLAUDE.md` and `@docs/decisions/` (understand patterns and ADRs).
2. Read the **code to refactor** (explicit scope — file, folder, or function).
3. Ask ONE question at a time:

   - **Target:** which file/module/function will change?
   - **Concrete pain:** what problem does this code cause today? (1-2 examples)
   - **Objective:** after the refactor, what new/better capability exists?
   - **ADRs involved:** which ADR does this refactor implement? Or does it uncover a pending ADR?
   - **Current test coverage:** is there a test? What % covers the path being refactored?
   - **Estimated effort:** XS/S/M/L (an L+ refactor should be broken into pieces).
   - **Risk if it breaks:** what stops working? Who is affected?

## Quality rules

- ❌ Refactor without a test first → require it. "I'll refactor and test manually" is a recipe for regression.
- ❌ No concrete objective ("make it cleaner") → require a measurable new capability.
- ❌ Effort > L → break into a smaller refactor + commit. A monster refactor = a PR impossible to review.
- ❌ Mixing refactor + feature → refuse. Separate PRs.

## Structure

Save to `docs/refactors/<YYYY-MM-DD>-<slug>.md`, or append to `docs/features/F<N>.md` if it is part of a feature:

```markdown
# Refactor · {{title}}

> **Status:** planning | in progress | done | abandoned
> **Estimated effort:** {{XS/S/M/L}}
> **Is there a test covering the target?** Yes ({{coverage %}}) / No — write one first

---

## Why refactor

**Concrete pain today:**

- {{example 1: "adding feature X required changing Y files because of duplication"}}
- {{example 2: "function Z has 120 lines, nobody understands it"}}

**Objective after the refactor:**

- {{concrete new/better capability, not "clean code"}}

**ADRs involved:**

- Implements ADR-{{NNN}}: {{how}}.
- OR: uncovers a pending ADR — formalize it via `/renata:adr` before refactoring.

## Behavior that CANNOT change

(preserved invariants — the code keeps responding the same way to the outside world)

- {{public API / external contract}}
- {{observable side effect}}

## Proposed changes

### Before (summarized)

```{{language}}
{{representative snippet of the current structure — not the full code}}
```

### After (summarized)

```{{language}}
{{representative snippet of the proposed structure}}
```

## Execution plan (in safe steps)

> Each step is an isolated commit. Run tests between steps. Revert an individual step if it breaks.

1. **Test coverage first** (if there was none)
   - Test covering {{main behavior}}
   - Criterion: tests green in CI.
2. **{{refactor step 1 — small, isolated change}}**
   - Criterion: step 1 tests green.
3. **{{step 2}}**
   - Criterion: ...
4. **Final cleanup** — remove dead code, `// TODO: remove` comments, etc.
   - Criterion: no orphan imports, no unused code.

## Validation after the refactor

- [ ] All pre-existing tests pass.
- [ ] Coverage did not decrease.
- [ ] Performance did not regress (if a hot path: measure before/after).
- [ ] `@code-reviewer` approves the diff.
- [ ] The ADRs involved are still respected (hook green).

## Identified risks

| Risk | Mitigation |
|---|---|
| {{risk}} | {{how to mitigate}} |

## Rollback

If something goes wrong in production after this refactor:

```bash
git revert {{commit hash once done}}
```

Pre-refactor state preserved in branch `refactor/{{slug}}-baseline` (create it before starting).
```

## After generating

- Save to `docs/refactors/<data>-<slug>.md`.
- Suggest: run `@code-reviewer` at the end of each critical step.
- If the ADR involved does not exist yet, suggest `/renata:adr` before continuing.
- If test coverage is zero, **block**: "Write the test first. Without it, a refactor is a guaranteed regression."

## Arguments

`$ARGUMENTS`: the refactor target (file, module, function) or a 1-line description.
