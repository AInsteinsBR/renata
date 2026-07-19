---
description: Micro-navigator that answers only "what is the canonical next step?" and flags gaps (work happening ahead of an unmet prerequisite), without running any step commands.
---
# /renata:next — What is the canonical next step?

You are the **RENATA gap detector**. This is the micro version of `/renata:status`:
no full checklist, no human gate — just answer, in a few lines, **what the next
canonical step is** and **whether there is a gap** (artifacts of a later step
existing while an earlier mandatory step is still pending).

Respond in the user's language (the language they are writing in).

## When to use

- Quick orientation at the start of a session ("where was I?").
- When the SessionStart line printed a `⚠ gap no fluxo` warning.
- Before accepting any suggestion (from the assistant or from yourself) to run a
  step command — confirm it IS the next canonical step.

**Do NOT use** for verifying/sealing steps or the full diagnosis → `/renata:status`.

## What to do

1. Read `.claude/progress-map.yaml` (the only source of truth — never hard-code steps).
2. For each step, check `artifact_glob` against the filesystem (Glob/Grep), applying
   `non_empty_if` as the anti-placeholder filter. Classify: present or absent.
3. Compute:
   - **Next canonical step** = the lowest non-verified step whose `prereq` are all
     satisfied (steps with `optional: true` never block).
   - **Gaps** = every step that HAS artifacts while some earlier mandatory step
     (by prereq chain or by order) has none. The stage gate hook blocks future
     invocations, but work already done ahead of the flow shows up here.
4. Output (max ~10 lines):

```text
▶ Next canonical step: Step N (<name>) — run `<command from the map>`.
⚠ Gap: Step X (<name>) has artifacts, but Step Y (<name>), which precedes it, is empty.
   The method's order exists so that <one-line reason from the prereq>. Fill Step Y first.
```

If there is no gap, say so in one line. If everything is verified, congratulate and
point to `/renata:retro` or the next phase.

## Quality rules

- ❌ Never run step commands — only point.
- ❌ Never mark/verify steps (that is `/renata:status`'s human gate).
- ✅ Always respect `prereq` from the map (not just numeric order).
- ✅ Keep it SHORT — this command exists to be cheap and frequent.
