#!/usr/bin/env bash
# rules-violation.sh — Hook declarativo do RENATA
#
# Lê .claude/rules.yaml e valida o repo contra as regras de ADR aceitas.
# Saída 0 = sem violação. Saída 1 = pelo menos 1 violação encontrada.
#
# Uso:
#   - Pre-commit: ativado automaticamente pelo /renata-init (symlink em .git/hooks/pre-commit)
#   - CI: rodar antes do build
#   - Manual: bash ${CLAUDE_PLUGIN_ROOT}/hooks/scripts/rules-violation.sh
#
# Dependência opcional: yq (parsing YAML). Se não tiver, usa parser bash bobo
# que suporta um subset das regras (forbid_pattern com pattern, scope, exclude, message).

set -uo pipefail

RULES_FILE=".claude/rules.yaml"
FAILED=0

# ─────────────────────────────────────────────────────────────
# Sanity checks
# ─────────────────────────────────────────────────────────────
if [[ ! -f "$RULES_FILE" ]]; then
  echo "⚠ Arquivo $RULES_FILE não encontrado. Skipando hook."
  echo "  Para ativar, copie .claude/rules.yaml.template para .claude/rules.yaml e edite."
  exit 0
fi

# ─────────────────────────────────────────────────────────────
# Helper de impressão
# ─────────────────────────────────────────────────────────────
print_violation() {
  local adr="$1"
  local title="$2"
  local msg="$3"
  local found="$4"
  echo ""
  echo "❌ Violação de $adr ($title)"
  echo "   $msg"
  echo "   Encontrado em:"
  echo "$found" | sed 's/^/     /'
  echo "   → ver docs/decisions/${adr}*.md"
  FAILED=1
}

# ─────────────────────────────────────────────────────────────
# Modo yq (recomendado)
# ─────────────────────────────────────────────────────────────
if command -v yq >/dev/null 2>&1; then
  ADR_COUNT=$(yq '.adrs | length' "$RULES_FILE")

  if [[ "$ADR_COUNT" == "0" || "$ADR_COUNT" == "null" ]]; then
    echo "ℹ Nenhuma ADR com enforcement em $RULES_FILE. Skipando."
    exit 0
  fi

  for i in $(seq 0 $((ADR_COUNT - 1))); do
    ADR_ID=$(yq ".adrs[$i].id" "$RULES_FILE")
    ADR_TITLE=$(yq ".adrs[$i].title" "$RULES_FILE")
    RULE_COUNT=$(yq ".adrs[$i].enforce | length" "$RULES_FILE")

    for j in $(seq 0 $((RULE_COUNT - 1))); do
      KIND=$(yq ".adrs[$i].enforce[$j].kind // \"forbid_pattern\"" "$RULES_FILE")
      PATTERN=$(yq ".adrs[$i].enforce[$j].pattern" "$RULES_FILE")
      SCOPE=$(yq ".adrs[$i].enforce[$j].scope // \".\"" "$RULES_FILE")
      EXCLUDE=$(yq ".adrs[$i].enforce[$j].exclude // \"\"" "$RULES_FILE")
      MSG=$(yq ".adrs[$i].enforce[$j].message" "$RULES_FILE")

      case "$KIND" in
        forbid_pattern)
          GREP_ARGS=(-rEnI --include="*.py" --include="*.ts" --include="*.tsx" --include="*.js" --include="*.jsx" --include="*.go" --include="*.rs" --include="*.java" --include="*.kt" --include="*.sql")
          if [[ -n "$EXCLUDE" && "$EXCLUDE" != "null" ]]; then
            GREP_ARGS+=(--exclude-dir="$EXCLUDE")
          fi
          # Exclui sempre _framework e produto-exemplo do scan (são docs/template)
          GREP_ARGS+=(--exclude-dir="_framework" --exclude-dir="produto-exemplo" --exclude-dir="node_modules" --exclude-dir=".venv" --exclude-dir=".git")

          if [[ -d "$SCOPE" ]]; then
            FOUND=$(grep "${GREP_ARGS[@]}" -- "$PATTERN" "$SCOPE" 2>/dev/null || true)
          else
            FOUND=""
          fi

          if [[ -n "$FOUND" ]]; then
            print_violation "$ADR_ID" "$ADR_TITLE" "$MSG" "$FOUND"
          fi
          ;;

        require_pattern)
          # Verifica que arquivos no SCOPE contêm o PATTERN. Falha se algum arquivo do escopo NÃO contém.
          if [[ -d "$SCOPE" ]]; then
            for FILE in $(find "$SCOPE" -type f \( -name "*.py" -o -name "*.ts" -o -name "*.sql" \) 2>/dev/null); do
              if ! grep -qE "$PATTERN" "$FILE" 2>/dev/null; then
                print_violation "$ADR_ID" "$ADR_TITLE" "$MSG (arquivo sem padrão obrigatório)" "$FILE"
              fi
            done
          fi
          ;;

        *)
          echo "⚠ Tipo de enforce desconhecido em $ADR_ID: '$KIND'. Skipando."
          ;;
      esac
    done
  done

else
  # ─────────────────────────────────────────────────────────────
  # yq NÃO instalado — comportamento depende do modo
  # ─────────────────────────────────────────────────────────────
  echo "🔴 'yq' não instalado — hook NÃO pode validar regras do rules.yaml."
  echo ""
  echo "   Instale com:"
  echo "     macOS:  brew install yq"
  echo "     Linux:  sudo apt install yq  (ou snap install yq)"
  echo ""

  # Em CI ou modo --strict, falha. Em modo dev local, avisa mas permite seguir.
  if [[ "${CI:-false}" == "true" || "${1:-}" == "--strict" ]]; then
    echo "❌ Modo CI/strict: abortando porque yq é obrigatório."
    echo "   Adicione yq ao setup do CI antes de prosseguir."
    exit 1
  fi

  echo "⚠ Modo dev local: hook permite seguir, mas regras NÃO foram validadas."
  echo "   ATENÇÃO: você pode estar violando ADRs sem perceber. Instale yq quanto antes."
  exit 0
fi

# ─────────────────────────────────────────────────────────────
# Resultado
# ─────────────────────────────────────────────────────────────
if [[ $FAILED -eq 1 ]]; then
  echo ""
  echo "💡 Para entender por que essas regras existem: cat docs/decisions/README.md"
  echo "   Para discutir mudança: abra ADR superseding via /adr — NÃO contorne o hook."
  exit 1
fi

echo "✓ Nenhuma violação de ADR detectada."
exit 0
