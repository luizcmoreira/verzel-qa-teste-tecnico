#!/usr/bin/env bash
# Confere a consistência do repositório. Termina com código 1 se achar problema.
cd "$(git rev-parse --show-toplevel)" || exit 1
erros=0
falha() { echo -e "ERRO: $1"; erros=$((erros+1)); }

feat=$(grep -hE "^\s*(Esquema do )?Cenário:" docs/02-cenarios/*.feature | grep -oE "CT-[A-Z]+-[0-9]+" | sort)
dup=$(echo "$feat" | uniq -d)
[ -n "$dup" ] && falha "ID duplicado nos .feature: $dup"

exec_ids=$(grep -E "^\| CT-" docs/03-execucao.md | grep -oE "^\| CT-[A-Z]+-[0-9]+" | grep -oE "CT-[A-Z]+-[0-9]+" | sort)
evid_ids=$(grep -E "^\| CT-" docs/05-evidencias/README.md | grep -oE "^\| CT-[A-Z]+-[0-9]+" | grep -oE "CT-[A-Z]+-[0-9]+" | sort)

d1=$(diff <(echo "$feat") <(echo "$exec_ids")); [ -n "$d1" ] && falha "IDs do .feature diferem de 03-execucao.md:\n$d1"
d2=$(diff <(echo "$feat") <(echo "$evid_ids")); [ -n "$d2" ] && falha "IDs do .feature diferem de 05-evidencias/README.md:\n$d2"

vazios=$(find docs scripts README.md automacao -type f -empty -not -name .gitkeep -not -path "*/node_modules/*" 2>/dev/null)
[ -n "$vazios" ] && falha "Arquivos vazios:\n$vazios"

while IFS= read -r md; do
  dir=$(dirname "$md")
  grep -o ']([^)]*)' "$md" | sed 's/^](\(.*\))$/\1/' | grep -vE '^(https?:|#|mailto:)' | sort -u | while IFS= read -r link; do
    alvo="${link%%#*}"
    [ -z "$alvo" ] && continue
    [ -e "$dir/$alvo" ] || echo "LINK QUEBRADO em $md: $link"
  done
done < <(find . -name "*.md" -not -path "./.git/*" -not -path "*/node_modules/*") | tee /tmp/links.txt
[ -s /tmp/links.txt ] && erros=$((erros+1))

echo "Cenários nos .feature: $(echo "$feat" | wc -l) | em 03-execucao: $(echo "$exec_ids" | wc -l) | em evidências: $(echo "$evid_ids" | wc -l)"
if [ "$erros" -eq 0 ]; then echo "TUDO CERTO"; else echo "$erros problema(s) encontrado(s)"; exit 1; fi
