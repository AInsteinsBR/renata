# Referência — apêndices do RENATA

> 🇬🇧 [English version](REFERENCE.md)

> Material de consulta rápida que antes vivia no final do [`GETTING-STARTED.pt-br.md`](GETTING-STARTED.pt-br.md). Leia o tutorial primeiro; volte aqui quando precisar de um cheatsheet, uma ordem alternativa ou um sanity check.

---

## Apêndice A — Quando NÃO usar este método

RENATA não é o caminho certo pra tudo. Não use se:

- ❌ **Código descartável** — um script de 1 uso, uma demo, uma prova de conceito de 1 dia
- ❌ **Base legada com método estabelecido** (não tente impor). Uma base legada **sem** método é diferente — pra isso existe o `/renata:adopt` (veja o [`ADOPTION.pt-br.md`](ADOPTION.pt-br.md))
- ❌ **Time grande (>15 pessoas)** — otimizado pra solo/squad pequeno (1-6)
- ❌ **Domínio extremamente regulado** sem suplementação de compliance/auditoria

---

## Apêndice B — Anti-padrões do método

Sinais de alerta — você está fazendo errado:

| Sintoma | Diagnóstico |
|---|---|
| Um PRD de 10 páginas | É um Micro PRD. 1 página. Vivo. |
| Uma ADR com 5 alternativas todas "rejeitadas por serem ruins" | Análise rasa. Force um motivo concreto. |
| Persona "todo dev brasileiro" | Vago demais. Force o específico. |
| Uma feature âncora da qual ninguém depende | Aplique os 4 critérios. Se falhar, escolha outra. |
| Roadmap sem gates | Sem critério objetivo, não é roadmap, é lista de desejos. |
| Hook desligado "temporariamente" | Sinal de doença. Resolva ou abra uma ADR que a substitua. |

---

## Apêndice C — Ordem alternativa pra projetos diferentes

A ordem 0-13 é canônica, mas pode variar:

**Projeto técnico (sem persona externa clara):**
1, 6 (ADRs primeiro), 10 (arquitetura), 7 (features), 9 (roadmap), 11, 12, 13.
PRD e personas podem ser mais leves.

**Projeto de pesquisa/exploração:**
1, 2 (PRD com hipótese forte), 6 (1-2 ADRs sobre o stack), 11 (planejar direto), 12.
Pule 7-9 — refatore se virar produto.

**Plugin/biblioteca pra devs:**
1, 2 (PRD), 3 (persona = dev), 6 (ADRs sobre a superfície da API), 7-8 (features = endpoints), 10 (arquitetura), 12.
Métricas (5) ficam leves — dev não responde survey.

**Projeto existente (brownfield):**
`/renata:adopt` pré-preenche as etapas 1, 2, 6, 7, 8 e 10 como 🔄 (as-built); você as verifica via `/renata:status`, depois preenche 3-5 (personas, jornada, métricas) e planeja a PRÓXIMA fase. Guia completo: [`ADOPTION.pt-br.md`](ADOPTION.pt-br.md).

---

## Apêndice D — Tempo total realista

| Cenário | Tempo pras Etapas 0-11 (até começar a codar) |
|---|---|
| Solo, projeto novo, conhece o domínio | 8-12h ao longo de 3-5 dias |
| Solo, projeto novo, domínio novo | 15-25h ao longo de 1-2 semanas |
| Dupla, projeto novo | 12-18h ao longo de 1 semana (sincronização cria atrito) |
| Time pequeno (4-6) | 20-40h ao longo de 2 semanas (mais discussão por etapa) |

A Etapa 12 (execute) é sempre o maior bloco — pode levar de semanas a meses.

---

## Apêndice E — Cheatsheet rápido

Pra quando você já fez o tutorial uma vez e quer uma referência rápida.

## Comandos (em ordem de uso)

| Etapa | Comando | O que faz |
|---|---|---|
| 0.5 | `/renata:adopt [escopos]` | Adota o RENATA numa base de código existente — padrão + features + PRD retroativo, as-built (só pra projetos existentes; veja `ADOPTION.pt-br.md`) |
| 1 | `/renata:init <nome>` | Cria o scaffold `CLAUDE.md` + `docs/` + `.claude/` no projeto |
| 1.5 | `/renata:discovery <ideia>` | Intuição vaga → problema claro (5 porquês + JTBD + why-now) (opcional) |
| 2 | `/renata:prd <ideia>` | Micro PRD em 9 perguntas |
| 3 | `/renata:persona <nome>` | Persona estruturada em 4 turnos |
| 4 | `/renata:user-journey <persona>` | Antes/durante/depois |
| 5 | `/renata:metrics` | 4 camadas (adoção, engajamento, valor, qualidade) |
| 6 | `/renata:adr <decisão>` | ADR Nygard + atualiza `rules.yaml` |
| 6 | `/renata:extract-pattern <repo>` | Destila o padrão de um repo existente em ADRs + doc de code-pattern |
| 6.5 | `/renata:landscape` | Pesquisa competitiva → gaps de diferenciação (opcional) |
| 7 | `/renata:feature-breakdown` | Lista features + identifica a âncora |
| 7.5 | `/renata:phase-roadmap` | Distribui todas as features em fases sequenciais (Fase 0 = conjunto-âncora) |
| 7.7 | `/renata:feature-behavior <id>` | Feature como comportamento observável (histórias + Gherkin) antes da spec (opcional) |
| 8 | `/renata:feature-spec <id>` | Detalha uma feature + plano em fases |
| 8.5 | `/renata:screens` | Inventário + fluxo + briefs de telas (opcional) |
| gate | `/renata:assumption-test <premissa>` | Testa um risco de valor/viabilidade antes de construir (loop Measure-Learn) |
| gate | `/renata:interview-kit [premissa]` | Guia de campo Mom Test de uma página antes de uma entrevista de problema |
| gate | `/renata:interview-debrief <transcrição>` | Transcrição → evidência verbatim + board + coaching do entrevistador |
| 9 | `/renata:roadmap-gates` | Endurece o roadmap macro: gate explícito e verificável por fase + um arquivo por fase |
| 10 | `/renata:architecture` | Sintetiza ADRs aceitas + specs + spikes em `stack.md` + `arquitetura.md` (C4) — não decide nada novo |
| 11 | `/renata:plan-phase <fase>` | Plano blindado (writing-plans + @architect) |
| 12 | `/renata:execute <fase>` | Orquestra a execução da fase: pre-flight + gate de pronto por task (embrulha o executing-plans) |
| 12 | `/renata:spike <pergunta>` | Investigação de risco |
| 12 | `/renata:phase-scope <fase>` | Re-escopo com MoSCoW |
| 12 | `/renata:triage <contexto>` | Prioriza bugs/dívidas |
| 12 | `/renata:todo <add\|sync\|list\|done>` | Backlog de pendências (inline + sync central) |
| 12 | `/renata:refactor <alvo>` | Refactor disciplinado |
| 13 | `/renata:retro [fase]` | Retrospectiva (aprendizado de execução) |
| 13 | `/renata:hypothesis-check [hipótese]` | Veredito da hipótese vs dados reais (✅/❌/🤔 + sunset) |
| 14 | `/renata:bug-report <descrição crua>` | Um bug fresco de produção → estruturado, classificado por severidade, roteado |
| 14 | `/renata:incident <descrição>` | Coordenação ao vivo de um incidente maior de produção → entrega pro `/renata:retro` |
| — | `/renata:status [N]` | Onde estou no fluxo + o próximo passo (valida a etapa atual com gate humano) |
| — | `/renata:next` | Micro-navegador: só o próximo passo canônico + gaps (não roda comandos de etapa) |

## Subagentes (chame quando estiver em dúvida)

Você invoca esses com `@` quando quer uma segunda opinião focada. Cada um lê os docs/diff relevantes e devolve um veredito estruturado — nenhum deles escreve código de produto.

| Quando | Agente | O que ele devolve |
|---|---|---|
| Antes de codar, uma dúvida arquitetural | `@architect` | Revisa uma proposta/diff contra o CLAUDE.md + ADRs; decide e justifica (não coda) |
| Código pronto, antes de um PR | `@code-reviewer` | Lê o diff: bugs, padrões violados, testes faltando, naming, ADRs não honradas no código |
| Antes de marcar uma feature como pronta | `@qa-tester` | Roda o app real (Playwright/manual) contra o PRD + critérios de aceite da feature, reporta achados |
| Latência/throughput abaixo da meta do PRD | `@perf-auditor` | Auditoria profunda de performance: hot paths, N+1, memory leaks, cache faltando, I/O síncrono em caminho assíncrono |
| Mexeu em auth / permissões / dados sensíveis | `@security-reviewer` | OWASP top-10 prático, secrets vazados, validação de input, authz cross-tenant, LGPD básica |

> **O `@pattern-mapper` é a exceção — você não o chama direto.** Ele mapeia o padrão de um repo (4 eixos, com força de evidência) e roda **dentro** do `/renata:extract-pattern` (e do `/renata:adopt`, que compõe com ele), transformando o mapa em ADRs + um doc carregável. Se quiser um padrão mapeado, rode o comando, não o agente.

## Skills do framework (auto-ativáveis — você não invoca)

Essas três disparam sozinhas quando a conversa bate num gatilho. Você não as chama; elas vigiam o momento e entram em cena.

- `respecting-adrs` — dispara em "vou implementar X / qual lib / vamos refatorar". Força ler as ADRs aceitas e validar a proposta contra elas **antes** de codar.
- `keeping-docs-alive` — dispara em "terminei / vou pausar / fase concluída". Atualiza o plano ativo + a Seção 5 do CLAUDE.md (os dois portadores de estado retomável), pros docs nunca descolarem do código.
- `detecting-scope-creep` — dispara em "já que estou aqui / também seria fácil…". Compara a ideia nova com o escopo IN/OUT da feature ativa e **oferece três opções** (fazer agora / estacionar como TODO / abrir uma ADR), forçando uma decisão consciente em vez de crescimento silencioso de escopo.

## Skills do Superpowers (automáticas)

- `superpowers:writing-plans` — plano de execução (Etapa 11)
- `superpowers:executing-plans` / `subagent-driven-development` — executa (Etapa 12, orquestrado pelo `/renata:execute`)
- `superpowers:test-driven-development` — durante a implementação
- `superpowers:systematic-debugging` — quando aparece um bug
- `superpowers:verification-before-completion` — antes de declarar pronto

## Validação macro por etapa (resumo)

| Etapa | Está pronta quando |
|---|---|
| 2 PRD | Uma hipótese falseável + uma métrica decisiva com baseline |
| 3 Personas | Uma primária com nome, dor numérica, uma citação + anti-personas |
| 4 Jornada | Antes/durante/depois com pontos críticos amarrados |
| 5 Métricas | 3-4 camadas + uma métrica decisiva amarrada à hipótese |
| 6 ADRs | ≥5 aceitas + hook testado + cada uma com gatilho de revisão |
| 7 Features | 3-7 features + a âncora marcada com 4 critérios |
| 8 Feature spec | Um plano em fases XS-M com critério verificável |
| 9 Roadmap | Fases macro + gates explícitos + anti-roadmap |
| 10 Arquitetura | Stack ancorado em constraints + C4 nível 1 e 2 |
| 11 Plano de execução | Um plano com TDD + ≥3 checkpoints |
| 12 Execução | Commits passam no hook + testes verdes |
| 13 Retro | Uma decisão explícita: próxima fase / repetir / pivotar |
| 14 Pós-produção | Todo bug fresco registrado; incidentes fechados só após o checklist de resolução; uma retro agendada |

---

## Apêndice F — Como evoluir o método

O método **vai mudar**. Toda mudança nasce de atrito real, não de teoria.

Ao final de cada projeto:

1. Liste 3 momentos de atrito
2. Pra cada um: ajuste o método, ajuste a ferramenta, ou aceite o custo
3. Se ajustar o método: um PR pro RENATA com a mudança + justificativa
