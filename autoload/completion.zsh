#!/usr/bin/env zsh

# Cargar sistema de autocompletado de zsh si no está cargado
if ! command -v compdef >/dev/null 2>&1; then
  autoload -Uz compinit
  compinit
fi

# Función de autocompletado para bunvm en zsh
_bunvm() {
  local -a commands
  commands=(
    'install:Instala una versión de Bun'
    'uninstall:Desinstala una versión'
    'use:Activa una versión'
    'list:Lista versiones'
    'current:Muestra versión activa'
    'alias:Crea alias de versiones'
    'selfupdate:Actualiza BunVM'
    'help:Muestra ayuda'
  )

  local -a installed_versions
  local -a aliases_list

  # Obtener versiones instaladas
  if [ -d "$BUNVM_VERSIONS" ]; then
    installed_versions=(${(f)"$(find "$BUNVM_VERSIONS" -maxdepth 1 -type d -name 'bun-*' 2>/dev/null | sed 's#.*/bun-##')"})
  fi

  # Obtener aliases
  if [ -f "$BUNVM_ETC/aliases" ]; then
    aliases_list=(${(f)"$(cut -d'=' -f1 "$BUNVM_ETC/aliases" 2>/dev/null)"})
  fi

  local context state state_descr line
  typeset -A opt_args

  _arguments -C \
    '1: :->command' \
    '*::arg:->args'

  case "$state" in
    command)
      _describe -t commands 'bunvm commands' commands
      ;;

    args)
      case "$line[1]" in
        use)
          local -a use_options
          use_options=($installed_versions $aliases_list)
          _describe -t versions 'installed versions and aliases' use_options
          ;;

        uninstall)
          _describe -t versions 'installed versions' installed_versions
          ;;

        install)
          local -a install_options
          install_options=('latest:Última versión disponible')
          _describe -t versions 'install options' install_options
          ;;

        list)
          local -a list_options
          list_options=('--local:Solo versiones locales')
          _describe -t options 'list options' list_options
          ;;

        alias)
          if [ "$CURRENT" -eq 3 ]; then
            _describe -t versions 'installed versions' installed_versions
          fi
          ;;
      esac
      ;;
  esac

  return 0
}

# Registrar el autocompletado para bunvm
compdef _bunvm bunvm
