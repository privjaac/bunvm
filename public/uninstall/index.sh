#!/usr/bin/env bash
set -e

echo "🧹 Desinstalando BunVM..."
CANDIDATES=("$HOME/.bunvm")
if [ -n "$BUNVM_DIR" ]; then
  CANDIDATES+=("$BUNVM_DIR")
fi
# Detectar por ubicación del bunvm.sh si está en PATH
BUNVM_PATH="$(command -v bunvm 2>/dev/null || true)"
if [ -n "$BUNVM_PATH" ]; then
  REAL_DIR="$(dirname "$(dirname "$BUNVM_PATH")")"
  CANDIDATES+=("$REAL_DIR")
fi
# Eliminar duplicados
UNIQUE_DIRS=($(printf "%s\n" "${CANDIDATES[@]}" | awk '!seen[$0]++'))
echo "🔍 Buscando instalaciones de BunVM..."
FOUND=false
for DIR in "${UNIQUE_DIRS[@]}"; do
  if [ -d "$DIR" ]; then
    echo "🗑  Eliminando instalación encontrada en: $DIR"
    rm -rf "$DIR"
    FOUND=true
  fi
done
if [ "$FOUND" = false ]; then
  echo "ℹ  No se encontraron instalaciones de BunVM."
fi
# LIMPIAR PERFILES DE SHELL
echo "🧽 Limpiando archivos de configuración del shell..."
SHELL_FILES=("$HOME/.zshrc" "$HOME/.bashrc" "$HOME/.profile")
for FILE in "${SHELL_FILES[@]}"; do
  if [ -f "$FILE" ]; then
    if grep -q "bunvm" "$FILE" 2>/dev/null; then
      echo "🧽 Eliminando referencias en $FILE ..."
      if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' '/bunvm/d' "$FILE" 2>/dev/null || true
        sed -i '' '/BUNVM_DIR/d' "$FILE" 2>/dev/null || true
      else
        sed -i '/bunvm/d' "$FILE" 2>/dev/null || true
        sed -i '/BUNVM_DIR/d' "$FILE" 2>/dev/null || true
      fi
    fi
  fi
done

echo "✔ BunVM ha sido completamente desinstalado."
echo "ℹ Reinicia la terminal."
