TPM
===

The Package Manager, because we need more package managers. Seriously this tries
to be a package manager for people who like to share scripts, configs or even
simple programs that need building. This is great especially when using a forked
repo, no need to package it again, user only needs to change the URL.

This piece of "software" was designed (usability wise) after [npm](https://npmjs.org) and vim package manager
[Vundle](https://github.com/gmarik/vundle).

# Goal
- Portable over linux distributions (possibly OS X)
- No need for sudo
- Tab completion for bash/zsh
- Only dependences are bash/zsh and git

# Installation
Run installation script:
```bash
$ bash <(curl -kL https://raw.github.com/baabelfish/tpm/master/init)
```

NOTE: Remember to add the line it provides to your ``~/.zshrc`` or ``~/.bashrc``.

# Usage
- Modify the configuration file
- Run ``tpm install``
- Restart shell (to get sourced packages working)

Example ``~/.tpm.sh``:
```bash
#!/bin/bash

export TPM_BIN=$HOME/.local/tpm-bin
export TPM_DIR=$HOME/.local/tpm
. ${TPM_DIR}/tpm/tpm

plug tpm "baabelfish/tpm"

plug liquidprompt "nojhan-liquidprompt"
addSource liquidprompt "liquidprompt"

if [[ $HOSTNAME == "juho-desktop" ]] || [[ $HOSTNAME == "juho-laptop" ]]; then
    plug dspmgr "Deraen/dspmgr"

    plug ponymix "falconindy/ponymix"
    build ponymix "make"
    addBin ponymix ponymix ponymix
fi

commit
```

# Commands

#### Install
Check configuration and install new packages
```bash
$ tpm install
```

#### Clean
Remove unnecessary packages
```bash
$ tpm clean
```

#### Update
Updates installed packages
```bash
$ tpm update
```
