# Changelog

> 🇬🇧 [English version](CHANGELOG.md)

Todas as mudanças notáveis do RENATA estão documentadas aqui. Formato baseado em [Keep a Changelog](https://keepachangelog.com); versionamento segue [SemVer](https://semver.org).

## [Unreleased]

### Corrigido
- **Auditoria de drift dos docs (flagrada pelo Eric): os docs de vitrine não tinham absorvido 0.2.0-0.4.0.** METHOD: diagrama de fluxo com Etapas 9/10 ainda "manual" (agora `/renata:roadmap-gates` / `/renata:architecture`, contradizendo a própria tabela de comandos do doc), tabela "quem pertence a quê" apontando pro inexistente `.claude/hooks/rules-violation.sh` (agora `${CLAUDE_PLUGIN_ROOT}/hooks/scripts/`) e pro `init.sh --starter` (só existe no standalone; agora `/renata:init --starter`), e faltavam a convenção de marcadores, o `RENATA_STRICT_GATE` e a checagem de dependências do init. REFERENCE: `architecture`, `execute`, `next` e `roadmap-gates` ausentes do catálogo de comandos (Etapa 9 ainda "manual"). GETTING-STARTED: Etapa 6.4 ensinava um symlink quebrado `ln -sf ../../.claude/hooks/...` (que desativa o enforcement de ADR silenciosamente) e contradizia o auto-enable do init; pre-flight #8 usava o caminho morto do hook; a tabela dos "11 pré-requisitos" listava só 10 (faltava o item 0, superpowers instalado); Etapa 0 chamava `yq` de "opcional" e omitia `jq`/`python3`; gate estrito não documentado. README: descrição do init sem a checagem de dependências da 0.4.0. Tudo corrigido nos pares EN e PT; ADOPTION auditado limpo.

## [0.4.0] — 2026-07-19

**O que há de novo:** as dependências de máquina do plugin deixam de ser uma armadilha silenciosa — o `/renata:init` (e o `init.sh` standalone) agora checam `yq`/`jq`/`git` no primeiro uso e oferecem instalar o que falta, em vez de deixar o enforcement de ADR degradar em silêncio.

### Adicionado
- **Checagem de dependências no `/renata:init` (passo 1)** — o init agora verifica as dependências de máquina do plugin antes do scaffold: `yq` (obrigatória — sem ela o `rules-violation.sh` não valida nada no commit), `jq`/`python3` (uma das duas; gate de etapa + status line) e `git`. Ferramentas ausentes são instaladas via gerenciador detectado (`brew`/`apt-get`/`dnf`) como chamada Bash visível — o prompt de permissão é o consentimento; sem gerenciador, ou se o usuário recusar, o init imprime o comando manual e segue (os hooks já degradam com avisos). Instalação de plugin não tem hook pós-install no Claude Code, então o primeiro uso no `/renata:init` é o momento confiável mais cedo pra checar; o aviso de `yq` no SessionStart continua como rede de segurança pra máquinas que nunca rodaram o init.
- **Mesma checagem no `init.sh` standalone** — o sync exclui `commands/init.md` (no standalone quem instala é `scripts/init.sh`), então o script mantido à mão ganhou o bloco equivalente: prompt interativo de instalação via gerenciador detectado; em modo `--yes` (CI) nunca instala sozinho, só imprime o comando; em qualquer caso termina o scaffold.

## [0.3.0] — 2026-07-19

**O que há de novo:** a rodada de auditoria estática pós-0.2.0 (de novo do projeto de campo Avatar) — todo `artifact_glob`/`non_empty_if` e toda referência cruzada dos 34 comandos foi checada. Dois bugs que quebravam o fluxo corrigidos (o caminho de hook que abortava `/renata:execute` e `/renata:plan-phase`, e a detecção de progresso dependente de idioma), mais atualização determinística dos docs vivos e uma convenção de marcador de etapa idioma-neutra.

### Corrigido
- **`bash .claude/hooks/rules-violation.sh` era invocado mas o arquivo nunca existe num projeto do plugin** (o scaffold só copia `progress-map.yaml` + `rules.yaml.template`). O pre-flight #8 do `/renata:plan-phase`, o #4 do `/renata:execute` e a validação pós-escrita do `/renata:adr` caíam em `No such file or directory` — abortando os dois comandos de execução com remédio enganoso. Os três agora invocam `bash "${CLAUDE_PLUGIN_ROOT}/hooks/scripts/rules-violation.sh"` (o sync do standalone reescreve pra `.claude/hooks/`, onde o arquivo existe de fato); os comentários desatualizados do `rules.yaml.template` e do `progress-map.yaml` também foram corrigidos.
- **A detecção de progresso era dependente de idioma.** Os docs saem "no idioma do usuário", mas cinco needles `non_empty_if` eram prosa monolíngue (`aposta escolhida`, `Soluções encontradas`, `Fase 0`, `Behavior`, `Decisão final`) — num projeto EN, a Etapa 7.5 lia como placeholder e **bloqueava o `/renata:feature-spec`**; num projeto PT a 7.7 sumia do `/renata:status`. Substituídos pela **convenção de marcador de etapa**: cada comando gerador carimba `<!-- renata:step=N -->` logo abaixo do título do doc (invisível na renderização) e os needles do mapa casam esse marcador — idioma-neutro por construção.
- **As Etapas 7.5 e 9 compartilhavam o mesmo glob e colidiam no needle** (`fases-overview.md`; a 7.5 já emite `gantt`, que era o needle da 9) — a Etapa 9 contava como feita assim que a 7.5 rodava, liberando a Etapa 10 sem gates. Agora o `/renata:phase-roadmap` carimba `renata:step=7.5` e o `/renata:roadmap-gates` carimba `renata:step=9` no mesmo arquivo; cada etapa casa o próprio marcador.
- **O glob da Etapa 8 (`docs/features/F1-*.md`) também casava o arquivo da 7.7 (`F1-*.behavior.md`)** — rodar o refinamento opcional de comportamento marcava a spec da âncora como presente sem spec existir. A Etapa 8 agora casa o marcador `renata:step=8`, que o `/renata:feature-spec` (e as specs as-built do `/renata:adopt`) carimbam e o doc de behavior não tem.
- **`Status: running` (detecção da Etapa 12 + pre-flight #3 do execute) não era escrito por comando nenhum** — ficava implicitamente delegado ao `writing-plans` externo, que não garante. O `/renata:plan-phase` agora exige `Status: draft` no plano gerado e grava `approved` após o aval do `@architect`; o `/renata:execute` grava `running` ao iniciar e `done` no fim da fase. A detecção da Etapa 12 mudou pro marcador `renata:step=12` (carimbado no início da execução, mantido após o `done` — assim a Etapa 12 não "some" quando a fase fecha, o que bloquearia o `/renata:retro`).
- **A validação de YAML do `/renata:adr` era uma falsa validação** — rodava o hook no caminho inexistente e, sem `yq`, o hook só avisa e não valida nada. O passo agora usa o caminho do plugin e diz explicitamente que a validação real exige `yq`.
- **`_framework/` expurgado do plugin** — é o layout do monorepo do RENATA, não algo que um projeto de usuário tenha. `plan-phase` (contexto obrigatório), `adr` (caminho do template), `execute` (ponteiro do SKILL-CANDIDATES), `CLAUDE.md.template` (2 menções) e os excludes de scan do `rules-violation.sh` agora referenciam `${CLAUDE_PLUGIN_ROOT}/METHOD.md` / texto neutro (o sync do standalone reescreve a referência do METHOD pra `.claude/METHOD.md` e passa a entregar o arquivo lá).
- Cosméticos: o `/renata:status` documenta que os comandos do mapa não têm namespace e devem ser exibidos com o prefixo `renata:` na edição plugin; a mensagem de bloqueio do gate cita a seção do METHOD nos dois idiomas ("Why this order?" / "Por que essa ordem?"); a inconsistência "fluxo de 14 etapas" vs `Etapa X/13` corrigida (o status.md é dirigido pelo mapa e a linha de status deriva o denominador da última etapa do mapa).

### Adicionado
- **Atualização determinística dos docs vivos no `/renata:execute` (R1)** — o estado retomável (checkboxes do plano, `Status` do plano, `CLAUDE.md` §5) não depende mais da skill `keeping-docs-alive` auto-ativar: o gate de pronto por task agora inclui marcar a task `[x]` e atualizar a §5 como critério explícito do gate, e o fim de fase grava `Status: done`. A skill permanece pro fechamento no nível da fase.
- **Gate estrito, opt-in (carryover do R2)** — `RENATA_STRICT_GATE=1` faz o `etapa-gate.sh` exigir também o selo de verificação humana (`> ✅ Verificado por você` / `> ✅ Verified by you`) nos artefatos de pré-requisito (done ≠ verificado). Desligado por padrão pra não enrijecer o fluxo.

## [0.2.0] — 2026-07-19

**O que há de novo:** enforcement que realmente enforça — feedback de campo de um projeto real (Avatar) provou que o gate de etapa era um no-op silencioso pra toda invocação real, o hook de pre-commit era inutilizável em repos com dependências vendoradas, e a convenção de pasta de plano colidia com o `superpowers`. Tudo corrigido, mais 3 comandos novos pra que toda etapa do fluxo tenha comando e cobertura do gate.

### Corrigido
- **Gate de etapa era no-op pra invocações namespaced (as reais).** O `etapa-gate.sh` casava o comando invocado contra o mapa ao pé da letra: `/plan-phase` bloqueava, mas `/renata:plan-phase` — como os usuários realmente invocam — sempre passava. O gate agora lê também `.tool_input.skill` (como a ferramenta Skill entrega slash commands) e compara basenames sem namespace, então `/plan-phase`, `/renata:plan-phase` e `renata:plan-phase` caem todos no gate. Provado por teste: `/renata:plan-phase 0` agora dá exit 2 enquanto a Etapa 10 não existe.
- **Hook de pre-commit varria a árvore inteira.** O `rules-violation.sh` rodava `grep -r` no repo todo, acusando violação de ADR dentro de código de terceiros gitignored (ex.: `pt_BR` num site-packages vendorado) e barrando commits com zero violações reais. Agora escaneia **apenas os arquivos staged** (`git diff --cached --name-only --diff-filter=ACM`) no pre-commit — honrando o `.gitignore` de graça — com fallback pra rastreados (`git ls-files`) em CI/`--all`, e pra varredura antiga só fora de repo git.
- **Pasta de plano colidia com a convenção do `superpowers`.** O RENATA gravava/lia planos de implementação em `docs/superpowers/specs/`, mas o `superpowers:writing-plans` salva em `docs/superpowers/plans/` (e no superpowers, `specs/` significa design doc) — então o `/renata:execute` nunca encontraria o plano gerado pelo `writing-plans`. Padronizado `docs/superpowers/plans/` em tudo (plan-phase, execute, progress-map Etapas 11-12, qa-tester, keeping-docs-alive, METHOD, GETTING-STARTED); `specs/` fica reservado pra design docs.
- **Handoff do `/renata:plan-phase` pulava o `/renata:execute`.** O Step 6/7 mandava o usuário invocar `superpowers:executing-plans` direto — jogando pra fora do método bem no fim. Agora entrega pra `/renata:execute <fase>` (que embrulha o `executing-plans` com pre-flight + gate de pronto por task).
- METHOD (en+pt): a seção "Inspirações declaradas" no rodapé, da era v0.1, era uma duplicata desatualizada de "Sobre os ombros de quem (linhagem)" (criada na 0.1.7) — sem Blank/Fitzpatrick e driftando no resto. Os dois itens únicos dela (curso AINSTEINS / AI-Driven Development, DDD-lite) foram fundidos na seção de linhagem e a duplicata removida.

### Adicionado
- `/renata:architecture` — a Etapa 10 ganha slash command (era "(manual)"): sintetiza ADRs aceitas + feature-specs + spikes em `stack.md` + `arquitetura.md` (C4 N1/N2), sem decidir nada novo. Com o matcher do gate corrigido, a Etapa 10 passa a ter cobertura do gate.
- `/renata:roadmap-gates` — a Etapa 9 ganha slash command (era "(manual)"): blinda o roadmap da 7.5 com gate explícito e verificável por fase + 1 `fase-N-<nome>.md` por fase + anti-roadmap.
- `/renata:next` — micro-navegador: responde só "qual o próximo passo canônico?" e aponta gaps (artefato existindo à frente de prereq não satisfeito). O complemento barato e frequente do `/renata:status`.
- **Detector de gap proativo no SessionStart** — o `method-status-line.sh` agora imprime uma linha `⚠ gap no fluxo` quando uma etapa posterior tem artefato enquanto uma etapa obrigatória anterior está vazia (o caso que o gate por-invocação não pega: trabalho já feito à frente do fluxo, ou plano sugerido em prosa).
- **`superpowers` declarado como dependência externa** — `/renata:plan-phase` e `/renata:execute` ganharam a checagem #0 no pre-flight (aborta com instrução de instalação se o plugin `superpowers` faltar — improvisar o plano/loop na mão é explicitamente proibido); README (en+pt) e GETTING-STARTED (en+pt) documentam a instalação.

### Mudado
- **Hooks não dependem mais de `yq`** — o `progress-map.yaml` é lido por um parser awk embutido (`progress-map-lib.sh`, arquivo novo compartilhado por `etapa-gate.sh` e `method-status-line.sh`), então o gate de etapa e a linha de status rodam em qualquer máquina. O JSON do evento do hook precisa de `jq` *ou* `python3` (fallback).
- **Enforcement OFF agora é barulhento** — trava silenciosamente desligada é pior que trava nenhuma. Se o gate não pode rodar (sem `jq`/`python3`) ou o `rules.yaml` existe mas o `yq` falta, o SessionStart imprime um aviso visível estilo `⚠ RENATA: enforcement OFF` com o comando de instalação; o próprio gate também avisa no stderr em vez de sair calado.
- `progress-map.yaml`: as Etapas 9 e 10 agora têm `command: "/roadmap-gates"` / `command: "/architecture"` em vez de `"(manual) ..."` — sem mais pontos cegos na cobertura do gate; as seções das Etapas 9/10 e a tabela de etapas do GETTING-STARTED (en+pt) apontam pros comandos novos; mensagem de próximos passos do `init.sh` atualizada.

## [0.1.11] — 2026-07-15

**O que há de novo:** adoção brownfield — nascida de feedback de uso real: um dev fazendo engenharia reversa de um sistema existente rodou o `/renata:extract-pattern` e ficou sem resposta pra "onde moram as specs técnicas?". Agora existe um comando e um guia pro caminho inteiro.

### Adicionado
- `/renata:adopt` — o 30º comando: adota o RENATA sobre uma base de código existente em 6 estágios confirmados — padrão técnico (compõe com o `/renata:extract-pattern` por escopo), contexto técnico (`stack.md` + `arquitetura.md` C4), inventário de features por engenharia reversa, PRD retroativo, specs as-built seletivas, fechamento com o mapa de artefatos. Todo artefato nasce 🔄 com a marca de proveniência `> 🏗️ As-built`; só o humano verifica, via `/renata:status`.
- `ADOPTION.md` (en+pt) — o guia brownfield: tabela estágio a estágio, **"Onde mora cada artefato"** (a tabela que responde a pergunta original), o que o `/renata:status` mostra depois de uma rodada, limpeza de ADRs pré-existentes, FAQ.
- `REFERENCE.md` (en+pt) — os seis apêndices do GETTING-STARTED (quando NÃO usar, anti-padrões, ordens alternativas, tempos realistas, cheatsheet, evoluir o método), agora com uma ordem alternativa brownfield e `/renata:adopt` + `/renata:init` no cheatsheet.
- O `/renata:init` detecta código existente (manifests de dependência / diretórios de código-fonte) e fecha apontando pro `/renata:adopt` em vez do fluxo greenfield da Etapa 2.

### Mudado
- GETTING-STARTED (en+pt) enxugado de ~2000 pra ~1550 linhas: o mermaid do mapa do tutorial, as 4 visões (loop de execução, responsabilidade, artefatos) e o ensaio "por que essa ordem?" foram pro METHOD.md (deduplicando o "Quem faz o quê" dentro da Visão C); os apêndices foram pro REFERENCE.md; o preâmbulo agora tem ~70 linhas com a bússola e o resumo das etapas.
- METHOD.md (en+pt) ganha "O fluxo de relance", "As 4 visões do método", uma categoria de comando "Scaffold" (`/renata:init`, `/renata:adopt`) e a nuance brownfield no "quando NÃO usar".

### Corrigido
- A Etapa 0.5 "Retrofit" era legado pré-plugin — `cp -R $FW/template` manual de um framework clonado, com contagens de validação defasadas ("18 comandos / 5 agentes") e sem conexão com o `/renata:extract-pattern`. Substituída por um ponteiro pro `/renata:adopt` + `ADOPTION.md`; o conselho de limpeza de ADRs pré-existentes foi pro ADOPTION.md.
- A Etapa 1 ordenava o `git init` (1.4) depois do `/renata:init` (1.2), então o hook de enforcement de ADR — que só ativa quando o git existe — nunca ativava na primeira rodada. O `git init` agora vem antes.

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
