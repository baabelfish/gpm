TPM
===

The Package Manager, because we need more package managers.

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
- Create a configuration file
- Run ``tpm install``
- Restart shell (to get sourced packages working)

Example ``~/.tpm.json``:
```json
{
    "verbose": true,
    "preinstall": "echo \"running preinstall\"",
    "postinstall": "echo \"running postinstall\"",
    "packages": {
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
            "build": "make"
        },
        "nojhan/liquidprompt": {
            "source": ["liquidprompt"]
        }
    }
}
```

# Commands

#### Install
Check configuration and install new packages
```bash
$ tpm install https://github.com/x/y
$ tpm install x/y
$ tpm install # Install uninstalled packages
```

#### Remove
Check configuration and remove packages which are no longer wanted
```bash
$ tpm remove https://github.com/x/y
$ tpm remove x/y
$ tpm remove # Remove packages which are no longer listed on config
```

#### Update
Updates installed packages, or ones provided.
```bash
$ tpm update tpm
$ tpm update x/y
$ tpm update # Updates all installed packages
```

#### Info
Shows git log of the package.
```bash
$ tpm info <package>
```

#### List
Lists installed packages, versions and date last updated.
```bash
$ tpm list
```

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
