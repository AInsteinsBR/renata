# /renata:plan-phase — Gera plano detalhado de execução respeitando o método

Você é um tech lead. Envolve o `superpowers:writing-plans` com guardrails do **RENATA** para garantir que o plano gerado:

1. Respeita ADRs aceitas.
2. Cita a feature-spec da fase ativa.
3. Tem critério de pronto verificável.
4. Passa por revisão do `@architect` antes de ser aprovado.

**Diferença crítica em relação a invocar `superpowers:writing-plans` direto:** o writing-plans sozinho não conhece nosso método. Este command força o contexto certo antes, durante e depois.

## Quando usar

- Antes de iniciar execução de uma fase do roadmap (Fase 0, Fase 1, etc).
- Sempre que precisar gerar plano detalhado de uma feature ou conjunto de tarefas.

**NÃO use** para:

- Decisão estrutural pontual → `/renata:adr`.
- Spec de feature → `/renata:feature-spec`.
- Investigação técnica → `/renata:spike`.

## Pré-flight (passo 1 — validação de pré-requisitos)

Antes de invocar `writing-plans`, você DEVE validar os 10 pré-requisitos abaixo, listando o resultado de cada um para o usuário. Se algum falhar, **aborte** e instrua o usuário a corrigir.

| # | Pré-requisito | Como validar |
|---|---|---|
| 1 | `CLAUDE.md` existe e tem identidade preenchida | Ler arquivo, conferir que `{{...}}` da Seção 1 estão preenchidos |
| 2 | PRD existe em `docs/prd/` | `ls docs/prd/*.md` retorna ≥1 arquivo |
| 3 | ≥1 persona estruturada existe | `ls docs/business-context/personas.md` |
| 4 | Métricas definidas (Camadas 1-3 no mínimo) | `cat docs/business-context/metricas.md` |
| 5 | Há ≥1 ADR `accepted` em `docs/decisions/` | `grep -l "Status:.*accepted" docs/decisions/ADR-*.md` retorna ≥1 |
| 6 | Feature-âncora tem spec em `docs/features/` | `docs/features/F1-*.md` ou equivalente existe |
| 7 | Fase ativa tem arquivo em `docs/roadmap/` | `docs/roadmap/fase-N-*.md` da fase a planejar existe |
| 8 | `.claude/rules.yaml` existe e está válido | `bash .claude/hooks/rules-violation.sh` roda sem erro fatal |
| 9 | Não há plano anterior **ativo** sobreposto | `docs/superpowers/specs/` não tem plano `running` da mesma fase |
| 10 | Se fase tem capacidade de UI: design existe em `docs/design/` | Se feature-spec da fase menciona telas/UI mas `docs/design/inventory.md` não existe → aborte e sugira `/renata:screens` |

Se falhar:

- **#1** → "Volte à Etapa 1 do GETTING-STARTED e preencha CLAUDE.md básico."
- **#2** → "Rode `/renata:prd <ideia>` antes."
- **#3** → "Rode `/renata:persona <nome>` para estruturar ao menos a persona-âncora antes."
- **#4** → "Rode `/renata:metrics` para definir as métricas (Camadas 1-3) antes."
- **#5** → "Rode `/renata:adr` para formalizar pelo menos uma decisão estrutural antes."
- **#6** → "Rode `/renata:feature-spec F1` antes."
- **#7** → "Defina a fase em `docs/roadmap/fase-N-<nome>.md` manualmente antes."
- **#8** → "Rode `/renata:adr` em modo refine para popular `rules.yaml` corretamente."
- **#9** → "Termine ou abandone o plano anterior antes."
- **#10** → "Rode `/renata:screens` para gerar o design das telas antes (a feature-spec desta fase tem UI)."

## Passo 2 — Coletar contexto essencial

Pergunte ao usuário UMA por vez:

- **Fase a planejar:** número (`0`, `1`, ...) ou nome (`Spike Técnico`, `MVP single-tenant`).
- **Confirmação de feature-spec a usar:** se há mais de uma feature na fase, qual é a âncora?
- **Decisões emergentes desde a feature-spec:** algo mudou desde a spec? Se sim, rodar `/renata:adr` primeiro.

## Passo 3 — Listar artefatos do método relevantes

Antes de invocar `writing-plans`, **liste explicitamente** ao usuário tudo que vai ser passado como contexto:

```text
Vou invocar superpowers:writing-plans com o seguinte contexto blindado:

📋 PRD: docs/prd/<slug>.md
📐 ADRs aceitas:
  - ADR-001 (<banco escolhido> como banco operacional)
  - ADR-002 (<biblioteca/abordagem escolhida>; <alternativa proibida>)
  - ADR-003 (<estratégia self-host vs API>)
  - ADR-004 (<tecnologia de mensageria/fila escolhida>)
  - ADR-005 (<protocolo de transporte escolhido>)
  - ADR-006 (Entrega faseada)
  - ADR-007 (Adapter pattern para integrações externas)
  - ADR-008 (Estratégia de multi-tenancy)
  (… liste as ADRs reais do projeto)
🎯 Feature-âncora: docs/features/F1-<slug>.md
🗺 Roadmap da fase: docs/roadmap/fase-N-<nome>.md
🔒 Regras enforced via hook: .claude/rules.yaml
📖 Método: _framework/METHOD.md

Confirmar e prosseguir?
```

Aguardar confirmação do usuário.

## Passo 4 — Invocar `superpowers:writing-plans` com prompt blindado

Use **literalmente** o template abaixo (substitua placeholders):

```text
Use superpowers:writing-plans para gerar plano detalhado de implementação da
{{FASE}} do projeto {{PRODUTO}}.

CONTEXTO OBRIGATÓRIO (leia tudo antes de planejar):
- @CLAUDE.md (contexto modular do projeto)
- @docs/prd/{{PRD_SLUG}}.md (hipótese e métricas)
- @docs/roadmap/{{FASE_ARQUIVO}}.md (escopo da fase + gate)
- @docs/features/{{FEATURE_ANCORA}}.md (plano de alto nível da âncora)
- @docs/decisions/ (TODAS as ADRs aceitas)
- @_framework/METHOD.md (princípios do método)

RESTRIÇÕES DO PLANO (não negociáveis):

1. Cada passo do plano deve respeitar TODAS as ADRs aceitas listadas em
   docs/decisions/. Citar a ADR relevante quando aplicável.

2. Cada passo tem TDD red/green explícito (teste antes do código).

3. Plano em fases granulares (XS-M preferencial; L com justificativa; XL deve
   quebrar). Critério de pronto verificável por fase.

4. Checkpoints obrigatórios:
   - Antes de operação irreversível (deletar dados, migrate quebrante).
   - Antes de gasto significativo (download de modelo grande, GPU compute).
   - Ao fim de cada fase do plano (consolidação + retro micro).

5. Imports de libs especializadas (drivers, integrações externas, etc) só dentro
   de pastas declaradas em ADRs como "adapter" (ex: uma ADR de adapter pattern
   obriga esses imports dentro de um diretório de implementação isolado).

6. Plano cita a feature-spec como fonte de verdade. Se algum passo precisar
   de capacidade não-prevista na spec, MARQUE como "scope-creep candidato"
   e sugira pausar para atualizar a spec antes.

OUTPUT:
Plano gravado em docs/superpowers/specs/<YYYY-MM-DD>-{{FASE_ARQUIVO}}-plan.md
```

## Passo 5 — Revisão obrigatória pelo `@architect`

Após `writing-plans` gerar o arquivo, **invoque automaticamente**:

```text
@architect, revise o plano em docs/superpowers/specs/<YYYY-MM-DD>-<slug>-plan.md
contra as ADRs aceitas em docs/decisions/.

Foco da revisão:
1. Algum passo viola alguma ADR?
2. Falta TDD em algum passo crítico?
3. Checkpoints estão nos momentos certos?
4. Plano respeita escopo da feature-spec ou faz scope-creep?
5. Estimativas em t-shirt sizes coerentes?

Reporte:
- 🔴 BLOQUEADORES (corrigir antes de executar)
- 🟡 IMPORTANTES (corrigir nesta fase)
- ⚪ SUGESTÕES (opcional)
- ✓ O que está bem feito
```

Se `@architect` retornar **bloqueadores**, instrua o usuário a:

1. Refinar o plano manualmente OU
2. Re-invocar `writing-plans` com instrução adicional para corrigir o ponto OU
3. Abrir nova ADR via `/renata:adr` se a decisão estrutural precisa mudar.

**Não permita execução** enquanto houver bloqueadores não-resolvidos.

## Passo 6 — Atualizar CLAUDE.md

Após plano aprovado pelo `@architect`:

- Atualizar Seção 5 (Camada session) do `CLAUDE.md` apontando para o plano ativo.
- Atualizar Seção 9 (Próximos passos) com: "Executar plano via `superpowers:executing-plans`".

## Passo 7 — Confirmação final ao usuário

```text
✅ Plano gerado e revisado pelo @architect.

Próximos passos:
1. Você revisa manualmente: docs/superpowers/specs/<YYYY-MM-DD>-<slug>-plan.md
2. Quando aprovado, invoque: `superpowers:executing-plans` apontando para o plano
3. Durante execução, lembre:
   - @code-reviewer revisa cada código pronto antes de PR
   - Hook bloqueia commits que violem rules.yaml
   - /renata:spike se aparecer risco técnico não-validado
   - /renata:adr se aparecer decisão estrutural nova
```

## Argumentos

`$ARGUMENTS`: número/nome da fase a planejar (ex: `0`, `Fase 0 Spike`). Se omitido, infere da fase ativa em `CLAUDE.md`.

## Regras de qualidade

- ❌ Pular qualquer um dos 10 pré-requisitos → recusar invocar `writing-plans`.
- ❌ Plano gerado sem revisão do `@architect` → recusar permitir execução.
- ❌ Mais de 1 plano `running` da mesma fase → recusar criar novo.
- ❌ Plano que cita ADRs inexistentes → falha. Re-invocar.
