#!/usr/bin/env bash
#
# Copyright (c) 2018-2025 Stéphane Micheloud
#
# Licensed under the MIT License.
#

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

debug() {
    local DEBUG_LABEL="[46m[DEBUG][0m"
    [[ $DEBUG -eq 1 ]] && echo "$DEBUG_LABEL $1" 1>&2
}

warning() {
    local WARNING_LABEL="[46m[WARNING][0m"
    echo "$WARNING_LABEL $1" 1>&2
}

error() {
    local ERROR_LABEL="[91mError:[0m"
    echo "$ERROR_LABEL $1" 1>&2
}

# use variables EXITCODE, TIMER_START
cleanup() {
    [[ $1 =~ ^[0-1]$ ]] && EXITCODE=$1

    debug "EXITCODE=$EXITCODE"
    exit $EXITCODE
}

args() {
    [[ $# -eq 0 ]] && HELP=1 && return 1

    for arg in "$@"; do
        case "$arg" in
        ## options
        -debug)    DEBUG=1 ;;
        -help)     HELP=1 ;;
        -mlton)    TOOLSET=mlton ;;
        -mosml)    TOOLSET=mosml ;;
        -smlnj)    TOOLSET=smlnj ;;
        -verbose)  VERBOSE=1 ;;
        -*)
            error "Unknown option $arg"
            EXITCODE=1 && return 0
            ;;
        ## subcommands
        clean)     CLEAN=1 ;;
        compile)   COMPILE=1 ;;
        help)      HELP=1 ;;
        run)       COMPILE=1 && RUN=1 ;;
        *)
            error "Unknown subcommand $arg"
            EXITCODE=1 && return 0
            ;;
        esac
    done
    debug "Options    : DEBUG=$DEBUG TOOLSET=$TOOLSET VERBOSE=$VERBOSE"
    debug "Subcommands: CLEAN=$CLEAN COMPILE=$COMPILE HELP=$HELP RUN=$RUN"
    debug "Variables  : GIT_HOME=$GIT_HOME"
    debug "Variables  : MLTON_HOME=$MLTON_HOME"
    debug "Variables  : MOSML_HOME=$MOSML_HOME"
    debug "Variables  : SMLNJ_HOME=$SMLNJ_HOME"
}

help() {
    cat << EOS
Usage: $BASENAME { <option> | <subcommand> }

  Options:
    -debug       print commands executed by this script
    -mlton       select MLton toolset
    -mosml       select Moscow ML toolset
    -smlnj       select SML/NJ toolset
    -verbose     print progress messages

  Subcommands:
    clean        delete generated files
    compile      compile SML source files
    help         print this help message
    run          execute main class "$APP_NAME"
EOS
}

clean() {
    if [[ -d "$TARGET_DIR" ]]; then
        if [[ $DEBUG -eq 1 ]]; then
            debug "Delete directory \"$(mixed_path $TARGET_DIR)\""
        elif [[ $VERBOSE -eq 1 ]]; then
            echo "Delete directory \"${TARGET_DIR/$ROOT_DIR\//}\"" 1>&2
        fi
        rm -rf "$(mixed_path $TARGET_DIR)"
        [[ $? -eq 0 ]] || ( EXITCODE=1 && return 0 )
    fi
    rm -f "$ROOT_DIR/errinfo.\$\$\$"
}

compile() {
    [[ -d "$TARGET_DIR" ]] || mkdir -p "$TARGET_DIR"

    local is_required="$(action_required "$TARGET_FILE" "$SOURCE_DIR/" "*.sml")"
    [[ $is_required -eq 0 ]] && return 1
    
    compile_$TOOLSET $is_required
    [[ $? -eq 0 ]] || ( EXITCODE=1 && return 0 )
}

action_required() {
    local target_file=$1
    local search_path=$2
    local search_pattern=$3
    local source_file=
    for f in $(find "$search_path" -type f -name "$search_pattern" 2>/dev/null); do
        [[ $f -nt $source_file ]] && source_file=$f
    done
    if [[ -z "$source_file" ]]; then
        ## Do not compile if no source file
        echo 0
    elif [[ ! -f "$target_file" ]]; then
        ## Do compile if target file doesn't exist
        echo 1
    else
        ## Do compile if target file is older than most recent source file
        [[ $source_file -nt $target_file ]] && echo 1 || echo 0
    fi
}

compile_mlton() {
    local n_files="1 SML source file"
    local mlton_opts="-output \"$TARGET_FILE\""

    if [[ $DEBUG -eq 1 ]]; then
        debug "\"$MLTON_HOME/bin/mlton\" $mlton_opts \"$SOURCE_DIR/$MAIN_NAME.sml\""
    elif [[ $VERBOSE -eq 1 ]]; then
        echo "Compile SML source file" 1>&2
    fi
    eval "$MLTON_HOME/bin/mlton" $mlton_opts "$SOURCE_DIR/$MAIN_NAME.sml"
    if [[ $? -ne 0 ]]; then
        error "Failed to compile $n_files into directory \"$TARGET_DIR\""
        cleanup 1
    fi
}

compile_mosml() {
    warning "Not yet implemented"
}

compile_smlnj() {
    warning "Not yet implemented"
}

mixed_path() {
    if [[ -x "$CYGPATH_CMD" ]]; then
        $CYGPATH_CMD -am $1
    elif [[ $(($mingw + $msys)) -gt 0 ]]; then
        echo $1 | sed 's|/|\\\\|g'
    else
        echo $1
    fi
}

run() {
    if [[ ! -f "$TARGET_FILE" ]]; then
        error "Program \"$TARGET_FILE\" not found"
        cleanup 1
    fi
    eval "$(mixed_path $TARGET_FILE)"
    if [[ $? -ne 0 ]]; then
        error "Failed to execute program \"$TARGET_FILE\""
        cleanup 1
    fi
}

##############################################################################
## Environment setup

BASENAME=$(basename "${BASH_SOURCE[0]}")

EXITCODE=0

ROOT_DIR="$(getHome)"

SOURCE_DIR="$ROOT_DIR/src"
TARGET_DIR="$ROOT_DIR/target"

## We refrain from using `true` and `false` which are Bash commands
## (see https://man7.org/linux/man-pages/man1/false.1.html)
CLEAN=0
COMPILE=0
DEBUG=0
HELP=0
MAIN_NAME=hello
MAIN_ARGS=
RUN=0
TOOLSET=smlnj
VERBOSE=0

COLOR_START="[32m"
COLOR_END="[0m"

cygwin=0
mingw=0
msys=0
darwin=0
case "$(uname -s)" in
    CYGWIN*) cygwin=1 ;;
    MINGW*)  mingw=1 ;;
    MSYS*)   msys=1 ;;
    Darwin*) darwin=1
esac
unset CYGPATH_CMD
PSEP=":"
if [[ $(($cygwin + $mingw + $msys)) -gt 0 ]]; then
    CYGPATH_CMD="$(which cygpath 2>/dev/null)"
    PSEP=";"
    [[ -n "$GIT_HOME" ]] && GIT_HOME="$(mixed_path $GIT_HOME)"
    [[ -n "$MLTON_HOME" ]] && MLTON_HOME="$(mixed_path $MLTON_HOME)"
    [[ -n "$MOSML_HOME" ]] && MOSML_HOME="$(mixed_path $MOSML_HOME)"
    [[ -n "$SMLNJ_HOME" ]] && SMLNJ_HOME="$(mixed_path $SMLNJ_HOME)"
fi

APP_NAME="$(basename $ROOT_DIR)"
TARGET_FILE="$TARGET_DIR/$APP_NAME.exe"

args "$@"
[[ $EXITCODE -eq 0 ]] || cleanup 1

##############################################################################
## Main

[[ $HELP -eq 1 ]] && help && cleanup

if [[ $CLEAN -eq 1 ]]; then
    clean || cleanup 1
fi
if [[ $COMPILE -eq 1 ]]; then
    compile || cleanup 1
fi
if [[ $RUN -eq 1 ]]; then
    run || cleanup 1
fi
cleanup
