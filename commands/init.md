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

### 1. Check machine dependencies
The RENATA hooks and the commit-time ADR enforcement depend on a few CLI tools. Check them all in a single Bash call:

```bash
for t in yq jq python3 git; do command -v "$t" >/dev/null 2>&1 && echo "ok       $t" || echo "MISSING  $t"; done
```

- `yq` — **required**: without it, `rules-violation.sh` does not validate `rules.yaml` on commit and the status line loses ADR enforcement. No fallback.
- `jq` **or** `python3` — the stage gate and the status line need at least one of the two; only treat as missing if **both** are absent.
- `git` — needed for step 6 (pre-commit enforcement) and for the `--starter` clone.

If nothing is missing, say nothing about this step and move on.

If something is missing:
1. Detect the available package manager (`brew` on macOS, `apt-get` or `dnf` on Linux) and install the missing tools with it (e.g., `brew install yq jq`). Run the install as a normal, visible Bash call — the user's permission prompt is the consent. Never install through any other silent mechanism.
2. If there is no package manager, or the user declines the install, print the manual install command(s) and **continue with the init** — the hooks degrade with warnings instead of breaking, and the SessionStart warning will keep reminding the user about `yq`.

### 2. Resolve arguments
- `$ARGUMENTS` = project name (e.g., "TaskFlow"). If empty, ask.
- Detect the optional `--starter <URL>` flag in `$ARGUMENTS`.

### 3. Detect existing code (brownfield)
Before copying, check whether the directory already contains real code — ignoring anything the scaffold itself brings (`docs/`, `.claude/`, `CLAUDE.md`):

- A dependency manifest at the root or in a first-level subdirectory: `package.json`, `pyproject.toml`, `requirements.txt`, `go.mod`, `Cargo.toml`, `Gemfile`, `pom.xml`, `composer.json`; OR
- A code directory (`src/`, `app/`, `lib/`, `apps/`, `frontend/`, `backend/`) containing source files.

If any match, mark the project as **brownfield** — this only changes the closing output (step 8); the scaffold is copied the same way.

### 4. Copy the scaffold to the current project
Use Bash to copy the plugin template to the current directory, including dotfiles:
```bash
cp -R "${CLAUDE_PLUGIN_ROOT}/template/." .
```
This brings `CLAUDE.md.template`, `.claude/progress-map.yaml`, `.claude/rules.yaml.template`, and the `docs/` tree.

### 5. Materialize the template files
- Rename `CLAUDE.md.template` → `CLAUDE.md`.
- Rename `.claude/rules.yaml.template` → `.claude/rules.yaml`.
- In `CLAUDE.md`, fill in the `{{PROJECT_NAME}}` of Section 1 with the received name. Leave the other `{{...}}` (they are filled in the following steps via `/renata:prd`, `/renata:persona`, etc.).

### 6. Activate ADR enforcement on commit (if there is git)
If the directory has `.git/` (run `test -d .git`):
```bash
# Turns on the blocking of commits that violate an ADR (rules-violation), out of the box:
chmod +x "${CLAUDE_PLUGIN_ROOT}/hooks/scripts/rules-violation.sh"
ln -sf "${CLAUDE_PLUGIN_ROOT}/hooks/scripts/rules-violation.sh" .git/hooks/pre-commit
```
If there is NO git: warn that ADR enforcement will be activated when the project has git, and that it is enough to re-run `/renata:init` or create the symlink above manually.

### 7. (Optional) Frontend starter
If `--starter <URL>` was provided:
```bash
git clone <URL> frontend
rm -rf frontend/.git
```
Then materialize `docs/decisions/ADR-001-frontend-starter.md` documenting that the frontend inherits the starter (Context, Decision, Alternatives, Trade-offs, Review trigger), and add it to the `docs/decisions/README.md` index.

### 8. Next steps
If the project was marked **brownfield** in step 3, print:
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
- ❌ Installing dependencies through anything other than a visible Bash call → the permission prompt is the user's consent; if they decline, print the manual command and move on.
- ❌ Aborting the init because a dependency is missing → the hooks degrade with warnings; always finish the scaffold.
- ❌ Overwriting an existing CLAUDE.md without warning → ask first.
- ❌ Creating the pre-commit symlink without checking `.git/` → check first.

## Arguments

`$ARGUMENTS`: project name + optional `--starter <URL>` flag.
