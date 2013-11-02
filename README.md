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
$ git clone https://github.com/baabelfish/gpm ~/.gpm
$ echo "source ~/.gpm/gpm.sh" >> ~/.zshrc
```

# Configuration
```bash
$ gpm init
Where shall I place the binaries? [ ~/bin ]: <CR>
Where shall I place package lists? [ ~/.gpmfile ]: <CR>
Where shall I place configuration? [ ~/.gpmrc ]: <CR>
Done.
```

# Usage
```bash
$ gpm install x/y
Downloading... x/y
Compiling...
Creating symlinks...
Done.

$ gpm remove x/y
Done.
```


# Packaging


# Commands

#### Init
Interactive configuration setter.
```bash
$ gpm init
```

#### Install
Installs a package to
```bash
$ gpm install https://github.com/x/y
$ gpm install x/y
$ gpm i x/y
```

#### Remove
Removes an installed package.
```bash
$ gpm remove https://github.com/x/y
$ gpm remove x/y
$ gpm r x/y
```

## For later

#### List
Lists available packages.
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

#### Edit
```bash
# same as $EDITOR $GPMCONFIG
$ gpm edit
```

#### Search
Searches available packages by string.
```bash
$ gpm search <string>
```
