---
description: Initializes a new project with the RENATA scaffold (CLAUDE.md, docs/, .claude/) and optional frontend starter.
---

# /renata:init — Initialize a new project with the RENATA structure

You initialize the current project with the RENATA scaffold: CLAUDE.md, the `docs/` structure, and `.claude/` (progress-map + rules). Optionally, it clones a frontend starter. It receives the project name in `$ARGUMENTS`.

Respond to the user, and write the "next steps" output, in the user's language (the language they are writing in).

## When to use

- Right after installing the RENATA plugin, in a new project directory (empty or with initial code).
- To "renata-ify" an existing project that does not yet have the structure.

## Steps

### 1. Resolve arguments
- `$ARGUMENTS` = project name (e.g., "TaskFlow"). If empty, ask.
- Detect the optional `--starter <URL>` flag in `$ARGUMENTS`.

### 2. Copy the scaffold to the current project
Use Bash to copy the plugin template to the current directory, including dotfiles:
```bash
cp -R "${CLAUDE_PLUGIN_ROOT}/template/." .
```
This brings `CLAUDE.md.template`, `.claude/progress-map.yaml`, `.claude/rules.yaml.template`, and the `docs/` tree.

### 3. Materialize the template files
- Rename `CLAUDE.md.template` → `CLAUDE.md`.
- Rename `.claude/rules.yaml.template` → `.claude/rules.yaml`.
- In `CLAUDE.md`, fill in the `{{PROJECT_NAME}}` of Section 1 with the received name. Leave the other `{{...}}` (they are filled in the following steps via `/renata:prd`, `/renata:persona`, etc.).

### 4. Activate ADR enforcement on commit (if there is git)
If the directory has `.git/` (run `test -d .git`):
```bash
# Turns on the blocking of commits that violate an ADR (rules-violation), out of the box:
chmod +x "${CLAUDE_PLUGIN_ROOT}/hooks/scripts/rules-violation.sh"
ln -sf "${CLAUDE_PLUGIN_ROOT}/hooks/scripts/rules-violation.sh" .git/hooks/pre-commit
```
If there is NO git: warn that ADR enforcement will be activated when the project has git, and that it is enough to re-run `/renata:init` or create the symlink above manually.

### 5. (Optional) Frontend starter
If `--starter <URL>` was provided:
```bash
git clone <URL> frontend
rm -rf frontend/.git
```
Then materialize `docs/decisions/ADR-001-frontend-starter.md` documenting that the frontend inherits the starter (Context, Decision, Alternatives, Trade-offs, Review trigger), and add it to the `docs/decisions/README.md` index.

### 6. Next steps
Print the initial roadmap pointing to the plugin commands:
```text
✓ RENATA project initialized.
Next steps:
  - Step 2: /renata:prd <idea>
  - Step 3: /renata:persona <name>
  - Step 4: /renata:user-journey <persona>
  - Step 5: /renata:metrics
  - Step 6: /renata:adr (structural decisions)
  - Run /renata:status at any time to see where you are.
```

## Quality rules
- ❌ Overwriting an existing CLAUDE.md without warning → ask first.
- ❌ Creating the pre-commit symlink without checking `.git/` → check first.

## Arguments

`$ARGUMENTS`: project name + optional `--starter <URL>` flag.
