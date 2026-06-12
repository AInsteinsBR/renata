# /persona — Extrai persona estruturada

Você é um pesquisador de produto. Recebe um nome/papel em `$ARGUMENTS` e extrai persona estruturada, adicionando em `docs/business-context/personas.md`.

## Antes de gerar

1. Leia `@CLAUDE.md` para contexto do produto.
2. Verifique se persona já existe em `docs/business-context/personas.md`. Se sim, refine.
3. Pergunte em até 4 turnos (não tudo de uma vez):

   **Turno 1 — Papel e contexto:**
   - Que cargo essa pessoa tem? Em que tipo de empresa? Que tamanho?
   - Qual é a rotina dela?

   **Turno 2 — Dor específica:**
   - Qual a dor dela com **número** (horas, %, R$, frequência)?
   - O que ela já tentou fazer pra resolver? Por que falhou?

   **Turno 3 — Critério de sucesso:**
   - Em palavras dela: "Quando vou saber que ganhei?"
   - Qual seria a frase âncora dela sobre o problema?

   **Turno 4 — Anti-persona:**
   - Quem NÃO é essa persona? Quem se parece mas não é?

## Regras de qualidade

- ❌ Persona sem nome próprio → exija ("Marina", não "EM").
- ❌ Dor sem número → exija. "Perde tempo" é desejo; "perde 6h/semana" é dor.
- ❌ Sem "o que já tentou" → exija. Histórico de tentativas falidas é gold.
- ❌ Sem anti-persona → exija. Definir quem não é evita escopo difuso.

## Estrutura

Cada persona tem 2 blocos de citação que servem propósitos diferentes — não confunda:

- **Critério de sucesso** → frase mais longa, descritiva. Responde "quando vou saber que ganhei?". A persona descrevendo a vitória.
- **Frase âncora** → lema curto e impactante (1 linha). Responde "qual é o grito de guerra da dor?". Vai virar mantra do time.

```markdown
## {{Nome}} · {{Papel}} ({{primária | secundária | indireta}})

**Papel + contexto:**
{{cargo, empresa, tamanho, rotina}}

**Dor específica:**

- {{ponto 1 com número}}
- {{ponto 2 com número}}

**Alternativas que já tentou:**

- **{{tentativa}}** — {{por que falhou}}
- ...

**Critério de sucesso (palavras dela — descritivo):**
> "{{citação mais longa descrevendo o cenário de vitória}}"

**Frase âncora (lema curto e impactante):**
> "{{1 linha que captura a dor central}}"
```

E para anti-personas, **uma única seção consolidada ao final do arquivo** (não por persona):

```markdown
## Quem **não** é persona deste produto

- ❌ **{{quem}}** — {{por que não}}
- ❌ ...
```

> ⚠️ **Quando rodar `/persona` para múltiplas personas:** o arquivo `personas.md` vai conter N blocos de persona seguidos por **uma única** seção "Quem não é persona". Cada execução de `/persona` deve:
> 1. Adicionar a nova persona como bloco separado.
> 2. Mergir os "anti-personas" dela com a seção consolidada existente (não duplicar; se já tem item igual, manter).
> 3. Manter o header global do arquivo (`# Personas · {{Produto}}` + tese) inalterado.

## Após gerar

- Append em `docs/business-context/personas.md` (não sobrescreve).
- Se for a primeira persona, marque como `persona-âncora` no `CLAUDE.md` seção 1.
- Para o próximo passo verificado contra os pré-requisitos, rode /status.

## Argumentos

`$ARGUMENTS`: nome + papel resumido (ex: "Marina · Engineering Manager").
