<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/AInsteinsBR/renata/main/assets/logoRenata-dark.svg">
    <img src="assets/logoRenata.svg" alt="RENATA" width="560">
  </picture>
</p>

<p align="center">
  <sub>by</sub>&nbsp;&nbsp;<picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/AInsteinsBR/renata/main/assets/ainsteins-logo-dark.png">
    <img src="assets/ainsteins-logo.png" alt="AInsteins" height="22" valign="middle">
  </picture>
</p>

<p align="center">
  <a href="https://www.claudepluginhub.com/plugins/ainsteinsbr-renata?ref=badge"><img src="https://www.claudepluginhub.com/badge/ainsteinsbr-renata" alt="Listed on ClaudePluginHub"></a>
</p>

> 🇬🇧 [English version](README.md)

> **R**ecord · **E**vidence · **N**ame · **A**nchor · **T**est · **A**utomate — registre, meça, nomeie, ancore, teste, automatize.

**RENATA** é um método de produto que amarra **persona → métrica → ADR → código**, materializado como plugin do Claude Code. Tira você de "tenho uma ideia" até "código rodando" sem perder o porquê de cada decisão no caminho.

> Criado por **Eric Luque** · **AInsteins** — https://www.ainsteins.com.br

## Por que o RENATA existe

O RENATA vive numa interseção que ninguém mais ocupa:

1. **Frameworks de produto** (Cagan, Torres, Lean) ensinam a decidir o que construir — mas param na fronteira do código. A decisão vira slide; o código nasce órfão do porquê.
2. **Ferramentas de AI coding / vibe-coding** geram código rápido — mas sem método: sem persona, sem métrica, sem decisão registrada. Velocidade acumulando juros.
3. **O RENATA é a ponte, com enforcement:** o método de produto vai *até dentro* do código — a ADR bloqueia o commit que a viola, o hook cobra o gate, a hipótese volta pra ser falsificada. O porquê sobrevive à implementação.

**Pra quem é:** founder solo ou time pequeno PM+dev construindo com IA, que quer rigor de produto sem ter uma organização de produto.
**O que NÃO é:** não é gestão de projeto (não substitui o Scrum/kanban do time), não é gerador de código, não é curso de produto — é o método entre a sua ideia e o código que a IA escreve.

---

## Instalação

```text
/plugin marketplace add AInsteinsBR/renata
/plugin install renata@ainsteins
```

> **Dependência declarada:** `/renata:plan-phase` (Etapa 11) e `/renata:execute` (Etapa 12) embrulham as skills `writing-plans` / `executing-plans` do plugin [`superpowers`](https://github.com/obra/superpowers) — que **não** vem junto com o RENATA. Instale-o também: `/plugin marketplace add obra/superpowers` + `/plugin install superpowers@superpowers-marketplace`. Os dois comandos checam a presença dele no pre-flight e abortam com instrução se estiver faltando. Tooling recomendado pro enforcement completo dos hooks: `jq` (ou `python3`) pro gate de etapa, `yq` pras regras de ADR (`brew install jq yq`).

## Começar um projeto

```text
/renata:init "Meu Produto"
```

Primeiro checa as dependências da máquina (`yq`, `jq`/`python3`, `git`) e oferece instalar o que faltar; depois cria `CLAUDE.md`, `docs/` e `.claude/` no projeto, e ativa o enforcement de ADR no commit (se há git). Depois siga o `GETTING-STARTED.pt-br.md`.

## Projeto existente?

```text
/renata:adopt
```

Já tem código? O `/renata:adopt` faz engenharia reversa do padrão técnico (ADRs + docs de code-pattern), do inventário de features, das specs as-built e de um PRD retroativo — confirmando cada item com você. Guia: [`ADOPTION.pt-br.md`](ADOPTION.pt-br.md).

## O que vem no plugin

- **33 comandos** — planejamento (`/renata:discovery`, `/renata:prd`, `/renata:persona`, `/renata:user-journey`, `/renata:metrics`, `/renata:adr`, `/renata:landscape`, `/renata:feature-breakdown`, `/renata:feature-behavior`, `/renata:phase-roadmap`, `/renata:roadmap-gates`, `/renata:architecture`, `/renata:feature-spec`), design (`/renata:screens`), validação (`/renata:assumption-test`, `/renata:interview-kit`, `/renata:interview-debrief`, `/renata:hypothesis-check`), desenvolvimento (`/renata:plan-phase`, `/renata:execute`, `/renata:spike`, `/renata:phase-scope`, `/renata:triage`, `/renata:todo`, `/renata:refactor`, `/renata:retro`, `/renata:extract-pattern`), pós-produção (`/renata:bug-report`, `/renata:incident`), navegação (`/renata:status`, `/renata:next`), e o scaffold (`/renata:init`, `/renata:adopt`).
- **6 agentes** — `@architect`, `@code-reviewer`, `@qa-tester`, `@perf-auditor`, `@security-reviewer`, `@pattern-mapper`.
- **3 skills auto-ativáveis** — `respecting-adrs`, `keeping-docs-alive`, `detecting-scope-creep`.
- **Hooks** — gate de etapas, status na sessão, enforcement de ADR no commit.

Para a filosofia, veja `METHOD.pt-br.md`. Para o passo a passo, `GETTING-STARTED.pt-br.md`. Pra adotar o método numa base de código existente, `ADOPTION.pt-br.md`. Pros apêndices/cheatsheet, `REFERENCE.pt-br.md`. Pra ver o que há de novo em cada versão, veja [`CHANGELOG.pt-br.md`](CHANGELOG.pt-br.md).

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
