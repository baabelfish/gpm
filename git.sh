#!/bin/bash
source $TPM_PACKAGES/tpm/helpers.sh
source $TPM_PACKAGES/tpm/json.sh

# $1 - url or github suffix
# Convert url to github form
githubify() {
    local regex='^http'
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
        rm -rf "$TPM_PACKAGES/$1"
        rm -f "$TPM_PACKAGES/${1}_source"
        echo -e "${C_REMOVING}Removed${default}: ${bold}$1${default}"
    else
        echo -e "${C_ERROR}${bold}No such package${default}: ${bold}$1"
    fi
}

updateOne() {
    cd $TPM_PACKAGES/$1
    git submodule update --init --recursive
    git pull
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
        local URL=$(echo $(githubify "$(getName $i)") | tr -d '"')
        local NAME=$(echo $URL | rev | cut -f1 -d '/' | rev)
        local SOURCE="$TPM_PACKAGES/${NAME}_source"

        # Handle sourcing
        echo -n "" > "$SOURCE"
        SOURCES=($(echo $(getSources $i) | tr -d '"'))
        for s in ${SOURCES[@]}; do
            echo "source $TPM_PACKAGES/$NAME/$s" > "$SOURCE"
        done

        # Clone repo
        git clone "$URL" $TPM_PACKAGES/$NAME

        # TODO Write install info
    done
}
