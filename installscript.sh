#!/bin/bash
[[ ! -e ~/.local/tpm/tpm ]] && ./init
cp -f tpm ~/.local/tpm/tpm/tpm
cp -f git.sh ~/.local/tpm/tpm/git.sh
cp -f helpers.sh ~/.local/tpm/tpm/helpers.sh
cp -f json.sh ~/.local/tpm/tpm/json.sh
cp -f source ~/.local/tpm/tpm/source
