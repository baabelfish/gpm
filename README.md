TPM
===

The Package Manager

# Goal
- Portable over linux distributions (possibly OS X)
- No need for sudo
- Only dependences are bash/zsh and git
- Tab completion for bash/zsh

# Installation
```bash
bash <(curl -kL https://raw.github.com/baabelfish/tpm/master/init)
```

# Usage

Example config
```bash
{
    "packages": "$HOME/.local/tpm",
    "symlinks": "$HOME/bin",
    "packages": {
        "x/y": "*",
        "Deraen/displaymgr": {
            "version": "~0.0.1",
            "bin": {"dsp": "displaymgr.py"}
        },
        "liquidprompt/liquidprompt": {
            "source": ["liquidprompt"]
        }
    }
}
```

```bash
$ tpm install x/y
$ tpm remove x/y
$ tpm update
Updated x/y, v0.0.1 -> v0.0.2
Checking installed packages [2/20]...
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

## For later

#### List
Lists installed packages
```bash
$ tpm list
```

#### Disable
Disables an installed package. (Deletes symlink)
```bash
$ tpm disable <package>
```

#### Enable
Enables a disabled package. (Creates symlink)
```bash
$ tpm enable <package>
```

#### Update
Updates installed packages, or ones provided.
```bash
$ tpm update [packages...]
```
