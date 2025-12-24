#!/usr/bin/env zsh

# Load zsh autocompletion system if not already loaded
if ! command -v compdef >/dev/null 2>&1; then
  autoload -Uz compinit
  compinit
fi

# Autocompletion function for bunvm in zsh
_bunvm() {
  local -a commands
  commands=(
    'install:Install a Bun version'
    'uninstall:Uninstall a version'
    'use:Activate a version'
    'list:List versions'
    'current:Show active version'
    'alias:Create version aliases'
    'selfupdate:Update BunVM'
    'help:Show help'
  )

  local -a installed_versions
  local -a aliases_list

  # Get installed versions
  if [ -d "$BUNVM_VERSIONS" ]; then
    installed_versions=(${(f)"$(find "$BUNVM_VERSIONS" -maxdepth 1 -type d -name 'bun-*' 2>/dev/null | sed 's#.*/bun-##')"})
  fi

  # Get aliases
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
          install_options=('latest:Latest available version')
          _describe -t versions 'install options' install_options
          ;;

        list)
          local -a list_options
          list_options=('--local:Local versions only')
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

# Register autocompletion for bunvm
compdef _bunvm bunvm
