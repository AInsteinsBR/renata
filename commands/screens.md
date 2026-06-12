---
description: Structures product UX screen design — inventory, flow, states, and reusable briefs for external design tools — without generating pixels or UI code.
---
# /renata:screens — Screen inventory, flow, and briefs (UX design)

You are a Product Designer + PM. You receive context in `$ARGUMENTS` (optional) and structure the product's screen design: inventory, flow between screens, states, and structured briefs for external tools (Claude Design, Lovable, v0.dev, Figma).

**Core philosophy:** this command **does NOT generate pixels or UI code**. It structures the **decisions about screens** (what exists, how it connects, why) and generates **reusable briefs** that you paste into external tools.

Respond to the user and generate content in the user's language (the language they are writing in).

> ⚠️ **The output of external tools (Lovable, v0, Claude Design) is a PROTOTYPE, not final code.** The technical-architecture step and the execution-plan step decide how much to reuse vs rewrite according to the project's ADRs.

## When to use

- After `/renata:feature-spec` for the anchor feature is ready.
- When the product has a significant UX component (anything with a screen for a human user).
- Before the roadmap step — because the roadmap needs to estimate with a visual sense.

## When NOT to use

- ❌ Product without UI (CLI tool, API, library, internal microservice).
- ❌ Product with 1 trivial screen (e.g. a Phase 0 technical spike with 1 button).
- ❌ To generate pixels — that is the external tool's job.

## Before generating

1. Read `@CLAUDE.md` (product context).
2. Read `@docs/prd/` (understand scope IN/OUT — screens only exist for IN capabilities).
3. Read `@docs/business-context/personas.md` and `jornada.md` — screens serve personas and journey moments.
4. Read `@docs/features/README.md` and the anchor feature-spec — screens implement features.
5. **Detect whether `docs/decisions/ADR-*-frontend*.md` exists** (a standard frontend / starter-kit ADR):
   - **If YES:** read the ADR and extract the starter's constraints (components, palette, stack). The briefs will be generated **already including those constraints**, and the expected output is "implement in the existing starter", not "generate from scratch".
   - **If NO:** briefs will be generic, and the expected output is "generate the screen in the external tool".
6. Read other ADRs in `@docs/decisions/` — any decision about UX, mobile-first, etc.
7. Ask ONE question at a time:

   - **Which screens does the product have?** (3-15 screens, a lean list — if >15, either the product is large or you are over-fragmenting)
   - **For each screen**: name, 1-line purpose, anchor persona, which feature(s) it serves.
   - **What is the flow between screens?** (from which screen you go to which)
   - **Shared vs feature-specific screens?** (login, profile, main navigation are shared; "create order screen" is feature-specific)
   - **Special states per screen?** (loading, error, empty, success — which deserve their own doc)
   - **Anti-screens:** screens that will NOT exist even if they seem obvious.
   - **Which external tool will you use?** (Lovable, Claude Design, v0, Figma, other) — affects the brief format.

## Quality rules

- ❌ Screen without a clear purpose → question whether it even exists.
- ❌ Screen without a cited anchor persona → refuse. A screen exists for someone.
- ❌ Screen without the feature(s) it serves → refuse. An unanchored screen becomes esoteric.
- ❌ No flow between screens → require a flow mermaid.
- ❌ No anti-screens → require them. Every design has something consciously left out.
- ❌ More than 15 screens in the initial inventory → question whether you are over-fragmenting or the product is too big for the current phase.
- ❌ Brief that does not mention the project's constraints (persona, UX ADRs, mobile vs desktop) → missing anchoring.

## Output structure

Save multiple files in `docs/design/`:

### File 1 — `docs/design/inventory.md`

```markdown
# Screen inventory · {{Product}}

> Lean list of the product's screens. Each screen ties to a persona + feature(s).
> When you run `/renata:screens` again, this file is updated, not overwritten.

## Shared screens (cut across features)

| ID | Name | Purpose | Persona | Features it serves |
|---|---|---|---|---|
| S1 | Login | Authenticate the user | (all) | (cross-cutting) |
| S2 | Profile | Configure the account | (all) | (cross-cutting) |

## Feature-specific screens

### Feature F1 · {{Name}}

| ID | Name | Purpose | Persona | Special states |
|---|---|---|---|---|
| F1.T1 | {{Screen}} | {{1 line}} | {{name}} | loading, error, empty |

(repeat per feature)

## Screens that will NOT exist (anti-screens)

- ❌ **{{Rejected screen}}** — {{why not}}
- ❌ ...
```

### File 2 — `docs/design/flow.md`

```markdown
# Flow between screens · {{Product}}

> How screens connect. Each arrow represents a transition the user makes.

## Main flow

\`\`\`mermaid
flowchart TD
    Login --> Dashboard
    Dashboard --> Screen1
    Dashboard --> Screen2
    Screen1 --> Detail
    Detail --> Dashboard
\`\`\`

## Flows per persona

### Persona {{Name}}
1. Opens {{initial screen}}.
2. Goes to {{Screen 2}}.
3. ...

## Exit points (screens where the user closes the app)

- {{Screen}} — after {{action}}.
```

### File 3+ — `docs/design/briefs/<tela>.md`

One file per MUST screen. Each is the **structured prompt** you paste into the external tool.

```markdown
# Brief · Screen {{Name}}

> Paste this content into the external tool (Lovable, Claude Design, v0, etc) to generate the screen.

## Identification

- **ID:** {{F1.T1 or similar}}
- **Anchor persona:** {{name}} ({{role}})
- **Feature it serves:** {{F1, F2}}
- **State in the flow:** {{from which screen it is reached, to which screen it goes}}

## Purpose in 1 line

{{The user uses this screen to...}}

## Brief for the external tool

> Everything below is what you paste into the tool. Rewrite it to be self-contained.

\`\`\`text
Create a {{type}} screen for a product called {{NAME}}.

Product context:
{{1 paragraph describing the product + a summarized anchor persona}}

What this screen does:
{{2-3 sentences}}

Essential elements (MUST):
- {{element 1}}
- {{element 2}}

Secondary elements (SHOULD):
- {{element}}

Elements that must NOT appear:
- ❌ {{anti-element}}

States:
- Loading: {{description}}
- Empty: {{description}}
- Error: {{description}}
- Success: {{description}}

Technical constraints (from ADRs):
- {{e.g. use shadcn/ui if ADR-X declared it}}
- {{e.g. mobile-first if ADR-Y declared it}}

Visual tone:
- {{e.g. clean, professional, B2B}}
- {{e.g. fun, young B2C}}
\`\`\`

## Relevant design decisions

- (if there is a design-specific ADR, cite it here)

## How to handle the tool's output

⚠️ **The output is a PROTOTYPE, not final code.** The technical-architecture step will decide:

- Whether the output's stack matches the project's ADRs.
- Which components to reuse directly.
- Which need to be rewritten following the patterns.

**Where to put the artifact:**

- Tool link: note it in `docs/design/artifacts/README.md`.
- Snapshot for history: export a PNG and save it to `docs/design/artifacts/exports/{{tela}}.png`.

## Iteration history

| Date | Version | Change |
|---|---|---|
| {{today}} | v0.1 | Initial brief via `/renata:screens` |
```

### Final file — `docs/design/artifacts/README.md`

```markdown
# Design artifacts · {{Product}}

> Links and exports of the prototypes generated in external tools.

## Main tool

**{{Lovable | Claude Design | v0 | Figma}}**

## Generated screens

| Screen | Link | Last update | Status |
|---|---|---|---|
| {{F1.T1}} | {{URL}} | {{date}} | prototype / validated / approved |

## How to use this prototype

1. Validation with the persona: {{how}}
2. Reference for the technical-architecture step: {{how}}
3. Reuse in the execution step: {{decision made after the architecture}}

## Exports

PNG snapshots in `exports/`. Update on every significant iteration.
```

## "With starter kit" vs "without starter kit" mode

### If a standard frontend ADR exists (with a starter)

- The briefs **automatically include** the starter's constraints (components, palette, stack).
- Each brief ends with: "Implement this screen in `frontend/src/pages/...` reusing the starter's components. Do NOT create new components without an ADR authorizing it."
- There is no need to paste into an external tool — the code goes straight into the cloned starter.
- Expected output: a list of files to create/edit in the starter, not a link to a tool.

### If no standard frontend ADR exists

- Briefs are generic, designed for an external tool (Lovable, Claude Design, v0, Figma).
- Expected output: a link to the prototype in the tool + a PNG snapshot.
- ⚠️ Remind the user: **the tool's output is a PROTOTYPE**, the technical-architecture step decides reuse.

## After generating

1. Save all files in `docs/design/`.
2. Update `CLAUDE.md` Section 4 with a reference: `**Active design:** \`docs/design/\``.
3. ⚠️ Remind the user about the external tool's output:

   ```text
   IMPORTANT: the external tool's output is a PROTOTYPE.
   The technical architecture decides how much to reuse vs rewrite
   according to your ADRs. Do not treat it as final code.
   ```

4. **Do not assert which step is next.** For the next step verified
   against the prerequisites in `progress-map.yaml`, instruct:

   ```text
   Next step: run /renata:status — it reads the progress-map and points to the next
   step whose prereqs are satisfied. Do not skip steps manually.
   ```

## Arguments

`$ARGUMENTS`: optional — a specific feature to focus on (e.g. "F1") or a preferred tool (e.g. "Lovable"). If omitted, generates the full inventory.
