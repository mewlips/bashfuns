#!/bin/bash

################
# bashfuns 1.0 #
################

BASHFUNS_SCRIPT=~/.bashfuns
BASHFUNS_SAVES_GLOBAL=~/.bashfuns-saves
BASHFUNS_SAVES_PRIVATE=~/.bashfuns-saves_${USER}_at_${HOSTNAME}

editbashfuns() {
    $EDITOR "$BASHFUNS_SCRIPT"
}
loadbashfuns() {
    . "$BASHFUNS_SCRIPT"
}
setglobal() {
    BASHFUNS_SAVES="$BASHFUNS_SAVES_GLOBAL"
}
setprivate() {
    BASHFUNS_SAVES="$BASHFUNS_SAVES_PRIVATE"
}
savefuns() {
    for fun in $*; do
        if [ ! -z "$fun" ]; then
            declare -f "$fun" >> "$BASHFUNS_SAVES"
            if [ $? = 0 ]; then
                echo \"$fun\" saved.
            else
                echo \"$fun\" is not defined.
            fi
        else
            echo usage: savefun \<fun\>..
        fi
    done
}
loadfuns() {
    for saves in "$BASHFUNS_SAVES_GLOBAL" "$BASHFUNS_SAVES_PRIVATE"; do
        if [ -f "$saves" ]; then
            . "$saves"
        fi
    done
}
editfuns() {
    $EDITOR "$BASHFUNS_SAVES"
}
listfuns() {
    for saves in "$BASHFUNS_SAVES_GLOBAL" "$BASHFUNS_SAVES_PRIVATE"; do
        if [ -f "$saves" ]; then
            echo $saves
            grep --color=auto '^[a-z]' "$saves" | sed 's/^/    /' | sort
        fi
    done
}

loadfuns
setglobal
