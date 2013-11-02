gpm
===

Git Package Manager

# Goal
- Portable over linux distributions (possibly OS X)
- No need for sudo
- Only dependences are bash/zsh and git
- Tab completion for bash/zsh

# Installation
```bash
bash <(curl -kL https://raw.github.com/baabelfish/gpm/master/init)
```

# Usage

Example config
```bash
{
    "packages": "$HOME/.local/gpm",
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
$ gpm install x/y
$ gpm remove x/y
$ gpm update
Updated x/y, v0.0.1 -> v0.0.2
Checking installed packages [2/20]...
```

# Commands

#### Install
Check configuration and install new packages
```bash
$ gpm install https://github.com/x/y
$ gpm install x/y
$ gpm install # Install uninstalled packages
```

#### Remove
Check configuration and remove packages which are no longer wanted
```bash
$ gpm remove https://github.com/x/y
$ gpm remove x/y
$ gpm remove # Remove packages which are no longer listed on config
```

## For later

#### List
Lists installed packages
```bash
$ gpm list
```

#### Disable
Disables an installed package. (Deletes symlink)
```bash
$ gpm disable <package>
```

#### Enable
Enables a disabled package. (Creates symlink)
```bash
$ gpm enable <package>
```

#### Update
Updates installed packages, or ones provided.
```bash
$ gpm update [packages...]
```
