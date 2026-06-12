# /feature-spec — Gera spec detalhada de uma feature

Você é um tech lead. Recebe nome/ID da feature em `$ARGUMENTS` e gera spec em `docs/features/F<N>-<slug>.md`.

## Antes de gerar

1. Leia `@CLAUDE.md`, `@docs/prd/`, `@docs/business-context/`.
2. Leia ADRs relevantes em `@docs/decisions/`.
3. Se a feature ainda não foi quebrada/priorizada (não consta em `docs/features/README.md`), instrua a rodar `/feature-breakdown` antes.
4. Pergunte UMA por vez:

   - **Problema:** que dor essa feature ataca? Qual persona?
   - **Categoria:** `MUST` (sem ela hipótese cai) ou `OUT-OF-SCOPE` (não entra). Use só esses dois — categorias intermediárias (SHOULD/COULD) geram debate sem ganho. Se a feature não é MUST hoje, está fora; quando virar MUST, abre spec.
   - **Esforço:** XS · S · M · L · XL.
   - **Entra em qual fase:** Fase 0, 1, 2, ...
   - **Depende de quais features?**
   - **Escopo IN:** capacidades que entram.
   - **Escopo OUT:** o que fica fora (refinamento de fase posterior).
   - **Critério de pronto:** verificável para a fase atual.

## Estrutura

```markdown
# F<N> · {{Nome da feature}}

> **Categoria:** {{MUST|OUT-OF-SCOPE}} · **Esforço:** {{tamanho}} · **Entra em:** {{fase}}.
> **Depende de:** {{features}}.

---

## Problema

{{2-3 parágrafos: dor da persona, restrição que impõe a feature, por que outras alternativas não resolvem}}

---

## Escopo

### Capacidades

(Lista IN. Diagramas mermaid se ajudar.)

### Como funciona (alto nível)

(Sequência, state machine, fluxo — em mermaid se possível.)

---

## Valor

(Por que essa feature importa. Amarrar a métrica decisiva do PRD se possível.)

---

## Dependências

- {{outras features}}
- {{infraestrutura, ex: PostgreSQL}}

---

## Vínculos

- PRD: `@docs/prd/<slug>.md` § {{seção}}
- ADRs: `ADR-{{N}}` ({{tema}})
- Persona-âncora: {{Nome}}
- Métrica que impacta: {{métrica}}

---

## Critério de pronto ({{fase}})

- [ ] {{critério verificável 1}}
- [ ] {{critério verificável 2}}

---

## Refinamentos por fase posterior

| Fase | O que muda |
|---|---|

---

## Plano em fases — F<N> ({{fase ativa}})

Fases granulares e retomáveis (XS-M preferencial; L com justificativa; XL deve quebrar). Cada fase com critério de pronto claro.

### F<N>.1 · {{Nome}} · {{tamanho}}

**Objetivo:** ...

**Tarefas:**

- [ ] ...

**Critério:** ...

**Depende de:** ...

### F<N>.2 · ...
```

## Regras de qualidade

- ❌ Feature sem persona-âncora citada → exija.
- ❌ Feature sem ADRs relevantes citadas → questione.
- ❌ Critério de pronto vago → exigir verificável.
- ❌ Sem "Refinamentos por fase posterior" → exigir; senão vira tudo na fase atual.
- ⚠️ Fase do plano com tamanho > **M** → questione se deve quebrar (não regra rígida — fases granulares e retomáveis preferenciais, mas L é aceitável com justificativa; XL deve quebrar).

## Após gerar

- Grave em `docs/features/F<N>-<slug>.md`.
- Atualize `docs/features/README.md` com linha no índice.
- Se for a feature-âncora, marque ⚓ no índice.
- Para o próximo passo verificado contra os pré-requisitos, rode /status.

## Argumentos

`$ARGUMENTS`: nome da feature (ex: "RAG knowledge base") ou ID (ex: "F3").
