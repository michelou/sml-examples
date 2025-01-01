#!/usr/bin/env bash

## Usage: $ . ./setenv.sh

##############################################################################
## Subroutines

getHome() {
    local source="${BASH_SOURCE[0]}"
    while [[ -h "$source" ]]; do
        local linked="$(readlink "$source")"
        local dir="$( cd -P $(dirname "$source") && cd -P $(dirname "$linked") && pwd )"
        source="$dir/$(basename "$linked")"
    done
    ( cd -P "$(dirname "$source")" && pwd )
}

getOS() {
    local os
    case "$(uname -s)" in
        Linux*)  os=linux;;
        Darwin*) os=mac;;
        CYGWIN*) os=cygwin;;
        MINGW*)  os=mingw;;
        MSYS*)   os=msys;;
        *)       os=unknown
    esac
    echo $os
}

getPath() {
    local path=""
    for i in $(ls -d "$1"*/ 2>/dev/null); do path=$i; done
    # ignore trailing slash introduced in for loop
    [[ -z "$path" ]] && echo "" || echo "${path::-1}"
}

##############################################################################
## Environment setup

PROG_HOME="$(getHome)"

OS="$(getOS)"
[[ $OS == "unknown" ]] && { echo "Unsuppored OS"; exit 1; }

if [[ $OS == "cygwin" || $OS == "mingw" || $OS == "msys" ]]; then
    [[ $OS == "cygwin" ]] && prefix="/cygdrive" || prefix=""
    export GIT_HOME="$(getPath "$prefix/c/opt/Git")"
    export MLTON_HOME="$(getPath "$prefix/c/opt/mlton")"
    export MOSML_HOME="$(getPath "$prefix/c/opt/mosml")"
    export SMLNJ_HOME="$(getPath "$prefix/c/opt/smlnj")"
else
    export MLTON_HOME="$(getPath "/opt/mlton")"
    export MOSML_HOME="$(getPath "/opt/mosml")"
    export SMLNJ_HOME="$(getPath "/opt/smlnj")"
fi
PATH1="$PATH"
[[ -x "$GIT_HOME/bin/git" ]] && PATH1="$PATH1:$GIT_HOME/bin"
export PATH="$PATH1"
