#!/bin/bash
# Temporary helper script
[[ ! -z $TPM_CONFIG ]] && rm -f $TPM_CONFIG
[[ ! -z $TPM_SYMLINKS ]] && rm -rf $TPM_SYMLINKS
[[ ! -z $TPM_PACKAGES ]] && rm -rf $TPM_PACKAGES
