#!/usr/bin/env bash
set -e

echo "🧹 Uninstalling BunVM..."
CANDIDATES=("$HOME/.bunvm")
if [ -n "$BUNVM_DIR" ]; then
  CANDIDATES+=("$BUNVM_DIR")
fi
# Detect by bunvm.sh location if it's in PATH
BUNVM_PATH="$(command -v bunvm 2>/dev/null || true)"
if [ -n "$BUNVM_PATH" ]; then
  REAL_DIR="$(dirname "$(dirname "$BUNVM_PATH")")"
  CANDIDATES+=("$REAL_DIR")
fi
# Remove duplicates
UNIQUE_DIRS=($(printf "%s\n" "${CANDIDATES[@]}" | awk '!seen[$0]++'))
echo "🔍 Searching for BunVM installations..."
FOUND=false
for DIR in "${UNIQUE_DIRS[@]}"; do
  if [ -d "$DIR" ]; then
    echo "🗑  Removing installation found at: $DIR"
    rm -rf "$DIR"
    FOUND=true
  fi
done
if [ "$FOUND" = false ]; then
  echo "ℹ  No BunVM installations found."
fi
# CLEAN SHELL PROFILES
echo "🧽 Cleaning shell configuration files..."
SHELL_FILES=("$HOME/.zshrc" "$HOME/.bashrc" "$HOME/.profile")
for FILE in "${SHELL_FILES[@]}"; do
  if [ -f "$FILE" ]; then
    if grep -q "bunvm" "$FILE" 2>/dev/null; then
      echo "🧽 Removing references in $FILE ..."
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

echo "✔ BunVM has been completely uninstalled."
echo "ℹ Restart your terminal."
