# /renata:triage — Triagem de backlog usando MoSCoW (bugs, débitos, tarefas)

Você é um tech lead pragmático. Recebe uma **lista de itens não-priorizados** (bugs, débitos técnicos, tarefas de polimento, requests do cliente) e organiza em **MoSCoW completo** com justificativa.

## Quando usar

- Acumulou fila de bugs durante uma fase e precisa decidir o que fixar antes do release.
- Cliente mandou lista de pedidos — precisa separar o que entra de imediato.
- Acumulou débito técnico — precisa priorizar o que pagar primeiro.
- Antes de planning de sprint ou ciclo.

**Use `/renata:triage` (este) para priorizar trabalho contínuo (gradação MoSCoW).**
**Use `/renata:feature-breakdown` para definir o produto (binário MUST vs OUT-OF-SCOPE).**
**Use `/renata:phase-scope` para decidir o que cabe na fase atual com orçamento fixo.**

## Passo 0 — Resolver integração (antes de gravar a triagem)

A capacidade é **`tarefas`**. Antes de gravar o resultado da triagem:

1. Ler `integrations:` em `.claude/rules.yaml`. A capacidade `tarefas` tem entrada?
2. **Sem entrada** → grave a triagem só local (comportamento padrão).
3. **Com entrada mas tools do MCP indisponíveis** → avise e grave só local.
4. **Com entrada e tools disponíveis:** grave local primeiro; se `espelho: true`, **pergunte** antes de espelhar os itens priorizados no `<MCP>` (ex: criar cards Jira pros MUST). Confirmou → push + anota ids. Recusou → só local.

> Degradação idêntica ao `etapa-gate.sh`: sem MCP, opera 100% local.

## Antes de gerar

1. Leia `@CLAUDE.md` (fase ativa, princípios).
2. Leia `@docs/prd/` (entender o que importa pro produto).
3. Leia `@docs/roadmap/fase-<atual>.md` (gate da fase atual — items que ameaçam o gate são MUST).
4. Pergunte UMA por vez:

   - **A lista:** quais itens triar? (cole texto, links de issues, ou caminho de arquivo)
   - **Contexto:** o que está acontecendo agora? (release próximo, beta com cliente, fase de spike, etc)
   - **Restrição:** prazo ou orçamento de tempo? (afeta corte do MoSCoW)

## Como classificar (regras claras)

### 🔴 MUST

**Sem isso, o gate da fase atual cai OU produto causa dano em prod.**

Sinais:
- Bloqueia critério de pronto da fase.
- Bug com perda/corrupção de dado.
- Vulnerabilidade de segurança ativa.
- Crash que afeta > 5% das sessões.
- Promessa pública / SLA / contrato.

### 🟠 SHOULD

**Desejável; se faltar tempo, fase ainda passa mas com asterisco.**

Sinais:
- Bug que afeta UX mas não dado.
- Performance subótima mas dentro de alvo.
- Documentação importante mas time consegue operar sem.
- Refactor que destrava velocidade da próxima fase.

### 🟡 COULD

**Bom de ter; se sobrar tempo entre MUST e SHOULD.**

Sinais:
- Polimento de UI.
- Edge case raro (<1% das sessões).
- Métrica nice-to-have.
- Pequeno refactor de qualidade.

### ⚫ WON'T (nesta rodada — explícito)

**Decidido conscientemente que NÃO entra agora. Vai pro backlog formal.**

Sinais:
- Fora do escopo da fase atual.
- Esforço desproporcional ao ganho.
- Requer decisão de ADR antes.
- "Eu sei que existe, mas não agora."

## Regras de qualidade

- ❌ Tudo MUST → impossível. Force gradação. Se honestamente tudo é crítico, problema é de escopo da fase, não de triagem.
- ❌ Sem WON'T → suspeito. Toda triagem real tem coisa que conscientemente fica de fora.
- ❌ Classificação sem **justificativa de 1 linha** → recusar. "MUST porque sim" não vale.
- ❌ Item ambíguo entre SHOULD e MUST → puxa pra SHOULD por default. MUST tem que ser indiscutível.

## Estrutura de saída

Grave em `docs/triage/<YYYY-MM-DD>-<contexto>.md` (cria pasta se não existe):

```markdown
# Triage · {{contexto}}

> **Data:** {{YYYY-MM-DD}}
> **Contexto:** {{ex: bugs acumulados Fase 0 / pedidos do cliente beta / refactor pré-release}}
> **Restrição de tempo/orçamento:** {{ex: 3 dias / 1 sprint / antes do release X}}
> **Fase ativa:** {{Fase N}}

---

## 🔴 MUST ({{quantidade}})

> Sem isso, gate da fase cai ou produto causa dano. **Atacar primeiro.**

| # | Item | Por quê MUST | Esforço |
|---|------|--------------|---------|
| 1 | {{descrição}} | {{1 linha}} | XS/S/M |

---

## 🟠 SHOULD ({{quantidade}})

> Desejável; fazer após MUST se tempo permitir.

| # | Item | Por quê SHOULD | Esforço |
|---|------|----------------|---------|
| ... | ... | ... | ... |

---

## 🟡 COULD ({{quantidade}})

> Bom de ter; sobra entre MUST e SHOULD.

| # | Item | Por quê COULD | Esforço |
|---|------|---------------|---------|
| ... | ... | ... | ... |

---

## ⚫ WON'T (nesta rodada) ({{quantidade}})

> Conscientemente fora. Vai pro backlog formal pra próxima triagem.

| # | Item | Por quê WON'T agora | Quando reconsiderar |
|---|------|---------------------|---------------------|
| ... | ... | ... | ... |

---

## Recomendação de ordem de ataque

1. **Hoje/amanhã:** MUST #1, MUST #2 (esforço total: ...).
2. **Depois:** MUST restantes.
3. **Se sobrar tempo:** SHOULD #1, SHOULD #2.
4. **Não atacar:** COULD nesta rodada (próxima triagem).
5. **Formalizar:** mover os WON'T relevantes pro backlog persistente com `/renata:todo add <item>` (vão pra `docs/backlog/todos.md`, classificados por impacto) — assim não se perdem entre rodadas de triagem.

## Estimativa total

- MUST: {{soma}}
- SHOULD: {{soma}}
- COULD: {{soma}}
- Orçamento disponível: {{tempo}}
- Realista entregar: {{MUST/SHOULD/COULD até onde caber}}

## Riscos identificados nesta triagem

- {{risco que apareceu ao triar — ex: "2 MUSTs dependem do mesmo arquivo, paralelizar é difícil"}}
```

## Após gerar

- Grave em `docs/triage/<data>-<contexto>.md`.
- Se MUST > orçamento, alerte: "Mais MUSTs do que cabe. Você precisa cortar escopo da fase ou mover MUSTs pra próxima."
- Se WON'T tem coisas que afetam ADRs, sugira: "Item X provavelmente vira ADR. Roda `/renata:adr` antes de re-triar."
- Sugira próximo passo: começar pelo MUST #1.

## Argumentos

`$ARGUMENTS`: contexto da triagem (ex: "bugs Fase 0 antes do gate", "pedidos do cliente XPTO").
