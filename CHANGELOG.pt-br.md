# Changelog

> 🇬🇧 [English version](CHANGELOG.md)

Todas as mudanças notáveis do RENATA estão documentadas aqui. Formato baseado em [Keep a Changelog](https://keepachangelog.com); versionamento segue [SemVer](https://semver.org).

## [Unreleased]

_Nada ainda._

## [0.1.6] — 2026-06-25

**O que há de novo:** pesquisa competitiva que acha seus gaps de diferenciação.

### Adicionado
- `/renata:landscape` — pesquisa competitiva pós-PRD: mapeia soluções similares ancorado no PRD (MCP do Perplexity se disponível, senão busca web nativa; fontes obrigatórias), salva tudo pra você ler, depois cura junto com você pra achar os gaps de diferenciação que viram features candidatas.
- Nova capacidade de integração `research` (fonte de busca web pro landscape).

## [0.1.5] — 2026-06-25

**O que há de novo:** a etapa de ideação antes do PRD — pra quando você ainda não sabe o que quer.

### Adicionado
- `/renata:discovery` — Etapa 0 do método: converge uma intuição vaga num problema claro com 5 porquês + JTBD + por que agora, ensinando cada framework enquanto conduz. Força 2-3 enquadramentos antes de convergir, e semeia pistas pra persona/jornada/métricas.

### Mudado
- `/renata:prd` lê o doc de discovery como ponto de partida (e sugere rodar o discovery quando você chega sem clareza).
- `/renata:persona`, `/renata:user-journey`, `/renata:metrics` leem suas "sementes" do discovery como ponto de partida.

## [0.1.4] — 2026-06-12

**O que há de novo:** uma camada de comportamento opcional entre o breakdown e a spec técnica — nascida de feedback de uso real.

### Adicionado
- `/renata:feature-behavior` — refina a feature como comportamento observável (user stories + Gherkin + regras de negócio + aceite), com zero técnico. O handoff limpo Produto→Engenharia.

### Mudado
- `/renata:feature-spec` consome a spec de comportamento quando existe (linka pra ela, sem duplicar).

## [0.1.3] — 2026-06-12

**O que há de novo:** o RENATA fica internacional.

### Mudado
- Conteúdo dos 22 comandos, 6 agentes e 3 skills traduzido pro inglês; cada comando ganha uma `description` em inglês no menu `/`. (O idioma do arquivo não força o idioma da conversa — o RENATA continua respondendo no idioma do usuário.)

## [0.1.2] — 2026-06-12

**O que há de novo:** nomes de comando mais limpos.

### Mudado
- Comandos são invocados com o prefixo `/renata:` (namespace do plugin).
- `renata-init` renomeado pra `init` → `/renata:init` (sem "renata" duplicado).

## [0.1.1] — 2026-06-12

### Corrigido
- Formato do `hooks.json` (faltava o wrapper `hooks` no topo) que impedia os hooks do plugin de carregar.

## [0.1.0] — 2026-06-12

**O que há de novo:** o RENATA nasce — um método de produto que amarra persona → métrica → ADR → código, empacotado como plugin do Claude Code.

### Adicionado
- 21 comandos (planejamento, design, validação, desenvolvimento, navegação) + o scaffold `/renata:init`.
- 6 agentes, 3 skills auto-ativáveis, hooks (gate de etapa, bloqueio de commit que viola ADR).
- Docs bilíngues (EN + PT-BR): README, METHOD, GETTING-STARTED. MIT © Eric Luque / AInsteins.
