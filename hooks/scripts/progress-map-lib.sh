#!/usr/bin/env bash
# progress-map-lib.sh — parser embutido do progress-map.yaml (subset RENATA).
#
# Elimina a dependência de `yq` nos hooks: o mapa é gerado pelo template e segue
# um shape fixo (lista `steps:` com campos escalares + `prereq` inline). Este
# parser lê exatamente esse subset via awk (POSIX, presente em qualquer máquina)
# — NÃO é um parser YAML genérico.
#
# Uso (source a partir do mesmo diretório):
#   source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/progress-map-lib.sh"
#
# API:
#   pm_rows <mapfile>        → uma linha por etapa, campos separados por TAB:
#                              num  name  command  artifact_glob  non_empty_if  optional  prereq
#                              (prereq vem como lista separada por espaço; campo ausente = vazio)
#   pm_row  <mapfile> <num>  → só a linha da etapa <num> (vazio se não existe)

pm_rows() {
  awk '
    function unquote(s) {
      sub(/^[ \t]+/, "", s); sub(/[ \t\r]+$/, "", s)
      if (s ~ /^".*"$/) s = substr(s, 2, length(s) - 2)
      return s
    }
    function flush() {
      if (num != "") printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\n", num, name, cmd, glob, needle, opt, prereq
      num = name = cmd = glob = needle = opt = prereq = ""
    }
    /^[ \t]*#/ { next }                                # comentário de linha inteira
    /^[ \t]*-[ \t]+num:/ {
      flush()
      num = unquote(substr($0, index($0, ":") + 1)); next
    }
    /^[ \t]*name:/          { name   = unquote(substr($0, index($0, ":") + 1)); next }
    /^[ \t]*command:/       { cmd    = unquote(substr($0, index($0, ":") + 1)); next }
    /^[ \t]*artifact_glob:/ { glob   = unquote(substr($0, index($0, ":") + 1)); next }
    /^[ \t]*non_empty_if:/  { needle = unquote(substr($0, index($0, ":") + 1)); next }
    /^[ \t]*optional:/      { opt    = unquote(substr($0, index($0, ":") + 1)); next }
    /^[ \t]*prereq:/ {
      p = substr($0, index($0, ":") + 1)
      gsub(/[][",]/, " ", p); gsub(/[ \t]+/, " ", p)
      sub(/^ /, "", p); sub(/ $/, "", p)
      prereq = p; next
    }
    END { flush() }
  ' "$1"
}

pm_row() {
  pm_rows "$1" | awk -F'\t' -v n="$2" '$1 == n { print; exit }'
}
