#!/bin/bash
IFS=$'\n'
jq_bin="jq"
jq_location="$TPM_PACKAGES/.aux/jq"
[[ -e $jq_location ]] && jq_bin="$jq_location"

# $1 = File name
# Return package objects separated by newlines
getPackages() {
    local i
    local NAMES=$($jq_bin '.packages' ${1} | $jq_bin keys)
    local LEN=$(echo $NAMES | $jq_bin -r length)
    for (( i = 0; i < $LEN; i++ )); do
        PKG=$(echo $NAMES | $jq_bin -r .[${i}])
        DATA=$($jq_bin '.packages' ${1} | $jq_bin ".[\"$PKG\"]")
        DATA=$(echo ${DATA} | $jq_bin "if (. | type) != \"string\" then . else {version: .} end")
        DATA=$(echo ${DATA} | $jq_bin ". + {name: \"$PKG\"}")
        echo $DATA
    done
}

# $1 = Field name
# $2 = File name
# Returns a string
getField() {
    echo $(cat ${2} | $jq_bin -r "if .${1} != null then .${1} else \"\" end")
}

# $1 = Field name
# $2 = Object
# Returns a string
parseField() {
    echo $(echo ${2} | $jq_bin -r "if .${1} != null then .${1} else \"\" end")
}

# $1 = Package Object
# Returns strings, separated by newlines
getSources() {
    local i
    local LEN=$(echo ${1} | $jq_bin -r ".source | length")
    if [[ $LEN -gt 0 ]]; then
        for (( i = 0; i < $LEN; i++ )); do
            echo $(echo ${1} | $jq_bin -r ".source[${i}]")
        done
    fi
}

# $1 = Package Object
# Return destination and source filename separated by tabs
# and all these pairs separated by newlines
getBinaries() {
    local i
    local LEN=$(echo ${1} | $jq_bin -r ".bin | length")
    if [[ $LEN -gt 0 ]]; then
        local NAMES=$(echo ${1} | $jq_bin ".bin | keys")
        for (( i = 0; i < $LEN; i++ )); do
            local NAME=$(echo ${NAMES} | $jq_bin -r ".[${i}]")
            echo $NAME$'\t'$(echo ${1} | $jq_bin -r ".bin[\"${NAME}\"]")
        done
    fi
}
