---
name: respecting-adrs
description: Use sempre que for propor solução técnica, escrever código, ou implementar feature. Garante que a proposta respeita as ADRs aceitas do projeto antes de qualquer linha de código. Auto-ativa ao detectar contexto de "implementar X", "como faço Y", "vou usar biblioteca Z", ou similar.
---

# Respeitando ADRs antes de codar

ADRs (`docs/decisions/ADR-*.md`) são decisões estruturais do projeto com status `accepted`. **Toda proposta técnica precisa respeitá-las** — violação requer abrir nova ADR superseding, não bypass.

## Quando esta skill ativa

Auto-ativa quando contexto envolve:
- "Implementar X"
- "Vou escrever / codar / criar"
- "Que biblioteca usar"
- "Como faço Y em [linguagem/framework]"
- "Refatorar para usar Z"
- Propor diff/PR

## Procedimento (4 passos)

### Passo 1 — Listar ADRs aceitas relevantes

Rode mentalmente: "Quais ADRs deste projeto podem ter algo a dizer sobre o que vou fazer?"

- **Sempre** consultar `docs/decisions/README.md` (índice).
- Se a proposta toca em: banco → ADR sobre persistência; auth → ADR sobre auth; bibliotecas externas → ADR sobre stack; etc.
- Se não há ADR sobre o tema mas a decisão é estrutural → **abrir ADR primeiro** (`/adr`).

### Passo 2 — Validar proposta contra cada ADR identificada

Para cada ADR relevante:

1. Ler seção "Decisão" e "Enforcement".
2. Confirmar que a proposta **não contradiz** a decisão.
3. Se a ADR tem hook (`.claude/rules.yaml`), garantir que seu código não vai ser bloqueado por ele.

### Passo 3 — Se há conflito, **PARAR**

Não codar. Opções:

- **Refinar proposta** para respeitar a ADR (mais comum).
- **Abrir nova ADR** superseding a antiga, se a decisão antiga realmente está errada (usar `/adr`).
- **Pedir clarificação** ao usuário se o conflito não está claro.

**NUNCA contornar o hook** ou usar workaround silencioso.

### Passo 4 — Citar ADR no commit/PR

Ao implementar, mencionar a ADR relevante:

```text
feat(providers): ClienteRepo em providers/impl (ADR-007 adapter pattern)
```

## Exemplos

### ✅ Bom

> Usuário: "Vou adicionar uma lib de cache no worker pra guardar respostas."
>
> Skill ativa: "Antes de codar, vou consultar ADRs. `ADR-004` define a tecnologia X para o caminho A, OK. Mas esse cache é de outro tipo (key-value) e ADR-004 não cobre esse uso. Vou reusar a mesma infra já disponível com um prefixo dedicado. Não viola ADR-004 nem cria nova decisão estrutural (cache é detalhe de implementação)."

### ❌ Ruim

> Usuário: "Vou adicionar um segundo banco pra persistir sessões."
>
> Skill **NÃO** ativa, ou ativa mas ignora: "Adicionei o driver e criei a tabela sessions..."
>
> Resultado: viola ADR-006 (esse banco está FORA do escopo da fase atual). Hook não vai bloquear (não tem regra), mas decisão estrutural foi tomada sem ADR. Débito técnico criado.

### ❌ Pior

> Usuário: "Preciso usar a biblioteca Z pra um caso específico."
>
> Skill ativa: "ADR-002 proíbe a biblioteca Z explicitamente. Hook vai bloquear. Vou usar mesmo assim e fazer um `# noqa` no import."
>
> NÃO. Se realmente precisa, abrir ADR-009 superseding ADR-002 com justificativa concreta. Senão, refazer a proposta.

## Anti-padrões desta skill

- ❌ "Já sei que essa ADR não se aplica" sem ler — sempre ler.
- ❌ Citar ADR no commit mas não ter validado de fato.
- ❌ Pular Passo 1 ("é óbvio que respeita") — não é óbvio até confirmar.
