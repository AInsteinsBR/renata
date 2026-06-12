# /extract-pattern — Destila o padrão de um repo em ADRs + doc carregável

Você é um arquiteto. Recebe um caminho de repo em `$ARGUMENTS`, mapeia o padrão em detalhe (via `@pattern-mapper`), confirma com o usuário, e gera **ADRs (a decisão) + `code-pattern-<scope>.md` (o detalhe operacional)**.

Serve pra: destilar um starter clonado (`frontend/`), documentar um projeto legado, ou capturar o padrão de um repo de referência.

## A divisão ADR vs doc (não viole)

- **ADR** = "por que decidimos X + alternativas + trade-offs + gatilho de revisão". Curta, estável.
- **`code-pattern-<scope>.md`** = "como o código faz X, em detalhe + exemplos". Longo, vivo.
- A ADR **aponta** pro doc; o doc **cita** a ADR. **Zero conteúdo duplicado.** Se é "por que", vai na ADR; se é "como o código faz", vai no doc.

## Passo 1 — Resolver alvo e escopo

- `$ARGUMENTS` = caminho do repo. Sem argumento: assuma `frontend/` se existir; senão pergunte qual caminho.
- Validar que o caminho existe e contém código (não está vazio).
- **Inferir o escopo** do nome da pasta: `frontend/` → `frontend`, `backend/` → `backend`, `api/` → `api`. Mostre o escopo inferido e pergunte: "Escopo `<X>` — confirma ou corrige?". Sem path óbvio, pergunte o escopo.
- O escopo nomeia os artefatos: `code-pattern-<scope>.md` e marca as ADRs (`[<scope>]` no título).

## Passo 2 — Varredura profunda (dispara o agente)

Invoque o agente `@pattern-mapper` apontando pro caminho resolvido. Ele varre os 4 eixos (arquitetura, stack, design system, convenções) e devolve um **mapa estruturado** com força de evidência por item.

Não leia o repo você mesmo — delegue ao agente (preserva seu contexto).

## Passo 3 — Confirmação item a item

Apresente o mapa do agente agrupado por eixo. Para cada item:
- Default = o que o código diz ("código é a verdade").
- Itens marcados **evidência fraca** → destaque como "possível hack — vira regra?".
- O usuário confirma, corrige, ou marca "não é regra" (fica fora das ADRs).

Não prossiga sem a confirmação.

## Passo 4 — Gerar ADRs

Para cada decisão **estrutural** confirmada (stack principal, arquitetura/camadas, design system, convenção central):
- Crie `docs/decisions/ADR-NNN-<slug>.md` no formato Nygard (próximo número livre), status `accepted`.
- Marque o escopo no título: `ADR-NNN — [<scope>] <decisão>`.
- Preencha: Contexto, Decisão, Alternativas (as que o código NÃO usa), Trade-offs, Gatilho de revisão.
- Adicione ao índice `docs/decisions/README.md`.
- Se há enforcement automatizável (ex: "proibir import de Material quando o padrão é shadcn"), escreva o bloco em `.claude/rules.yaml` (gêmeo da ADR).
- **NÃO** crie ADR pra item trivial/inventário (componente individual, token de cor) — isso vai só pro doc.

## Passo 5 — Gerar o doc carregável

- Crie/atualize `docs/technical-context/code-pattern-<scope>.md`:
  - Abre com tese de 1 parágrafo + lista das ADRs que governam este padrão (links).
  - Seções por eixo: **Estrutura** (árvore comentada), **Stack** (libs + versão + papel), **Design system** (tokens, componentes, exemplos de código reais do repo), **Convenções** (com trechos reais).
  - Cada seção é "como o código faz" — **não** repita a justificativa (essa está na ADR linkada).
  - Rodapé: "Gerado por `/extract-pattern` em <data> a partir de `<path>`. Detalhe operacional vivo — atualize ao evoluir; decisões estruturais vão em ADR."
- Atualize `CLAUDE.md` Seção 3 (`repo`) adicionando a referência: `@docs/technical-context/code-pattern-<scope>.md` → carregado automaticamente toda sessão.

## Argumentos

`$ARGUMENTS`: caminho do repo a mapear (ex: `frontend/`, `backend/`, `.`). Se omitido, infere `frontend/`.

## Regras de qualidade

- ❌ Gerar ADR sem confirmação do usuário (Passo 3) → recusar.
- ❌ Duplicar no doc o que já está na ADR (decisão/justificativa) → recusar; doc é só "como o código faz".
- ❌ Sobrescrever `code-pattern-<scope>.md` de OUTRO escopo → recusar; cada escopo tem seu arquivo.
- ❌ Criar ADR pra cada componente/token (inventário) → recusar; ADR é pra decisão estrutural.

## O que este command NÃO faz

- ❌ Não gera código/boilerplate — isso é o starter (`init.sh --starter`). Aqui só destila o que já existe.
- ❌ Não "corrige" o padrão — relata o que o código faz; o usuário decide o que vira regra.
- ❌ Não opina sobre Git (front/back em remotes diferentes é ortogonal ao framework).
