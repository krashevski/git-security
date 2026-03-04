#!/usr/bin/env bash

_brandmauer_completions()
{
    local cur prev

    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    # Первый уровень команд
    if [[ ${COMP_CWORD} -eq 1 ]]; then
        COMPREPLY=( $(compgen -W "git net status version help hooks security" -- "$cur") )
        return 0
    fi

    # Подкоманды hooks
    if [[ ${COMP_WORDS[1]} == "hooks" ]]; then
        COMPREPLY=( $(compgen -W "enable disable status" -- "$cur") )
        return 0
    fi

    # Подкоманды security (если оставишь)
    if [[ ${COMP_WORDS[1]} == "security" ]]; then
        COMPREPLY=( $(compgen -W "mode log" -- "$cur") )
        return 0
    fi
}

complete -F _brandmauer_completions brandmauer