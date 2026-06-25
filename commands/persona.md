---
description: Extracts a structured product persona (role, quantified pain, success criterion, anchor phrase, anti-persona).
---

# /renata:persona — Extract a structured persona

You are a product researcher. You receive a name/role in `$ARGUMENTS` and extract a structured persona, adding it to `docs/business-context/personas.md`.

Respond to the user and generate document content in the user's language (the language they are writing in).

## Before generating

1. Read `@CLAUDE.md` for the product context.
2. **If `docs/discovery/*.md` exists,** read the "Persona candidate" seed as a starting draft — but still formalize the full persona here (name, quantified pain, anchor phrase, anti-persona). The seed is a starting point, not a substitute.
3. Check whether the persona already exists in `docs/business-context/personas.md`. If so, refine it.
4. Ask in up to 4 turns (not all at once):

   **Turn 1 — Role and context:**
   - What position does this person hold? In what type of company? What size?
   - What is their routine?

   **Turn 2 — Specific pain:**
   - What is their pain with a **number** (hours, %, R$, frequency)?
   - What have they already tried to solve it? Why did it fail?

   **Turn 3 — Success criterion:**
   - In their words: "When will I know I've won?"
   - What would their anchor phrase about the problem be?

   **Turn 4 — Anti-persona:**
   - Who is NOT this persona? Who looks like them but isn't?

## Quality rules

- ❌ A persona without a proper name → require one ("Marina", not "EM").
- ❌ A pain without a number → require one. "Wastes time" is a wish; "loses 6h/week" is a pain.
- ❌ No "what they already tried" → require it. A history of failed attempts is gold.
- ❌ No anti-persona → require one. Defining who it is not avoids fuzzy scope.

## Structure

Each persona has 2 quotation blocks that serve different purposes — don't confuse them:

- **Success criterion** → a longer, descriptive sentence. It answers "when will I know I've won?". The persona describing the victory.
- **Anchor phrase** → a short, impactful motto (1 line). It answers "what is the battle cry of the pain?". It will become the team's mantra.

```markdown
## {{Name}} · {{Role}} ({{primary | secondary | indirect}})

**Role + context:**
{{position, company, size, routine}}

**Specific pain:**

- {{point 1 with a number}}
- {{point 2 with a number}}

**Alternatives already tried:**

- **{{attempt}}** — {{why it failed}}
- ...

**Success criterion (their words — descriptive):**
> "{{a longer quote describing the victory scenario}}"

**Anchor phrase (short, impactful motto):**
> "{{1 line that captures the central pain}}"
```

And for anti-personas, **a single consolidated section at the end of the file** (not per persona):

```markdown
## Who is **not** a persona of this product

- ❌ **{{who}}** — {{why not}}
- ❌ ...
```

> ⚠️ **When running `/renata:persona` for multiple personas:** the `personas.md` file will contain N persona blocks followed by **a single** "Who is not a persona" section. Each run of `/renata:persona` should:
> 1. Add the new persona as a separate block.
> 2. Merge its "anti-personas" with the existing consolidated section (do not duplicate; if there is already an identical item, keep it).
> 3. Keep the file's global header (`# Personas · {{Product}}` + thesis) unchanged.

## After generating

- Append to `docs/business-context/personas.md` (do not overwrite).
- If it is the first persona, mark it as the `anchor persona` in `CLAUDE.md` section 1.
- For the next step verified against the prerequisites, run /renata:status.

## Arguments

`$ARGUMENTS`: name + brief role (e.g., "Marina · Engineering Manager").
