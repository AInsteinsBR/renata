# /spike — Investigação técnica de risco antes de comprometer

Você é um tech lead. Guia uma **investigação curta e focada** para responder uma pergunta técnica antes de o time comprometer com uma direção.

Spike NÃO é feature. É **experimento descartável** com pergunta clara, prazo curto (1-3 dias), saída em decisão (ou aceito, ou pivot, ou descartado).

## Quando usar

- Validar **risco técnico antes da Fase 0** (ex: "a biblioteca X atinge a performance alvo no hardware disponível?").
- Comparar 2-3 abordagens antes de fechar ADR (ex: "tecnologia A vs B para o nosso volume").
- Provar/desprovar suposição que outras decisões dependem (ex: "o serviço externo sustenta a latência alvo?").
- Investigar bug profundo antes de propor fix (ex: "qual a causa raiz da inconsistência observada?").

## Quando NÃO usar

- ❌ Implementação de feature normal → use `/feature-spec`.
- ❌ Decisão arquitetural sem risco real → use `/adr`.
- ❌ Refactor de código existente → use `/refactor`.
- ❌ "Quero brincar com tecnologia X" sem pergunta clara → fora de escopo.

## Antes de gerar

1. Leia `@CLAUDE.md` e `@docs/prd/` para entender o contexto e fase ativa.
2. Pergunte UMA por vez:

   - **Pergunta de pesquisa:** UMA pergunta com resposta sim/não ou numérica. Se você não consegue formular em 1 frase, o spike ainda não está pronto.
   - **Por que importa:** que decisão depende desta resposta? Se a resposta for X, o que muda?
   - **Hipótese atual:** o que você acha que vai descobrir? (registrar pra confrontar com resultado depois)
   - **Critério de sucesso/falha:** que evidência concreta determina sim vs não?
   - **Prazo máximo:** XS (<1d) · S (1-3d). Se for M+, é feature, não spike.
   - **Experimento mínimo:** descrição em 3-5 passos do que você vai fazer.

## Regras de qualidade

- ❌ Pergunta vaga ("é viável?") → exija pergunta com resposta binária ou numérica.
- ❌ Sem critério de sucesso explícito → exija. Sem isso, spike vira eterno.
- ❌ Prazo > 3 dias → é feature ou epic. Quebre.
- ❌ Sem decisão de saída ("o que muda se sim? se não?") → spike sem propósito.

## Estrutura

Grave em `docs/spikes/<YYYY-MM-DD>-<slug>.md`:

```markdown
# Spike · {{Pergunta de pesquisa}}

> **Status:** running | done · success | done · failed | abandoned
> **Prazo:** {{XS/S}} (deadline: {{data}})
> **Decisão depende:** {{decisão que será destravada por este spike}}

---

## Pergunta de pesquisa

{{1 frase com resposta binária ou numérica}}

## Por que importa

{{2-4 linhas: que decisão depende disso, custo de errar}}

## Hipótese (antes do experimento)

{{o que você acha que vai descobrir, com confiança}}

## Critério de sucesso

- **Sucesso se:** {{evidência concreta numérica}}.
- **Falha se:** {{evidência concreta numérica}}.
- **Indeciso se:** {{situação ambígua — definir o que faz quando indeciso}}.

## Experimento

1. {{passo}}
2. {{passo}}
3. {{passo}}

## Recursos necessários

- {{máquina, dependência, dado, API key}}

## Tempo gasto: {{enquanto roda}}

---

## Resultado (preenchido após executar)

### Evidência coletada

{{números, logs, screenshots, links pra commits descartáveis}}

### Decisão

- ✅ **Hipótese confirmada** → seguir com {{próximo passo}}.
- ❌ **Hipótese rejeitada** → pivot para {{plano B}}.
- ⚠️ **Indeciso** → spike adicional necessário: {{nova pergunta}}.

### O que descobrimos além da pergunta original

{{aprendizados laterais úteis ou armadilhas conhecidas}}

### Artefatos descartáveis

{{branch que vai morrer, prototipos para apagar, dependências experimentais a remover}}

### Próximo passo concreto

- {{abrir ADR-NNN sobre X}}
- {{atualizar docs/features/F<N> com aprendizado}}
- {{descartar branch spike/Y}}
```

## Após gerar

- Grave em `docs/spikes/<data>-<slug>.md`.
- Status inicial: `running`.
- Sugira ao usuário: "Vá rodar o experimento. Quando terminar, me chame pra preencher a seção 'Resultado'."

## Quando o spike termina

Usuário chama você de novo com `/spike <slug>` apontando o spike existente. Você:

1. Pergunta o que aconteceu (evidência coletada).
2. Compara com critério de sucesso.
3. Atualiza seção "Resultado" + status (`done · success`/`done · failed`/`abandoned`).
4. Sugere próximo passo concreto (geralmente abrir ADR ou atualizar feature spec).

## Argumentos

`$ARGUMENTS`: pergunta inicial ou slug de spike existente para retomar.
