# /adr — Formaliza uma ADR a partir de uma decisão

Você é um arquiteto sênior. Recebe a descrição de uma decisão técnica em `$ARGUMENTS` e formaliza no padrão Nygard, gravando em `docs/decisions/ADR-NNN-<slug>.md`.

**Atribuição clara antes de começar:**

- O **arquivo de ADR** (`docs/decisions/ADR-NNN-*.md`) é **conteúdo do projeto** — você escreve aqui.
- O **`.claude/rules.yaml`** também é **conteúdo do projeto** — quando o enforcement da ADR é via hook automatizado, você **adiciona o bloco YAML diretamente nele**, não apenas sugere.
- O **template** (`_framework/template/.claude/rules.yaml.template`) é do framework — não toque.

ADR e seu bloco em `rules.yaml` são **gêmeos**: nascem juntos, vivem juntos, mudam juntos.

## Modo de operação: criar vs refinar

Antes de qualquer pergunta, identifique o modo:

- **Modo CRIAR** (default): `$ARGUMENTS` descreve uma decisão nova → próximo número livre, ADR do zero.
- **Modo REFINAR**: `$ARGUMENTS` contém "refinar ADR-NNN" ou similar → carregue a ADR existente, valide cada seção, complete lacunas, e sincronize com `rules.yaml`.
- **Modo ADOTAR-MCP** (variação do CRIAR): `$ARGUMENTS` descreve adotar um MCP pra uma capacidade (ex: "usar Jira pra tarefas"). Além da ADR Nygard normal, você **escreve a entrada correspondente no bloco `integrations:` do `.claude/rules.yaml`**:
  - Forma: `<capacidade>: { mcp: <nome-no-.mcp.json>, adr: ADR-NNN, espelho: <true|false> }`.
  - Capacidades canônicas: `tarefas`, `pr`, `db` (extensível).
  - `espelho: true` quando o MCP recebe escrita espelhada após confirmação; `false` quando é só leitura/ação.
  - A ADR e a entrada em `integrations:` são **gêmeas** (mesmo princípio do bloco `adrs:`): nascem juntas, somem juntas se a ADR vira superseded.
  - Confirme o `<nome-no-.mcp.json>` com o usuário (precisa bater com o servidor declarado no `.mcp.json`).

Use `/adr refinar ADR-NNN ...` quando:

- ADR já existe mas foi escrita fora do fluxo `/adr` (típico em projetos retrofitados — o `rules.yaml` pode estar vazio ou desincronizado).
- ADR tem placeholders, alternativas faltando, ou enforcement ainda não declarado.
- Decisão evoluiu e precisa de revisão.

No modo refinar, **não cria nova ADR** — atualiza a existente preservando histórico.

## Antes de gerar

1. **Modo CRIAR:** Liste ADRs existentes em `docs/decisions/` e use o próximo número livre.
   **Modo REFINAR:** Localize o arquivo `docs/decisions/ADR-NNN-*.md` mencionado. Se não existir, aborte com aviso.
2. Leia `@CLAUDE.md` para conhecer o contexto do produto:
   - Se identidade já preenchida, use de contexto.
   - Se ainda só placeholders, peça primeiro `/prd` (decisão estrutural sem produto definido é prematura).
3. Leia `@docs/decisions/_template.md` para o padrão Nygard.
4. Leia `@.claude/rules.yaml` para conhecer a estrutura atual (se já existe). Você vai precisar dele depois.
5. **Modo REFINAR**: leia a ADR existente e identifique lacunas — quais seções estão completas? Qual está faltando? Há bloco correspondente em `rules.yaml`? Pergunte apenas o que falta.
   **Modo CRIAR**: Pergunte UMA pergunta por vez:

   - **Contexto:** que situação **agora** força essa decisão? (não "o quê", mas o "por quê")
   - **Alternativas consideradas:** liste TODAS, mesmo as rejeitadas em segundos.
   - **Por que cada alternativa foi rejeitada?** (motivo concreto, não "não gostei")
   - **Trade-offs aceitos:** o que abre mão ao escolher esta?
   - **Gatilho de revisão:** sob que condição esta ADR deve ser reaberta?
   - **Enforcement:** este é o passo crítico. Pergunte explicitamente qual dos mecanismos abaixo se aplica (pode ser mais de um):
     - **Hook declarativo** (`.claude/rules.yaml`) — se a violação pode ser detectada por regex/grep no código (ex: `import lib_proibida`, "query SQL sem tenant_id").
     - **Lint custom no CI** — se exige AST ou análise mais complexa que o hook não cobre.
     - **Review checklist** — se exige julgamento humano.
     - **Teste** — se pode ser validado por suite de testes automáticos.

## Regras de qualidade

- ❌ "Escolhemos X porque é bom" → exija amarração a restrição (persona, incidente, métrica).
- ❌ Sem 2 alternativas consideradas → exija.
- ❌ Sem gatilho de revisão → exija. Decisão sem condição de reabrir é fé religiosa.
- ❌ Sem enforcement quando possível → sugira mecanismo concreto.
- ❌ Enforcement marcado como "hook" mas usuário não passou pattern regex → exija o pattern antes de gravar.

## Estrutura do arquivo ADR

Use o template em `docs/decisions/_template.md`. Preencha **TODAS** as seções. Sem placeholder vazio.

## Após gerar a ADR (3 passos obrigatórios)

### Passo 1 — Gravar/atualizar o arquivo da ADR

- **Modo CRIAR:** grave `docs/decisions/ADR-NNN-<slug>.md` com Nygard completo.
- **Modo REFINAR:** atualize o arquivo existente preservando histórico. Se mudou status (ex: `proposed → accepted`), registre a data da mudança.

### Passo 2 — Atualizar `docs/decisions/README.md`

- **Modo CRIAR:** adicione linha no índice:

  ```markdown
  | NNN | [Título](./ADR-NNN-slug.md) | accepted |
  ```

- **Modo REFINAR:** atualize a linha existente apenas se status mudou.

### Passo 3 — Se enforcement inclui **hook**, atualize `.claude/rules.yaml` DIRETAMENTE

Não apenas sugira o bloco — **escreva nele**. Procedimento:

**Modo REFINAR:** primeiro verifique se já existe bloco `id: ADR-NNN` no `rules.yaml`:

- Se existe e está correto, anuncie ("rules.yaml já tem o bloco correto para ADR-NNN, nada a mudar") e pule pro Passo 4.
- Se existe mas precisa atualizar (pattern, scope ou mensagem mudaram), mostre o **diff** e peça confirmação.
- Se não existe, siga o fluxo normal abaixo (mostra → confirma → adiciona).

**Modo CRIAR ou bloco ausente em REFINAR:**

1. **Mostre ao usuário** o bloco YAML que você vai adicionar:

   ```yaml
   - id: ADR-NNN
     title: "{{título conciso}}"
     enforce:
       - kind: forbid_pattern   # ou require_pattern
         pattern: "{{regex}}"
         scope: "{{path}}"      # opcional
         exclude: "{{path}}"    # opcional
         message: "{{mensagem ao desenvolvedor que violar}}"
   ```

2. **Peça confirmação** em uma frase: "Vou adicionar este bloco ao final de `.claude/rules.yaml`. OK?"

3. Após `OK`, edite `.claude/rules.yaml` apendando o novo bloco dentro da chave `adrs:`. Se o arquivo ainda não tem chave `adrs:`, crie-a.

4. Rode `bash .claude/hooks/rules-violation.sh` em modo de validação (sem commit) para confirmar que o YAML está válido e o hook reconhece a nova regra.

5. Se o hook reclamar (YAML inválido, pattern não compila), reverte o append e reporta. **Não deixe o `rules.yaml` quebrado.**

### Passo 4 — Se enforcement inclui **lint/test/checklist**, registre como ação pendente

- Se for lint custom: anote no fim do arquivo da ADR a regra de lint a criar (path do script, regex, etc).
- Se for teste: anote o nome do teste a criar.
- Se for review checklist: sugira o item a adicionar no template de PR.

Essas ações não são automatizadas pelo hook — vão para a próxima fase de implementação como tarefa.

## Argumentos

`$ARGUMENTS`: descrição em 1-2 linhas da decisão (ex: "usar Postgres como banco principal").
