#!/usr/bin/env bash

############
# bashfuns #
############

BASHFUNS_SCRIPT=~/.bashfuns
BASHFUNS_VERSION=2.1

BASHFUNS_SAVES_GLOBAL=~/.bashfuns-saves
BASHFUNS_SAVES_PRIVATE=~/.bashfuns-saves_${USER}_at_${HOSTNAME}

bashfuns-edit-script() {
    $EDITOR "$BASHFUNS_SCRIPT"
}
bashfuns-load-script() {
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
bashfuns-load() {
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
    echo "Bashfuns v$BASHFUNS_VERSION"
    echo
    echo "bf help            :     "
    echo "bf list            : <F2>"
    echo "bf load            : <F3>"
    echo "bf save <fun>..    : <F4>"
    echo "bf save -g <fun>.. :     "
    echo "bf edit            : <F5>"
    echo "bf edit -g         :     "
    echo "bf load-script     : <F6>"
    echo "bf save-script     : <F7>"
    echo
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

bashfuns-load

alias bf=bashfuns

# key bindings
# F2:list F3:load F4:save F5:edit F6:load-script F7:edit-script
bind '"OQ":"bf list"'
bind '"OR":"bf load"'
bind '"OS":"bf save "'
bind '"[15~":"bf edit "'
bind '"[17~":"bf load-script"'
bind '"[18~":"bf edit-script"'

PS1_LINE_ADDON="[bashfuns] F2:LIST F3:LOAD F4:SAVE F5:EDIT F6:LOAD-SCR F7:EDIT-SCR\n"
