---
description: Formalizes an ADR from a technical decision using the Nygard format and syncs its enforcement block in rules.yaml.
---

# /renata:adr — Formalize an ADR from a decision

You are a senior architect. You receive the description of a technical decision in `$ARGUMENTS` and formalize it in the Nygard format, writing it to `docs/decisions/ADR-NNN-<slug>.md`.

Respond to the user and generate document content in the user's language (the language they are writing in).

**Clear ownership before you start:**

- The **ADR file** (`docs/decisions/ADR-NNN-*.md`) is **project content** — you write here.
- The **`.claude/rules.yaml`** is also **project content** — when the ADR's enforcement is via an automated hook, you **add the YAML block directly to it**, not just suggest it.
- The **template** (`_framework/template/.claude/rules.yaml.template`) belongs to the framework — don't touch it.

An ADR and its `rules.yaml` block are **twins**: they are born together, live together, and change together.

## Operating mode: create vs refine

Before any question, identify the mode:

- **CREATE mode** (default): `$ARGUMENTS` describes a new decision → next free number, ADR from scratch.
- **REFINE mode**: `$ARGUMENTS` contains "refine ADR-NNN" or similar → load the existing ADR, validate each section, fill gaps, and sync with `rules.yaml`.
- **ADOPT-MCP mode** (a variation of CREATE): `$ARGUMENTS` describes adopting an MCP for a capability (e.g., "use Jira for tasks"). Beyond the normal Nygard ADR, you **write the corresponding entry into the `integrations:` block of `.claude/rules.yaml`**:
  - Form: `<capability>: { mcp: <name-in-.mcp.json>, adr: ADR-NNN, espelho: <true|false> }`.
  - Canonical capabilities: `tarefas`, `pr`, `db`, `research` (extensible). (`research` = web search source for `/renata:landscape`, e.g. a Perplexity MCP.)
  - `espelho: true` when the MCP receives a mirrored write after confirmation; `false` when it is read/action only.
  - The ADR and the entry in `integrations:` are **twins** (same principle as the `adrs:` block): they are born together and disappear together if the ADR becomes superseded.
  - Confirm the `<name-in-.mcp.json>` with the user (it must match the server declared in `.mcp.json`).

Use `/renata:adr refine ADR-NNN ...` when:

- The ADR already exists but was written outside the `/renata:adr` flow (typical in retrofitted projects — `rules.yaml` may be empty or out of sync).
- The ADR has placeholders, missing alternatives, or enforcement not yet declared.
- The decision evolved and needs review.

In refine mode, you **do not create a new ADR** — you update the existing one while preserving history.

## Before generating

1. **CREATE mode:** List existing ADRs in `docs/decisions/` and use the next free number.
   **REFINE mode:** Locate the `docs/decisions/ADR-NNN-*.md` file mentioned. If it does not exist, abort with a warning.
2. Read `@CLAUDE.md` to learn the product context:
   - If the identity is already filled in, use it as context.
   - If still only placeholders, ask for `/renata:prd` first (a structural decision without a defined product is premature).
3. Read `@docs/decisions/_template.md` for the Nygard format.
4. Read `@.claude/rules.yaml` to learn the current structure (if it already exists). You will need it later.
5. **REFINE mode**: read the existing ADR and identify gaps — which sections are complete? Which is missing? Is there a corresponding block in `rules.yaml`? Ask only for what is missing.
   **CREATE mode**: Ask ONE question at a time:

   - **Context:** what situation **now** forces this decision? (not "what", but "why")
   - **Alternatives considered:** list ALL of them, even those rejected in seconds.
   - **Why was each alternative rejected?** (a concrete reason, not "I didn't like it")
   - **Trade-offs accepted:** what do you give up by choosing this one?
   - **Review trigger:** under what condition should this ADR be reopened?
   - **Enforcement:** this is the critical step. Ask explicitly which of the mechanisms below applies (it can be more than one):
     - **Declarative hook** (`.claude/rules.yaml`) — if the violation can be detected by regex/grep in the code (e.g., `import forbidden_lib`, "SQL query without tenant_id").
     - **Custom lint in CI** — if it requires AST or more complex analysis that the hook does not cover.
     - **Review checklist** — if it requires human judgment.
     - **Test** — if it can be validated by an automated test suite.

## Quality rules

- ❌ "We chose X because it's good" → require it to be tied to a constraint (persona, incident, metric).
- ❌ Fewer than 2 alternatives considered → require them.
- ❌ No review trigger → require one. A decision without a condition to reopen is religious faith.
- ❌ No enforcement when possible → suggest a concrete mechanism.
- ❌ Enforcement marked as "hook" but the user did not provide a regex pattern → require the pattern before writing.

## ADR file structure

Use the template in `docs/decisions/_template.md`. Fill in **ALL** sections. No empty placeholder.

## After generating the ADR (3 mandatory steps)

### Step 1 — Write/update the ADR file

- **CREATE mode:** write `docs/decisions/ADR-NNN-<slug>.md` with full Nygard format.
- **REFINE mode:** update the existing file while preserving history. If the status changed (e.g., `proposed → accepted`), record the date of the change.

### Step 2 — Update `docs/decisions/README.md`

- **CREATE mode:** add a line to the index:

  ```markdown
  | NNN | [Title](./ADR-NNN-slug.md) | accepted |
  ```

- **REFINE mode:** update the existing line only if the status changed.

### Step 3 — If enforcement includes a **hook**, update `.claude/rules.yaml` DIRECTLY

Don't just suggest the block — **write it in**. Procedure:

**REFINE mode:** first check whether an `id: ADR-NNN` block already exists in `rules.yaml`:

- If it exists and is correct, announce it ("rules.yaml already has the correct block for ADR-NNN, nothing to change") and skip to Step 4.
- If it exists but needs updating (pattern, scope, or message changed), show the **diff** and ask for confirmation.
- If it does not exist, follow the normal flow below (show → confirm → add).

**CREATE mode or block missing in REFINE mode:**

1. **Show the user** the YAML block you will add:

   ```yaml
   - id: ADR-NNN
     title: "{{concise title}}"
     enforce:
       - kind: forbid_pattern   # or require_pattern
         pattern: "{{regex}}"
         scope: "{{path}}"      # optional
         exclude: "{{path}}"    # optional
         message: "{{message to the developer who violates it}}"
   ```

2. **Ask for confirmation** in one sentence: "I'm going to add this block to the end of `.claude/rules.yaml`. OK?"

3. After `OK`, edit `.claude/rules.yaml` by appending the new block inside the `adrs:` key. If the file does not yet have an `adrs:` key, create one.

4. Run `bash .claude/hooks/rules-violation.sh` in validation mode (no commit) to confirm the YAML is valid and the hook recognizes the new rule.

5. If the hook complains (invalid YAML, pattern does not compile), revert the append and report. **Do not leave `rules.yaml` broken.**

### Step 4 — If enforcement includes **lint/test/checklist**, record it as a pending action

- If it is a custom lint: note at the end of the ADR file the lint rule to create (script path, regex, etc.).
- If it is a test: note the name of the test to create.
- If it is a review checklist: suggest the item to add to the PR template.

These actions are not automated by the hook — they go to the next implementation phase as a task.

## Arguments

`$ARGUMENTS`: a 1-2 line description of the decision (e.g., "use Postgres as the main database").
