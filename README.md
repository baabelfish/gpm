gpm
===

Git Package Manager

# Goal
- Portable over linux distributions (possibly OS X)
- No need for sudo
- Tab completion for bash/zsh

# Installation
```bash
$ curl -kL http.//github.com/baabelfish/gpm/blob/master/init | bash
Where shall I place the symlinks? [ ~/bin ]: <CR>
Where shall I place the packages? [ ~/.local/gpm ]: <CR>
Where shall I place configuration? [ ~/.gpm.json ]: <CR>

Now add the following line into your .bashrc or .zshrc:

source ~/.local/gpm/gpm/source
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
            "version": "*",
            "bin": {"dsp": "displaymgr.py"}
        },
        "liquidprompt/liquidprompt": {
            "version": "*",
            "source": ["liquidprompt"]
        }
    }
}
```

```bash
$ gpm check
Installing new package x/y...

$ gpm clean
Removing no longer wanted package x/y...

$ gpm install [-S --save] x/y

$ gpm enable x/y

$ gpm disable x/y

$ gpm remove x/y

$ gpm update
Checking installed packages [1/20]...
Updating x/y, v0.0.1 -> v0.0.2
```

# Commands

#### Install
Check configuration and install new packages
```bash
$ gpm install https://github.com/x/y
$ gpm install x/y
$ gpm i x/y
```

#### Remove
Check configuration and remove packages which are no longer wanted
```bash
$ gpm remove https://github.com/x/y
$ gpm remove x/y
$ gpm r x/y
```

## For later

#### List
Lists installed packages.
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

#### Search
Searches available packages by string.
```bash
$ gpm search <string>
```
