#!/usr/bin/env bash

############
# bashfuns #
############

BASHFUNS_SCRIPT=~/.bashfuns
BASHFUNS_VERSION=2.2

BASHFUNS_SAVES_GLOBAL=~/.bashfuns-saves
BASHFUNS_SAVES_PRIVATE=~/.bashfuns-saves_${USER}_at_${HOSTNAME}

if [ -z "$EDITOR" ]; then
    EDITOR=vi
fi

bashfuns_wrap_color () {
    local color=$1
    shift
    case "$color" in
        "black")   echo $(tput setaf 0)"$*"$(tput sgr0);;
        "red")     echo $(tput setaf 1)"$*"$(tput sgr0);;
        "green")   echo $(tput setaf 2)"$*"$(tput sgr0);;
        "yellow")  echo $(tput setaf 3)"$*"$(tput sgr0);;
        "blue")    echo $(tput setaf 4)"$*"$(tput sgr0);;
        "magenta") echo $(tput setaf 5)"$*"$(tput sgr0);;
        "cyan")    echo $(tput setaf 6)"$*"$(tput sgr0);;
        "white")   echo $(tput setaf 7)"$*"$(tput sgr0);;
        "BLACK")   echo $(tput bold)$(tput setaf 0)"$*"$(tput sgr0);;
        "RED")     echo $(tput bold)$(tput setaf 1)"$*"$(tput sgr0);;
        "GREEN")   echo $(tput bold)$(tput setaf 2)"$*"$(tput sgr0);;
        "YELLOW")  echo $(tput bold)$(tput setaf 3)"$*"$(tput sgr0);;
        "BLUE")    echo $(tput bold)$(tput setaf 4)"$*"$(tput sgr0);;
        "MAGENTA") echo $(tput bold)$(tput setaf 5)"$*"$(tput sgr0);;
        "CYAN")    echo $(tput bold)$(tput setaf 6)"$*"$(tput sgr0);;
        "WHITE")   echo $(tput bold)$(tput setaf 7)"$*"$(tput sgr0);;
        [0-9]*)    echo $(tput bold)$(tput setaf $color)"$*"$(tput sgr0);;
        *)         echo $color "$*"
    esac
}
alias wrap_color=bashfuns_wrap_color

bashfuns_edit_script() {
    $EDITOR "$BASHFUNS_SCRIPT"
}
bashfuns_load_script() {
    . "$BASHFUNS_SCRIPT"
}
bashfuns_save() {
    local saves
    if [[ $1 == "-g" ]]; then
        saves="$BASHFUNS_SAVES_GLOBAL"
        shift
    else
        saves="$BASHFUNS_SAVES_PRIVATE"
    fi
    for fun in $*; do
        declare -f "$fun" >> "$saves"
        if [[ $? = 0 ]]; then
            echo \"$fun\" saved.
        else
            echo "undefined function: $fun [skipped]"
        fi
    done
}
bashfuns_load() {
    for saves in "$BASHFUNS_SAVES_GLOBAL" "$BASHFUNS_SAVES_PRIVATE"; do
        if [ -f "$saves" ]; then
            . "$saves"
        fi
    done
}
bashfuns_edit() {
    local saves
    if [[ $1 == "-g" ]]; then
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
bashfuns_list() {
    for saves in "$BASHFUNS_SAVES_GLOBAL" "$BASHFUNS_SAVES_PRIVATE"; do
        if [[ -f $saves ]]; then
            echo "<< $(wrap_color WHITE $saves) >>"
            echo
            echo $(wrap_color BLUE "  [EXPORTS]")
            grep '^export' "$saves" | sed 's/export *//' | sed 's/^/      /' | sort
            echo
            echo $(wrap_color BLUE "  [FUNCTIONS]")
            grep '^[a-zA-Z]' "$saves" | grep '()' | sed 's/ *()//' | sed 's/ *#//' | sed 's/^/      /' | sort
            echo
            echo $(wrap_color BLUE "  [ALIASES]")
            grep '^alias' "$saves" | sed 's/^alias /      /' | sort
        fi
        echo
    done
}
bashfuns_save_alias() {
    local saves
    if [[ $1 == "-g" ]]; then
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

# key bindings
# F2:list F3:load F4:save F5:edit F6:load-script F7:edit-script
bind '"OQ":"bf list"'
bind '"OR":"bf load"'
bind '"OS":"bf save "'
bind '"[15~":"bf edit "'
bind '"[17~":"bf load_script"'
bind '"[18~":"bf edit_script"'

bashfuns_help() {
    echo "Bashfuns v$BASHFUNS_VERSION"
    echo
    echo "bf help            :     "
    echo "bf list            : <F2>"
    echo "bf load            : <F3>"
    echo "bf save <fun>..    : <F4>"
    echo "bf save -g <fun>.. :     "
    echo "bf edit            : <F5>"
    echo "bf edit -g         :     "
    echo "bf load_script     : <F6>"
    echo "bf save_script     : <F7>"
    echo
}
bashfuns() {
    local cmd="$1"
    if [[ -z $cmd ]]; then
        bashfuns_help
        return
    fi
    shift
    bashfuns_"$cmd" $*
}

bashfuns_load

alias bf=bashfuns
