# /renata:todo — Backlog de pendências (inline no doc + sync central)

Você gerencia o **backlog de TODOs** do projeto: pendências que não bloqueiam o trabalho atual mas precisam ser registradas. O backlog vive em `docs/backlog/todos.md`, ordenado por **impacto no andamento**.

O fluxo tem dois lados que se reconciliam:
- **Inline:** o TODO nasce colado ao contexto, na linha de origem dentro de um doc.
- **Central:** `docs/backlog/todos.md` agrega tudo numa visão única e priorizável.

## Passo 0 — Resolver integração (antes de gravar)

A capacidade desta operação é **`tarefas`**. Antes de qualquer escrita:

1. Ler `integrations:` em `.claude/rules.yaml`. A capacidade `tarefas` tem entrada?
2. **Sem entrada** → opere 100% local em `docs/backlog/todos.md` (comportamento padrão). Pule pro fluxo normal.
3. **Com entrada, mas os tools do MCP declarado NÃO estão disponíveis na sessão** → avise ("MCP `<nome>` declarado para `tarefas` mas indisponível — gravando só local") e opere local.
4. **Com entrada e tools disponíveis:**
   a. Grave PRIMEIRO no local (`docs/backlog/todos.md` + marcador inline). Local é a verdade.
   b. Se `espelho: true` → **PERGUNTE**: "Espelhar este TODO no `<MCP>` (cria/atualiza card)?". Confirmou → push via MCP, anote o id externo (ex: `JIRA-123`) ao lado do item local. Recusou → fica só local; espelha depois.
   c. Se `espelho: false` → não faz push de escrita.

> Padrão de degradação idêntico ao `etapa-gate.sh` (ferramenta ausente → avisa, nunca trava). Sem MCP, o `/renata:todo` funciona inteiro localmente.

## Quando usar

- Usou um número/dado provisório num doc (PRD, persona, métricas) e quer lembrar de validar depois — sem travar o andamento.
- Acumulou pequenas pendências espalhadas e quer uma visão central.
- Quer puxar a próxima pendência relevante pra executar.
- Fechou uma pendência e quer marcar como feita.

**Use `/renata:todo` para o registro persistente de pendências.**
**Use `/renata:triage` quando precisar priorizar uma rodada inteira em MoSCoW (os WON'T do triage podem virar entradas aqui).**

## Convenção do marcador inline

No doc de origem, na própria linha onde a pendência nasce:

```markdown
Estimamos ~10k usuários/mês. <!-- TODO[2026-05-30][🟡]: validar com dado real do analytics -->
```

Formato: `<!-- TODO[YYYY-MM-DD][impacto]: texto -->`
Impacto é um de: `🔴` (bloqueia fase) · `🟡` (não bloqueia mas importa) · `⚪` (nice-to-have).

## Modos (lê o primeiro token de `$ARGUMENTS`)

### `add <texto>` — adiciona direto ao central

Use quando o TODO **não** nasceu dentro de um doc (ideia solta, débito geral).

1. Pergunte o impacto se não estiver óbvio no texto (🔴/🟡/⚪).
2. Gere um `id` curto e estável: `t-` + 4 chars de hash do texto (ex: `t-9f3a`).
3. Adicione a linha na seção de impacto correta de `docs/backlog/todos.md`, com Origem = `(manual)`, Status = `aberto`, Criado = data de hoje.
4. Atualize o contador no título da seção (ex: `🟡 Não bloqueia mas importa (3)`).

### `sync` — varre os docs e reconcilia com o central

Este é o modo mais importante. Faça **nesta ordem**:

1. **Varra** todos os docs em busca de marcadores inline:
   ```
   grep -rn "<!-- TODO\[" docs/ CLAUDE.md
   ```
2. Para cada marcador encontrado, derive o `id` estável (hash do texto do TODO). Monte a lista "presente nos docs".
3. **Adicionar novos:** marcador no doc cujo `id` não está no central → adicione na seção de impacto correta. Origem = `arquivo.md:linha` (link clicável). Status = `aberto`.
4. **Detectar órfãos:** entrada no central com Status `aberto`/`em-andamento` cujo `id` **não** aparece mais em nenhum doc → o marcador sumiu. NÃO feche automaticamente. Mova a entrada pra seção **⚠️ Órfãos**, registrando de qual arquivo sumiu e a data de detecção.
5. **Perguntar sobre cada órfão** (um a um, ou em lista se forem muitos):
   > "O TODO `<texto>` sumiu de `<arquivo>`. Foi **resolvido** (movo pra Concluídos) ou **removido por engano** (re-insiro o marcador no doc)?"
   - Resolvido → move pra ✅ Concluídos com data de hoje.
   - Por engano → re-insira o marcador inline no doc de origem e devolva a entrada à seção de impacto.
6. **Não duplique:** id já presente e ainda no doc → não faça nada (a não ser que o texto/impacto tenha mudado; nesse caso atualize a linha existente).
7. Atualize todos os contadores das seções.
8. Reporte um resumo: `X novos · Y órfãos detectados · Z inalterados`.

### `list [filtro]` — mostra o backlog

- Sem filtro: mostra o central inteiro, seções na ordem 🔴 → 🟡 → ⚪ → ⚠️.
- `list bloqueia` / `list importa` / `list nice`: filtra por impacto.
- `list orfaos`: só os órfãos pendentes de decisão.
- Sempre destaque no topo: se há 🔴 abertos, alerte "Tem TODO marcado como bloqueia-fase aberto — isso devia estar no /renata:phase-scope, não só no backlog."

### `done <id>` — fecha um TODO

1. Encontre a entrada pelo `id`.
2. Mova pra ✅ Concluídos com data de hoje.
3. Se o TODO tinha marcador inline na origem, **remova o marcador do doc** (ou avise pra remover) — senão o próximo `sync` vai re-adicionar.
4. Atualize contadores.

## Regras de qualidade

- ❌ TODO sem impacto definido → recuse, pergunte 🔴/🟡/⚪. "Impacto no andamento" é o eixo de ordenação inteiro.
- ❌ 🔴 que mora no backlog há tempo → não é TODO, é trabalho de fase. Alerte pra mover pro `/renata:phase-scope`.
- ❌ `sync` fechando órfão sem perguntar → **proibido**. Órfão sempre passa por confirmação humana (decisão do Eric).
- ❌ Duplicar entrada que já existe → o `id` por hash existe justamente pra evitar isso. Sempre cheque antes de adicionar.
- ✅ `id` estável: mesmo texto → mesmo id, sempre. Isso é o que faz a reconciliação funcionar entre runs.

## Após qualquer modo

- Confirme em 1 linha o que mudou no `docs/backlog/todos.md`.
- Se algum 🔴 está aberto, lembre que ele compete com o gate da fase.
- Sugira próximo passo natural (ex: depois de `sync` com órfãos → resolver os órfãos; depois de `add` 🔴 → rodar `/renata:phase-scope`).

## Argumentos

`$ARGUMENTS`: `add <texto>` · `sync` · `list [filtro]` · `done <id>`. Sem argumento → assuma `list`.
