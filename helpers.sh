#!/bin/bash

# Misc helpers
################################################################################
typeset -Ag FX FG BG

addSource() {
    [[ -e "$1" ]] && source "$1"
}

# Drawing
################################################################################
cursor_load() {
    echo -en '\033[u'
}

cursor_save() {
    echo -en '\033[s'
}

cursor_hide() {
    echo -en "\033[?25l"
}

cursor_show() {
    echo -en "\033[?25h"
}

term_height() {
    echo $(tput lines)
}

term_width() {
    echo $(tput cols)
}

clear_rest_of_screen() {
    WIDTH=$(term_width)
    EMPTY=""
    for (( i = 0; i < $WIDTH; i++ )); do
        EMPTY=$EMPTY' '
    done

    ROW=$(cursor_pos_row)
    HEIGHT=$(term_height)
    TOGO=$(($HEIGHT-$ROW))
    for (( i = 1; i < $TOGO; i++ )); do
        echo -e '\033[K'
    done
}

clear_rest_of_line() {
    COL=$(cursor_pos_col)
    SIZE=$(term_width)
    EMPTY=""
    for (( i = $COL; i < $SIZE; i++ )); do
        EMPTY=$EMPTY' '
    done
    echo -n $EMPTY
}


# Colors
################################################################################
if (( $# == 0 )); then
    SUPPORT=256
else
    SUPPORT=$1
fi

for color in {000..$SUPPORT}; do
    FG[$color]="\e[38;5;${color}m"
    BG[$color]="\e[48;5;${color}m"
done

BLUE="[38;05;67m"
CYAN='\033[1;36m'
GREEN="[38;05;107m"
ORANGE="[38;05;179m"
PURPLE="[38;05;96m"
RED="[38;05;167m"
YELLOW="[38;05;222m"

blue='\033[0;34m'
cyan='\033[0;36m'
default='\033[0m'
green='\033[0;32m'
purple='\033[0;35m'
red='\033[0;31m'
yellow='\033[0;33m'

default='\033[0m'
bold='\033[1m'
underline='\033[4m'

C_HEADER=${GREEN}
C_DEFAULTPARAM=${BLUE}
C_ERROR=${underlined}${RED}
C_WARNING=${ORANGE}
C_SUCCESS=${GREEN}
C_PACKAGE_NAME=${bold}
C_PACKAGE_UPDATED=${green}
