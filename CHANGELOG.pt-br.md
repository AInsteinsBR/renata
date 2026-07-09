# Changelog

> 🇬🇧 [English version](CHANGELOG.md)

Todas as mudanças notáveis do RENATA estão documentadas aqui. Formato baseado em [Keep a Changelog](https://keepachangelog.com); versionamento segue [SemVer](https://semver.org).

## [Unreleased]

_Nada ainda._

## [0.1.10] — 2026-07-09

**O que há de novo:** dois comandos novos fecham o loop pós-produção — `/renata:bug-report` estrutura um único bug report recém-chegado de produção; `/renata:incident` coordena a resposta ao vivo a um incidente maior e entrega pro `/renata:retro` para o post-mortem.

### Adicionado
- `/renata:bug-report` — converte um relato bruto de produção (reclamação de cliente, ticket de suporte, bug encontrado por você) num item estruturado e classificado por severidade, com próximo passo claro (hotfix, `/renata:todo`, `/renata:triage`, ou escalar pra `/renata:incident`).
- `/renata:incident` — coordena a resposta ao vivo a um incidente de produção ativo e maior: declara, mantém uma timeline com timestamps, acompanha comunicação externa, e força um checklist de resolução antes de fechar — depois entrega pro `/renata:retro` para o post-mortem de causa raiz.
- GETTING-STARTED (en+pt): nova **Etapa 14 — Pós-produção**, cobrindo o loop transversal que começa toda vez que um cliente/suporte/você encontra um bug depois do release — o passo-a-passo do tutorial antes terminava na retro da Etapa 13 sem caminho de volta para um bug pós-release. Adicionado ao mapa do tutorial (mermaid), ao "Resumo das etapas" e ao cheatsheet do Apêndice E.
- METHOD (en+pt): nova categoria de comando **Pós-produção**, separada de "Desenvolvimento (operar dentro de uma fase)" — bug-report/incident não pertencem lá porque aquela seção é sobre trabalho ainda dentro de uma fase não lançada.

### Corrigido
- `/renata:bug-report` e `/renata:incident` tinham sido colocados na tabela "comandos úteis durante a execução" da Etapa 12 e na categoria "Desenvolvimento" do METHOD — ambas descrevem trabalho numa fase não lançada, então um bug pós-release não tinha lugar correto. Movidos para a nova seção/categoria Pós-produção acima.

## [0.1.9] — 2026-07-03

**O que há de novo:** a visão panorâmica do tutorial alcançou o método.

### Corrigido
- GETTING-STARTED (en+pt): a camada de orientação (mapa mermaid do tutorial, tabela "Sumário das etapas", tabela "Por que essa ordem?", Views C/D, cheatsheet do Apêndice E) não tinha as etapas opcionais adicionadas na 0.1.4-0.1.6 — **1.5 Discovery**, **6.5 Landscape**, **7.7 Comportamento da feature** — além da linha **7.5 Fasear o sistema** e do `/renata:extract-pattern` no cheatsheet. O corpo passo-a-passo já estava completo; só os artefatos de visão geral tinham derivado. Todos os diagramas mermaid validados com mmdc.

## [0.1.8] — 2026-07-03

**O que há de novo:** schema YAML em inglês — identificadores em inglês, antecipando a localização completa.

### Alterado (⚠️ breaking para projetos criados até a 0.1.7)
- Chaves do schema do `progress-map.yaml` renomeadas para inglês: `etapas`→`steps` · `nome`→`name` · `comando`→`command` · `artefato_glob`→`artifact_glob` · `nao_vazio_se`→`non_empty_if` · `opcional`→`optional` · `validacao`→`validation`. Os valores (rótulos das etapas, critérios de validação) continuam em português — são conteúdo, cobertos pela futura onda de localização.
- Bloco de integrações do `rules.yaml`: `espelho`→`mirror`; capacidade canônica `tarefas`→`tasks`.
- Hooks (`method-status-line.sh`, `etapa-gate.sh`) e comandos (`/renata:status`, `/renata:adr`, `/renata:todo`, `/renata:triage`) atualizados para o novo schema; ambos os hooks testados funcionalmente contra ele.
- **Migração para projetos existentes:** renomeie as chaves acima no seu `.claude/progress-map.yaml` e `.claude/rules.yaml`. Não há camada de compatibilidade.

## [0.1.7] — 2026-07-03

**O que há de novo:** sair de dentro do prédio — o loop de entrevista e os selos de evidência.

### Adicionado
- `/renata:interview-kit` — roteiro de campo Mom Test de 1 página pra entrevistas de problema (perguntas sobre passado e comportamento, lista do NUNCA perguntar, sinais pra prestar atenção), feito pra ler no celular. 1 kit = 1 premissa.
- `/renata:interview-debrief` — processa uma transcrição já pronta (só transcrição — integração com áudio é evolução futura): citações literais por premissa, graduadas 🥇 espontânea / 🥈 provocada / 🚫 contaminada, board de evidência agregado (`docs/interviews/README.md`), promoção/rebaixamento de selo nos docs de origem, e coaching obrigatório do entrevistador.
- **Selos de evidência** (🔴 crença · 🟡 anedota · 🟢 entrevistado · ✅ medido) — documentados uma vez no METHOD.md; carimbados pelo `/renata:discovery`, movidos pelo `/renata:interview-debrief`, sacados pelo `/renata:assumption-test` / `/renata:hypothesis-check`. Selos nunca bloqueiam — eles forçam honestidade.
- Seção de posicionamento no README ("Por que o RENATA existe") e linhagem intelectual no METHOD (Cagan, Torres, Blank, Fitzpatrick, Nygard, Ries).
- `docs/interviews/` (kits + debriefs + board) no scaffold do projeto.

### Mudado
- `/renata:discovery` — carimba selos de evidência e semeia a premissa mais arriscada (4ª semente).
- `/renata:assumption-test` — aceita input do discovery pré-PRD; a linha do catálogo de entrevista de problema se conecta ao loop de entrevista; resultados citam o board de evidência.
- `/renata:status` — sugere `/renata:interview-kit` quando a aposta escolhida carrega um selo fraco.

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
