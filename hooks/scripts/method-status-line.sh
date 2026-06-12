#!/usr/bin/env bash
# method-status-line.sh — Hook SessionStart do RENATA
#
# Imprime UMA linha resumindo o progresso do projeto no fluxo de 14 etapas.
# Lê .claude/progress-map.yaml. Cosmético: degrada em SILÊNCIO se yq faltar
# ou se o mapa não existir (nunca quebra a sessão).
#
# Saída exemplo:
#   📍 RENATA: Etapa 6/13 (Decisões técnicas (ADRs)) — 5 docs presentes, 3 verificados. Rode /status.

set -uo pipefail

MAP=".claude/progress-map.yaml"

# Degradação silenciosa: sem mapa ou sem yq, não imprime nada.
[[ -f "$MAP" ]] || exit 0
command -v yq >/dev/null 2>&1 || exit 0

N=$(yq '.etapas | length' "$MAP" 2>/dev/null) || exit 0
[[ "$N" =~ ^[0-9]+$ ]] || exit 0
[[ "$N" -gt 0 ]] || exit 0

presentes=0
verificados=0
etapa_atual_num=""
etapa_atual_nome=""

for i in $(seq 0 $((N - 1))); do
  GLOB=$(yq -r ".etapas[$i].artefato_glob" "$MAP")
  NOME=$(yq -r ".etapas[$i].nome" "$MAP")
  NUM=$(yq -r ".etapas[$i].num" "$MAP")
  OPCIONAL=$(yq -r ".etapas[$i].opcional" "$MAP")
  NAO_VAZIO=$(yq -r ".etapas[$i].nao_vazio_se" "$MAP")

  # Expande o glob. compgen -G funciona corretamente para literais E wildcards.
  # Compatível com bash 3.2 (macOS): usa while-read em vez de mapfile.
  arquivos=()
  while IFS= read -r f; do
    # Aplica o filtro de conteúdo (nao_vazio_se): se definido, só conta o
    # arquivo se ele contém a substring — distingue etapas que compartilham glob.
    if [[ -z "$NAO_VAZIO" || "$NAO_VAZIO" == "null" ]]; then
      arquivos+=("$f")
    elif grep -lqF -- "$NAO_VAZIO" "$f" 2>/dev/null; then
      arquivos+=("$f")
    fi
  done < <(compgen -G "$GLOB" 2>/dev/null)

  if [[ ${#arquivos[@]} -gt 0 ]]; then
    presentes=$((presentes + 1))
    # Verificado se ALGUM arquivo do glob tem a linha de verificação.
    if grep -lq "✅ Verificado por você" "${arquivos[@]}" 2>/dev/null; then
      verificados=$((verificados + 1))
    else
      # primeiro artefato presente-mas-não-verificado = etapa atual (exceto opcionais)
      if [[ -z "$etapa_atual_num" && "$OPCIONAL" != "true" ]]; then
        etapa_atual_num="$NUM"
        etapa_atual_nome="$NOME"
      fi
    fi
  else
    # primeiro artefato ausente também é candidato a etapa atual (exceto opcionais)
    if [[ -z "$etapa_atual_num" && "$OPCIONAL" != "true" ]]; then
      etapa_atual_num="$NUM"
      etapa_atual_nome="$NOME"
    fi
  fi
done

# Se tudo verificado, etapa atual = última.
if [[ -z "$etapa_atual_num" ]]; then
  etapa_atual_num=$(yq -r ".etapas[$((N-1))].num" "$MAP")
  etapa_atual_nome=$(yq -r ".etapas[$((N-1))].nome" "$MAP")
fi

echo "📍 RENATA: Etapa ${etapa_atual_num}/13 (${etapa_atual_nome}) — ${presentes} docs presentes, ${verificados} verificados. Rode /status."
exit 0
