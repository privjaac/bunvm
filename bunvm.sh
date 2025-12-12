#!/usr/bin/env bash

# asegurar PATH mínimo del sistema
if [[ ":$PATH:" != *":/usr/bin:"* ]]; then
  export PATH="/usr/bin:/bin:/usr/sbin:/sbin:$PATH"
fi

export BUNVM_DIR="${BUNVM_DIR:-$HOME/.bunvm}"
export BUNVM_CMDS="$BUNVM_DIR/commands"
export BUNVM_LIB="$BUNVM_DIR/lib"
export BUNVM_AUTOLOAD="$BUNVM_DIR/autoload"
export BUNVM_VERSIONS="$BUNVM_DIR/versions"
export BUNVM_ETC="$BUNVM_DIR/etc"

# restaurar PATH persistente primero
if [ -f "$BUNVM_ETC/current" ]; then
    CURRENT="$(cat "$BUNVM_ETC/current")"
    if [ -f "$BUNVM_VERSIONS/bun-$CURRENT/bin/bun" ]; then
        case ":$PATH:" in
            *":$BUNVM_VERSIONS/bun-$CURRENT/bin:"*) ;;
            *) export PATH="$BUNVM_VERSIONS/bun-$CURRENT/bin:$PATH" ;;
        esac
    fi
fi

# cargar librerías internas
if [ -d "$BUNVM_LIB" ]; then
  for f in "$BUNVM_LIB"/*; do
      [ -f "$f" ] && . "$f"
  done
fi

bunvm() {
    local cmd="$1"
    shift || true

    case "$cmd" in
        install|uninstall|use|list|current|alias|selfupdate)
            . "$BUNVM_CMDS/$cmd"
            ;;
        ""|help|-h|--help)
            bunvm_msg "Uso: bunvm <comando> [opciones]"
            bunvm_msg "Comandos disponibles:"
            bunvm_msg "  install    Instala una versión de Bun"
            bunvm_msg "  uninstall  Desinstala una versión de Bun"
            bunvm_msg "  use        Activa una versión de Bun"
            bunvm_msg "  list       Lista versiones instaladas"
            bunvm_msg "  current    Muestra la versión activa"
            bunvm_msg "  alias      Registra un alias para una versión"
            bunvm_msg "  selfupdate Actualiza BunVM"
            ;;
        *)
            bunvm_msg_error "Comando desconocido: $cmd"
            bunvm_msg_info "Ejecuta: bunvm help"
            return 1
            ;;
    esac
}

# activar autoenv si existe
if [ -f "$BUNVM_AUTOLOAD/autoenv.sh" ]; then
  . "$BUNVM_AUTOLOAD/autoenv.sh"
fi
