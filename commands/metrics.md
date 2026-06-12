# /renata:metrics — Define ou refina métricas do produto

Você é um Product Manager + Data Lead. Recebe contexto em `$ARGUMENTS` (opcional) e estrutura métricas em 4 camadas em `docs/business-context/metricas.md`.

## Antes de gerar

1. **Se `docs/business-context/metricas.md` já existe**, refine em vez de sobrescrever — leia o conteúdo atual e use as perguntas abaixo para identificar lacunas/inconsistências antes de reescrever.
2. Leia `@docs/prd/` — métrica decisiva precisa amarrar com hipótese do PRD.
3. Leia `@docs/business-context/personas.md` — métricas servem personas específicas.
4. Leia `@docs/business-context/jornada.md` se existir — pontos críticos da jornada geram métricas.
5. Se faltar PRD ou persona, instrua a rodar `/renata:prd` ou `/renata:persona` primeiro.
6. Pergunte UMA por vez:

   **Camada 1 — Adoção (alguém usa?):**
   - Qual é o sinal mínimo de uso? Como medir? Meta inicial e meta de prod?

   **Camada 2 — Engajamento (usa direito?):**
   - O que significa "usar bem"? (sessões longas, retornos, etc) — métrica + meta.

   **Camada 3 — Valor (entrega resultado?):**
   - Qual é a métrica que prova ROI pra stakeholder? Baseline e meta?
   - **Esta é a métrica decisiva** — deve bater com **uma hipótese do PRD**. Se o PRD tem N hipóteses, há **N métricas decisivas** (uma por hipótese); deixe explícito qual métrica decide qual hipótese.

   **Camada 4 — Qualidade percebida (específica do produto):**
   - Tem alguma dimensão de qualidade que outras camadas não capturam? (Ex: "parece humano", "responde bem", etc) — opcional, mas valioso pra produtos que dependem de experiência.

   **Métricas técnicas que destravam negócio:**
   - Quais limites técnicos (latência, FPS, custo unitário, uptime) são pré-requisito pra métricas de negócio?

   **Kill criteria / tripwire (obrigatório por métrica):**
   - Qual é o número que, se atingido, **dispara uma decisão** (não só um alerta)? Ex: "se adoção < 10% do alvo em 30 dias → para e repensa a feature". Alvo sem tripwire é dashboard, não instrumento de gestão.
   - Qual é a **ação** disparada? (repensar feature · reabrir PRD · rodar `/renata:hypothesis-check` · candidata a sunset).

   **Estado do baseline (estimado vs medido):**
   - O baseline atual é **chute** ou **medido de verdade**? Se chute: a métrica está **instrumentada** (evento/telemetria existe)? Se não, isso é dívida — marque com TODO 🟡 (`/renata:todo`) "instrumentar antes de declarar pronto".

   **Cadência de revisão:**
   - Quem revê qual métrica e com que frequência?

## Regras de qualidade

- ❌ Métrica sem **baseline** → fantasia. Estimar mesmo que aproximado.
- ❌ Métrica sem **fórmula explícita** → não dá pra medir.
- ❌ Métrica sem **fonte** (de onde vem o dado?) → impossível auditar.
- ❌ Métrica decisiva (Camada 3) sem amarração à hipótese do PRD → recusar.
- ❌ "NPS" sozinho na Camada 3 → vago demais. NPS é Camada 4 ou métrica secundária.
- ❌ Mais de 1 métrica decisiva → escolher uma. Outras viram secundárias.
- ❌ Falta de **anti-métricas** explícitas → exigir.
- ❌ Métrica sem **kill criteria / tripwire** → recusar. Todo alvo precisa de um número que dispara decisão. "Subir é bom" não é gestão.
- ❌ Kill criteria que dispara **alerta** mas não **ação** → insuficiente. "Hipótese em risco" não é ação; "rodar `/renata:hypothesis-check` e decidir sunset" é.
- ❌ Baseline marcado como medido sem **fonte instrumentada** → é chute disfarçado. Estimativa honesta vira dívida (`/renata:todo` 🟡 "instrumentar"), não baseline final.

## Estrutura

```markdown
# Métricas · {{Produto}}

> 3 camadas canônicas: **adoção** · **engajamento** · **valor**.
> Adicione a 4ª (**qualidade percebida**) se o produto exige.

---

## 1 · Adoção

**Métrica:** {{nome}}.
**Como medir:** {{fórmula}}.
**Baseline:** {{valor}} · **estado:** {{🟡 estimado (chute) | ✅ medido — fonte instrumentada}}.
**Meta inicial:** {{valor}}.
**Meta prod:** {{valor}}.
**Por que essa métrica:** {{justificativa}}.
**🔫 Kill criteria:** se {{métrica}} {{< X}} em {{período}} → **{{ação: repensar feature | reabrir PRD | rodar /renata:hypothesis-check | candidata a sunset}}**.

## 2 · Engajamento

(mesma estrutura — incluindo **estado do baseline** e **kill criteria**)

**Métrica secundária:** {{nome opcional}}.

## 3 · Valor

**Métrica decisiva:** {{nome}}.
**Como medir:** {{fórmula}}.
**Baseline:** {{valor estimado, fonte}} · **estado:** {{🟡 estimado | ✅ medido}}.
**Meta {{fase}}:** {{valor}}.
**🔫 Kill criteria:** se {{métrica}} {{< X}} em {{período}} → **{{ação}}**. _(É o tripwire da hipótese que esta métrica decide — quando dispara, `/renata:hypothesis-check` é obrigatório.)_
**Por que essa métrica:** {{esta é a métrica do CFO/stakeholder. Amarra com qual hipótese do PRD (H1, H2…)}}.

## 4 · Qualidade percebida (opcional)

(use se o produto depende de experiência subjetiva)

**Métrica:** {{nome}}.
**Como medir:** {{pesquisa, sampling}}.
**Meta {{fase}}:** {{valor}}.
**Por que essa métrica:** {{esta é a métrica de falsificabilidade da diferenciação do produto}}.

---

## Métricas técnicas que destravam as de negócio

| Métrica técnica | Alvo | Por que importa |
|---|---|---|
| ... | ... | ... |

---

## O que **NÃO** é métrica deste produto

- ❌ {{exemplo de métrica de vaidade}} — {{por que não}}.
- ❌ {{exemplo de métrica de input vs output}} — {{por que não}}.

---

## Cadência de revisão

- **Métricas técnicas:** {{quem, frequência}}.
- **Métricas de produto:** {{quem, frequência}}.
- **Métrica decisiva:** {{quem, frequência — geralmente mensal com stakeholder executivo}}.
- **Métrica de qualidade percebida:** {{frequência maior, ex: trimestral}}.
```

## Após gerar

- Grave em `docs/business-context/metricas.md`.
- Atualize `CLAUDE.md` seção 2 referenciando o arquivo (se ainda não estava).
- Para o próximo passo verificado contra os pré-requisitos, rode /renata:status.

## Argumentos

`$ARGUMENTS`: opcional — contexto extra ou métricas já em mente.
