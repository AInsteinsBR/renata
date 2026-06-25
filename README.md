<p align="center">
  <img src="assets/logoRenata.svg" alt="RENATA" width="560">
</p>

<p align="center">
  <sub>by</sub>&nbsp;&nbsp;<img src="assets/ainsteins-logo.png" alt="AInsteins" height="22" valign="middle">
</p>

> 🇧🇷 [Versão em português](README.pt-br.md)

> **R**ecord · **E**vidence · **N**ame · **A**nchor · **T**est · **A**utomate.

**RENATA** is a product method that ties **persona → metric → ADR → code**, shipped as a Claude Code plugin. It takes you from "I have an idea" to "code running in production" without losing the *why* behind each decision along the way.

> Created by **Eric Luque** · **AInsteins** — https://www.ainsteins.com.br

---

## Install

```text
/plugin marketplace add AInsteinsBR/renata
/plugin install renata@ainsteins
```

## Start a project

```text
/renata:init "My Product"
```

Creates `CLAUDE.md`, `docs/` and `.claude/` in the project, and activates ADR-violation blocking on commit (if the project uses git). Then follow `GETTING-STARTED.md`.

## What's in the plugin

- **23 commands** — planning (`/renata:discovery`, `/renata:prd`, `/renata:persona`, `/renata:user-journey`, `/renata:metrics`, `/renata:adr`, `/renata:feature-breakdown`, `/renata:feature-behavior`, `/renata:phase-roadmap`, `/renata:feature-spec`), design (`/renata:screens`), validation (`/renata:assumption-test`, `/renata:hypothesis-check`), development (`/renata:plan-phase`, `/renata:execute`, `/renata:spike`, `/renata:phase-scope`, `/renata:triage`, `/renata:todo`, `/renata:refactor`, `/renata:retro`, `/renata:extract-pattern`), navigation (`/renata:status`), and the scaffold (`/renata:init`).
- **6 agents** — `@architect`, `@code-reviewer`, `@qa-tester`, `@perf-auditor`, `@security-reviewer`, `@pattern-mapper`.
- **3 auto-activating skills** — `respecting-adrs`, `keeping-docs-alive`, `detecting-scope-creep`.
- **Hooks** — stage gate, in-session status, ADR-violation blocking on commit.

> **Note:** the method content (commands, docs) is currently written in Portuguese; identifiers (commands, agents, files) are in English. Full English localization is on the roadmap. For the philosophy, see `METHOD.md`; for the step-by-step, `GETTING-STARTED.md`. For what's new in each version, see [`CHANGELOG.md`](CHANGELOG.md).

---

## Need help rolling it out?

RENATA is free and open (MIT). If you want to **deploy the method at your company** — setup, team training, custom code starters, or product/architecture consulting — **AInsteins** does that:

**https://www.ainsteins.com.br**

---

## Why "RENATA"

Every method needs a name. This one carries hers.

RENATA is named after my wife, Renata. Behind every project I build there are hours that belonged to us — evenings, weekends, the small precious time a couple has. She gave that time up, again and again, so these ideas could exist. Not grudgingly: she's the one who pushes me to create, who believes the thing is worth building before anyone else does.

So the acronym is real — **R**ecord, **E**vidence, **N**ame, **A**nchor, **T**est, **A**utomate, the six verbs of the method — but the name is a thank-you. To the person who anchors everything else.

— Eric

---

## License

MIT © Eric Luque / AInsteins. Use freely; keep the copyright notice.
