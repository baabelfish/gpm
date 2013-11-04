#!/bin/bash
IFS=$'\n'

# $1 = File name
# Return package objects separated by newlines
getPackages() {
    local i
    local NAMES=$(jq keys ${1})
    local LEN=$(echo $NAMES | jq -r length)
    for (( i = 0; i < $LEN; i++ )); do
        PKG=$(echo $NAMES | jq -r .[${i}])

        DATA=$(jq ".[\"$PKG\"]" ${1})
        DATA=$(echo ${DATA} | jq "if (. | type) != \"string\" then . else {version: .} end")
        DATA=$(echo ${DATA} | jq ". + {name: \"$PKG\"}")
        echo $DATA
    done
}

# $1 = Package Object
# Returns a string
getName() {
    echo $(echo ${1} | jq ".name")
}

# $1 = Package Object
# Returns a string
getVersion() {
    echo $(echo ${1} | jq "if .version != null then .version else \"*\" end")
}

# $1 = Package Object
# Returns a build command string
getBuild() {
    echo $(echo ${1} | jq ".build")
}

# $1 = Package Object
# Returns strings, separated by newlines
getSources() {
    local i
    local LEN=$(echo ${1} | jq ".source | length")
    if [[ $LEN -gt 0 ]]; then
        for (( i = 0; i < $LEN; i++ )); do
            echo $(echo ${1} | jq -r ".source[${i}]")
        done
    fi
}

# $1 = Package Object
# Return destination and source filename separated by tabs
# and all these pairs separated by newlines
getBinaries() {
    local i
    local LEN=$(echo ${1} | jq ".bin | length")
    if [[ $LEN -gt 0 ]]; then
        local NAMES=$(echo ${1} | jq ".bin | keys")
        for (( i = 0; i < $LEN; i++ )); do
            local NAME=$(echo ${NAMES} | jq -r ".[${i}]")
            echo $NAME$'\t'$(echo ${1} | jq -r ".bin[\"${NAME}\"]")
        done
    fi
}

# PKGS=($(getPackages example.gpm.json))
# for PKG in ${PKGS[@]}; do
#     echo "PACKAGE"
#     getName "$PKG"
#
#     echo "version $(getVersion "$PKG")"
#     echo "sources"
#     getSources "$PKG"
#     echo
#     echo "binaries"
#     getBinaries "$PKG"
#     echo
# done
