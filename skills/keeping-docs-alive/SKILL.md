---
name: keeping-docs-alive
description: Use sempre que terminar uma task, pausar uma sessão, completar uma fase, ou mudar status do projeto. Garante que docs vivas (CLAUDE.md, .claude/sessions/, plano ativo) reflitam o estado real para a próxima sessão retomar sem perda de contexto. Auto-ativa em "terminei", "pausando", "completou", "fim de fase", "vou parar agora".
---

# Mantendo docs vivas durante execução

Docs vivas são o **sistema nervoso entre sessões**. Sem elas atualizadas, a próxima sessão (humana ou IA) começa do zero ou pior — começa errado.

## Quando esta skill ativa

Auto-ativa quando contexto envolve:
- "Terminei task X" / "task X pronta"
- "Vou pausar" / "stop por hoje" / "amanhã continuamos"
- "Fase X completa"
- "Decidi mudar abordagem para Y"
- "Vou abrir PR / commit final"
- Checkbox de plano sendo marcado como concluído

## Procedimento (3 passos obrigatórios)

### Passo 1 — Atualizar o plano ativo

Se o trabalho atual corresponde a uma task do plano em `docs/superpowers/specs/<plan>.md`:

1. **Marcar checkboxes** dos steps completados: `[ ]` → `[x]`.
2. **Adicionar nota** se a task teve desvio do plano (ex: "tive que adicionar X porque Y").
3. **Atualizar contagem** se há campo "completed: N/M" no plano.

### Passo 2 — Atualizar `CLAUDE.md`

Seção 4 (Camada feature) — se houve mudança de fase/feature:
- `**Fase ativa:**` deve apontar pra fase em curso real.
- `**Feature-âncora:**` idem.

Seção 5 (Camada session) — sempre que pausar/retomar:
- Apontar pra arquivo de sessão atual: `.claude/sessions/<data>-fase-N-<descrição>.md`.

Seção 9 (Próximos passos) — atualizar pra refletir o que vem agora.

### Passo 3 — Criar/atualizar arquivo de sessão

`.claude/sessions/<YYYY-MM-DD>-fase-<N>-<descrição>.md`:

```markdown
# Sessão · YYYY-MM-DD · Fase N — <Descrição>

## Estado ao pausar

- **Plano ativo:** `docs/superpowers/specs/<file>.md`
- **Última task completada:** Task N (Step N.M)
- **Próxima ação ao retomar:** <1 frase específica>

## O que foi feito nesta sessão

- ...

## Pegadinhas descobertas

- (se houver)

## Decisões emergentes

- (se houver — pode virar ADR)

## Comandos engatilhados

\`\`\`bash
# Pra retomar:
cd <pasta>
docker compose ...
\`\`\`
```

## Quando NÃO ativar

- ❌ Mudança trivial (typo, comment) — não vale poluir docs.
- ❌ Mid-task ("acabei de escrever uma função") — espera completar a task inteira.
- ❌ Refatoração que não muda fase/feature/escopo.

## Exemplo bom

> Usuário: "Acabei a Task 4. Vou pausar por hoje."
>
> Skill ativa: "Vou atualizar 3 coisas:
> 1. `docs/superpowers/specs/2026-05-27-fase-0-spike.md` — marcar steps 4.1 a 4.11 como `[x]`.
> 2. `CLAUDE.md` seção 5 — apontar pra `.claude/sessions/2026-05-27-fase-0-task5.md`.
> 3. Criar `.claude/sessions/2026-05-27-fase-0-task5.md` com 'Última task completada: Task 4 · Próxima ação: implementar o componente da Task 5'."

## Anti-padrões

- ❌ Atualizar só os checkboxes e esquecer CLAUDE.md.
- ❌ Criar sessão com "fiz várias coisas" sem detalhe acionável.
- ❌ Não atualizar quando "vou continuar amanhã" — amanhã você esquece.
