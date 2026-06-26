<p align="center">
  <img src="assets/logoRenata.svg" alt="RENATA" width="560">
</p>

<p align="center">
  <sub>by</sub>&nbsp;&nbsp;<picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/AInsteinsBR/renata/main/assets/ainsteins-logo-dark.png">
    <img src="assets/ainsteins-logo.png" alt="AInsteins" height="22" valign="middle">
  </picture>
</p>

> 🇬🇧 [English version](README.md)

> **R**ecord · **E**vidence · **N**ame · **A**nchor · **T**est · **A**utomate — registre, meça, nomeie, ancore, teste, automatize.

**RENATA** é um método de produto que amarra **persona → métrica → ADR → código**, materializado como plugin do Claude Code. Tira você de "tenho uma ideia" até "código rodando" sem perder o porquê de cada decisão no caminho.

> Criado por **Eric Luque** · **AInsteins** — https://www.ainsteins.com.br

---

## Instalação

```text
/plugin marketplace add AInsteinsBR/renata
/plugin install renata@ainsteins
```

## Começar um projeto

```text
/renata:init "Meu Produto"
```

Cria `CLAUDE.md`, `docs/` e `.claude/` no projeto, e ativa o enforcement de ADR no commit (se há git). Depois siga o `GETTING-STARTED.md`.

## O que vem no plugin

- **24 comandos** — planejamento (`/renata:discovery`, `/renata:prd`, `/renata:persona`, `/renata:user-journey`, `/renata:metrics`, `/renata:adr`, `/renata:landscape`, `/renata:feature-breakdown`, `/renata:feature-behavior`, `/renata:phase-roadmap`, `/renata:feature-spec`), design (`/renata:screens`), validação (`/renata:assumption-test`, `/renata:hypothesis-check`), desenvolvimento (`/renata:plan-phase`, `/renata:execute`, `/renata:spike`, `/renata:phase-scope`, `/renata:triage`, `/renata:todo`, `/renata:refactor`, `/renata:retro`, `/renata:extract-pattern`), navegação (`/renata:status`), e o scaffold (`/renata:init`).
- **6 agentes** — `@architect`, `@code-reviewer`, `@qa-tester`, `@perf-auditor`, `@security-reviewer`, `@pattern-mapper`.
- **3 skills auto-ativáveis** — `respecting-adrs`, `keeping-docs-alive`, `detecting-scope-creep`.
- **Hooks** — gate de etapas, status na sessão, enforcement de ADR no commit.

Para a filosofia, veja `METHOD.pt-br.md`. Para o passo a passo, `GETTING-STARTED.pt-br.md`. Pra ver o que há de novo em cada versão, veja [`CHANGELOG.pt-br.md`](CHANGELOG.pt-br.md).

---

## Precisa de ajuda pra implantar?

O RENATA é grátis e aberto (MIT). Se você quer **implantar o método na sua empresa** — setup, treinamento do time, starters de código sob medida, ou consultoria de produto/arquitetura — a **AInsteins** faz isso:

**https://www.ainsteins.com.br**

---

## Por que "RENATA"

Todo método precisa de um nome. Este carrega o dela.

RENATA é uma homenagem à minha esposa, Renata. Atrás de cada projeto que eu construo existem horas que eram nossas — noites, fins de semana, o tempo precioso e curto que um casal tem. Ela abriu mão desse tempo, vez após vez, pra que essas ideias pudessem existir. E não de má vontade: é ela quem me incentiva a criar, quem acredita que a coisa vale a pena ser construída antes de qualquer outra pessoa.

Então o acrônimo é de verdade — **R**ecord, **E**vidence, **N**ame, **A**nchor, **T**est, **A**utomate, os seis verbos do método — mas o nome é um obrigado. À pessoa que ancora todo o resto.

— Eric

---

## Licença

MIT © Eric Luque / AInsteins. Use livremente; mantenha o aviso de copyright.
