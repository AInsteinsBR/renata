# /renata:execute — Orquestra a Etapa 12 (executar plano) respeitando o método

Você é um tech lead conduzindo a execução de uma fase. Este command é o **espelho de saída** do `/renata:plan-phase`: assim como `/renata:plan-phase` não deixa *começar* sem os 10 pré-requisitos, o `/renata:execute` não deixa *fechar* uma task sem verificação.

Ele orquestra `superpowers:executing-plans` com os guardrails do RENATA, amarrando as skills/agents no momento certo de cada task. Sozinho, o `executing-plans` não conhece nosso método nem nosso gate de pronto.

## Quando usar

- Para executar uma fase do roadmap que já tem plano aprovado pelo `@architect` (saída da Etapa 11 / `/renata:plan-phase`).

**NÃO use** para:

- Gerar o plano → `/renata:plan-phase`.
- Investigação técnica → `/renata:spike`.
- Decisão estrutural → `/renata:adr`.

## Passo 1 — Pré-flight (validação de pré-requisitos)

Valide os 4 itens abaixo, listando o resultado de cada um. Se algum falhar, **aborte** e instrua a correção.

| # | Pré-requisito | Como validar | Falha → |
|---|---|---|---|
| 1 | Existe plano aprovado em `docs/superpowers/specs/` | `ls docs/superpowers/specs/*-plan.md` retorna ≥1 e CLAUDE.md Seção 5 aponta pra ele | "Rode `/renata:plan-phase <fase>` antes." |
| 2 | Plano sem bloqueadores 🔴 abertos do `@architect` | `grep -c "🔴" docs/superpowers/specs/<plano>` — confirmar que os 🔴 estão marcados como resolvidos | "Resolva os bloqueadores do `@architect` antes." |
| 3 | Não há outro plano `running` sobreposto da mesma fase | só 1 plano da fase com `Status: running` | "Termine ou abandone o plano anterior antes." |
| 4 | `rules.yaml` válido | `bash .claude/hooks/rules-violation.sh` roda sem erro fatal | "Rode `/renata:adr` em modo refine pra popular `rules.yaml`." |

## Passo 2 — Carregar contexto de execução (antes do primeiro Edit/Write)

Antes de tocar em qualquer arquivo de código:

1. Invoque a skill `respecting-adrs` (valida proposta contra ADRs aceitas).
2. Leia: o plano ativo, `CLAUDE.md`, a feature-spec da fase em `docs/features/`.

> Este passo cobre na prática a candidata `retrieving-context-before-coding` (ver `_framework/SKILL-CANDIDATES.md`) SEM criar a skill — o command força a leitura. Se a fricção de "começou a codar sem ler contexto" aparecer mesmo assim em uso real, aí promova a candidata a skill.

## Passo 3 — Loop de execução por task

Para CADA task do plano, nesta ordem:

1. **TDD:** invoque `superpowers:test-driven-development` — escreva o teste que falha (red) ANTES do código.
2. **Código:** implemente o mínimo pra passar (green).
3. **Review:** invoque `@code-reviewer` no diff da task. Resolva bloqueadores 🔴 antes de seguir.
4. **GATE DE PRONTO:** invoque `superpowers:verification-before-completion`. NÃO marque a task como `[x]` sem:
   - teste em verde (rodar e confirmar output, não assumir);
   - hook `rules-violation.sh` não-bloqueando.
   - **Granularidade:** o gate por-task cobre os dois primeiros critérios do princípio 4 (teste passa + hook não bloqueia). O terceiro (métrica observável) é nível de fase, validado no Passo 4 — não exija métrica observável a cada `[x]`.
5. **Scope-creep:** se a task revelou capacidade fora da feature-spec, a skill `detecting-scope-creep` deve ativar — pause e decida (ampliar spec via `/renata:feature-spec` ou cortar) antes de continuar.

### Quando aparecer bug

Invoque `superpowers:systematic-debugging` ANTES de propor fix (não chute).

<!-- TODO: quando a candidata `ai-pipeline-debugging` for promovida (ver SKILL-CANDIDATES.md), complementar este gancho para pipelines de IA (latência, GPU OOM, drift áudio-vídeo). -->

## Passo 4 — Fim de fase

Quando todas as tasks do plano estão `[x]`:

1. Invoque `@qa-tester` — valida contra critério de aceite do PRD/feature-spec (validação independente, age como a persona-âncora). Resolva bloqueadores antes de declarar a fase pronta.
2. Invoque a skill `keeping-docs-alive` — atualiza CLAUDE.md Seção 5, `.claude/sessions/` e os checkboxes do plano.
3. Sugira `/renata:retro <fase>`. Se a fase entregou feature mensurável, sugira também `/renata:hypothesis-check`.

## Argumentos

`$ARGUMENTS`: número/nome da fase a executar (ex: `0`, `Fase 0 Spike`). Se omitido, infere da fase ativa em `CLAUDE.md`.

## Regras de qualidade

- ❌ Pré-flight falhou → recusar iniciar execução.
- ❌ Marcar task `[x]` sem passar pelo gate de pronto (Passo 3.4) → recusar.
- ❌ Declarar fase pronta sem `@qa-tester` (Passo 4.1) → recusar.

## O que este command NÃO faz

- ❌ Não substitui `superpowers:executing-plans` — o invoca/complementa (igual `/renata:plan-phase` faz com `writing-plans`).
- ❌ Não decide arquitetura (isso é `@architect` via `/renata:adr`).
- ❌ Não roda testes via hook automático — o gate de pronto é a skill `verification-before-completion`, não um hook. Se a skill se mostrar fraca no uso real, promova a hook.
