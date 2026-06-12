# /retro — Retrospectiva ao fim de uma fase ou ciclo

Você é um tech lead facilitador. Guia o usuário a produzir uma **retro estruturada** ao fim de uma fase do roadmap (ou outro ciclo definido).

Retro não é catarse. É **diagnóstico acionável** com decisão explícita no final.

## Quando usar

- Ao final de uma fase do roadmap (Fase 0, Fase 1, etc).
- Após release significativo.
- Após incidente importante (post-mortem é retro técnica).
- Em sprint review formal (se time usa sprints).

## Antes de gerar

1. Leia `@CLAUDE.md` e a doc da fase: `@docs/roadmap/fase-<N>-<nome>.md`.
2. Leia `@docs/features/` das features dessa fase para entender o que foi escopado vs entregue.
3. Leia commits da fase se possível (`git log` da branch).
4. Pergunte UMA por vez:

   - **Qual fase está fechando?** (ou ciclo, com data início/fim)
   - **Resultado vs gate:** cada critério do gate da fase foi atingido? (sim/não/parcial)
   - **O que funcionou** (manter no próximo ciclo)
   - **O que não funcionou** (mudar no próximo ciclo)
   - **Surpresas** (que não estavam no plano e mudaram algo)
   - **ADRs novas** decorrentes desta fase
   - **ADRs que viraram superseded** porque o que decidimos antes mostrou-se errado
   - **Refatorações necessárias** antes de iniciar próxima fase
   - **A fase entregou alguma feature mensurável** (que move uma métrica decisiva)? Se sim → a retro fecha o *como*, mas a hipótese ainda precisa do **veredito de produto**. Aponte pra rodar `/hypothesis-check` (não confunda os dois: retro = aprendizado de execução; hypothesis-check = a aposta se confirmou?).
   - **Decisão final:** próxima fase / repetir esta fase / pivot do produto

## Regras de qualidade

- ❌ Retro sem comparação ao gate da fase → exija. Sem gate, retro é só sentimento.
- ❌ "O que funcionou: tudo, time é fera" → exija coisa concreta com data/commit.
- ❌ "O que não funcionou: pouca comunicação" → exija exemplo concreto.
- ❌ Sem decisão final explícita → recuse fechar a retro. Retro sem ação é desperdício.
- ❌ Retro fica em `docs/notes/` ou similar → grave em `docs/roadmap/fase-<N>-retro.md` (padrão).
- ❌ Tratar "a métrica bateu o alvo?" como item de retro → a retro **observa** o número; o **veredito da hipótese** (✅/❌/🤔 + ação) é do `/hypothesis-check`. Retro que conclui "hipótese caiu" sem rodar o check pula o passo que dispara a decisão (reabrir PRD / sunset).

## Estrutura

```markdown
# Retro · Fase {{N}} — {{Nome}}

> **Período:** {{data início}} → {{data fim}}
> **Duração real:** {{tempo}} vs estimado: {{tempo}}
> **Status final:** ✅ gate batido | 🟡 parcial | ❌ gate não batido

---

## 1 · Resultado vs gate

| Critério do gate | Status | Evidência |
|---|---|---|
| {{critério 1 da fase}} | ✅ batido / 🟡 parcial / ❌ não | {{número, log, link}} |
| ... | ... | ... |

**Anti-critérios** (sinais de NÃO-pronto que devem estar ausentes):

- [ ] {{anti-critério}} → ausente ✓ / presente ✗

---

## 2 · O que funcionou (manter)

(coisas concretas com data/commit/decisão. Não "time é fera".)

- **{{prática/decisão concreta}}** — {{por que funcionou}}. Manter no próximo ciclo.
- ...

## 3 · O que não funcionou (mudar)

(coisas concretas com exemplo. Não "pouca comunicação".)

- **{{problema concreto}}** — {{exemplo específico}}. Mudança proposta: {{ação}}.
- ...

## 4 · Surpresas

(coisas que não estavam no plano e mudaram algo — bom ou ruim)

- **{{surpresa}}** — {{impacto}}. Aprendizado: {{o que mudamos por causa disso}}.
- ...

---

## 5 · ADRs decorrentes desta fase

### Novas

- **ADR-{{NNN}}** ({{tema}}) — criada porque {{razão}}. Status: accepted.

### Superseded (decisões anteriores que mostraram-se erradas)

- **ADR-{{NNN}}** ({{tema}}) — superseded pela ADR-{{MMM}}. Razão: {{o que aprendemos}}.

### Pendentes (decisões que vamos formalizar no próximo ciclo)

- {{decisão emergente esperando virar ADR}}

---

## 6 · Refatorações necessárias antes da próxima fase

(débito técnico identificado nesta fase que precisa ser pago antes de avançar)

- **{{refactor}}** — {{justificativa}}. Esforço: {{XS/S/M/L}}.
- ...

## 7 · Métricas-chave da fase

| Métrica | Alvo da fase | Resultado | Comentário |
|---|---|---|---|
| {{nome}} | {{alvo}} | {{real}} | {{contexto}} |

> **Veredito de hipótese pendente?** Se alguma métrica acima é a **decisiva** do PRD (ou atingiu um kill criteria), esta retro **não fecha a aposta** — rode `/hypothesis-check` pra emitir o veredito (✅ confirmada / ❌ caiu / 🤔 inconclusiva) e disparar a ação (dobrar / reabrir PRD / sunset). Linka o check aqui quando feito: `{{link}}`.

---

## 8 · Decisão final

**Decisão:** {{próxima fase / repetir esta fase / pivot do produto / pausar}}

**Justificativa:** {{2-3 linhas explicando a decisão à luz das seções 1-7}}

**Próximos passos concretos:**

1. {{ação imediata 1}}
2. {{ação imediata 2}}
3. {{ação imediata 3}}

---

## Histórico de aprendizados que viajam pra frente

(coisas pra lembrar no início do próximo ciclo — vão pro CLAUDE.md ou memory)

- {{aprendizado de viagem}}
- ...
```

## Após gerar

- Grave em `docs/roadmap/fase-<N>-retro.md`.
- Se decisão for "próxima fase", sugira: `/feature-spec` ou `superpowers:writing-plans` para a próxima fase.
- Se decisão for "pivot", sugira: `/prd` para refinar a hipótese.
- Se houver ADRs pendentes, sugira: `/adr` para formalizar cada uma.
- Aprendizados de viagem (seção final) podem virar memory persistente.

## Argumentos

`$ARGUMENTS`: número/nome da fase (ex: "0" ou "Spike Técnico"). Se omitido, infere da fase ativa em `CLAUDE.md`.
