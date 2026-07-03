# Design · Interview Loop (Steve Blank / Mom Test no RENATA)

> **Data:** 2026-07-03 · **Status:** aprovado em brainstorm, aguardando plano de implementação
> **Decisão de origem:** o pré-PRD do RENATA acontece 100% "dentro do prédio" — o primeiro contato com um humano real só aparece no `assumption-test`, depois do PRD pronto. Este design traz o "get out of the building" (Steve Blank / Customer Development) para antes do PRD, sem duplicar o que `assumption-test` e `hypothesis-check` já fazem bem.

---

## O problema

1. **Discovery converge sem evidência externa.** Os 5-whys, o JTBD e o why-now são respondidos pelo fundador. O doc de discovery parece conclusão, mas é uma pilha de hipóteses não testadas — e nada no método marca essa diferença.
2. **Ninguém ensina a entrevistar.** O catálogo do `assumption-test` diz "problem interview (5-8 pessoas)" sem dar a técnica. Entrevista mal feita é confirmation theater — o próprio comando alerta contra isso sem entregar a ferramenta.
3. **A entrevista acontece longe do PC.** O usuário precisa de um roteiro pronto ANTES (lido no celular) e de um processador de transcrição DEPOIS. Durante, o framework fica fora da sala (decisão de design: assistente na sala mata a naturalidade que o Mom Test exige).

## Decisões tomadas no brainstorm

| Decisão | Escolha | Alternativa rejeitada |
|---|---|---|
| Estrutura | 2 comandos novos + integrações nos existentes (opção A) | Comando único com modos (B); tudo dentro do assumption-test (C) |
| Input do debrief | **Transcrição pronta, sempre** (texto colado ou caminho de arquivo) | Áudio bruto via whisper local — fica para versão futura explícita; v1 recusa áudio educadamente |
| Entrevista no fluxo | Transversal — sugestão contextual do `/status` | Etapa numerada no progress-map (rejeitada: serve pré-PRD e pós-PRD) |
| Escala de evidência | Definida UMA vez no METHOD.md (ancora o E de Evidence) | Repetida em cada comando |
| Nomes | `interview-kit`, `interview-debrief` (inglês; conteúdo em português) | — |

## A escala de selos de evidência (vai para o METHOD.md)

| Selo | Nível | Significado |
|---|---|---|
| 🔴 | belief | Crença do fundador — zero evidência externa |
| 🟡 | anecdote | 1-2 relatos informais, não estruturados |
| 🟢 | interviewed | Padrão ouvido espontaneamente em N≥3 entrevistas |
| ✅ | measured | Número real medido (instrumentação/dados) |

Regra de uso: o selo **não bloqueia** o avanço — força honestidade ("você está apostando em 🔴 — declare e siga, ou teste por XS agora"). Compatível com o princípio "Evidence reopens decisions".

---

## Componente 1 · `/renata:interview-kit` (novo comando)

Roteiro de campo de uma página, gerado a partir da assunção mais arriscada.

- **Lê:** `docs/assumptions/*.md` (preferido) ou `docs/discovery/*.md` (fallback). `$ARGUMENTS` pode dar a assunção direto.
- **Gera:** `docs/interviews/kits/<YYYY-MM-DD>-<slug>.md`
- **Formato:** UMA página, mobile-first — listas curtas, sem tabelas largas. É para ler no celular a caminho da entrevista.
- **Estrutura do kit:**
  1. Assunção-alvo + sinal de falsificação (topo, 2 linhas)
  2. Perfil de quem entrevistar (da seed de persona)
  3. Abertura sem pitch (contexto honesto, pedir permissão para gravar)
  4. 5-7 perguntas Mom Test — sobre passado e comportamento, nunca futuro e opinião ("me conta a última vez que…")
  5. Perguntas PROIBIDAS ("você usaria?", "você pagaria?", "gostou da ideia?")
  6. Sinais para escutar — ouro: dor espontânea, gambiarra atual, dinheiro/tempo já gasto · lixo: elogio, hipótese, resposta educada
  7. Fechamento: pedir indicações (detecção de earlyvangelist)
- **Quality rules (o que recusa):**
  - ❌ Pergunta de futuro/hipótese no roteiro → reescreve para passado/comportamento
  - ❌ Kit sem assunção-alvo ligada a um doc → exige a origem
  - ❌ Mais de 1 assunção por kit → 1 kit = 1 assunção (foco)
- **Depois de gerar:** instrui a gravar (o gravador do celular/Meet já transcreve) e a rodar `/renata:interview-debrief` na volta.

## Componente 2 · `/renata:interview-debrief` (novo comando)

Processa a transcrição: insights por assunção + selos de evidência + coaching do entrevistador.

- **Recebe:** transcrição como texto colado ou caminho de arquivo de texto. **Caminho de áudio → recusa educada** ("me dá a transcrição — seu gravador já faz isso"). Integração com áudio bruto é evolução futura explícita, fora deste escopo.
- **Lê:** o kit correspondente (se existir) + docs de assumption/discovery.
- **Faz três coisas:**
  1. **Extração por assunção** — cada sinal é uma **citação verbatim** classificada: 🥇 espontânea (a pessoa trouxe sem ser provocada) · 🥈 provocada (respondeu à pergunta — evidência fraca) · 🚫 contaminada (veio depois de um pitch/pergunta indutora — descartada como evidência).
  2. **Atualização de evidência** — grava o debrief individual, atualiza o board agregado (`docs/interviews/README.md`) e promove/rebaixa os selos nos docs de discovery/assumption de origem (🔴→🟡→🟢).
  3. **Coaching obrigatório** — critica as perguntas do entrevistador contra as regras Mom Test: "na pergunta X você pitcheou a solução; a resposta seguinte está contaminada". Roda mesmo em entrevista limpa (reforço positivo do que funcionou).
- **Gera:** `docs/interviews/<YYYY-MM-DD>-<slug>.md` (1 por entrevista) + atualiza `docs/interviews/README.md` (board) + edita selos nos docs de origem.
- **Board agregado (`docs/interviews/README.md`):** por assunção — nº de entrevistas, saldo de sinais ouro vs contra, selo atual, link dos debriefs.
- **Quality rules (o que recusa):**
  - ❌ Veredicto sobre a assunção com 1 entrevista → veredicto é do `assumption-test`, e com N≥3
  - ❌ Paráfrase como evidência → só citação verbatim conta
  - ❌ Pular o coaching → obrigatório em todo debrief
  - ❌ Aceitar áudio → transcrição pronta, sempre (v1)

## Componente 3 · Integrações nos comandos existentes

- **`commands/discovery.md`:** cada saída-chave (dor real, JTBD, why-now) ganha selo de evidência; nova quality rule "a aposta escolhida declara seu nível de evidência"; **4ª seed**: "assunção mais arriscada" → pista para `/renata:assumption-test` / `interview-kit`.
- **`commands/assumption-test.md`:** linha "Problem interview" do catálogo referencia `/renata:interview-kit`; seção Resultado aceita debriefs/board como fonte de evidência; passa a **aceitar o doc de discovery como input quando não há PRD** (destrava validação pré-PRD).
- **`commands/status.md`:** sugestão contextual — aposta escolhida com selo 🔴 → sugerir `interview-kit` antes do PRD.

## Fluxo ponta a ponta

```
/discovery (marca 🔴) → /interview-kit (roteiro no celular) → [campo: gravar]
→ /interview-debrief ×N (board evolui 🔴→🟢, coaching melhora o entrevistador)
→ /assumption-test (veredicto citando o board) → /prd (hipótese com lastro)
→ … → /hypothesis-check (✅ medido)
```

---

## Inventário completo de arquivos a criar/editar

### Criar

| Arquivo | Conteúdo |
|---|---|
| `commands/interview-kit.md` | Comando novo (Componente 1) |
| `commands/interview-debrief.md` | Comando novo (Componente 2) |
| `template/docs/interviews/kits/.gitkeep` | Pasta no scaffold (padrão .gitkeep das demais) |
| `template/docs/interviews/.gitkeep` | idem |

### Editar

| Arquivo | Mudança |
|---|---|
| `commands/discovery.md` | Selos de evidência + 4ª seed + quality rule |
| `commands/assumption-test.md` | Catálogo → kit; debrief como evidência; aceita discovery sem PRD |
| `commands/status.md` | Sugestão contextual (selo 🔴 → interview-kit) |
| `METHOD.md` + `METHOD.pt-br.md` | Escala de selos (seção única, ancorada no E de Evidence) + 2 comandos na lista |
| `README.md` + `README.pt-br.md` | Tabela de comandos: 24 → 26 |
| `GETTING-STARTED.md` + `GETTING-STARTED.pt-br.md` | Inserir o loop de entrevista no walkthrough (hoje só menciona assumption-test) |
| `template/CLAUDE.md.template` | Lista de comandos (~linha 94): adicionar interview-kit e interview-debrief |
| `template/docs/README.md` | Tabela de pastas ganha `interviews/`; avaliar mapa mermaid |
| `template/.claude/progress-map.yaml` | Etapa 1.5 (discovery): validação das seeds ganha a 4ª seed ("assunção mais arriscada"); NÃO criar etapa numerada de entrevista |
| `.claude-plugin/plugin.json` | Bump de versão (release) |
| `CHANGELOG.md` + `CHANGELOG.pt-br.md` | Entrada da versão (fluxo canônico de release: CHANGELOG + tag + GitHub Release) |

### Verificar na implementação (podem não precisar de mudança)

- `.claude-plugin/marketplace.json` — se replica descrição/contagem de comandos
- `hooks/` — se algum hook itera sobre a lista de comandos
- `template/.claude/rules.yaml.template` — se ganha enforcement de selo (provável NÃO na v1; selo não bloqueia)

## Fora de escopo (explícito)

- Transcrição de áudio (whisper local ou API) — evolução futura declarada
- Customer Development completo do Blank (4 etapas, business model canvas, earlyvangelist tracking formal) — pesado demais para o público do RENATA; o método adota só a técnica de entrevista + evidência progressiva
- Enforcement bloqueante de selo em `rules.yaml` — selo força honestidade, não bloqueia
- Comando de agendamento/CRM de entrevistados
