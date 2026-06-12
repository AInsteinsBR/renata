# /renata:init — Inicializa um projeto novo com a estrutura RENATA

Você inicializa o projeto atual com o scaffold do RENATA: CLAUDE.md, estrutura de `docs/`, e `.claude/` (progress-map + rules). Opcionalmente clona um starter de frontend. Recebe o nome do projeto em `$ARGUMENTS`.

## Quando usar

- Logo após instalar o plugin RENATA, num diretório de projeto novo (vazio ou com código inicial).
- Para "renata-ificar" um projeto existente que ainda não tem a estrutura.

## Passos

### 1. Resolver argumentos
- `$ARGUMENTS` = nome do projeto (ex: "TaskFlow"). Se vazio, pergunte.
- Detectar flag opcional `--starter <URL>` no `$ARGUMENTS`.

### 2. Copiar o scaffold pro projeto atual
Use Bash para copiar o template do plugin pro diretório atual, incluindo dotfiles:
```bash
cp -R "${CLAUDE_PLUGIN_ROOT}/template/." .
```
Isso traz `CLAUDE.md.template`, `.claude/progress-map.yaml`, `.claude/rules.yaml.template` e a árvore `docs/`.

### 3. Materializar os arquivos de template
- Renomeie `CLAUDE.md.template` → `CLAUDE.md`.
- Renomeie `.claude/rules.yaml.template` → `.claude/rules.yaml`.
- No `CLAUDE.md`, preencha o `{{PROJECT_NAME}}` da Seção 1 com o nome recebido. Deixe os demais `{{...}}` (são preenchidos nas etapas seguintes via `/renata:prd`, `/renata:persona`, etc.).

### 4. Ativar o enforcement de ADR no commit (se há git)
Se o diretório tem `.git/` (rode `test -d .git`):
```bash
# Liga o bloqueio de commits que violam ADR (rules-violation), de fábrica:
chmod +x "${CLAUDE_PLUGIN_ROOT}/hooks/scripts/rules-violation.sh"
ln -sf "${CLAUDE_PLUGIN_ROOT}/hooks/scripts/rules-violation.sh" .git/hooks/pre-commit
```
Se NÃO há git: avise que o enforcement de ADR será ativado quando o projeto tiver git, e que basta re-rodar `/renata:init` ou criar o symlink acima manualmente.

### 5. (Opcional) Starter de frontend
Se veio `--starter <URL>`:
```bash
git clone <URL> frontend
rm -rf frontend/.git
```
Depois materialize `docs/decisions/ADR-001-frontend-starter.md` documentando que o frontend herda o starter (Contexto, Decisão, Alternativas, Trade-offs, Gatilho de revisão), e adicione ao índice `docs/decisions/README.md`.

### 6. Próximos passos
Imprima o roteiro inicial apontando os comandos do plugin:
```text
✓ Projeto RENATA inicializado.
Próximos passos:
  - Etapa 2: /renata:prd <ideia>
  - Etapa 3: /renata:persona <nome>
  - Etapa 4: /renata:user-journey <persona>
  - Etapa 5: /renata:metrics
  - Etapa 6: /renata:adr (decisões estruturais)
  - Rode /renata:status a qualquer momento pra ver onde está.
```

## Regras de qualidade
- ❌ Sobrescrever um CLAUDE.md já existente sem avisar → pergunte antes.
- ❌ Criar o symlink de pre-commit sem checar `.git/` → cheque primeiro.

## Argumentos

`$ARGUMENTS`: nome do projeto + flag opcional `--starter <URL>`.
