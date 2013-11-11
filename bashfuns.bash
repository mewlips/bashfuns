#!/bin/bash

################
# bashfuns 2.0 #
################

BASHFUNS_SCRIPT=~/.bashfuns
BASHFUNS_SAVES_GLOBAL=~/.bashfuns-saves
BASHFUNS_SAVES_PRIVATE=~/.bashfuns-saves_${USER}_at_${HOSTNAME}

bashfuns-edit-script() {
    $EDITOR "$BASHFUNS_SCRIPT"
}
bashfuns-reload-script() {
    . "$BASHFUNS_SCRIPT"
}
bashfuns-save() {
    local saves
    if [ "$1" == "-g" ]; then
        saves="$BASHFUNS_SAVES_GLOBAL"
        shift
    else
        saves="$BASHFUNS_SAVES_PRIVATE"
    fi
    for fun in $*; do
        declare -f "$fun" >> "$saves"
        if [ $? = 0 ]; then
            echo \"$fun\" saved.
        else
            echo "undefined function: $fun [skipped]"
        fi
    done
}
bashfuns-reload() {
    for saves in "$BASHFUNS_SAVES_GLOBAL" "$BASHFUNS_SAVES_PRIVATE"; do
        if [ -f "$saves" ]; then
            . "$saves"
        fi
    done
}
bashfuns-edit() {
    local saves
    if [ "$1" == "-g" ]; then
        saves="$BASHFUNS_SAVES_GLOBAL"
        shift
    else
        saves="$BASHFUNS_SAVES_PRIVATE"
    fi

    if [ "$EDITOR" == "vim" ]; then
        vim -c ":set syntax=sh" "$saves"
    else
        $EDITOR "$saves"
    fi
}
bashfuns-list() {
    for saves in "$BASHFUNS_SAVES_GLOBAL" "$BASHFUNS_SAVES_PRIVATE"; do
        if [ -f "$saves" ]; then
            echo $saves
            grep --color=auto '^[a-z]' "$saves" | sed 's/^/    /' | sort
        fi
    done
}
bashfuns-save-alias() {
    local saves
    if [ "$1" == "-g" ]; then
        saves="$BASHFUNS_SAVES_GLOBAL"
        shift
    else
        saves="$BASHFUNS_SAVES_PRIVATE"
    fi

    for a in $*; do
        if alias "$a" > /dev/null; then
            alias "$a" >> "$saves"
            echo "$a" saved.
        fi
    done
}

bashfuns-help() {
    echo bashfuns
}
bashfuns() {
    local cmd="$1"
    if [ -z "$cmd" ]; then
        bashfuns-help
        return
    fi
    shift
    bashfuns-"$cmd" $*
}

bashfuns-reload

alias bf=bashfuns
