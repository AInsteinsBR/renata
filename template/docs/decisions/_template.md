# ADR-NNN — {{TÍTULO CONCISO}}

- **Status:** proposed | accepted | superseded
- **Data:** YYYY-MM-DD
- **Autor:** {{nome}} ({{papel}})
- **Supersedes:** —
- **Superseded by:** —

---

## Contexto

(1-3 parágrafos — situação que força a decisão. **Por que agora**, não só **o quê**. Sem contexto, ADR vira papel morto.)

## Decisão

(em 1-2 frases — o que foi decidido)

## Alternativas consideradas

| Opção | Por que NÃO foi escolhida |
|---|---|
| **Alternativa A** | razão concreta |
| **Alternativa B** | razão concreta |

> Pelo menos 2 alternativas explicitamente rejeitadas. Decisão sem alternativa considerada é fé, não decisão.

## Justificativa amarrada

(restrição de persona, ADR anterior, ou constraint operacional)

- **Restrição @persona/{{NOME}}:** {{como amarra}}
- **Restrição @ADR-{{N}}:** {{como amarra}}
- **Restrição @operacional:** {{como amarra}}

> Decisão sem âncora vira ADR órfã (e violada toda sprint).

## Trade-offs aceitos

(o que estamos abrindo mão)

## Gatilho de revisão

(quando essa decisão deve ser revisitada)

Revisitar se:

1. {{condição 1}}
2. {{condição 2}}

> ADR sem gatilho de revisão é fé religiosa. Toda decisão envelhece.

## Enforcement

(como o código garante essa decisão)

- **Hook:** {{regra em `.claude/rules.yaml` se aplicável}}
- **Lint:** {{regra custom no CI se aplicável}}
- **Review checklist:** {{item se aplicável}}
- **Test:** {{teste que valida se aplicável}}
