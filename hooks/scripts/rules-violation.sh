#!/usr/bin/env bash
# rules-violation.sh — Hook declarativo do RENATA
#
# Lê .claude/rules.yaml e valida o repo contra as regras de ADR aceitas.
# Saída 0 = sem violação. Saída 1 = pelo menos 1 violação encontrada.
#
# Uso:
#   - Pre-commit: ativado automaticamente pelo /renata:init (symlink em .git/hooks/pre-commit)
#   - CI: rodar antes do build (com CI=true ou --strict; escaneia todos os rastreados)
#   - Manual: bash ${CLAUDE_PLUGIN_ROOT}/hooks/scripts/rules-violation.sh [--all] [--strict]
#
# ESCOPO DO SCAN (importante):
#   - Em pre-commit (default): APENAS os arquivos STAGED (git diff --cached).
#     Isso honra o .gitignore de graça (arquivo ignorado nunca é staged) e valida
#     exatamente o que vai ser commitado — nada de falso-positivo em node_modules/,
#     .venv/ ou site-packages de dependências de terceiros.
#   - Com --all, CI=true ou sem nada staged: todos os arquivos RASTREADOS (git ls-files).
#   - Fora de um repo git: fallback pra varredura do working tree (comportamento antigo).
#
# Dependência opcional: yq (parsing YAML). Sem yq, o hook avisa ALTO e não valida.

set -uo pipefail

RULES_FILE=".claude/rules.yaml"
FAILED=0
STRICT=0
ALL=0

for arg in "$@"; do
  case "$arg" in
    --strict) STRICT=1 ;;
    --all)    ALL=1 ;;
  esac
done

# ─────────────────────────────────────────────────────────────
# Sanity checks
# ─────────────────────────────────────────────────────────────
if [[ ! -f "$RULES_FILE" ]]; then
  echo "⚠ Arquivo $RULES_FILE não encontrado. Skipando hook."
  echo "  Para ativar, copie .claude/rules.yaml.template para .claude/rules.yaml e edite."
  exit 0
fi

# ─────────────────────────────────────────────────────────────
# Universo de arquivos a escanear (ver "ESCOPO DO SCAN" acima)
# ─────────────────────────────────────────────────────────────
SCAN_MODE="tree"
FILE_LIST=""
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  if [[ $ALL -eq 1 || "${CI:-false}" == "true" ]]; then
    SCAN_MODE="tracked"
    FILE_LIST=$(git ls-files 2>/dev/null)
  else
    FILE_LIST=$(git diff --cached --name-only --diff-filter=ACM 2>/dev/null)
    if [[ -n "$FILE_LIST" ]]; then
      SCAN_MODE="staged"
    else
      SCAN_MODE="tracked"
      FILE_LIST=$(git ls-files 2>/dev/null)
    fi
  fi
fi

# Filtra a lista pra: código-fonte suportado, dentro do scope da regra, fora do
# exclude da regra e fora dos diretórios sempre-excluídos.
filter_files() {  # $1 = scope, $2 = exclude-dir; lê a lista via stdin
  local scope="${1%/}" exclude="${2:-}" f
  while IFS= read -r f; do
    [[ -z "$f" || ! -f "$f" ]] && continue
    case "$f" in
      _framework/*|produto-exemplo/*|node_modules/*|.venv/*|.git/*) continue ;;
      */node_modules/*|*/.venv/*|*/.git/*) continue ;;
    esac
    if [[ -n "$scope" && "$scope" != "." ]]; then
      case "$f" in "$scope"/*) ;; *) continue ;; esac
    fi
    if [[ -n "$exclude" && "$exclude" != "null" ]]; then
      case "$f" in "$exclude"/*|*/"$exclude"/*) continue ;; esac
    fi
    case "$f" in
      *.py|*.ts|*.tsx|*.js|*.jsx|*.go|*.rs|*.java|*.kt|*.sql) printf '%s\n' "$f" ;;
    esac
  done
}

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

  if [[ "$SCAN_MODE" != "tree" && -z "$FILE_LIST" ]]; then
    echo "ℹ Nenhum arquivo staged/rastreado pra validar. Skipando."
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
          FOUND=""
          if [[ "$SCAN_MODE" == "tree" ]]; then
            # Fallback sem git: varredura do working tree (comportamento antigo).
            GREP_ARGS=(-rEnI --include="*.py" --include="*.ts" --include="*.tsx" --include="*.js" --include="*.jsx" --include="*.go" --include="*.rs" --include="*.java" --include="*.kt" --include="*.sql")
            if [[ -n "$EXCLUDE" && "$EXCLUDE" != "null" ]]; then
              GREP_ARGS+=(--exclude-dir="$EXCLUDE")
            fi
            GREP_ARGS+=(--exclude-dir="_framework" --exclude-dir="produto-exemplo" --exclude-dir="node_modules" --exclude-dir=".venv" --exclude-dir=".git")
            if [[ -d "$SCOPE" ]]; then
              FOUND=$(grep "${GREP_ARGS[@]}" -- "$PATTERN" "$SCOPE" 2>/dev/null || true)
            fi
          else
            MATCHED=$(printf '%s\n' "$FILE_LIST" | filter_files "$SCOPE" "$EXCLUDE")
            if [[ -n "$MATCHED" ]]; then
              FOUND=$(printf '%s\n' "$MATCHED" | tr '\n' '\0' | xargs -0 grep -EnI -- "$PATTERN" /dev/null 2>/dev/null || true)
            fi
          fi

          if [[ -n "$FOUND" ]]; then
            print_violation "$ADR_ID" "$ADR_TITLE" "$MSG" "$FOUND"
          fi
          ;;

        require_pattern)
          # Verifica que arquivos no SCOPE contêm o PATTERN. Falha se algum arquivo do escopo NÃO contém.
          if [[ "$SCAN_MODE" == "tree" ]]; then
            CANDIDATES=$(find "$SCOPE" -type f \( -name "*.py" -o -name "*.ts" -o -name "*.sql" \) 2>/dev/null || true)
          else
            CANDIDATES=$(printf '%s\n' "$FILE_LIST" | filter_files "$SCOPE" "$EXCLUDE" | grep -E '\.(py|ts|sql)$' || true)
          fi
          while IFS= read -r FILE; do
            [[ -z "$FILE" || ! -f "$FILE" ]] && continue
            if ! grep -qE "$PATTERN" "$FILE" 2>/dev/null; then
              print_violation "$ADR_ID" "$ADR_TITLE" "$MSG (arquivo sem padrão obrigatório)" "$FILE"
            fi
          done <<< "$CANDIDATES"
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
  if [[ "${CI:-false}" == "true" || $STRICT -eq 1 ]]; then
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

echo "✓ Nenhuma violação de ADR detectada ($SCAN_MODE: $(printf '%s\n' "$FILE_LIST" | grep -c . 2>/dev/null || echo 0) arquivos no universo do scan)."
exit 0
