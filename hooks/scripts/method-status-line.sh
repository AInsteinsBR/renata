#!/usr/bin/env bash
# method-status-line.sh — Hook SessionStart do RENATA
#
# Imprime UMA linha resumindo o progresso do projeto no fluxo de 14 etapas,
# mais (quando aplicável):
#   - um aviso de GAP: há artefato de etapa posterior enquanto uma etapa
#     obrigatória anterior segue pendente (trabalho à frente do prereq);
#   - um aviso ALTO se o enforcement estiver desligado por falta de tooling
#     (uma trava silenciosamente desligada é pior que trava nenhuma).
#
# Lê .claude/progress-map.yaml com o parser embutido (progress-map-lib.sh —
# sem dependência de yq). Sem o mapa, sai em silêncio (nunca quebra a sessão).
#
# Saída exemplo:
#   📍 RENATA: Etapa 6/13 (Decisões técnicas (ADRs)) — 5 docs presentes, 3 verificados. Rode /renata:status.

set -uo pipefail

MAP=".claude/progress-map.yaml"
[[ -f "$MAP" ]] || exit 0

# Localiza a lib ao lado deste script sem depender de binários externos (dirname).
SCRIPT_DIR="${BASH_SOURCE[0]%/*}"
[[ "$SCRIPT_DIR" == "${BASH_SOURCE[0]}" ]] && SCRIPT_DIR="."
if ! source "$SCRIPT_DIR/progress-map-lib.sh" 2>/dev/null; then
  echo "⚠ RENATA: status do método indisponível — progress-map-lib.sh não encontrado ao lado do hook."
  exit 0
fi

presentes=0
verificados=0
etapa_atual_num=""
etapa_atual_nome=""
primeira_pendente_num=""
primeira_pendente_nome=""
gap_num=""
gap_nome=""

while IFS=$'\t' read -r NUM NOME CMD GLOB NAO_VAZIO OPCIONAL PREREQ; do
  [[ -z "$NUM" ]] && continue

  # Expande o glob. compgen -G funciona corretamente para literais E wildcards.
  # Compatível com bash 3.2 (macOS): usa while-read em vez de mapfile.
  arquivos=()
  while IFS= read -r f; do
    # Aplica o filtro de conteúdo (non_empty_if): se definido, só conta o
    # arquivo se ele contém a substring — distingue etapas que compartilham glob.
    if [[ -z "$NAO_VAZIO" ]]; then
      arquivos+=("$f")
    elif grep -lqF -- "$NAO_VAZIO" "$f" 2>/dev/null; then
      arquivos+=("$f")
    fi
  done < <(compgen -G "$GLOB" 2>/dev/null)

  if [[ ${#arquivos[@]} -gt 0 ]]; then
    presentes=$((presentes + 1))
    # GAP: artefato presente DEPOIS de uma etapa obrigatória ainda ausente.
    if [[ -n "$primeira_pendente_num" && -z "$gap_num" ]]; then
      gap_num="$NUM"
      gap_nome="$NOME"
    fi
    # Verificado se ALGUM arquivo do glob tem a linha de verificação.
    if grep -lq "✅ Verificado por você\|✅ Verified by you" "${arquivos[@]}" 2>/dev/null; then
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
    # primeira etapa OBRIGATÓRIA sem artefato — referência pro detector de gap
    if [[ -z "$primeira_pendente_num" && "$OPCIONAL" != "true" ]]; then
      primeira_pendente_num="$NUM"
      primeira_pendente_nome="$NOME"
    fi
  fi
done < <(pm_rows "$MAP")

# Se tudo verificado, etapa atual = última.
if [[ -z "$etapa_atual_num" ]]; then
  ultima=$(pm_rows "$MAP" | tail -1)
  etapa_atual_num=$(printf '%s' "$ultima" | cut -f1)
  etapa_atual_nome=$(printf '%s' "$ultima" | cut -f2)
fi

echo "📍 RENATA: Etapa ${etapa_atual_num}/13 (${etapa_atual_nome}) — ${presentes} docs presentes, ${verificados} verificados. Rode /renata:status."

# Detector de gap proativo: trabalho à frente do primeiro prereq não satisfeito.
if [[ -n "$gap_num" ]]; then
  echo "⚠ RENATA: gap no fluxo — a Etapa ${primeira_pendente_num} (${primeira_pendente_nome}) está pendente, mas já existe artefato da Etapa ${gap_num} (${gap_nome}). Próximo passo canônico: Etapa ${primeira_pendente_num}. Rode /renata:next."
fi

# Enforcement OFF? Avisa ALTO — nunca desligar trava em silêncio.
if ! command -v jq >/dev/null 2>&1 && ! command -v python3 >/dev/null 2>&1; then
  echo "⚠ RENATA: gate de etapa OFF — nem jq nem python3 disponíveis. Instale um deles (ex.: brew install jq) pra reativar o bloqueio de pré-requisitos."
fi
if [[ -f ".claude/rules.yaml" ]] && ! command -v yq >/dev/null 2>&1; then
  echo "⚠ RENATA: enforcement de ADR limitado — yq ausente; rules-violation.sh não valida o rules.yaml no commit. Instale com: brew install yq"
fi

exit 0
