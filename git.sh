#!/bin/bash
source $TPM_PACKAGES/tpm/helpers.sh
source $TPM_PACKAGES/tpm/json.sh

# $1 - url or github suffix
# Convert url to github form
githubify() {
    local regex='^http|^git:'
    if [[ $1 =~ $regex ]]; then
        echo "$1"
    else
        echo "https://github.com/${1}"
    fi
}

listOne() {
    cd $TPM_PACKAGES/$1
    echo -e "${C_PACKAGE_NAME}$1${default}    (${C_PACKAGE_UPDATED}updated${default}: $(git log -1|grep '^Date'|cut -f2- -d':'|sed 's/^ *//g'))"
}

removeOne() {
    if [[ -d "$TPM_PACKAGES/$1" ]]; then
        local BINARIES=($(cat "$TPM_PACKAGES/${1}_binaries"))
        for i in ${BINARIES[@]}; do
            rm "$i"
        done
        rm -rf "$TPM_PACKAGES/$1"
        rm -f "$TPM_PACKAGES/${1}_source"
        rm -f "$TPM_PACKAGES/${1}_binaries"
        echo -e "${C_REMOVING}Removed${default}: ${bold}$1${default}"
    else
        echo -e "${C_ERROR}${bold}No such package${default}: ${bold}$1"
    fi
}

updateOne() {
    cd "$1"
    local NAME=$(echo $1 | rev | cut -f1 -d '/' | rev)
    echo -n "$NAME"
    git submodule update --init --recursive --quiet 2> /dev/null
    git pull --quiet 2> /dev/null
    echo -e "${S_DONE}"
}

infoOne() {
    cd $TPM_PACKAGES/$1
    git log
}

installOne() {
    echo $1
}

installConfig() {
    PACKAGES=($(getPackages $TPM_CONFIG))
    for i in ${PACKAGES[@]}; do
        # Package info
        local URL=$(echo $(githubify "$(getName $i | tr -d '"')") | tr -d '"')
        local NAME=$(echo $URL | rev | cut -f1 -d '/' | rev)

        local SOURCE="$TPM_PACKAGES/${NAME}_source"
        local BINARY="$TPM_PACKAGES/${NAME}_binaries"

        # Don't touch existing
        if [[ -d "$TPM_PACKAGES/${NAME}" ]]; then
            continue
        fi

        cd "$TPM_PACKAGES/$NAME"
        echo -ne "${C_PACKAGE_NAME}$NAME${default}: "

        # Clone repo
        echo -ne "${S_CLONING}"
        git clone --quiet "$URL" $TPM_PACKAGES/$NAME

        # Change version
        # local VERSION="$(echo $(getVersion $i) | tr -d '"')"
        # if [[ ! -z "$VERSION" ]] && [[ "$VERSION" != "null" ]]; then
        #     git checkout feature/${VERSION}
        # elif

        # Run buildcommand
        local BUILDCOMMAND="$(echo $(getBuild $i) | tr -d '"')"
        if [[ ! -z "$BUILDCOMMAND" ]] && [[ "$BUILDCOMMAND" != "null" ]]; then
            echo -ne "${S_BUILDING}"
            eval "$BUILDCOMMAND" > /dev/null
        fi
        [[ $ERR -ne 0 ]] && echo ${S_FAILURE} && return 1

        # Handle sourcing
        echo -ne "${S_SOURCING}"
        echo -n "" > "$SOURCE"
        SOURCES=($(echo $(getSources $i) | tr -d '"'))
        for s in ${SOURCES[@]}; do
            echo "source $TPM_PACKAGES/$NAME/$s" > "$SOURCE"
        done
        [[ $ERR -ne 0 ]] && echo ${S_FAILURE} && return 1

        # Handle binaries
        echo -ne "${S_LINKING}"
        echo -n "" > "$BINARY"
        BINARIES=($(echo $(getBinaries $i) | tr -d '"'))
        for b in ${BINARIES[@]}; do
            local BIN_TO=$(echo $b | cut -f1 -d'	')
            local BIN_FROM=$(echo $b | cut -f2 -d'	')
            ln -s $TPM_PACKAGES/${NAME}/${BIN_FROM} $TPM_SYMLINKS/${BIN_TO}
            echo "$TPM_SYMLINKS/${BIN_TO}" > "$BINARY"
        done
        [[ $ERR -ne 0 ]] && echo ${S_FAILURE} && return 1

        # TODO Write install info
        echo -e "${S_SUCCESS}${default}"
    done
}
