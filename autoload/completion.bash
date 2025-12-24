#!/usr/bin/env bash

# Autocompletion function for bunvm
_bunvm_completion() {
  local cur prev words cword

  # Inicializar variables manualmente (compatible sin bash-completion)
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"
  words=("${COMP_WORDS[@]}")
  cword=$COMP_CWORD

  # List of main commands
  local commands="install uninstall use list current alias selfupdate help"

  # Si estamos en la primera palabra después de bunvm
  if [ "$cword" -eq 1 ]; then
    COMPREPLY=($(compgen -W "$commands" -- "$cur"))
    return 0
  fi

  # Get the command (first word)
  local cmd="${words[1]}"

  case "$cmd" in
    use|uninstall)
      # Autocompletar con versiones instaladas
      if [ -d "$BUNVM_VERSIONS" ]; then
        local versions=$(find "$BUNVM_VERSIONS" -maxdepth 1 -type d -name 'bun-*' 2>/dev/null | sed 's#.*/bun-##' | tr '\n' ' ')

        # For 'use' also add aliases
        if [ "$cmd" = "use" ] && [ -f "$BUNVM_ETC/aliases" ]; then
          local aliases=$(cut -d'=' -f1 "$BUNVM_ETC/aliases" 2>/dev/null | tr '\n' ' ')
          versions="$versions $aliases"
        fi

        COMPREPLY=($(compgen -W "$versions" -- "$cur"))
      fi
      ;;

    install)
      # For install, suggest 'latest'
      COMPREPLY=($(compgen -W "latest" -- "$cur"))
      ;;

    list)
      # For list, suggest --local
      COMPREPLY=($(compgen -W "--local" -- "$cur"))
      ;;

    alias)
      # For alias <name> <version>, autocomplete version in second argument
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

# Register autocompletion for bunvm
complete -F _bunvm_completion bunvm
