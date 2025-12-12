#!/usr/bin/env bash

# Función de autocompletado para bunvm
_bunvm_completion() {
  local cur prev words cword

  # Inicializar variables manualmente (compatible sin bash-completion)
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"
  words=("${COMP_WORDS[@]}")
  cword=$COMP_CWORD

  # Lista de comandos principales
  local commands="install uninstall use list current alias selfupdate help"

  # Si estamos en la primera palabra después de bunvm
  if [ "$cword" -eq 1 ]; then
    COMPREPLY=($(compgen -W "$commands" -- "$cur"))
    return 0
  fi

  # Obtener el comando (primera palabra)
  local cmd="${words[1]}"

  case "$cmd" in
    use|uninstall)
      # Autocompletar con versiones instaladas
      if [ -d "$BUNVM_VERSIONS" ]; then
        local versions=$(find "$BUNVM_VERSIONS" -maxdepth 1 -type d -name 'bun-*' 2>/dev/null | sed 's#.*/bun-##' | tr '\n' ' ')

        # Para 'use' también agregar aliases
        if [ "$cmd" = "use" ] && [ -f "$BUNVM_ETC/aliases" ]; then
          local aliases=$(cut -d'=' -f1 "$BUNVM_ETC/aliases" 2>/dev/null | tr '\n' ' ')
          versions="$versions $aliases"
        fi

        COMPREPLY=($(compgen -W "$versions" -- "$cur"))
      fi
      ;;

    install)
      # Para install, sugerir 'latest'
      COMPREPLY=($(compgen -W "latest" -- "$cur"))
      ;;

    list)
      # Para list, sugerir --local
      COMPREPLY=($(compgen -W "--local" -- "$cur"))
      ;;

    alias)
      # Para alias <nombre> <version>, autocompletar versión en segundo argumento
      if [ "$cword" -eq 3 ]; then
        if [ -d "$BUNVM_VERSIONS" ]; then
          local versions=$(find "$BUNVM_VERSIONS" -maxdepth 1 -type d -name 'bun-*' 2>/dev/null | sed 's#.*/bun-##' | tr '\n' ' ')
          COMPREPLY=($(compgen -W "$versions" -- "$cur"))
        fi
      fi
      ;;
  esac

  return 0
}

# Registrar el autocompletado para bunvm
complete -F _bunvm_completion bunvm
