#!/usr/bin/env bash
set -e
echo "🔧 Installing BunVM..."
INSTALLER_URL="https://raw.githubusercontent.com/privjaac/bunvm/main/install.sh"
curl -fsSL "$INSTALLER_URL" | bash
