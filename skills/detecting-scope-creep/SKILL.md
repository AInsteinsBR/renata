---
name: detecting-scope-creep
description: Use sempre que aparecer impulso de "também vou adicionar X", "aproveitando que estou aqui", "já que mexi nisso", ou capacidade não-prevista na feature spec. Compara proposta com escopo IN/OUT da feature ativa e força decisão consciente antes de ampliar trabalho.
---

# Detectando scope-creep antes que aconteça

Scope-creep é a forma mais comum de estourar prazo de fase. Cada "só uma coisinha a mais" custa tempo, atenção, contexto, e arrisca o gate da fase.

## Quando esta skill ativa

Auto-ativa quando contexto envolve frases como:
- "Já que estou aqui, vou também..."
- "Aproveitando, posso adicionar..."
- "Faz sentido também..."
- "Vou só dar um jeito em..."
- "Também precisamos de..."
- Proposta menciona capacidade não-listada na feature-spec ativa

## Procedimento (3 passos)

### Passo 1 — Identificar feature ativa + ler escopo

1. Consultar `CLAUDE.md` seção 4 — qual é a feature-âncora ativa?
2. Ler `docs/features/F<N>-*.md` da feature.
3. Listar mentalmente o escopo IN e o escopo OUT.

### Passo 2 — Classificar a proposta

A coisa nova proposta pertence a qual categoria?

- **(A) Dentro do escopo IN da feature ativa** — OK. Pode prosseguir.
- **(B) Dentro do escopo OUT explícito** — STOP. Não fazer agora.
- **(C) Não mencionado em IN nem OUT** — zona cinzenta. Decidir conscientemente.

### Passo 3 — Conforme classificação

#### (A) Está no IN

Prossiga. Nada a fazer.

#### (B) Está no OUT explícito

**Recuse claramente.** Resposta sugerida:

> "Isso está marcado como escopo OUT em `docs/features/F<N>-*.md`. Razão: <citar do doc>. Se mudou de ideia, podemos:
> 1. Adiar pra próxima fase (F<N+1>).
> 2. Abrir nova feature-spec via `/feature-spec` se virou prioridade.
> 3. Atualizar a feature atual conscientemente (mover do OUT pro IN com justificativa).
>
> Por enquanto, vou seguir o escopo original."

#### (C) Zona cinzenta

Apresentar pro usuário 3 opções de decisão consciente:

1. **Adicionar agora ao IN** — se for crítico pra fase atual. Atualizar a feature-spec.
2. **Adiar pra próxima fase** — registrar via `/todo` ou no backlog do projeto.
3. **Spike rápido (`/spike`)** — se a dúvida é "será que vale a pena?".

**NÃO codar sem decisão explícita.**

## Exemplos

### ✅ Bom

> Eric: "Já que vou implementar a feature-âncora, posso aproveitar e adicionar métricas detalhadas (capacidade Z)."
>
> Skill ativa: "Verifiquei `docs/features/F1-<slug>.md` § Escopo. Instrumentação está sim listada como capacidade. MAS a capacidade Z específica não é mencionada — F1 prevê só o básico. Status: zona cinzenta.
>
> Opções:
> 1. Manter só o básico na Fase 0 (alinhado ao plano).
> 2. Adicionar a capacidade Z agora (atualizar F1 spec primeiro).
>
> Recomendo opção 1 — a capacidade Z está prevista numa feature de fase posterior (`F7-<slug>.md`). Adicionar agora vira scope-creep de fase futura puxado pra Fase 0."

### ❌ Ruim

> Eric: "Vou aproveitar e fazer auth básica no edge."
>
> Skill **não ativa** ou ativa mas é ignorada: implementação avança.
>
> Resultado: Fase 0 (que tem "sem auth" no escopo OUT) ganha código de auth não-testado, não-revisado, e a Fase 2 vai herdar débito. Gate da Fase 0 atrasa.

### Caso especial: refactor "preparatório"

Frase típica: "Vou já deixar o código preparado pra multi-tenant que vem na Fase 2."

Geralmente **NÃO**. Faz parte da disciplina YAGNI:
- Construir abstração agora pra "futuro" gera código não-validado.
- Quando a Fase 2 vier, requisitos podem ter mudado.
- O `@architect` provavelmente recusaria isso em revisão.

Exceção: se custo de fazer agora é trivial E custo de fazer depois é alto (ex: nome de coluna). Aí ok, mas DECLARAR.

## Anti-padrões desta skill

- ❌ Aceitar zona cinzenta como "se está em dúvida, faz" — força decisão.
- ❌ Confundir "refator de qualidade" (dentro do código que está mexendo) com scope-creep (capacidade nova).
- ❌ Não consultar a feature-spec ativa antes de classificar.
