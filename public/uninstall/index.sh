#!/usr/bin/env bash
set -e
echo "🧹 Desinstalando BunVM..."
BUNVM_DIR="$HOME/.bunvm"
if [ -d "$BUNVM_DIR" ]; then
  echo "🗑  Eliminando carpeta $BUNVM_DIR ..."
  rm -rf "$BUNVM_DIR"
else
  echo "ℹ  BunVM no está instalado en $BUNVM_DIR"
fi
SHELL_FILES=("$HOME/.zshrc" "$HOME/.bashrc" "$HOME/.profile")
for FILE in "${SHELL_FILES[@]}"; do
  if [ -f "$FILE" ]; then
    if grep -q "BUNVM" "$FILE"; then
      echo "🧽 Limpiando referencias en $FILE ..."
      sed -i '' '/BunVM/d' "$FILE" 2>/dev/null || sed -i '/BunVM/d' "$FILE"
    fi
  fi
done
echo "✔ BunVM ha sido completamente desinstalado."
echo "ℹ Recuerda ejecutar: source ~/.zshrc  o  source ~/.bashrc"
