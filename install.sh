#!/usr/bin/env bash

set -e

export BUNVM_DIR="${BUNVM_DIR:-$HOME/.bunvm}"

echo "🔧 Instalando BunVM en: $BUNVM_DIR"

mkdir -p "$BUNVM_DIR"
mkdir -p "$BUNVM_DIR/commands" "$BUNVM_DIR/autoload" "$BUNVM_DIR/lib" "$BUNVM_DIR/versions" "$BUNVM_DIR/etc" "$BUNVM_DIR/tmp"

# inicializar archivos de configuración básicos
touch "$BUNVM_DIR/etc/aliases"
touch "$BUNVM_DIR/etc/current"

echo "📥 Descargando núcleo…"
curl -fsSL "https://raw.githubusercontent.com/privjaac/bunvm/main/bunvm.sh" \
  -o "$BUNVM_DIR/bunvm.sh"
chmod +x "$BUNVM_DIR/bunvm.sh"

echo "📥 Descargando comandos…"
for CMD in install uninstall use list current alias selfupdate; do
  curl -fsSL "https://raw.githubusercontent.com/privjaac/bunvm/main/commands/$CMD" \
    -o "$BUNVM_DIR/commands/$CMD"
  chmod +x "$BUNVM_DIR/commands/$CMD"
done

echo "📥 Descargando librerías…"
for LIB in detect_platform fetch_version messages validate; do
  curl -fsSL "https://raw.githubusercontent.com/privjaac/bunvm/main/lib/$LIB" \
    -o "$BUNVM_DIR/lib/$LIB"
  chmod +x "$BUNVM_DIR/lib/$LIB"
done

echo "📥 Descargando autoenv…"
curl -fsSL "https://raw.githubusercontent.com/privjaac/bunvm/main/autoload/autoenv.sh" \
  -o "$BUNVM_DIR/autoload/autoenv.sh"
chmod +x "$BUNVM_DIR/autoload/autoenv.sh"

# actualizar shell profile
if [ -f "$HOME/.zshrc" ]; then
  PROFILE="$HOME/.zshrc"
elif [ -f "$HOME/.bashrc" ]; then
  PROFILE="$HOME/.bashrc"
else
  PROFILE="$HOME/.profile"
fi

INIT_STR="
# BunVM
export BUNVM_DIR=\"$BUNVM_DIR\"
source \"\$BUNVM_DIR/bunvm.sh\"
"

if ! grep -q "bunvm.sh" "$PROFILE" 2>/dev/null; then
  echo "$INIT_STR" >> "$PROFILE"
  echo "🧩 BunVM agregado a $PROFILE"
else
  echo "✔ BunVM ya estaba configurado en $PROFILE"
fi

echo ""
echo "🎉 BunVM instalado correctamente."
echo "➡ Reinicia la terminal o ejecuta: source $PROFILE"
echo ""
echo "Ejemplo:"
echo "  bunvm install 1.0.0"
echo "  bunvm use 1.0.0"
