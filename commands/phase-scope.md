# /phase-scope — Define o escopo realista de uma fase usando MoSCoW

Você é um tech lead pragmático. Recebe a **lista de capacidades candidatas** de uma fase e o **orçamento de tempo** disponível, e produz o escopo realista com **MoSCoW completo** + corte explícito.

## Quando usar

- Antes de iniciar uma fase do roadmap, para validar que o escopo cabe no tempo.
- Quando uma fase já está rodando e ficou claro que o escopo não cabe — re-scope.
- Para conversar com stakeholder sobre o que cortar quando tempo não dá.

**Diferença em relação a outros comandos:**

- `/feature-breakdown`: define o **produto** inteiro (binário MUST / OUT-OF-SCOPE).
- `/phase-scope` (este): define o que cabe em **uma fase específica** com orçamento fixo (MoSCoW completo).
- `/triage`: prioriza **trabalho contínuo** dentro de uma fase já em andamento (bugs, débitos).

## Antes de gerar

1. Leia `@CLAUDE.md` e `@docs/prd/` (entender fase ativa e hipótese).
2. Leia `@docs/features/README.md` (features que entram na fase).
3. Leia `@docs/roadmap/fase-<N>.md` (gate da fase + tarefas listadas).
4. Pergunte UMA por vez:

   - **Qual fase está escopando?** (Fase 0, 1, 2...)
   - **Lista de capacidades candidatas:** items que querem entrar na fase. Pode vir do `fase-N.md` ou ser nova.
   - **Orçamento de tempo:** duração realista (XS/S/M/L/XL ou semanas).
   - **Gate da fase:** quais critérios são objetivos pro gate?
   - **Restrições externas:** dependência de cliente, prazo de demo, etc?

## Como classificar (regras claras)

### 🔴 MUST nesta fase

**Sem isso, o gate da fase cai.** Não é "importante", é **gate-blocking**.

Sinais:
- Critério explícito do gate.
- Dependência de outro MUST.
- Risco técnico não validado (precisa entrar pra fase fazer sentido).

### 🟠 SHOULD nesta fase

**Desejável e provável de fazer; cabe se MUSTs forem mais rápidos que estimado.**

Sinais:
- Capacidade que destrava velocidade da próxima fase.
- Documentação ou tooling que economiza tempo recorrente.
- Polimento de UX que evita rework imediato.

### 🟡 COULD nesta fase

**Só se sobrar tempo absurdamente.**

Sinais:
- Refinamento de algo que já está OK.
- Métrica adicional não-crítica.
- "Seria legal mostrar na demo".

### ⚫ WON'T nesta fase (vai para próxima)

**Conscientemente adiado. Vira refinamento de fase posterior.**

Sinais:
- Capacidade que melhora algo já funcional.
- Generalização que serve casos não-existentes ainda.
- "Quando virar relevante."

## Regras de qualidade

- ❌ Soma de MUST > orçamento → **cortar escopo da fase OU expandir prazo**. Não enganar a si mesmo.
- ❌ Sem WON'T explícito → suspeito. Toda fase real tem coisa boa que fica de fora.
- ❌ MUST sem amarração ao **gate** → não é MUST, é desejo. Aponte qual critério do gate quebra sem ele.
- ❌ Esforço estimado em "horas" sem t-shirt → exija t-shirt (XS/S/M/L/XL). Horas trazem falsa precisão.
- ❌ Estimativa total ≥ 90% do orçamento → folga zero. Inflar 20% obrigatório (incertezas, debug, retro).

## Estrutura de saída

Atualiza `docs/roadmap/fase-<N>-<nome>.md` (seção "Tarefas") ou cria `docs/roadmap/fase-<N>-scope.md` separado:

```markdown
# Scope · Fase {{N}} — {{Nome}}

> **Duração estimada:** {{XS/S/M/L/XL}}
> **Orçamento (folga 20% incluída):** {{tempo total}}
> **Gate:** {{1 linha resumindo o gate da fase}}

---

## 🔴 MUST ({{N}} items, esforço total: {{soma}})

> Sem qualquer um destes, gate da fase cai.

| # | Item | Quebra qual critério do gate | Esforço | Depende de |
|---|------|------------------------------|---------|------------|
| 1 | {{capacidade}} | {{critério específico}} | M | — |
| 2 | ... | ... | S | #1 |

## 🟠 SHOULD ({{N}}, esforço: {{soma}})

> Cabe se MUSTs vierem rápido. Não bloqueia gate.

| # | Item | Por que SHOULD | Esforço | Depende de |
|---|------|----------------|---------|------------|
| ... | ... | ... | ... | ... |

## 🟡 COULD ({{N}}, esforço: {{soma}})

> Só se sobrar tempo absurdo. Aceitamos não fazer.

| # | Item | Por que COULD | Esforço |
|---|------|---------------|---------|
| ... | ... | ... | ... |

## ⚫ WON'T (Fase {{N}}) — vai para Fase {{N+1}} ou backlog

> Conscientemente fora desta fase.

| # | Item | Por que adiado | Vai para |
|---|------|----------------|----------|
| ... | ... | ... | Fase {{N+1}} / backlog |

---

## Cálculo de orçamento

- **MUST:** {{soma}}
- **SHOULD:** {{soma}}
- **COULD:** {{soma}}
- **Total realista (MUST + SHOULD):** {{soma}}
- **Orçamento disponível:** {{tempo}}
- **Folga (20%):** {{tempo}}

**Veredito:** ✅ cabe / 🟡 apertado (cortar 1-2 SHOULDs) / ❌ não cabe (cortar MUST ou expandir prazo)

## Riscos do escopo definido

- {{risco se MUST X demorar mais que estimado}}
- {{dependência crítica entre items}}

## Plano de corte (se prazo apertar)

Ordem de sacrifício ao chegar nos 80% do orçamento:

1. Cortar COULD {{lista}}.
2. Cortar SHOULD {{lista}} — começando pelos de menor impacto.
3. Se ainda apertar: revisitar MUSTs com `@architect` (se algum MUST pode virar "MVP do MUST" mais simples).

## Decisão final

- ✅ **Aprovado para executar:** sim/não.
- **Próximo passo:** Para o próximo passo verificado contra os pré-requisitos, rode /status.
```

## Após gerar

- Grave em `docs/roadmap/fase-<N>-scope.md` (ou anexa em `fase-<N>-<nome>.md`).
- Se veredito for ❌, alerte explicitamente: "Esta fase **não cabe** no orçamento. Decisão: ou cortar escopo (sugiro mover X, Y pra Fase N+1) ou expandir prazo (precisa de mais Z dias)."
- Se houver SHOULD/COULD que dependem de MUST de outra fase, alerte.
- Sugira próximo passo:
  - Se ✅: Para o próximo passo verificado contra os pré-requisitos, rode /status.
  - Se 🟡: cortar 1-2 SHOULDs e regerar.
  - Se ❌: re-conversar com stakeholder sobre escopo/prazo antes de seguir.

## Argumentos

`$ARGUMENTS`: número/nome da fase (ex: "0", "Fase 0 Spike"). Se omitido, infere da fase ativa em `CLAUDE.md`.
