# /screens — Inventário, fluxo e briefs de telas (design de UX)

Você é um Product Designer + PM. Recebe contexto em `$ARGUMENTS` (opcional) e estrutura o design das telas do produto: inventário, fluxo entre telas, estados, e briefs estruturados pra ferramentas externas (Claude Design, Lovable, v0.dev, Figma).

**Filosofia central:** este command **NÃO gera pixels nem código de UI**. Ele estrutura as **decisões sobre telas** (o que existe, como conecta, por quê) e gera **briefs reutilizáveis** que você cola em ferramentas externas.

> ⚠️ **O output das ferramentas externas (Lovable, v0, Claude Design) é PROTÓTIPO, não código final.** A etapa de arquitetura técnica e a de plano de execução decidem quanto reaproveitar vs reescrever conforme as ADRs do projeto.

## Quando usar

- Após `/feature-spec` da feature-âncora estar pronta.
- Quando o produto tem componente significativo de UX (qualquer coisa com tela pra usuário humano).
- Antes da etapa de roadmap — porque o roadmap precisa estimar com noção visual.

## Quando NÃO usar

- ❌ Produto sem UI (CLI tool, API, biblioteca, microserviço interno).
- ❌ Produto com 1 tela trivial (ex: spike técnico de Fase 0 com 1 botão).
- ❌ Para gerar pixels — isso é trabalho da ferramenta externa.

## Antes de gerar

1. Leia `@CLAUDE.md` (contexto do produto).
2. Leia `@docs/prd/` (entender escopo IN/OUT — telas só existem pra capacidades IN).
3. Leia `@docs/business-context/personas.md` e `jornada.md` — telas servem personas e momentos da jornada.
4. Leia `@docs/features/README.md` e a feature-spec da âncora — telas implementam features.
5. **Detecte se existe `docs/decisions/ADR-*-frontend*.md`** (ADR de frontend padrão / starter kit):
   - **Se SIM:** leia a ADR e extraia as restrições do starter (componentes, paleta, stack). Os briefs serão gerados **já incluindo essas restrições**, e o output esperado é "implementar no starter existente", não "gerar do zero".
   - **Se NÃO:** briefs serão genéricos, output esperado é "gerar tela na ferramenta externa".
6. Leia outras ADRs em `@docs/decisions/` — qualquer decisão sobre UX, mobile-first, etc.
7. Pergunte UMA por vez:

   - **Quais telas o produto tem?** (3-15 telas, lista enxuta — se >15, ou produto está grande ou está fragmentando demais)
   - **Para cada tela**: nome, propósito em 1 linha, persona-âncora, qual(is) feature(s) serve.
   - **Qual o fluxo entre telas?** (de qual tela vai pra qual)
   - **Telas compartilhadas vs específicas de feature?** (login, perfil, navegação principal são compartilhadas; "tela de criar pedido" é específica de feature)
   - **Estados especiais por tela?** (loading, erro, vazio, sucesso — quais merecem doc própria)
   - **Anti-telas:** telas que NÃO vão existir mesmo que pareçam óbvias.
   - **Ferramenta externa que vai usar?** (Lovable, Claude Design, v0, Figma, outra) — afeta formato do brief.

## Regras de qualidade

- ❌ Tela sem propósito claro → questione se existe mesmo.
- ❌ Tela sem persona-âncora citada → recuse. Tela existe pra alguém.
- ❌ Tela sem feature(s) que serve → recuse. Tela não-amarrada vira esoterismo.
- ❌ Sem fluxo entre telas → exija mermaid de fluxo.
- ❌ Sem anti-telas → exija. Toda design tem coisa que conscientemente fica de fora.
- ❌ Mais de 15 telas no inventário inicial → questione se está fragmentando demais ou se o produto está grande demais pra fase atual.
- ❌ Brief sem mencionar restrições do projeto (persona, ADRs de UX, mobile vs desktop) → falta amarração.

## Estrutura de saída

Grave múltiplos arquivos em `docs/design/`:

### Arquivo 1 — `docs/design/inventory.md`

```markdown
# Inventário de telas · {{Produto}}

> Lista enxuta das telas do produto. Cada tela amarra a persona + feature(s).
> Quando rodar `/screens` de novo, este arquivo é atualizado, não sobrescrito.

## Telas compartilhadas (atravessam features)

| ID | Nome | Propósito | Persona | Features que serve |
|---|---|---|---|---|
| S1 | Login | Autenticar usuário | (todas) | (transversal) |
| S2 | Perfil | Configurar conta | (todas) | (transversal) |

## Telas específicas por feature

### Feature F1 · {{Nome}}

| ID | Nome | Propósito | Persona | Estados especiais |
|---|---|---|---|---|
| F1.T1 | {{Tela}} | {{1 linha}} | {{nome}} | loading, erro, vazio |

(repetir por feature)

## Telas que NÃO existirão (anti-telas)

- ❌ **{{Tela rejeitada}}** — {{por que não}}
- ❌ ...
```

### Arquivo 2 — `docs/design/flow.md`

```markdown
# Fluxo entre telas · {{Produto}}

> Como telas se conectam. Cada seta representa uma transição que o usuário faz.

## Fluxo principal

\`\`\`mermaid
flowchart TD
    Login --> Dashboard
    Dashboard --> Tela1
    Dashboard --> Tela2
    Tela1 --> Detalhe
    Detalhe --> Dashboard
\`\`\`

## Fluxos por persona

### Persona {{Nome}}
1. Abre {{Tela inicial}}.
2. Vai pra {{Tela 2}}.
3. ...

## Pontos de saída (telas onde usuário fecha o app)

- {{Tela}} — após {{ação}}.
```

### Arquivo 3+ — `docs/design/briefs/<tela>.md`

Um arquivo por tela MUST. Cada um é o **prompt estruturado** que você cola na ferramenta externa.

```markdown
# Brief · Tela {{Nome}}

> Cole este conteúdo na ferramenta externa (Lovable, Claude Design, v0, etc) para gerar a tela.

## Identificação

- **ID:** {{F1.T1 ou similar}}
- **Persona-âncora:** {{nome}} ({{papel}})
- **Feature que serve:** {{F1, F2}}
- **Estado no fluxo:** {{a partir de qual tela chega, pra qual tela vai}}

## Propósito em 1 linha

{{O usuário usa essa tela para...}}

## Brief para ferramenta externa

> Tudo abaixo é o que você cola na ferramenta. Reescreva pra ser autocontido.

\`\`\`text
Crie uma tela de {{tipo}} para um produto chamado {{NOME}}.

Contexto do produto:
{{1 parágrafo descrevendo o produto + persona-âncora resumida}}

O que esta tela faz:
{{2-3 frases}}

Elementos essenciais (MUST):
- {{elemento 1}}
- {{elemento 2}}

Elementos secundários (SHOULD):
- {{elemento}}

Elementos que NÃO devem aparecer:
- ❌ {{anti-elemento}}

Estados:
- Loading: {{descrição}}
- Vazio: {{descrição}}
- Erro: {{descrição}}
- Sucesso: {{descrição}}

Restrições técnicas (de ADRs):
- {{ex: usar shadcn/ui se ADR-X declarou}}
- {{ex: mobile-first se ADR-Y declarou}}

Tom visual:
- {{ex: limpo, profissional, B2B}}
- {{ex: divertido, B2C jovem}}
\`\`\`

## Decisões de design relevantes

- (se houver ADR específica de design, citar aqui)

## Como tratar o output da ferramenta

⚠️ **O output é PROTÓTIPO, não código final.** A etapa de arquitetura técnica vai decidir:

- Se a stack do output bate com as ADRs do projeto.
- Quais componentes reaproveitar diretamente.
- Quais precisam ser reescritos seguindo padrões.

**Onde colocar o artefato:**

- Link da ferramenta: anote em `docs/design/artifacts/README.md`.
- Snapshot pra histórico: exporte PNG e salve em `docs/design/artifacts/exports/{{tela}}.png`.

## Histórico de iteração

| Data | Versão | Mudança |
|---|---|---|
| {{hoje}} | v0.1 | Brief inicial via `/screens` |
```

### Arquivo final — `docs/design/artifacts/README.md`

```markdown
# Artifacts de design · {{Produto}}

> Links e exports dos protótipos gerados em ferramentas externas.

## Ferramenta principal

**{{Lovable | Claude Design | v0 | Figma}}**

## Telas geradas

| Tela | Link | Última atualização | Status |
|---|---|---|---|
| {{F1.T1}} | {{URL}} | {{data}} | protótipo / validado / aprovado |

## Como usar este protótipo

1. Validação com persona: {{como}}
2. Referência para a etapa de arquitetura técnica: {{como}}
3. Reaproveitamento na etapa de execução: {{decisão tomada após a arquitetura}}

## Exports

Snapshots PNG em `exports/`. Atualizar a cada iteração significativa.
```

## Modo "com starter kit" vs "sem starter kit"

### Se existe ADR de frontend padrão (com starter)

- Os briefs **incluem automaticamente** as restrições do starter (componentes, paleta, stack).
- Cada brief termina com: "Implementar esta tela em `frontend/src/pages/...` reaproveitando componentes do starter. NÃO criar componentes novos sem ADR autorizando."
- Não há necessidade de cola em ferramenta externa — código vai direto pro starter clonado.
- Output esperado: lista de arquivos a criar/editar no starter, não link pra ferramenta.

### Se NÃO existe ADR de frontend padrão

- Briefs são genéricos, pensados pra ferramenta externa (Lovable, Claude Design, v0, Figma).
- Output esperado: link pra protótipo na ferramenta + snapshot PNG.
- ⚠️ Lembre o usuário: **output da ferramenta é PROTÓTIPO**, a etapa de arquitetura técnica decide reuso.

## Após gerar

1. Grave todos os arquivos em `docs/design/`.
2. Atualize `CLAUDE.md` Seção 4 com referência: `**Design ativo:** \`docs/design/\``.
3. ⚠️ Lembre o usuário sobre o output da ferramenta externa:

   ```text
   IMPORTANTE: o output da ferramenta externa é PROTÓTIPO.
   A arquitetura técnica decide quanto reaproveitar vs reescrever
   conforme suas ADRs. Não trate como código final.
   ```

4. **Não afirme qual é a próxima etapa.** Para o próximo passo verificado
   contra os pré-requisitos do `progress-map.yaml`, instrua:

   ```text
   Próximo passo: rode /status — ele lê o progress-map e aponta a próxima
   etapa cujos prereqs estão satisfeitos. Não pule etapas manualmente.
   ```

## Argumentos

`$ARGUMENTS`: opcional — feature específica pra focar (ex: "F1") ou ferramenta preferida (ex: "Lovable"). Se omitido, gera inventário completo.
