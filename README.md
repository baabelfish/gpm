TPM
===

The Package Manager, because we need more package managers.

# Goal
- Portable over linux distributions (possibly OS X)
- No need for sudo
- Only dependences are bash/zsh and git
  - and [jq](http://stedolan.github.io/jq/), for now...
- Tab completion for bash/zsh

# Installation
```bash
$ bash <(curl -kL https://raw.github.com/baabelfish/tpm/master/init)
```

# Usage

Example config
```bash
{
    "x/y": "*",
    "Deraen/displaymgr": {
        "version": "~0.0.1",
        "bin": {"dsp": "displaymgr.py"}
    },
    "liquidprompt/liquidprompt": {
        "source": ["liquidprompt"]
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
$ tpm list <package>
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
