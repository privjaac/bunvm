#!/usr/bin/env bash

# ------------------------------------------------------------------
# Asegurar PATH mínimo del sistema (CRÍTICO)
# ------------------------------------------------------------------
SYSTEM_PATHS="/usr/bin:/bin:/usr/sbin:/sbin"

for p in ${SYSTEM_PATHS//:/ }; do
  case ":$PATH:" in
    *":$p:"*) ;;
    *) PATH="$p:$PATH" ;;
  esac
done

export PATH

# ------------------------------------------------------------------
# Variables base
# ------------------------------------------------------------------
export BUNVM_DIR="${BUNVM_DIR:-$HOME/.bunvm}"
export BUNVM_CMDS="$BUNVM_DIR/commands"
export BUNVM_LIB="$BUNVM_DIR/lib"
export BUNVM_AUTOLOAD="$BUNVM_DIR/autoload"
export BUNVM_VERSIONS="$BUNVM_DIR/versions"
export BUNVM_ETC="$BUNVM_DIR/etc"

# ------------------------------------------------------------------
# Restaurar versión activa si existe
# ------------------------------------------------------------------
if [ -f "$BUNVM_ETC/current" ]; then
  CURRENT="$(cat "$BUNVM_ETC/current" 2>/dev/null)"
  if [ -n "$CURRENT" ] && [ -x "$BUNVM_VERSIONS/bun-$CURRENT/bin/bun" ]; then
    case ":$PATH:" in
      *":$BUNVM_VERSIONS/bun-$CURRENT/bin:"*) ;;
      *) PATH="$BUNVM_VERSIONS/bun-$CURRENT/bin:$PATH" ;;
    esac
  fi
fi

export PATH

# ------------------------------------------------------------------
# Cargar librerías
# ------------------------------------------------------------------
if [ -d "$BUNVM_LIB" ]; then
  for f in "$BUNVM_LIB"/*; do
    [ -f "$f" ] && . "$f"
  done
fi

# ------------------------------------------------------------------
# Comando principal
# ------------------------------------------------------------------
bunvm() {
  local cmd="$1"
  shift || true

  case "$cmd" in
    install|uninstall|use|list|current|alias|selfupdate)
      . "$BUNVM_CMDS/$cmd"
      ;;
    ""|help|-h|--help)
      bunvm_msg "Uso: bunvm <comando>"
      bunvm_msg "Comandos disponibles:"
      bunvm_msg "  install    Instala una versión de Bun"
      bunvm_msg "  uninstall  Desinstala una versión"
      bunvm_msg "  use        Activa una versión"
      bunvm_msg "  list       Lista versiones"
      bunvm_msg "  current    Muestra versión activa"
      bunvm_msg "  alias      Alias de versiones"
      bunvm_msg "  selfupdate Actualiza BunVM"
      ;;
    *)
      bunvm_msg_error "Comando desconocido: $cmd"
      return 1
      ;;
  esac
}

# ------------------------------------------------------------------
# Autoenv
# ------------------------------------------------------------------
[ -f "$BUNVM_AUTOLOAD/autoenv.sh" ] && . "$BUNVM_AUTOLOAD/autoenv.sh"
