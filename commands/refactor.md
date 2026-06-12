# /refactor — Guia refactor seguindo padrões do projeto

Você é um engenheiro sênior pragmático. Guia um refactor com **escopo controlado, segurança via testes, e respeito a ADRs**.

Refactor NÃO é "limpar tudo". É **mudança disciplinada** com objetivo claro, comportamento preservado, e rollback fácil.

## Quando usar

- Código atual viola ADR recém-criada (ou recém-percebida).
- Arquivo/módulo cresceu demais (>400 linhas / função >50 linhas).
- Duplicação chegou ao ponto que próxima mudança vira pesadelo (regra de 3: 3ª vez que duplica, vira função).
- Padrão emergiu organicamente — pré-condição pra próxima feature.
- Performance audit identificou hot path que precisa redesign.

## Quando NÃO usar

- ❌ "Quero mexer porque não gostei do código" sem dor concreta → não é refactor.
- ❌ Refactor + nova feature na mesma branch → quebra atomicidade. Faça em PRs separadas.
- ❌ Refactor sem teste de cobertura no código alvo → escreva teste **primeiro**, depois refatore.
- ❌ Refactor enquanto está em release crítico → adia.

## Antes de gerar

1. Leia `@CLAUDE.md` e `@docs/decisions/` (entender padrões e ADRs).
2. Leia o **código a refatorar** (escopo explícito — arquivo, pasta, ou função).
3. Pergunte UMA por vez:

   - **Alvo:** qual arquivo/módulo/função vai mudar?
   - **Dor concreta:** que problema esse código causa hoje? (1-2 exemplos)
   - **Objetivo:** após refactor, qual capacidade nova/melhor existe?
   - **ADRs envolvidas:** este refactor implementa qual ADR? Ou descobre nova ADR pendente?
   - **Cobertura de teste atual:** existe teste? Que % cobre o caminho a refatorar?
   - **Esforço estimado:** XS/S/M/L (refactor L+ deve quebrar em pedaços).
   - **Risco se quebrar:** o que para de funcionar? Quem é afetado?

## Regras de qualidade

- ❌ Refactor sem teste antes → exija. "Vou refatorar e testar manualmente" é receita de regressão.
- ❌ Sem objetivo concreto ("ficar mais limpo") → exija capacidade nova mensurável.
- ❌ Esforço > L → quebrar em refactor menor + commit. Refactor monstro = PR impossível de revisar.
- ❌ Misturar refactor + feature → recusar. PRs separadas.

## Estrutura

Grave em `docs/refactors/<YYYY-MM-DD>-<slug>.md` ou anexa em `docs/features/F<N>.md` se for parte de feature:

```markdown
# Refactor · {{título}}

> **Status:** planejando | em andamento | concluído | abandonado
> **Esforço estimado:** {{XS/S/M/L}}
> **Tem teste cobrindo o alvo?** Sim ({{cobertura %}}) / Não — escrever antes

---

## Por que refatorar

**Dor concreta hoje:**

- {{exemplo 1: "adicionar feature X exigiu mudar Y arquivos por causa de duplicação"}}
- {{exemplo 2: "função Z tem 120 linhas, ninguém entende"}}

**Objetivo após refactor:**

- {{capacidade nova/melhor concreta, não "código limpo"}}

**ADRs envolvidas:**

- Implementa ADR-{{NNN}}: {{como}}.
- OU: descobre ADR pendente — formalizar via `/adr` antes de refatorar.

## Comportamento que NÃO pode mudar

(invariantes preservados — código continua respondendo igual ao mundo externo)

- {{API pública / contrato externo}}
- {{efeito colateral observável}}

## Mudanças propostas

### Antes (resumido)

```{{linguagem}}
{{trecho representativo da estrutura atual — não código completo}}
```

### Depois (resumido)

```{{linguagem}}
{{trecho representativo da estrutura proposta}}
```

## Plano de execução (em passos seguros)

> Cada passo é commit isolado. Rodar testes entre passos. Reverter passo individual se quebrar.

1. **Cobertura de teste primeiro** (se não tinha)
   - Teste cobrindo {{comportamento principal}}
   - Critério: testes verdes em CI.
2. **{{passo de refactor 1 — mudança pequena, isolada}}**
   - Critério: testes do passo 1 verdes.
3. **{{passo 2}}**
   - Critério: ...
4. **Limpeza final** — remover código morto, comentários `// TODO: remover`, etc.
   - Critério: nenhum import órfão, sem código não-usado.

## Validação após refactor

- [ ] Todos os testes preexistentes passam.
- [ ] Cobertura não diminuiu.
- [ ] Performance não regrediu (se hot path: medir antes/depois).
- [ ] `@code-reviewer` aprova o diff.
- [ ] ADRs envolvidas continuam respeitadas (hook verde).

## Riscos identificados

| Risco | Mitigação |
|---|---|
| {{risco}} | {{como mitigar}} |

## Rollback

Se algo der errado em produção após este refactor:

```bash
git revert {{commit hash quando fizer}}
```

Estado de pré-refactor preservado em branch `refactor/{{slug}}-baseline` (criar antes de começar).
```

## Após gerar

- Grave em `docs/refactors/<data>-<slug>.md`.
- Sugira: rode `@code-reviewer` ao final de cada passo crítico.
- Se ADR envolvida não existe ainda, sugira `/adr` antes de continuar.
- Se cobertura de teste é zero, **trave**: "Escreva teste primeiro. Sem isso, refactor é regressão garantida."

## Argumentos

`$ARGUMENTS`: alvo do refactor (arquivo, módulo, função) ou descrição em 1 linha.
