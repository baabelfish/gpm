#!/bin/bash
source $TPM_PACKAGES/tpm/helpers.sh
source $TPM_PACKAGES/tpm/json.sh

IFS=$'\n'
crashed=0
no_such_package=0

printName() {
    if [[ $PARAM_VERBOSE -eq 1 ]]; then
        echo -ne "${C_SEPARATOR}== ${default}"
        echo -ne "${C_PACKAGE_NAME}$1${default}"
        echo -e "${C_SEPARATOR} ==${default}"
    else
        echo -ne "${C_PACKAGE_NAME}$1${default}: "
    fi
}

configureApplication() {
    [[ $PARAM_VERBOSE -eq 0 ]] && GITPARAMS="--quiet"

    C_HEADER=${GREEN}
    C_DEFAULTPARAM=${BLUE}
    C_ERROR=${underlined}${RED}
    C_WARNING=${ORANGE}
    C_SUCCESS=${GREEN}
    C_PACKAGE_NAME=${bold}
    C_PACKAGE_UPDATED=${green}
    C_REMOVING=${ORANGE}${bold}
    C_INFO_PART=${green}
    C_SEPARATOR=${GREEN}

    S_INSTALLING="Installing "
    S_DONE="${GREEN}done${default}\n"
    S_BUILDING="Building${default}..."
    S_SOURCING="Sourcing${default}..."
    S_LINKING="Linking${default}..."
    S_CLONING="Cloning${default}..."
    S_SUCCESS="${underline}${GREEN}Success${default}\n"
    S_FAILURE="${RED}Failure${default}\n"

    if [[ $PARAM_VERBOSE -eq 1 ]]; then
        S_INSTALLING="Installing "
        S_DONE="${GREEN}done${default}\n\n"
        S_BUILDING="Building${default}\n"
        S_SOURCING="Sourcing${default}\n"
        S_LINKING="Linking${default}\n"
        S_CLONING="Cloning${default}\n"
    fi

    package_installed=($(find "$TPM_PACKAGES" -maxdepth 1 -not -name '.*' -type d | tail -n +2))
    package_objects=($(getPackages $TPM_CONFIG))
}

parsePackage() {
    package_url=$(githubify $(parseField 'name' "$1"))
    package_repo=$(echo $package_url | rev | cut -f1,2 -d '/' | rev)
    package_name=$(echo $package_repo | rev | cut -f1 -d '/' | rev)
    package_source="$TPM_PACKAGES/${package_name}_source"
    package_binary="$TPM_PACKAGES/${package_name}_binaries"
    package_version="$(parseField 'version' "$1")"
    package="$1"
}

parsePackageByName() {
    no_such_package=0
    local i
    for i in ${package_objects[@]}; do
        local name="$(echo $(parseField 'name' $i) | rev | cut -f1 -d '/' | rev)"
        if [[ $name == "$1" ]]; then
            parsePackage "$i"
            return
        fi
    done
    no_such_package=1
}

recover() {
    crashed=1
    removeOne "$package_name"
    exit 1
}

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

getBasename() {
    echo $(echo "$1" | rev | cut -f1 -d '/' | rev)
}

getCurrentVersion() {
    echo $(git branch | grep '^\*' | grep 'detached from' | rev | cut -f1 -d' ' | tr -d ')' | rev)
}

auxLink() {
    local SELECTED="$1"
    if [[ -z $(parseField "bin" "$1") ]]; then
        SELECTED="$2"
    fi
    echo -n "" > "$package_binary"
    BINARIES=($(getBinaries "$SELECTED"))
    for b in ${BINARIES[@]}; do
        local bin_to="$TPM_SYMLINKS/$(echo $b | cut -f1 -d $'\t')"
        local bin_from="$TPM_PACKAGES/${package_name}/$(echo $b | cut -f2 -d $'\t')"
        [[ ! -e $bin_to ]] && ln -s $bin_from $bin_to
        echo "$TPM_SYMLINKS/$bin_to" >> "$package_binary"
    done
}

auxSource() {
    local SELECTED="$1"
    if [[ -z $(parseField "source" "$1") ]]; then
        SELECTED="$2"
    fi
    echo -n "" > "$package_source"
    SOURCES=($(getSources "$SELECTED"))
    for s in ${SOURCES[@]}; do
        echo "source $TPM_PACKAGES/$package_name/$s" >> "$package_source"
    done
}

auxBuild() {
    local SELECTED="$1"
    if [[ -z $(parseField "build" "$1") ]]; then
        SELECTED="$2"
    fi
    local BUILDCOMMAND="$(parseField 'build' "$SELECTED")"
    if [[ ! -z "$BUILDCOMMAND" ]]; then
        cd "$TPM_PACKAGES/$package_name"
        if [[ $PARAM_VERBOSE -eq 0 ]]; then
            eval "$BUILDCOMMAND" > /dev/null
        else
            eval "$BUILDCOMMAND"
        fi
    fi
    [[ $? -ne 0 ]] && echo -en ${S_FAILURE} && recover $1
}

listOne() {
    cd $1
    echo -e "${C_PACKAGE_NAME}$(getBasename $1)${default} (${C_PACKAGE_UPDATED}updated${default}: $(git log -1|grep '^Date'|cut -f2- -d':'|sed 's/^ *//g'))"
}

removeOne() {
    [[ $name == "tpm" ]] && echo "I bet you don't want to do that" && return
    if [[ -d "$TPM_PACKAGES/$1" ]]; then
        local location_bin="$TPM_PACKAGES/${1}_binaries"
        local location_source="$TPM_PACKAGES/${1}_source"
        if [[ -e $location_bin ]]; then
            local BINARIES=($(cat $location_bin))
            for i in ${BINARIES[@]}; do
                rm -f "${i}"
            done
            rm -f $location_bin
        fi
        [[ -e $location_source ]] && rm -f $location_source
        rm -rf "$TPM_PACKAGES/$1"
        [[ $crashed -eq 0 ]] && echo -e "${C_REMOVING}Removed${default}: ${bold}$1${default}"
    else
        [[ $crashed -eq 0 ]] && echo -e "${C_ERROR}${bold}No such package${default}: ${bold}$1"
    fi
}

updateOne() {
    cd "$1"
    [[ $(pwd) == "$HOME" ]] && exit 7
    printName $name

    # Determine if update is needed
    # TODO check if user configuration has changed
    git fetch 2> /dev/null
    if [[ $(git rev-parse HEAD) == $(git rev-parse @{u}) ]]; then
        return
    fi

    # If it's so, reset the repo and run install
    git reset --hard HEAD ${GITPARAMS} 2> /dev/null
    git pull ${GITPARAMS} 2> /dev/null
    git submodule update --init --recursive ${GITPARAMS} 2> /dev/null

    local repojson="{}"
    [[ -e "$TPM_PACKAGES/$package_name/.tpm.json" ]] && repojson="$(cat $TPM_PACKAGES/$package_name/.tpm.json)"

    echo -ne "${S_BUILDING}"
    auxBuild "$package" "$repojson"

    echo -ne "${S_SOURCING}"
    auxSource "$package" "$repojson"

    echo -ne "${S_LINKING}"
    auxLink "$package" "$repojson"

    echo -ne "${S_DONE}"
}

historyOne() {
    cd $TPM_PACKAGES/$1
    git log --oneline
}

infoOne() {
    [[ ! -e "$TPM_PACKAGES/$1" ]] && echo "No such package" && exit 1
    cd $TPM_PACKAGES/$1
    local SOURCES=($(cat $TPM_PACKAGES/${1}_source))
    local BINARIES=($(cat $TPM_PACKAGES/${1}_binaries))
    local VERSION=$(getCurrentVersion)
    [[ -z $VERSION ]] && VERSION="latest"

    echo -e ${C_PACKAGE_NAME}$1${C_SEPARATOR}
    draw_screenwide_with '='
    echo -e "${C_INFO_PART}version${default}: $VERSION"
    echo -e "${C_INFO_PART}location${default}: $TPM_PACKAGES/$1"
    if [[ ${#SOURCES[@]} -gt 1 ]]; then
        echo -e "${C_INFO_PART}sources${default}:"
        for i in ${SOURCES[@]}; do
            echo $i
        done
    fi
    [[ ${#SOURCES[@]} -eq 1 ]] && echo -e "${C_INFO_PART}source${default}: $SOURCES"

    if [[ ${#BINARIES[@]} -gt 1 ]]; then
        echo -e "${C_INFO_PART}binaries${default}:"
        for i in ${BINARIES[@]}; do
            echo "  $(echo $i | rev | cut -f1 -d'/' | rev)"
        done
    fi
    if [[ ${#BINARIES[@]} -eq 1 ]]; then
        echo -e "${C_INFO_PART}binary${default}: $(echo $BINARIES | rev | cut -f1 -d'/' | rev)"
    fi
}

installOne() {
    printName $package_name

    echo -ne "${S_CLONING}"
    git clone ${GITPARAMS} "$package_url" $TPM_PACKAGES/$package_name

    # Set version
    if [[ ! -z $package_version ]]; then
        cd $TPM_PACKAGES/$package_name
        local EVERSION=$(git tag -l $package_version | tail -n 1)
        if [[ ! -z $EVERSION ]]; then
            git checkout ${GITPARAMS} tags/${EVERSION}
        fi
    fi

    local repojson="{}"
    [[ -e "$TPM_PACKAGES/$package_name/.tpm.json" ]] && repojson="$(cat $TPM_PACKAGES/$package_name/.tpm.json)"

    echo -ne "${S_BUILDING}"
    auxBuild "$i" "$repojson"

    echo -ne "${S_SOURCING}"
    auxSource "$i" "$repojson"

    echo -ne "${S_LINKING}"
    auxLink "$i" "$repojson"

    # TODO Write install info
    echo -e "${S_SUCCESS}${default}"
}

configRemove() {
    for i in ${package_installed[@]}; do
        local name=$(echo $i | rev | cut -f1 -d'/' | rev)
        parsePackageByName $name
        if [[ no_such_package -ne 0 ]]; then
            removeOne $name
        fi
    done
}

configUpdate() {
    for i in ${package_installed[@]}; do
        local name=$(echo $i | rev | cut -f1 -d'/' | rev)
        parsePackageByName $name
        if [[ no_such_package -eq 0 ]]; then
            updateOne $i
        fi
    done
}

configInstall() {
    for i in ${package_objects[@]}; do
        parsePackage "$i"
        [[ -d "$TPM_PACKAGES/${package_name}" ]] && continue
        installOne "$i"
    done
}
