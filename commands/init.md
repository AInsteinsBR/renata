---
description: Initializes a new project with the RENATA scaffold (CLAUDE.md, docs/, .claude/) and optional frontend starter.
---

# /renata:init — Initialize a new project with the RENATA structure

You initialize the current project with the RENATA scaffold: CLAUDE.md, the `docs/` structure, and `.claude/` (progress-map + rules). Optionally, it clones a frontend starter. It receives the project name in `$ARGUMENTS`.

Respond to the user, and write the "next steps" output, in the user's language (the language they are writing in).

## When to use

- Right after installing the RENATA plugin, in a new project directory (empty or with initial code).
- To "renata-ify" an existing project that does not yet have the structure — in that case the closing output points to `/renata:adopt` (full brownfield adoption).

## Steps

### 1. Resolve arguments
- `$ARGUMENTS` = project name (e.g., "TaskFlow"). If empty, ask.
- Detect the optional `--starter <URL>` flag in `$ARGUMENTS`.

### 2. Detect existing code (brownfield)
Before copying, check whether the directory already contains real code — ignoring anything the scaffold itself brings (`docs/`, `.claude/`, `CLAUDE.md`):

- A dependency manifest at the root or in a first-level subdirectory: `package.json`, `pyproject.toml`, `requirements.txt`, `go.mod`, `Cargo.toml`, `Gemfile`, `pom.xml`, `composer.json`; OR
- A code directory (`src/`, `app/`, `lib/`, `apps/`, `frontend/`, `backend/`) containing source files.

If any match, mark the project as **brownfield** — this only changes the closing output (step 7); the scaffold is copied the same way.

### 3. Copy the scaffold to the current project
Use Bash to copy the plugin template to the current directory, including dotfiles:
```bash
cp -R "${CLAUDE_PLUGIN_ROOT}/template/." .
```
This brings `CLAUDE.md.template`, `.claude/progress-map.yaml`, `.claude/rules.yaml.template`, and the `docs/` tree.

### 4. Materialize the template files
- Rename `CLAUDE.md.template` → `CLAUDE.md`.
- Rename `.claude/rules.yaml.template` → `.claude/rules.yaml`.
- In `CLAUDE.md`, fill in the `{{PROJECT_NAME}}` of Section 1 with the received name. Leave the other `{{...}}` (they are filled in the following steps via `/renata:prd`, `/renata:persona`, etc.).

### 5. Activate ADR enforcement on commit (if there is git)
If the directory has `.git/` (run `test -d .git`):
```bash
# Turns on the blocking of commits that violate an ADR (rules-violation), out of the box:
chmod +x "${CLAUDE_PLUGIN_ROOT}/hooks/scripts/rules-violation.sh"
ln -sf "${CLAUDE_PLUGIN_ROOT}/hooks/scripts/rules-violation.sh" .git/hooks/pre-commit
```
If there is NO git: warn that ADR enforcement will be activated when the project has git, and that it is enough to re-run `/renata:init` or create the symlink above manually.

### 6. (Optional) Frontend starter
If `--starter <URL>` was provided:
```bash
git clone <URL> frontend
rm -rf frontend/.git
```
Then materialize `docs/decisions/ADR-001-frontend-starter.md` documenting that the frontend inherits the starter (Context, Decision, Alternatives, Trade-offs, Review trigger), and add it to the `docs/decisions/README.md` index.

### 7. Next steps
If the project was marked **brownfield** in step 2, print:
```text
✓ RENATA scaffold initialized — existing code detected.
This looks like an existing project. Next step:
  - /renata:adopt  (reverse-engineers the pattern, features and a retroactive PRD)
  - Guide: ADOPTION.md in the plugin repo.
```
Otherwise (greenfield), print the initial roadmap pointing to the plugin commands:
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
