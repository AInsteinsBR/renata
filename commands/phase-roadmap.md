# /phase-roadmap — Distribui TODAS as features do sistema em fases por tempo

Você é um tech lead de planejamento macro. Recebe a lista completa de features (do
`/feature-breakdown`) e as distribui em **fases sequenciais** (Fase 0, 1, 2...) com
**tempo aproximado** por fase. **Nenhuma feature fica de fora** — o que muda é em que
fase cada uma entra. A **Fase 0 é o conjunto-âncora**: o slice vertical mínimo que já
entrega valor de ponta a ponta.

## Diferença pra /phase-scope (não confundir)

- `/phase-roadmap` (este): visão **macro** — distribui o sistema TODO em fases. Roda UMA vez,
  logo após o breakdown. Gera `docs/roadmap/fases-overview.md`.
- `/phase-scope <N>`: visão **micro** — desce numa fase específica e aplica MoSCoW +
  orçamento. Roda por fase, quando você vai executá-la.

Pipeline: `/feature-breakdown` → **`/phase-roadmap`** → `/phase-scope 0` → `/feature-spec` (por feature da Fase 0).

## Quando usar

- Logo após `/feature-breakdown` (Etapa 7.5), antes de specar qualquer feature.
- Quando o conjunto de features mudou e o faseamento precisa ser refeito.

## Antes de gerar

1. Leia `@CLAUDE.md` e `@docs/prd/` (hipótese + métrica decisiva).
2. Leia `@docs/features/README.md` (TODAS as features e suas dependências).
3. Leia `@docs/business-context/jornada.md` (a Fase 0 deve fechar ≥1 jornada-âncora de ponta a ponta).
4. Pergunte UMA por vez:
   - **Quantas fases o sistema terá?** (sugira 2-5; mais que isso, provavelmente é roadmap longo demais pra esta rodada)
   - **Tempo total disponível / horizonte?** (ex: "3 meses", "1 sprint por fase")
   - **Qual jornada a Fase 0 precisa fechar de ponta a ponta?** (define o conjunto-âncora)
   - **Restrições externas?** (demo marcada, dependência de cliente, prazo)

## Regras de qualidade

- ❌ Feature do breakdown que não aparece em NENHUMA fase → recuse. Nenhuma órfã.
- ❌ Fase 0 que não fecha uma jornada de ponta a ponta → não é âncora, é fragmento. Refaça.
- ❌ Fase que depende de feature de fase posterior → ordem inválida. Reordene por dependência.
- ❌ Fase sem tempo aproximado → exija t-shirt (XS/S/M/L/XL) ou semanas.
- ❌ Fase 0 maior que o resto somado → âncora inchada. Enxugue pro slice mínimo.

## Estrutura de saída

Grave em `docs/roadmap/fases-overview.md` um documento com esta estrutura (apresentada
abaixo como template; substitua os `{{placeholders}}`):

> `# Fases do sistema · {{Produto}}`
>
> > Todas as features distribuídas em fases por tempo. Fase 0 = conjunto-âncora
> > (slice vertical mínimo que entrega valor). Nenhuma feature fica de fora.
>
> `## Visão geral` — um diagrama Gantt mermaid com o roadmap macro:

```mermaid
gantt
    title Roadmap macro
    dateFormat  X
    section Fase 0 (âncora)
    {{Feature}}      :0, {{dur}}
    section Fase 1
    {{Feature}}      :after, {{dur}}
```

> `## Fase 0 — Conjunto-âncora · {{tempo aprox}}`
>
> > Jornada que fecha de ponta a ponta: {{jornada-âncora}}
>
> | Feature | Por que na Fase 0 | Esforço | Depende |
> |---|---|---|---|
> | F1 {{nome}} | {{fecha a jornada X}} | L | — |
> | F2 {{nome}} | {{idem}} | M | F1 |
>
> `## Fase 1 — {{nome}} · {{tempo aprox}}`
>
> | Feature | Por que nesta fase | Esforço | Depende |
> |---|---|---|---|
> | ... | ... | ... | ... |
>
> (repetir por fase)
>
> `## Conferência de cobertura`
>
> > Toda feature do breakdown aparece acima. Lista de verificação:
>
> | Feature (do README) | Fase atribuída |
> |---|---|
> | F1 | 0 |
> | F2 | 0 |
> | F3 | 1 |
> | ... | ... |
>
> `## Anti-faseamento`
>
> - ❌ {{O que conscientemente NÃO entra em nenhuma fase desta rodada}}

## Após gerar

1. Grave `docs/roadmap/fases-overview.md`.
2. Atualize `CLAUDE.md` Seção 4: `**Fase ativa:** Fase 0 (conjunto-âncora)`.
3. Para o próximo passo verificado contra os pré-requisitos, rode `/status`.

## Argumentos

`$ARGUMENTS`: opcional — horizonte de tempo (ex: "3 meses") ou número de fases desejado.
