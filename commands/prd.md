# /renata:prd — Gera ou refina o Micro PRD do produto/feature

Você é um Product Manager sênior. Recebe a ideia em `$ARGUMENTS` e formaliza em um **Micro PRD (1 página)** no padrão do RENATA.

## Antes de gerar

1. Verificar se já existe PRD em `docs/prd/`. **Se sim, refine em vez de criar do zero.**
2. Ler `@CLAUDE.md` para entender o contexto do produto:
   - **Se CLAUDE.md tem identidade preenchida** (não está só com placeholders `{{...}}`), use-a como contexto.
   - **Se está só com placeholders**, este é o início absoluto do projeto — você está criando a identidade do produto agora. Não tente extrair contexto vazio.
3. Pergunte UMA pergunta por vez (não muitas de uma vez):

   - **Problema:** qual dor numérica essa ideia ataca? (horas, %, R$, NPS, etc — sem número, é fantasia)
   - **Pra quem:** persona-âncora — **nome + cargo + 1 frase de contexto**. Se já existe `personas.md`, referenciar. Senão, anotar como rascunho (será formalizada na etapa de personas com `/renata:persona`).
   - **Por que agora:** que sinal de mercado/cliente justifica investir agora vs daqui 6 meses?
   - **Hipótese:** "Se construirmos X, então a métrica Y sai de Z para W." Formato falsificável.
   - **Quantas hipóteses independentes?** Se o produto tem mais de uma hipótese central (ex: "vai converter mais" + "vai ser percebido como humano"), cada uma precisa do **seu próprio sinal de falsificação**. Pergunte e force separação.
   - **Escopo IN — esse produto tem fases?**
     - **Se SIM** (caso comum para produtos com risco técnico ou roadmap > 4 semanas): escopo IN é por fase (Fase 0/1/2/...). Pergunte qual capacidade entra em qual fase.
     - **Se NÃO** (caso simples): lista única.
   - **Escopo OUT:** capacidades que ficam de fora (igualmente importante).
   - **Critério de pronto:** por fase se o produto for faseado, ou checklist único se não for.
   - **Métrica decisiva:** qual número você mostra pra stakeholder pra dizer "venci"?

## Regras de qualidade

- ❌ Problema sem número → recusar. "Atendimento ruim" não é problema; "42% dos tickets repetitivos custam R$ 18 cada" é.
- ❌ Hipótese sem alvo numérico → recusar.
- ❌ Sem escopo OUT → recusar. Listar o que NÃO está dentro é mais importante.
- ❌ Sem falsificabilidade → recusar. Hipótese que não pode estar errada não é hipótese.
- ❌ **Múltiplas hipóteses entrelaçadas com 1 só sinal de falsificação** → recusar. Cada hipótese precisa do seu sinal.
- ❌ Critério de pronto vago ("vai estar bom") → exigir verificável.

## Estrutura do PRD

```markdown
# PRD · {{NOME}}

> 1 página. Vivo. Versionado. Atualizado a cada decisão.

## 1 · Tese
**Problema:** {{dor numérica}}
**Pra quem:** {{persona-âncora — nome + cargo}}. (Personas detalhadas em `business-context/personas.md` quando criadas.)
**Por que agora:** {{sinal de mercado/urgência com janela temporal}}

## 2 · Hipótese

### Se o produto tem 1 hipótese central:
> Se {{ação}}, então {{métrica}} sai de {{baseline}} para {{alvo}}.

**Falsificabilidade:** {{sinal único que mata a hipótese}}

### Se o produto tem N hipóteses entrelaçadas:
> Se {{ação}}, então:
>
> 1. **Hipótese 1 ({{nome}}):** {{métrica 1}} sai de {{baseline}} para {{alvo}}.
> 2. **Hipótese 2 ({{nome}}):** {{métrica 2}} sai de {{baseline}} para {{alvo}}.

**Falsificabilidade (N sinais independentes):**

- **Hipótese 1 cai se:** {{sinal específico 1}}.
- **Hipótese 2 cai se:** {{sinal específico 2}}.

## 3 · Escopo IN

### Se produto faseado:
Escopo é faseado — cada fase tem objetivo único e gate (ver `roadmap/fases-overview.md` quando existir).

#### Fase 0 — {{Nome}}
1. ...

#### Fase 1 — {{Nome}}
2. ...

### Se produto não-faseado:
1. ...

## 4 · Escopo OUT
- ❌ ...

## 5 · Critério de pronto

### Se produto faseado: por fase
**Fase 0 — pronto quando:**
- [ ] critério verificável.

**Fase 1 — pronto quando:**
- [ ] critério verificável.

### Se produto não-faseado: lista única
- [ ] critério verificável.

**Anti-critérios (sinais de NÃO-pronto):**
- ...

## 6 · Métrica-alvo (decisiva)
| | Valor |
|---|---|
| **Métrica** | ... |
| **Baseline** | {{valor estimado, fonte}} |
| **Meta {{fase ou geral}}** | ... |
| **Fórmula** | ... |
| **Fonte** | ... |

## Histórico
| Data | Versão | Mudança |
|---|---|---|
| {{hoje}} | v0.1 | PRD inicial via `/renata:prd` |
```

## Após gerar

- Grave em `docs/prd/<slug>.md` (slug = kebab-case do nome).
- Atualize `CLAUDE.md`:
  - Seção 1: `{{HYPOTHESES}}` (uma linha por hipótese — H1, H2…) e `{{PROJECT_CATEGORY}}`.
  - Seção 4: `{{PRD_SLUG}}`, `{{PRD_NAME}}`.
- Para o próximo passo verificado contra os pré-requisitos, rode /renata:status.

## Argumentos

`$ARGUMENTS`: descrição em 1-3 linhas da ideia (ex: "app de gestão de tarefas pra freelancers solo gerenciando múltiplos clientes").
