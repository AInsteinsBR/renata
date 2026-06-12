#!/usr/bin/env bash
# etapa-gate.sh — Hook PreToolUse do RENATA.
#
# Bloqueia a invocação de um command de etapa quando os prereq daquela etapa
# (definidos em .claude/progress-map.yaml) não estão satisfeitos.
#
# Convenção Claude Code PreToolUse:
#   exit 0  → permite a ação
#   exit 2  → BLOQUEIA a ação; stderr volta ao modelo como feedback
#   outro   → erro não-bloqueante (avisa, mas não impede)
#
# Recebe via stdin o JSON do evento. Usa `jq` pra ler o input e `yq` pro YAML.
# Degradação: sem yq/jq → avisa e PERMITE (exit 0), nunca trava o usuário por falta de tooling.

set -uo pipefail

MAP=".claude/progress-map.yaml"

# Sem tooling → não bloqueia (degradação segura)
if ! command -v yq >/dev/null 2>&1 || ! command -v jq >/dev/null 2>&1; then
  echo "⚠ etapa-gate: yq/jq ausente — gate desativado nesta sessão." >&2
  exit 0
fi
[[ -f "$MAP" ]] || { exit 0; }  # sem mapa, nada a impor

# 1) Ler o prompt do command invocado a partir do stdin do hook.
INPUT=$(cat)
# O comando pode chegar de formas diferentes; tentamos o campo de prompt/command.
INVOKED=$(echo "$INPUT" | jq -r '.tool_input.command // .tool_input.prompt // .prompt // empty' 2>/dev/null)

# 2) Mapear o command invocado → num da etapa (via campo `comando` do mapa).
#    Casamos por substring do nome do slash command (ex: "/plan-phase").
TARGET_NUM=""
NUMS=$(yq -r '.etapas[].num' "$MAP")
for n in $NUMS; do
  cmd=$(yq -r ".etapas[] | select(.num == \"$n\") | .comando" "$MAP")
  # Só consideramos etapas cujo `comando` COMEÇA com um slash command real
  # (ignora "(manual) ..." e "superpowers:..."). Extrai o slash do início.
  slash=$(echo "$cmd" | grep -oE '^/[a-z][a-z0-9-]*' | head -1)
  [[ -z "$slash" ]] && continue
  # Casa como TOKEN: o INVOKED é exatamente o slash, ou o slash seguido de espaço.
  # Evita que /plan case dentro de /plan-phase.
  if [[ "$INVOKED" == "$slash" || "$INVOKED" == "$slash "* ]]; then
    TARGET_NUM="$n"
    break
  fi
done

# Não é um command de etapa rastreado → permite
[[ -z "$TARGET_NUM" ]] && exit 0

# 3) Pegar os prereq da etapa-alvo.
PREREQS=$(yq -r ".etapas[] | select(.num == \"$TARGET_NUM\") | .prereq[]" "$MAP" 2>/dev/null)
[[ -z "$PREREQS" ]] && exit 0  # sem prereq, libera

# 4) Para cada prereq, checar artefato presente + não-placeholder.
MISSING=()
for p in $PREREQS; do
  glob=$(yq -r ".etapas[] | select(.num == \"$p\") | .artefato_glob" "$MAP")
  needle=$(yq -r ".etapas[] | select(.num == \"$p\") | .nao_vazio_se" "$MAP")
  nome=$(yq -r ".etapas[] | select(.num == \"$p\") | .nome" "$MAP")

  # existe algum arquivo que casa o glob?
  # Detecta existência de forma robusta p/ glob COM wildcard e caminho literal.
  # compgen -G retorna 0 e lista os matches reais; falha se nada existe.
  # (loop em vez de mapfile p/ compat. com bash 3.2 do macOS)
  files=()
  while IFS= read -r _f; do files+=("$_f"); done < <(compgen -G "$glob" 2>/dev/null)

  if [[ ${#files[@]} -eq 0 ]]; then
    MISSING+=("Etapa $p ($nome): nenhum artefato em '$glob'")
    continue
  fi

  # se há needle, ao menos 1 arquivo precisa contê-lo (anti-placeholder)
  if [[ -n "$needle" && "$needle" != "null" ]]; then
    if ! grep -lq -- "$needle" "${files[@]}" 2>/dev/null; then
      MISSING+=("Etapa $p ($nome): artefato existe mas parece placeholder (falta '$needle')")
    fi
  fi
done

# 5) Veredito
if [[ ${#MISSING[@]} -gt 0 ]]; then
  alvo_nome=$(yq -r ".etapas[] | select(.num == \"$TARGET_NUM\") | .nome" "$MAP")
  {
    echo "⛔ Gate de etapa: você está tentando a Etapa $TARGET_NUM ($alvo_nome),"
    echo "   mas pré-requisitos canônicos não estão satisfeitos:"
    for m in "${MISSING[@]}"; do echo "   • $m"; done
    echo ""
    echo "   Rode /status para ver o próximo passo correto. Complete os prereqs antes."
    echo "   (Para entender a ordem: _framework/METHOD.md, seção 'Por que essa ordem?'.)"
  } >&2
  exit 2
fi

exit 0
