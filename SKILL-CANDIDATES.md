# Skill Candidates — observados durante uso real

> Diário de **fricções repetidas** observadas durante uso do RENATA que poderiam virar skills auto-ativáveis na v0.2.
> Regra: só adicionar entrada aqui após **2+ ocorrências** da mesma fricção em projetos reais.

---

## Como usar este arquivo

Sempre que durante uma sessão você (Eric ou Claude) perceber:

- "Aqui eu deveria ter lembrado de X automaticamente"
- "Toda vez que tô em Y, esqueço de fazer Z"
- "Esse reflexo deveria ser padrão, não exceção"

Adicione entrada abaixo. Não filtra agora — só registra.

Ao final de cada fase do roadmap (ou trimestralmente), revisita esta lista. Padrões com **2+ ocorrências** viram skills propostas; **3+** viram skills criadas.

---

## Template de entrada

```markdown
### {{slug-da-skill-candidata}}

**Fricção observada:** {{o que aconteceu/faltou}}.
**Quando:** {{data, contexto — projeto, fase}}.
**Trigger natural (quando deveria auto-ativar):** {{padrão que sinaliza o momento}}.
**Comportamento esperado:** {{o que a skill faria}}.
**Ocorrências:** 1 (atualizar quando repetir).
```

---

## Candidatos atuais (pré-uso real)

> Detectados teoricamente durante a criação do framework. **Não criar ainda** — esperar 2+ ocorrências em uso real antes de promover a skill.

### writing-with-tradeoffs

**Fricção observada:** docs (PRD, ADR, feature-spec) podem sair sem trade-offs explícitos se o usuário não for forçado.
**Trigger natural:** ao escrever qualquer doc de produto/arquitetura.
**Comportamento esperado:** lembrar "incluiu trade-offs aceitos?" antes de finalizar.
**Ocorrências:** 0 em uso real (teórico).

### reading-code-for-review

**Fricção observada:** revisão de código pode pular ordem importante (security → bug → perf → style).
**Trigger natural:** quando vou revisar diff ou arquivo.
**Comportamento esperado:** ordem fixa de varredura.
**Ocorrências:** 0 em uso real.

### numbering-the-pain

**Fricção observada:** dor descrita sem número vira fantasia.
**Trigger natural:** linguagem de "problema do usuário", "dor", "fricção".
**Comportamento esperado:** sempre pedir número (horas/% / R$).
**Ocorrências:** 0 em uso real.

### detecting-scope-creep ✅ PROMOVIDA (2026-05-27)

**Status:** mora em `skills/detecting-scope-creep/SKILL.md`.

**Fricção observada:** feature cresce durante implementação além do spec.
**Trigger natural:** ao codar feature que tem spec definida.
**Comportamento esperado:** detectar mudança de capacidade vs spec e pausar.
**Ocorrências:** 0 reais (promovida preventivamente — ver Histórico abaixo).

### respecting-adrs ✅ PROMOVIDA (2026-05-27)

**Status:** mora em `skills/respecting-adrs/SKILL.md`.

**Fricção observada:** propor solução que viola ADR aceita sem checar antes.
**Trigger natural:** ao propor mudança técnica estrutural.
**Comportamento esperado:** ler ADRs aceitas e validar antes de codar.
**Ocorrências:** 0 reais (promovida preventivamente — ver Histórico abaixo).

### retrieving-context-before-coding

**Fricção observada:** começar a codar sem ler CLAUDE.md/ADRs/feature spec.
**Trigger natural:** primeira tarefa de implementação numa sessão.
**Comportamento esperado:** força leitura dos arquivos relevantes antes do primeiro `Edit`/`Write`.
**Ocorrências:** 0 em uso real.
**Cobertura provisória (2026-06-11):** coberta provisoriamente pelo Passo 2 do `/execute` (força leitura de plano+CLAUDE.md+feature-spec antes do 1º Edit). NÃO promovida a skill. Promover só se a fricção "codou sem ler contexto" aparecer mesmo com o command.

### keeping-docs-alive ✅ PROMOVIDA (2026-05-27)

**Status:** mora em `skills/keeping-docs-alive/SKILL.md`.

**Fricção observada:** docs vivas (CLAUDE.md seção 5, `.claude/sessions/`, checkboxes de plano ativo) divergem do estado real entre sessões. Próxima sessão começa errada ou perde tempo refazendo investigação.
**Trigger natural:** ao terminar task, pausar sessão, completar fase, mudar status.
**Comportamento esperado:** lembrar de atualizar 3 lugares antes de fechar — plano, CLAUDE.md, arquivo de sessão.
**Ocorrências:** 0 reais (promovida preventivamente).

### ai-pipeline-debugging

**Fricção observada (antecipada):** debug de pipeline de IA (latência, GPU OOM, drift áudio-vídeo) tem padrões repetidos que não estão em `superpowers:systematic-debugging`.
**Trigger natural:** menção a "lento", "frame drop", "drift", "GPU full" + contexto de pipeline IA.
**Comportamento esperado:** carregar conhecimento específico (Prometheus pipeline_metrics, profiling de GPU, sync de stream).
**Ocorrências:** 0 em uso real.
**Gancho criado (2026-06-11):** há um marcador `<!-- TODO -->` no Passo 3 do `/execute` (seção "Quando aparecer bug") pronto pra apontar pra esta skill quando ela for promovida.
**Nota especial:** este é o **único candidato com alta probabilidade de virar skill após Fase 0**, porque a Fase 0 do AI Human Agent vai exigir exatamente este tipo de debug.

---

## Quando promover candidato a skill

Critérios cumulativos:

- [ ] **Frequência:** 2+ ocorrências em projetos reais.
- [ ] **Especificidade:** trigger não é coberto por skill do `superpowers:` existente.
- [ ] **Ortogonalidade:** não duplica slash command ou agent existente.
- [ ] **Auto-ativação faz sentido:** comportamento deveria ser reflexo, não invocado.

Se atende os 4, abrir issue/PR no RENATA para criar skill.

---

## Skills que NÃO devem ser criadas (decisões explícitas)

Estas foram consideradas e rejeitadas:

- ❌ `renata:generate-prd` — duplica `/prd`. Slash command é certo aqui (precisa de fluxo de perguntas).
- ❌ `renata:review-as-architect` — duplica `@architect` (agent). Agent é certo aqui (persona distinta).
- ❌ `renata:write-tests` — coberto por `superpowers:test-driven-development`.
- ❌ `renata:debug-systematically` — coberto por `superpowers:systematic-debugging`.

---

## Histórico de promoções a skill

| Data | Slug | Promovido a partir de quantas ocorrências | Trigger |
|---|---|---|---|
| 2026-05-27 | `respecting-adrs` | 0 reais (preventivo, antes de iniciar Fase 0) | Eric pediu agents/skills de desenvolvimento; sem skill, qualquer subagent do `subagent-driven-development` pode codar ignorando ADRs |
| 2026-05-27 | `keeping-docs-alive` | 0 reais (preventivo) | Mesmo motivo — sem skill, docs vivas (CLAUDE.md, sessions/) divergem do estado real entre sessões |
| 2026-05-27 | `detecting-scope-creep` | 0 reais (preventivo) | Mesmo motivo — risco alto de aproveitar contexto pra adicionar coisas fora do escopo da feature |

**Exceção à regra "2+ ocorrências antes de promover":** essas 3 skills foram criadas antes da execução real porque o usuário (Eric) explicitamente decidiu antecipar a infraestrutura de guardrails (vs aprender com dor real). Risco: skills mal calibradas. Mitigação: revisitar essas 3 ao fim da Fase 0 do AI Human Agent — se algum trigger ativou demais ou de menos, ajustar.
