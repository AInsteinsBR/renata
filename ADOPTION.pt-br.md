# Adotando o RENATA em um projeto existente (brownfield)

> 🇬🇧 [English version](ADOPTION.md)

> Você já tem uma base de código — talvez meses ou anos dela — e quer o método por cima: tech specs, ADRs, um PRD, o mapa completo. Este guia cobre esse caminho. Ele substitui a antiga "Etapa 0.5 — Retrofit" do tutorial.

---

## Projeto novo ou projeto existente?

- **Novo (greenfield):** este guia não é pra você. Siga o [`GETTING-STARTED.pt-br.md`](GETTING-STARTED.pt-br.md) a partir da Etapa 0 — `/renata:init`, depois `/renata:prd`.
- **Existente (brownfield):** continue lendo. Um único comando orquestra a adoção inteira: `/renata:adopt`.
- **Só quer a camada técnica** (ADRs + doc de code-pattern de um starter/repo, sem docs de produto)? Pule o adopt e rode `/renata:extract-pattern <path>` direto — veja a [sub-etapa 6.7 do tutorial](GETTING-STARTED.pt-br.md#67-opcional-destilar-o-padrão-de-um-boilerplaterepo).

---

## O comando único: `/renata:adopt`

`/renata:adopt` faz engenharia reversa da sua base de código em artefatos RENATA, **estágio por estágio, confirmando cada item com você**. A regra do começo ao fim: *o código é a verdade, o humano valida item por item.* Ele nunca escreve código, nunca "conserta" o seu padrão e nunca marca nada como verificado — esse trabalho é seu, via `/renata:status`.

| Estágio | O que ele gera | O que você confirma |
|---|---|---|
| 0 · Pre-flight | Scaffold via `/renata:init` se estiver faltando; detecta escopos de código | A lista de escopos (`frontend/`, `backend/`, `src/`…) |
| 1 · Padrão técnico | ADRs + `code-pattern-<scope>.md` + `rules.yaml` (compõe com `/renata:extract-pattern` por escopo) | Cada item do padrão, um a um ("possível gambiarra — vira regra?") |
| 2 · Contexto técnico | `stack.md` + `arquitetura.md` (C4 níveis 1-2) | Os diagramas C4 e as fronteiras inferidas |
| 3 · Inventário de features | `docs/features/README.md` — 3-9 features user-facing encontradas em rotas/telas/módulos | Cada feature: manter / renomear / fundir / descartar |
| 4 · PRD retroativo | `docs/prd/<slug>.md` — a aposta que o código incorpora, inferida e confirmada seção por seção | Problema, rascunho de persona, hipótese, escopo, métrica candidata |
| 5 · Specs as-built | `docs/features/F<N>-<slug>.md` para as features **selecionadas** (âncora ⚓ + o que você vai mexer em seguida) | A seleção, depois cada spec |
| 6 · Encerramento | `CLAUDE.md` atualizado + o mapa de artefatos abaixo + ponteiros pro que ele NÃO criou | — |

Todo artefato gerado carrega uma **marca de proveniência as-built** logo abaixo do título:

```markdown
> 🏗️ As-built — reverse-engineered from code by /renata:adopt on <date>. Verify with /renata:status.
```

Essa marca significa: conteúdo real, nascido do código, **ainda não verificado por um humano**. Nos termos do `/renata:status`, a etapa está 🔄 — você mesmo verifica e carimba o ✅.

---

## Onde cada artefato mora

O mapa que responde "onde ficam as tech specs?":

| Artefato | Onde mora | Criado por | Verificado via `/renata:status` |
|---|---|---|---|
| PRD retroativo | `docs/prd/<slug>.md` | adopt Estágio 4 (ou `/renata:prd`) | Etapa 2 |
| Inventário de features (índice, âncora ⚓) | `docs/features/README.md` | adopt Estágio 3 (ou `/renata:feature-breakdown`) | Etapa 7 |
| Feature specs (as-built) | `docs/features/F<N>-<slug>.md` | adopt Estágio 5 (ou `/renata:feature-spec`) | Etapa 8 |
| Code pattern — "como o código faz" | `docs/technical-context/code-pattern-<scope>.md` | `/renata:extract-pattern` (adopt Estágio 1) | — |
| Stack | `docs/technical-context/stack.md` | adopt Estágio 2 | Etapa 10 |
| Arquitetura (C4) | `docs/technical-context/arquitetura.md` | adopt Estágio 2 | Etapa 10 |
| ADRs — "por que decidimos" | `docs/decisions/ADR-NNN-<slug>.md` | `/renata:extract-pattern` / `/renata:adr` | Etapa 6 |
| Enforcement das ADRs | `.claude/rules.yaml` | `/renata:extract-pattern` / `/renata:adr` | — |
| Personas / jornada / métricas | `docs/business-context/*.md` | **NÃO gerados pelo adopt** → `/renata:persona`, `/renata:user-journey`, `/renata:metrics` | Etapas 3-5 |
| Mapa de progresso | `.claude/progress-map.yaml` | `/renata:init` | — |

> **"Tech spec" no RENATA são duas coisas diferentes.** A spec de uma *feature* (o que ela faz, critério de pronto, plano em fases) mora em `docs/features/F<N>-<slug>.md`. A spec do *padrão* (como o código faz as coisas: estrutura, stack, convenções) mora em `docs/technical-context/code-pattern-<scope>.md`, governada por ADRs em `docs/decisions/`. `/renata:adopt` gera as duas.

---

## Antes de rodar

1. **Instale o plugin** (uma vez): `/plugin marketplace add AInsteinsBR/renata` + `/plugin install renata@ainsteins`.
2. **Tenha git** no projeto — rode `git init` antes se precisar. O hook de enforcement das ADRs só ativa com git (o adopt te avisa, mas fazer antes evita uma segunda passada).
3. Só isso. Você NÃO precisa rodar `/renata:init` antes — o pre-flight do adopt roda por você se o scaffold estiver faltando. (Se você rodou `/renata:init` num diretório com código, ele detecta o brownfield e aponta pra cá.)

Depois, no diretório do projeto:

```text
/renata:adopt
```

ou, nomeando os escopos você mesmo:

```text
/renata:adopt frontend/ backend/
```

---

## Como é uma rodada (condensado)

```text
/renata:adopt

Estágio 0 · Scaffold encontrado: ausente → rodando o fluxo do /renata:init… feito.
           Escopos detectados: src/ (Node/Express). Confirma? → você: sim

Estágio 1 · @pattern-mapper varreu src/. 14 itens em 4 eixos.
           "Express + Prisma (forte, visto em 12 arquivos)" → você: confirmo
           "SQL cru em reports.ts (fraco — possível gambiarra?)" → você: não é regra
           → ADR-001..004 escritas, code-pattern-src.md escrito, rules.yaml atualizado.

Estágio 2 · stack.md + arquitetura.md (C4 L1-L2) rascunhados → você revisa os diagramas: ok.

Estágio 3 · Encontradas 3 features: auth (routes/auth.ts), CRUD de tarefas (routes/tasks.ts),
           export CSV (routes/export.ts). Manter/renomear/fundir? → você: manter todas
           → docs/features/README.md escrito (tudo MUST, hipótese TBD).

Estágio 4 · Rascunho de PRD a partir do README + inventário. Problema (palpite — confirme):
           "freelancers perdem horas faturáveis com controle de tarefas"… → você corrige
           seção por seção → docs/prd/taskflow.md escrito; âncora ⚓ marcada no CRUD de tarefas.

Estágio 5 · Spec agora pra: ⚓ CRUD de tarefas + export (você vai mexer nele em seguida)? → você: sim
           → F1-task-crud.md, F3-csv-export.md escritos (as-built).

Estágio 6 · ✓ RENATA adotado. Todo artefato está 🔄 — rode /renata:status.
```

Todo artefato acima nasceu com a marca as-built e **sem** a linha `> ✅ Verified by you` — essa linha só você adiciona, pelo gate do status.

---

## Depois do adopt: lendo o `/renata:status`

Logo depois de uma rodada completa, o mapa fica assim:

- **🔄 Etapas 1, 2, 6, 7, 8, 10** — scaffold, PRD, ADRs, features, specs, arquitetura: os artefatos existem (as-built) e aguardam a sua verificação. Verifique **na ordem dos pré-requisitos** (o status aponta o caminho): 1 → 2 → 6 → 7 → 8 → 10.
- **⬜ Etapas 3, 4, 5** — personas, jornada, métricas: o adopt NÃO inventa isso; o código não revela quem é a persona nem qual número importa. Rode `/renata:persona`, `/renata:user-journey`, `/renata:metrics` — é aqui que os baselines `TODO(measure)` do PRD retroativo ficam reais.
- **⬜ Etapas 7.5, 9, 11+** — faseamento, roadmap, planos: em brownfield você planeja a **próxima** fase, não o passado. Quando tiver trabalho novo, continue o fluxo normal (`/renata:phase-roadmap` → `/renata:feature-spec` → `/renata:plan-phase` → `/renata:execute`).

---

## Projetos com ADRs pré-existentes

Se você já tinha ADRs antes de adotar:

- o adopt (e o extract-pattern dentro dele) entra em **modo refinar** — ele nunca as sobrescreve.
- Se o `.claude/rules.yaml` foi populado **fora** do fluxo do `/renata:adr` (manualmente, ou ficou vazio), isso é dívida técnica: o YAML perdeu a amarração com a ADR. Para cada ADR existente que tem enforcement no hook, rode:

```text
/renata:adr refinar ADR-001 — re-validar enforcement no rules.yaml
```

O `/renata:adr` em modo refinar lê a ADR, valida o bloco YAML correspondente e completa o que falta com a sua confirmação.

---

## FAQ

**Onde moram as tech specs?**
Feature specs: `docs/features/F<N>-<slug>.md`. Padrão/stack/arquitetura: `docs/technical-context/`. Decisões: `docs/decisions/`. Mapa completo em ["Onde cada artefato mora"](#onde-cada-artefato-mora) acima.

**O adopt sobrescreve meu README, código ou docs existentes?**
Não. Ele nunca toca em código, e artefatos RENATA pré-existentes (PRD, ADRs, specs) o colocam em modo refinar. A cópia do scaffold do `/renata:init` pergunta antes de sobrescrever o `CLAUDE.md`.

**Posso rodar de novo?**
Sim. Re-rodar detecta o que já existe e refina em vez de recriar — útil pra adotar um escopo agora (`/renata:adopt frontend/`) e outro depois.

**Preciso fazer spec de toda feature?**
Não — e isso é deliberado. O inventário cobre 100% das features; specs completas só pra âncora + o que você está prestes a mexer. O resto: `/renata:feature-spec F<N>` sob demanda, logo antes de trabalhar nela.

**Meu projeto legado já tem um método próprio estabelecido. Devo adotar?**
Provavelmente não — veja o Apêndice A do [`REFERENCE.pt-br.md`](REFERENCE.pt-br.md). A adoção é pra bases de código *sem* um método que funcione.
