#!/usr/bin/env bash
# Szyfruje świeżo zbudowany HTML (StatiCrypt, AES-256) do index.html i wypycha na GitHub Pages.
# Hasło czytane z ../.haslo, sól z ../.staticrypt.json - oba poza repo.
# Zmiana hasła: edytuj ../.haslo i uruchom ten skrypt ponownie.
set -euo pipefail
cd "$(dirname "$0")"
SRC=../Claude_AI_w_codziennej_pracy_interaktywny.html
TMP=$(mktemp -d)
npx -y staticrypt@3 "$SRC" \
  -p "$(cat ../.haslo)" --short \
  -c ../.staticrypt.json -d "$TMP" \
  --remember 30 \
  --template-title "Claude AI w codziennej pracy" \
  --template-instructions "Materiały szkoleniowe ALX. Wpisz hasło podane na zajęciach." \
  --template-placeholder "Hasło" \
  --template-button "Otwórz" \
  --template-remember "Zapamiętaj mnie (30 dni)" \
  --template-error "Nieprawidłowe hasło" \
  --template-toggle-show "Pokaż hasło" \
  --template-toggle-hide "Ukryj hasło" \
  --template-color-primary "#1B3A8C" \
  --template-color-secondary "#FBFCFD"
mv "$TMP/$(basename "$SRC")" index.html
rm -rf "$TMP"
git add -A
if git diff --cached --quiet; then echo "Brak zmian."; exit 0; fi
git commit -q -m "Aktualizacja materiałów ($(date +%Y-%m-%d))"
git push -u origin main
