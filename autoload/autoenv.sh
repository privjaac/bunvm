#!/usr/bin/env bash

autoload_bunvm() {
    if [ -f ".bun-version" ]; then
        local VERSION
        VERSION="$(cat .bun-version)"
        bunvm use "$VERSION" >/dev/null 2>&1
    fi
}

# bash
if [ -n "$BASH_VERSION" ]; then
    case "$PROMPT_COMMAND" in
        *autoload_bunvm*) ;;
        "" ) PROMPT_COMMAND="autoload_bunvm" ;;
        * ) PROMPT_COMMAND="autoload_bunvm;$PROMPT_COMMAND" ;;
    esac
fi

# zsh
if [ -n "$ZSH_VERSION" ]; then
    autoload -U add-zsh-hook 2>/dev/null || true
    add-zsh-hook chpwd autoload_bunvm 2>/dev/null || true
fi
