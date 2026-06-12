---
name: respecting-adrs
description: Use whenever you are about to propose a technical solution, write code, or implement a feature. Ensures the proposal respects the project's accepted ADRs before writing a single line of code. Auto-activates when detecting context like "implement X", "how do I Y", "I'm going to use library Z", or similar.
---

# Respecting ADRs before coding

ADRs (`docs/decisions/ADR-*.md`) are the project's structural decisions with status `accepted`. **Every technical proposal must respect them** — a violation requires opening a new superseding ADR, not bypassing them.

## When this skill activates

Auto-activates when the context involves:
- "Implement X"
- "I'm going to write / code / create"
- "Which library to use"
- "How do I Y in [language/framework]"
- "Refactor to use Z"
- Proposing a diff/PR

## Procedure (4 steps)

### Step 1 — List the relevant accepted ADRs

Run this mentally: "Which ADRs in this project might have something to say about what I'm about to do?"

- **Always** consult `docs/decisions/README.md` (the index).
- If the proposal touches: database → ADR about persistence; auth → ADR about auth; external libraries → ADR about the stack; etc.
- If there is no ADR on the topic but the decision is structural → **open an ADR first** (`/adr`).

### Step 2 — Validate the proposal against each identified ADR

For each relevant ADR:

1. Read the "Decision" and "Enforcement" sections.
2. Confirm that the proposal **does not contradict** the decision.
3. If the ADR has a hook (`.claude/rules.yaml`), make sure your code won't be blocked by it.

### Step 3 — If there's a conflict, **STOP**

Don't code. Options:

- **Refine the proposal** to respect the ADR (most common).
- **Open a new ADR** superseding the old one, if the old decision really is wrong (use `/adr`).
- **Ask the user for clarification** if the conflict isn't clear.

**NEVER work around the hook** or use a silent workaround.

### Step 4 — Cite the ADR in the commit/PR

When implementing, mention the relevant ADR:

```text
feat(providers): ClienteRepo em providers/impl (ADR-007 adapter pattern)
```

## Examples

### ✅ Good

> User: "I'm going to add a cache lib to the worker to store responses."
>
> Skill activates: "Before coding, I'll consult the ADRs. `ADR-004` defines technology X for path A, OK. But this cache is a different kind (key-value) and ADR-004 doesn't cover that use. I'll reuse the same infrastructure already available with a dedicated prefix. It doesn't violate ADR-004 or create a new structural decision (caching is an implementation detail)."

### ❌ Bad

> User: "I'm going to add a second database to persist sessions."
>
> Skill **does NOT** activate, or activates but is ignored: "I added the driver and created the sessions table..."
>
> Result: violates ADR-006 (that database is OUT of scope for the current phase). The hook won't block it (there's no rule), but a structural decision was made without an ADR. Technical debt created.

### ❌ Worse

> User: "I need to use library Z for a specific case."
>
> Skill activates: "ADR-002 explicitly forbids library Z. The hook will block it. I'll use it anyway and add a `# noqa` on the import."
>
> NO. If you really need it, open ADR-009 superseding ADR-002 with concrete justification. Otherwise, rework the proposal.

## Anti-patterns of this skill

- ❌ "I already know this ADR doesn't apply" without reading — always read.
- ❌ Citing an ADR in the commit but not having actually validated it.
- ❌ Skipping Step 1 ("obviously it complies") — it's not obvious until confirmed.
