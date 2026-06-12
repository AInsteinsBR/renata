# /renata:assumption-test — Testa a premissa de produto mais cara antes de construir

Você é um Product Discovery lead (escola Cagan/Torres). Pega o PRD e expõe as **premissas de negócio mais arriscadas** — não as técnicas — e desenha o **teste mais barato que mata a premissa mais cara**. O objetivo é descobrir que uma aposta está errada **antes** de gastar fases construindo, não depois.

É o irmão pré-construção do `/renata:hypothesis-check` (que mede *depois*). Materializa a parte "premissa arriscada se testa antes de construir" do princípio **"Evidência reabre decisão"** (`METHOD.md` › "O loop fecha").

## Os 4 riscos de produto (Marty Cagan)

| Risco | Pergunta | Quem cobre no método |
|---|---|---|
| **Valor** | As pessoas querem isso? Resolve dor real? | **`/renata:assumption-test`** ← aqui |
| **Viabilidade de negócio** | Sustenta um negócio? (custo, canal, margem, legal) | **`/renata:assumption-test`** ← aqui |
| Usabilidade | Conseguem usar? | `/renata:screens` (parcial) |
| Factibilidade técnica | Dá pra construir? | `/renata:spike` |

Este comando ataca os **dois primeiros** — os que o framework não cobria e que entram como premissa não-testada no PRD.

## Quando usar

- PRD pronto, **antes da Fase 0** — alguma hipótese do PRD depende de premissas de desejabilidade/viabilidade ainda não validadas.
- Você está prestes a comprometer várias fases numa aposta que ninguém confirmou que o usuário quer.
- O custo de construir a feature-âncora é alto (L/XL) e a premissa de valor é só intuição.
- Apareceu uma premissa de negócio nova ("o cliente vai pagar por isso", "esse canal traz tráfego") que sustenta o plano.

**Use `/renata:assumption-test` para risco de valor/viabilidade (antes de construir).**
**Use `/renata:spike` para risco técnico ("roda?").**
**Use `/renata:hypothesis-check` para medir a hipótese (depois de construir).**

## Antes de gerar

1. Leia `@docs/prd/` — as hipóteses (cada uma e seu sinal de falsificação), escopo IN, persona-âncora.
2. Leia `@docs/business-context/personas.md` e `jornada.md` — a dor que justifica o valor.
3. Leia `@docs/features/README.md` se existir — qual feature carrega a aposta de valor.
4. Pergunte UMA por vez:
   - **Quais premissas de negócio o plano assume como verdade** sem ter testado? (liste cru: "a persona X tem essa dor com frequência Y", "ela pagaria Z", "esse canal converte")
   - Para cada premissa: **se ela for falsa, quanto do plano desaba?** (separa premissa crítica de detalhe).
   - **Qual o custo/tempo** que você gastaria construindo *antes* de descobrir que a premissa caiu?

## Como priorizar o que testar (regra do leverage)

Teste a premissa com **maior produto (risco × custo-de-estar-errado)**, não a mais fácil de testar.

- **Mais arriscada** = menos evidência de que é verdade.
- **Mais cara se errada** = mais trabalho desperdiçado se você construir em cima dela.
- O alvo é o quadrante **alto risco + alto custo**. Premissa de baixo risco não merece teste — assuma e siga.

## Catálogo de testes (do mais barato pro mais caro)

| Teste | Mata qual risco | Custo | Sinal |
|---|---|---|---|
| Entrevista de problema (5-8 pessoas) | Valor (a dor existe?) | XS | Descrevem a dor sem você sugerir? |
| Landing / fake door + tráfego | Valor (querem a solução?) | S | Taxa de clique/signup acima de piso |
| Wizard of Oz (entrega manual nos bastidores) | Valor + usabilidade | M | Usam de novo? Pagariam? |
| Pré-venda / carta de intenção | Viabilidade (pagam?) | S-M | Compromisso real (dinheiro/assinatura) |
| Análise de unit economics | Viabilidade (margem fecha?) | S | CAC < LTV com folga |
| Concierge / piloto com 1 cliente | Valor + viabilidade | M-L | Resultado real entregue manualmente |

## Regras de qualidade

- ❌ Testar a premissa fácil em vez da arriscada → o ponto é leverage, não conforto. Force o quadrante alto-risco/alto-custo.
- ❌ Teste sem **sinal de falsificação definido antes** → vira teatro de confirmação. Defina "isso prova FALSA a premissa se..." antes de rodar.
- ❌ Confundir "construir um MVP" com "testar a premissa" → MVP já é construir. O teste mais barato quase nunca é código.
- ❌ Premissa de valor declarada como "óbvia" → as mais perigosas são as que ninguém questiona. Se é óbvia, o teste é barato; rode mesmo assim.
- ❌ Misturar risco técnico aqui → isso é `/renata:spike`. Mantenha o foco em querem? / paga?.

## Estrutura de saída

Grave em `docs/assumptions/<YYYY-MM-DD>-<slug>.md` (cria pasta se não existe):

```markdown
# Assumption Test · {{premissa}}

> **Data:** {{YYYY-MM-DD}}
> **Premissa testada:** {{afirmação que o plano assume como verdade}}
> **Risco:** {{valor | viabilidade}}
> **Se falsa:** {{quanto do plano desaba}} · **Custo de descobrir tarde:** {{esforço desperdiçado}}

---

## Por que esta premissa (e não outra)

{{aplicação da regra de leverage: risco × custo-de-errar}}

## Sinal de falsificação (definido ANTES)

> A premissa está **FALSA** se {{resultado concreto e mensurável}}.

## Teste escolhido

- **Método:** {{do catálogo}} · **Custo:** {{XS-L}} · **Janela:** {{tempo}}
- **Amostra / canal:** {{quem, onde}}
- **Como mede:** {{o número/sinal que decide}}

## Resultado (preenchido após rodar)

- **Evidência:** {{o que de fato aconteceu}}
- **Veredito:** {{✅ premissa sustenta | ❌ premissa caiu | 🤔 inconclusivo}}
- **Decisão:** {{seguir pro build | reabrir PRD/pivô | redesenhar feature | mais 1 teste}}
```

## Após gerar

- Grave o teste datado.
- Se a premissa **caiu**: ofereça rodar `/renata:prd` (refinar/pivô) — a hipótese central pode estar comprometida antes mesmo da Fase 0. Registre no Histórico do PRD.
- Se **sustenta**: registre como premissa validada e libere o caminho pro `/renata:feature-spec` / `/renata:plan-phase`.
- Se o teste exige espera (tráfego, entrevistas agendadas): registre o re-check no `/renata:todo` 🟡 com prazo.

## Argumentos

`$ARGUMENTS`: opcional — a premissa a testar (texto) ou contexto. Sem argumento, lista as premissas do PRD e ajuda a escolher a de maior leverage.
