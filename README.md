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
  - ...and [jq](http://stedolan.github.io/jq/), for now...

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

Example ``~/.tpm.json``:
```json
{
    "verbose": true,
    "preinstall": "echo \"running preinstall\"",
    "postinstall": "echo \"running postinstall\"",
    "packages": {
        "https://github.com/baabelfish/tpm-filemanagement": {},
        "nojhan/liquidprompt": {
            "source": ["liquidprompt"]
        },
        "git://code.i3wm.org/i3": {
            "bin": { 
                "i3": "i3",
                "i3bar": "i3bar",
                "i3-config-wizard": "i3-config-wizard/i3-config-wizard",
                "i3-dmenu-desktop": "i3-dmenu-desktop",
                "i3-dump-log": "i3-dump-log/i3-dump-log",
                "i3-input": "i3-input/i3-input",
                "i3-migrate-config-to-v4": "i3-migrate-config-to-v4",
                "i3-msg": "i3-msg/i3-msg",
                "i3-nagbar": "i3-nagbar/i3-nagbar",
                "i3-sensible-editor": "i3-sensible-editor",
                "i3-sensible-pager": "i3-sensible-pager",
                "i3-sensible-terminal": "i3-sensible-terminal"
            },
            "version": "4.5.1",
            "build": "make"
        }
    }
}
```

You shouldn't install software like i3 with tpm unless you know what you're
doing. It's purpose here is to provide a more complex example.

# Commands

#### Install
Check configuration and install new packages.
```bash
$ tpm install https://github.com/x/y
$ tpm install x/y
$ tpm install # Install uninstalled packages
```

#### Remove
Check configuration and remove packages which are no longer wanted
```bash
$ tpm remove <name>
```

#### Prune
Removes all packages not in configuration file.
```bash
$ tpm prune
```

#### Update
Updates installed packages, or ones provided.
```bash
$ tpm update tpm
$ tpm update x/y
$ tpm update # Updates all installed packages
```

#### History
Shows git log of the package.
```bash
$ tpm info <package>
```

#### Info
Shows package information. Version, etc.
```bash
$ tpm info <package>
```

#### List
Lists installed packages, versions and date last updated.
```bash
$ tpm list
```

# TODO
- More clever update
- Complete removal of tpm (maybe with ``tpm remove tpm``
- persistent install `` tpm install --save <package> ``
- Support .tar packages
- List available versions and choose from them
- Support branch names as versions

#### Enable
Enables a disabled package.
```bash
$ tpm enable <packages>
```

#### Disable
Disables an installed package.
```bash
$ tpm disable <packages>
```
