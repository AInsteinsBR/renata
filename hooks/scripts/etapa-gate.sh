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
# Recebe via stdin o JSON do evento. O YAML é lido pelo parser embutido
# (progress-map-lib.sh — sem dependência de yq). O JSON do evento precisa de
# `jq` OU `python3`; sem nenhum dos dois, o gate avisa ALTO e permite (exit 0)
# — nunca trava o usuário por falta de tooling, mas nunca desliga em silêncio.

set -uo pipefail

MAP=".claude/progress-map.yaml"
[[ -f "$MAP" ]] || exit 0  # sem mapa, nada a impor

# Localiza a lib ao lado deste script sem depender de binários externos (dirname).
SCRIPT_DIR="${BASH_SOURCE[0]%/*}"
[[ "$SCRIPT_DIR" == "${BASH_SOURCE[0]}" ]] && SCRIPT_DIR="."
if ! source "$SCRIPT_DIR/progress-map-lib.sh" 2>/dev/null; then
  echo "⚠ RENATA: etapa-gate OFF — progress-map-lib.sh não encontrado ao lado do gate." >&2
  exit 0
fi

INPUT=$(cat)

# 1) Ler o comando invocado a partir do stdin do hook. O slash command chega em
#    campos diferentes conforme a ferramenta: .tool_input.command (Bash),
#    .tool_input.skill (Skill — ex. "renata:plan-phase", sem barra),
#    .tool_input.prompt / .prompt (variações).
if command -v jq >/dev/null 2>&1; then
  INVOKED=$(printf '%s' "$INPUT" | jq -r '.tool_input.command // .tool_input.prompt // .tool_input.skill // .prompt // empty' 2>/dev/null)
elif command -v python3 >/dev/null 2>&1; then
  INVOKED=$(printf '%s' "$INPUT" | python3 -c '
import json, sys
try:
    d = json.load(sys.stdin)
except Exception:
    sys.exit(0)
ti = d.get("tool_input") or {}
print(ti.get("command") or ti.get("prompt") or ti.get("skill") or d.get("prompt") or "")
' 2>/dev/null)
else
  echo "⚠ RENATA: etapa-gate OFF — nem jq nem python3 disponíveis pra ler o evento do hook. Instale um deles (ex.: brew install jq)." >&2
  exit 0
fi
[[ -z "${INVOKED:-}" ]] && exit 0

# 2) Normalizar antes de casar: primeiro token (descarta args), sem barra
#    inicial, sem namespace do plugin. Casa "/plan-phase 0",
#    "/renata:plan-phase 0" e "renata:plan-phase" (campo skill).
normalize() {
  local s="${1%% *}"
  s="${s#/}"
  s="${s#renata:}"
  printf '%s' "$s"
}
INVOKED_N=$(normalize "$INVOKED")
[[ -z "$INVOKED_N" ]] && exit 0

# 3) Mapear o comando invocado → num da etapa, comparando os BASENAMES
#    normalizados (o mapa guarda "/plan-phase <fase>"; etapas "(manual) ..."
#    não têm slash e são ignoradas aqui).
TARGET_NUM=""
TARGET_NAME=""
TARGET_PREREQS=""
while IFS=$'\t' read -r num name cmd glob needle opt prereq; do
  map_name="${cmd%% *}"                       # primeiro token do campo command
  [[ "$map_name" == /* ]] || continue         # só etapas com slash command real
  map_name="${map_name#/}"
  [[ -z "$map_name" ]] && continue
  if [[ "$INVOKED_N" == "$map_name" ]]; then
    TARGET_NUM="$num"
    TARGET_NAME="$name"
    TARGET_PREREQS="$prereq"
    break
  fi
done < <(pm_rows "$MAP")

# Não é um command de etapa rastreado → permite
[[ -z "$TARGET_NUM" ]] && exit 0
[[ -z "$TARGET_PREREQS" ]] && exit 0  # sem prereq, libera

# 4) Para cada prereq, checar artefato presente + não-placeholder.
MISSING=()
for p in $TARGET_PREREQS; do
  row=$(pm_row "$MAP" "$p")
  [[ -z "$row" ]] && continue
  IFS=$'\t' read -r _pnum pnome _pcmd pglob pneedle _popt _pprereq <<< "$row"

  # existe algum arquivo que casa o glob?
  # compgen -G retorna os matches reais (funciona pra wildcard E caminho literal).
  # (loop em vez de mapfile p/ compat. com bash 3.2 do macOS)
  files=()
  while IFS= read -r _f; do files+=("$_f"); done < <(compgen -G "$pglob" 2>/dev/null)

  if [[ ${#files[@]} -eq 0 ]]; then
    MISSING+=("Etapa $p ($pnome): nenhum artefato em '$pglob'")
    continue
  fi

  # se há needle, ao menos 1 arquivo precisa contê-lo (anti-placeholder)
  if [[ -n "$pneedle" ]]; then
    if ! grep -lq -- "$pneedle" "${files[@]}" 2>/dev/null; then
      MISSING+=("Etapa $p ($pnome): artefato existe mas parece placeholder (falta '$pneedle')")
    fi
  fi
done

# 5) Veredito
if [[ ${#MISSING[@]} -gt 0 ]]; then
  {
    echo "⛔ Gate de etapa: você está tentando a Etapa $TARGET_NUM ($TARGET_NAME),"
    echo "   mas pré-requisitos canônicos não estão satisfeitos:"
    for m in "${MISSING[@]}"; do echo "   • $m"; done
    echo ""
    echo "   Rode /renata:status para ver o próximo passo correto. Complete os prereqs antes."
    echo "   (Para entender a ordem: METHOD.md, seção 'Por que essa ordem?'.)"
  } >&2
  exit 2
fi

exit 0
