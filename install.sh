#!/usr/bin/env bash

set -e
export BUNVM_DIR="${BUNVM_DIR:-$HOME/.bunvm}"
echo "🔧 Installing BunVM at: $BUNVM_DIR"
mkdir -p "$BUNVM_DIR"
mkdir -p "$BUNVM_DIR/commands" "$BUNVM_DIR/autoload" "$BUNVM_DIR/lib" "$BUNVM_DIR/versions" "$BUNVM_DIR/etc" "$BUNVM_DIR/tmp"

# initialize basic configuration files
touch "$BUNVM_DIR/etc/aliases"
touch "$BUNVM_DIR/etc/current"

echo "📥 Downloading core…"
curl -fsSL "https://raw.githubusercontent.com/privjaac/bunvm/main/bunvm.sh" \
  -o "$BUNVM_DIR/bunvm.sh"
chmod +x "$BUNVM_DIR/bunvm.sh"

echo "📥 Downloading commands…"
for CMD in install uninstall use list current alias selfupdate; do
  curl -fsSL "https://raw.githubusercontent.com/privjaac/bunvm/main/commands/$CMD" \
    -o "$BUNVM_DIR/commands/$CMD"
  chmod +x "$BUNVM_DIR/commands/$CMD"
done

echo "📥 Downloading libraries…"
for LIB in detect_platform fetch_version messages validate; do
  curl -fsSL "https://raw.githubusercontent.com/privjaac/bunvm/main/lib/$LIB" \
    -o "$BUNVM_DIR/lib/$LIB"
  chmod +x "$BUNVM_DIR/lib/$LIB"
done

echo "📥 Downloading autoenv and autocompletion…"
curl -fsSL "https://raw.githubusercontent.com/privjaac/bunvm/main/autoload/autoenv.sh" \
  -o "$BUNVM_DIR/autoload/autoenv.sh"
chmod +x "$BUNVM_DIR/autoload/autoenv.sh"

curl -fsSL "https://raw.githubusercontent.com/privjaac/bunvm/main/autoload/completion.bash" \
  -o "$BUNVM_DIR/autoload/completion.bash"
chmod +x "$BUNVM_DIR/autoload/completion.bash"

curl -fsSL "https://raw.githubusercontent.com/privjaac/bunvm/main/autoload/completion.zsh" \
  -o "$BUNVM_DIR/autoload/completion.zsh"
chmod +x "$BUNVM_DIR/autoload/completion.zsh"

# update shell profile
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
  echo "🧩 BunVM added to $PROFILE"
else
  echo "✔ BunVM was already configured in $PROFILE"
fi

echo ""
echo "🎉 BunVM installed successfully."
echo "🔄 Loading configuration without restarting the terminal..."

# Reload environment
if [ -f "$PROFILE" ]; then
  set +e
  . "$PROFILE"
  set -e
fi

echo ""
echo "🎉 BunVM installed successfully."
echo "➡ Restart your terminal or run: source $PROFILE"
echo ""
echo "Example:"
echo "  bunvm install 1.0.0"
echo "  bunvm use 1.0.0"
echo "  bun --version"
echo ""