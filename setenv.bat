@echo off
setlocal enabledelayedexpansion

@rem only for interactive debugging
set _DEBUG=0

@rem #########################################################################
@rem ## Environment setup

set _EXITCODE=0

call :env
if not %_EXITCODE%==0 goto end

call :args %*
if not %_EXITCODE%==0 goto end

@rem #########################################################################
@rem ## Main

if %_HELP%==1 (
    call :help
    exit /b !_EXITCODE!
)

set _GIT_PATH=

call :mlton
@rem optional
@rem if not %_EXITCODE%==0 goto end

call :mosml
@rem optional
@rem if not %_EXITCODE%==0 goto end

call :smlnj
if not %_EXITCODE%==0 goto end

call :git
if not %_EXITCODE%==0 goto end

goto end

@rem #########################################################################
@rem ## Subroutines

@rem output parameters: _DEBUG_LABEL, _ERROR_LABEL, _WARNING_LABEL
:env
set _BASENAME=%~n0
set "_ROOT_DIR=%~dp0"

call :env_colors
set _DEBUG_LABEL=%_NORMAL_BG_CYAN%[%_BASENAME%]%_RESET%
set _ERROR_LABEL=%_STRONG_FG_RED%Error%_RESET%:
set _WARNING_LABEL=%_STRONG_FG_YELLOW%Warning%_RESET%:
set _PS1_LABEL=%_STRONG_BG_YELLOW%PS1%_RESET%

set "_HASH_DIR=%_ROOT_DIR%.hash"
goto :eof

:env_colors
@rem ANSI colors in standard Windows 10 shell
@rem see https://gist.github.com/mlocati/#file-win10colors-cmd

@rem normal foreground colors
set _NORMAL_FG_BLACK=[30m
set _NORMAL_FG_RED=[31m
set _NORMAL_FG_GREEN=[32m
set _NORMAL_FG_YELLOW=[33m
set _NORMAL_FG_BLUE=[34m
set _NORMAL_FG_MAGENTA=[35m
set _NORMAL_FG_CYAN=[36m
set _NORMAL_FG_WHITE=[37m

@rem normal background colors
set _NORMAL_BG_BLACK=[40m
set _NORMAL_BG_RED=[41m
set _NORMAL_BG_GREEN=[42m
set _NORMAL_BG_YELLOW=[43m
set _NORMAL_BG_BLUE=[44m
set _NORMAL_BG_MAGENTA=[45m
set _NORMAL_BG_CYAN=[46m
set _NORMAL_BG_WHITE=[47m

@rem strong foreground colors
set _STRONG_FG_BLACK=[90m
set _STRONG_FG_RED=[91m
set _STRONG_FG_GREEN=[92m
set _STRONG_FG_YELLOW=[93m
set _STRONG_FG_BLUE=[94m
set _STRONG_FG_MAGENTA=[95m
set _STRONG_FG_CYAN=[96m
set _STRONG_FG_WHITE=[97m

@rem strong background colors
set _STRONG_BG_BLACK=[100m
set _STRONG_BG_RED=[101m
set _STRONG_BG_GREEN=[102m
set _STRONG_BG_YELLOW=[103m
set _STRONG_BG_BLUE=[104m

@rem we define _RESET in last position to avoid crazy console output with type command
set _BOLD=[1m
set _UNDERSCORE=[4m
set _INVERSE=[7m
set _RESET=[0m
goto :eof

@rem input parameter: %*
@rem output parameters: _BASH, _HELP, _VERBOSE
:args
set _BASH=0
set _HELP=0
set _VERBOSE=0
set __N=0
:args_loop
set "__ARG=%~1"
if not defined __ARG goto args_done

if "%__ARG:~0,1%"=="-" (
    @rem option
    if "%__ARG%"=="-bash" ( set _BASH=1
    ) else if "%__ARG%"=="-debug" ( set _DEBUG=1
    ) else if "%__ARG%"=="-verbose" ( set _VERBOSE=1
    ) else (
        echo %_ERROR_LABEL% Unknown option "%__ARG%" 1>&2
        set _EXITCODE=1
        goto args_done
    )
) else (
    @rem subcommand
    if "%__ARG%"=="help" ( set _HELP=1
    ) else (
        echo %_ERROR_LABEL% Unknown subcommand "%__ARG%" 1>&2
        set _EXITCODE=1
        goto args_done
    )
    set /a __N+=1
)
shift
goto args_loop
:args_done
call :drive_name "%_ROOT_DIR%"
if not %_EXITCODE%==0 goto :eof
if %_DEBUG%==1 (
    call :env_uptodate
    if not !_EXITCODE!==0 goto end
)
if %_DEBUG%==1 (
    echo %_DEBUG_LABEL% Options    : _HELP=%_HELP% _VERBOSE=%_VERBOSE% 1>&2
    echo %_DEBUG_LABEL% Subcommands: _HELP=%_HELP% 1>&2
    echo %_DEBUG_LABEL% Variables  : _DRIVE_NAME=%_DRIVE_NAME% 1>&2
)
goto :eof

@rem input parameter: %1: path to be substituted
@rem output parameter: _DRIVE_NAME (2 characters: letter + ':')
:drive_name
set "__GIVEN_PATH=%~1"
@rem remove trailing path separator if present
if "%__GIVEN_PATH:~-1,1%"=="\" set "__GIVEN_PATH=%__GIVEN_PATH:~0,-1%"

@rem https://serverfault.com/questions/62578/how-to-get-a-list-of-drive-letters-on-a-system-through-a-windows-shell-bat-cmd
set __DRIVE_NAMES=F:G:H:I:J:K:L:M:N:O:P:Q:R:S:T:U:V:W:X:Y:Z:
for /f %%i in ('wmic logicaldisk get deviceid ^| findstr :') do (
    set "__DRIVE_NAMES=!__DRIVE_NAMES:%%i=!"
)
if %_DEBUG%==1 echo %_DEBUG_LABEL% __DRIVE_NAMES=%__DRIVE_NAMES% ^(WMIC^) 1>&2
if not defined __DRIVE_NAMES (
    echo %_ERROR_LABEL% No more free drive name 1>&2
    set _EXITCODE=1
    goto :eof
)
for /f "tokens=1,2,*" %%f in ('subst') do (
    set "__SUBST_DRIVE=%%f"
    set "__SUBST_DRIVE=!__SUBST_DRIVE:~0,2!"
    set "__SUBST_PATH=%%h"
    @rem Windows local file systems are not case sensitive (by default)
    if /i "!__SUBST_DRIVE!"=="!__GIVEN_PATH:~0,2!" (
        set _DRIVE_NAME=!__SUBST_DRIVE:~0,2!
        if %_DEBUG%==1 ( echo %_DEBUG_LABEL% Select drive !_DRIVE_NAME! for which a substitution already exists 1>&2
        ) else if %_VERBOSE%==1 ( echo Select drive !_DRIVE_NAME! for which a substitution already exists 1>&2
        )
        goto :eof
    ) else if "!__SUBST_PATH!"=="!__GIVEN_PATH!" (
        set "_DRIVE_NAME=!__SUBST_DRIVE!"
        if %_DEBUG%==1 ( echo %_DEBUG_LABEL% Select drive !_DRIVE_NAME! for which a substitution already exists 1>&2
        ) else if %_VERBOSE%==1 ( echo Select drive !_DRIVE_NAME! for which a substitution already exists 1>&2
        )
        goto :eof
    )
)
for /f "tokens=1,2,*" %%i in ('subst') do (
    set __USED=%%i
    call :drive_names "!__USED:~0,2!"
)
if %_DEBUG%==1 echo %_DEBUG_LABEL% __DRIVE_NAMES=%__DRIVE_NAMES% ^(SUBST^) 1>&2

set "_DRIVE_NAME=!__DRIVE_NAMES:~0,2!"
if /i "%_DRIVE_NAME%"=="%__GIVEN_PATH:~0,2%" goto :eof

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% subst "%_DRIVE_NAME%" "%__GIVEN_PATH%" 1>&2
) else if %_VERBOSE%==1 ( echo Assign drive %_DRIVE_NAME% to path "!__GIVEN_PATH:%USERPROFILE%=%%USERPROFILE%%!" 1>&2
)
subst "%_DRIVE_NAME%" "%__GIVEN_PATH%"
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to assign drive %_DRIVE_NAME% to path "!__GIVEN_PATH:%USERPROFILE%=%%USERPROFILE%%!" 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

@rem input parameter: %1=Used drive name
@rem output parameter: __DRIVE_NAMES
:drive_names
set "__USED_NAME=%~1"
set "__DRIVE_NAMES=!__DRIVE_NAMES:%__USED_NAME%=!"
goto :eof

:help
if %_VERBOSE%==1 (
    set __BEG_P=%_STRONG_FG_CYAN%
    set __BEG_O=%_STRONG_FG_GREEN%
    set __BEG_N=%_NORMAL_FG_YELLOW%
    set __END=%_RESET%
) else (
    set __BEG_P=
    set __BEG_O=
    set __BEG_N=
    set __END=
)
echo Usage: %__BEG_O%%_BASENAME% { ^<option^> ^| ^<subcommand^> }%__END%
echo.
echo   %__BEG_P%Options:%__END%
echo     %__BEG_O%-debug%__END%      print commands executed by this script
echo     %__BEG_O%-verbose%__END%    print progress messages
echo.
echo   %__BEG_P%Subcommands:%__END%
echo     %__BEG_O%help%__END%        print this help message
goto :eof

@rem output parameter: MLTON_HOME
:mlton
set _MLTON_HOME=

set __MLTON_CMD=
for /f "delims=" %%f in ('where mlton.bat 2^>NUL') do set "__MLTON_CMD=%%f"
if defined __MLTON_CMD (
    for /f "delims=" %%i in ("%__MLTON_CMD%") do set "__MLTON_BIN_DIR=%%~dpi"
    for /f "delims=" %%f in ("!__MLTON_BIN_DIR!\.") do set "_MLTON_HOME=%%~dpf"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of MLton executable found in PATH 1>&2
) else if defined MLTON_HOME (
    set "_MLTON_HOME=%MLTON_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable MLTON_HOME 1>&2
) else (
    set __PATH=C:\opt
    if exist "!__PATH!\mlton\" ( set "_MLTON_HOME=!__PATH!\mlton"
    ) else (
        for /f "delims=" %%f in ('dir /ad /b "!__PATH!\mlton*" 2^>NUL') do set "_MLTON_HOME=!__PATH!\%%f"
        if not defined _MLTON_HOME (
            set "__PATH=%ProgramFiles%"
            for /f "delims=" %%f in ('dir /ad /b "!__PATH!\mlton*" 2^>NUL') do set "_MLTON_HOME=!__PATH!\%%f"
        )
    )
    if defined _MLTON_HOME (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% Using default MLton installation directory "!_MLTON_HOME!" 1>&2
    )
)
if not exist "%_MLTON_HOME%\bin\mlton.bat" (
    echo %_ERROR_LABEL% MLton executable not found ^("%_MLTON_HOME%"^) 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

@rem output parameter: _MOSML_HOME
:mosml
set _MOSML_HOME=

set __MOSMLC_CMD=
for /f "delims=" %%f in ('where mosmlc.exe 2^>NUL') do set "__MOSMLC_CMD=%%f"
if defined __MOSMLC_CMD (
    for /f "delims=" %%i in ("%__MOSMLC_CMD%") do set "__MOSMLC_BIN_DIR=%%~dpi"
    for /f "delims=" %%f in ("!__MOSMLC_BIN_DIR!\.") do set "_MOSML_HOME=%%~dpf"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of Moscow ML executable found in PATH 1>&2
) else if defined MOSML_HOME (
    set "_MOSML_HOME=%MOSML_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable MOSML_HOME 1>&2
) else (
    set __PATH=C:\opt
    if exist "!__PATH!\mosml\" ( set "_MOSML_HOME=!__PATH!\mosml"
    ) else (
        for /f "delims=" %%f in ('dir /ad /b "!__PATH!\mosml*" 2^>NUL') do set "_MOSML_HOME=!__PATH!\%%f"
        if not defined _MOSML_HOME (
            set "__PATH=%ProgramFiles%"
            for /f "delims=" %%f in ('dir /ad /b "!__PATH!\mosml*" 2^>NUL') do set "_MOSML_HOME=!__PATH!\%%f"
        )
    )
    if defined _MOSML_HOME (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% Using default Moscow ML installation directory "!_MOSML_HOME!" 1>&2
    )
)
if not exist "%_MOSML_HOME%\bin\mosmlc.exe" (
    echo %_ERROR_LABEL% Moscow ML executable not found ^("%_MOSML_HOME%"^) 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

@rem output parameters: _SMLNJ_HOME
:smlnj
set _SMLNJ_HOME=

set __SML_CMD=
for /f "delims=" %%f in ('where sml.bat 2^>NUL') do set "__SML_CMD=%%f"
if defined __SML_CMD (
    for /f "delims=" %%i in ("%__SML_CMD%") do set "__SML_BIN_DIR=%%~dpi"
    for /f "delims=" %%f in ("!__SML_BIN_DIR!\.") do set "_GHC_HOME=%%~dpf"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of SML/NJ executable found in PATH 1>&2
) else if defined SMLNJ_HOME (
    set "_SMLNJ_HOME=%SMLNJ_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable SMLNJ_HOME 1>&2
) else (
    set __PATH=C:\opt
    if exist "!__PATH!\smlnj\" ( set "_SMLNJ_HOME=!__PATH!\smlnj"
    ) else (
        for /f "delims=" %%f in ('dir /ad /b "!__PATH!\smlnj*" 2^>NUL') do set "_SMLNJ_HOME=!__PATH!\%%f"
        if not defined _SMLNJ_HOME (
            set "__PATH=%ProgramFiles%"
            for /f "delims=" %%f in ('dir /ad /b "!__PATH!\smlnj*" 2^>NUL') do set "_SMLNJ_HOME=!__PATH!\%%f"
        )
    )
    if defined _SMLNJ_HOME (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% Using default SML/NJ installation directory "!_SMLNJ_HOME!" 1>&2
    )
)
if not exist "%_SMLNJ_HOME%\bin\sml.bat" (
    echo %_ERROR_LABEL% SML/NJ executable not found ^("%_SMLNJ_HOME%"^) 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

@rem output parameters: _GIT_HOME, _GIT_PATH
:git
set _GIT_HOME=
set _GIT_PATH=

set __GIT_CMD=
for /f "delims=" %%f in ('where git.exe 2^>NUL') do set "__GIT_CMD=%%f"
if defined __GIT_CMD (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of Git executable found in PATH 1>&2
    @rem keep _GIT_PATH undefined since executable already in path
    goto :eof
) else if defined GIT_HOME (
    set "_GIT_HOME=%GIT_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable GIT_HOME 1>&2
) else (
    set __PATH=C:\opt
    if exist "!__PATH!\Git\" ( set "_GIT_HOME=!__PATH!\Git"
    ) else (
        for /f "delims=" %%f in ('dir /ad /b "!__PATH!\Git*" 2^>NUL') do set "_GIT_HOME=!__PATH!\%%f"
        if not defined _GIT_HOME (
            set "__PATH=%ProgramFiles%"
            for /f "delims=" %%f in ('dir /ad /b "!__PATH!\Git*" 2^>NUL') do set "_GIT_HOME=!__PATH!\%%f"
        )
    )
    if defined _GIT_HOME (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% Using default Git installation directory "!_GIT_HOME!" 1>&2
    )
)
if not exist "%_GIT_HOME%\bin\git.exe" (
    echo %_ERROR_LABEL% Git executable not found ^("%_GIT_HOME%"^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_GIT_PATH=;%_GIT_HOME%\bin;%_GIT_HOME%\mingw64\bin;%_GIT_HOME%\usr\bin"
goto :eof

:print_env
set __VERBOSE=%1
set "__VERSIONS_LINE1=  "
set "__VERSIONS_LINE2=  "
set __WHERE_ARGS=

where /q "%MLTON_HOME%\bin:mlton.bat"
if %ERRORLEVEL%==0 (
    for /f "tokens=*" %%i in ('"%MLTON_HOME%\bin\mlton.bat"') do (
        set "__VERSIONS_LINE1=%__VERSIONS_LINE1% %%i,"
    )
    set __WHERE_ARGS=%__WHERE_ARGS% "%MLTON_HOME%\bin:mlton.bat"
)
where /q "%MOSML_HOME%\bin:mosmlc.exe"
if %ERRORLEVEL%==0 (
    for /f "tokens=1-9,10,*" %%i in ('"%MOSML_HOME%\bin\mosmlc.exe" -v 2^>^&1 ^| findstr system ^| findstr /v Caml') do (
        set "__VERSIONS_LINE1=%__VERSIONS_LINE1% mosmlc %%r,"
    )
    set __WHERE_ARGS=%__WHERE_ARGS% "%MOSML_HOME%\bin:mosmlc.exe"
)
where /q "%SMLNJ_HOME%\bin:sml.bat"
if %ERRORLEVEL%==0 (
    for /f "tokens=1-6,7,*" %%i in ('"%SMLNJ_HOME%\bin\sml.bat" -h ^| findstr Version') do (
        set "__VERSION=%%o"
        setlocal enabledelayedexpansion
        set "__VERSIONS_LINE1=%__VERSIONS_LINE1% sml !__VERSION:;=!,"
    )
    set __WHERE_ARGS=%__WHERE_ARGS% "%SMLNJ_HOME%\bin:sml.bat"
)
where /q "%GIT_HOME%\bin:git.exe"
if %ERRORLEVEL%==0 (
    for /f "tokens=1,2,*" %%i in ('"%GIT_HOME%\bin\git.exe" --version') do (
        for /f "delims=. tokens=1,2,3,*" %%a in ("%%k") do set "__VERSIONS_LINE2=%__VERSIONS_LINE2% git %%a.%%b.%%c,"
    )
    set __WHERE_ARGS=%__WHERE_ARGS% "%GIT_HOME%\bin:git.exe"
)
where /q "%GIT_HOME%\usr\bin:diff.exe"
if %ERRORLEVEL%==0 (
    for /f "tokens=1-3,*" %%i in ('"%GIT_HOME%\usr\bin\diff.exe" --version ^| findstr /B diff') do set "__VERSIONS_LINE2=%__VERSIONS_LINE2% diff %%l,"
    set __WHERE_ARGS=%__WHERE_ARGS% "%GIT_HOME%\usr\bin:diff.exe"
)
where /q "%GIT_HOME%\bin:bash.exe"
if %ERRORLEVEL%==0 (
    for /f "tokens=1-3,4,*" %%i in ('"%GIT_HOME%\bin\bash.exe" --version ^| findstr bash') do (
        set "__VERSION=%%l"
        setlocal enabledelayedexpansion
        set "__VERSIONS_LINE2=%__VERSIONS_LINE2% bash !__VERSION:-release=!"
    )
    set __WHERE_ARGS=%__WHERE_ARGS% "%GIT_HOME%\bin:bash.exe"
)
echo Tool versions:
echo %__VERSIONS_LINE1%
echo %__VERSIONS_LINE2%
if %__VERBOSE%==1 if defined __WHERE_ARGS (
    @rem if %_DEBUG%==1 echo %_DEBUG_LABEL% where %__WHERE_ARGS%
    echo Tool paths: 1>&2
    for /f "tokens=*" %%p in ('where %__WHERE_ARGS%') do (
        set "__LINE=%%p"
        setlocal enabledelayedexpansion
        echo    !__LINE:%USERPROFILE%=%%USERPROFILE%%! 1>&2
    )
    echo Environment variables: 1>&2
    if defined GIT_HOME echo    "GIT_HOME=%GIT_HOME%" 1>&2
    if defined MLTON_HOME echo    "MLTON_HOME=%MLTON_HOME%" 1>&2
    if defined MOSML_HOME echo    "MOSML_HOME=%MOSML_HOME%" 1>&2
    if defined MOSML_HOME echo    "MOSMLLIB=%MOSML_HOME%\lib" 1>&2
    if defined SMLNJ_HOME echo    "SMLNJ_HOME=%SMLNJ_HOME%" 1>&2
    echo Path associations: 1>&2
    for /f "delims=" %%i in ('subst') do (
        set "__LINE=%%i"
        setlocal enabledelayedexpansion
        echo    !__LINE:%USERPROFILE%=%%USERPROFILE%%! 1>&2
    )
)
goto :eof

@rem #########################################################################
@rem ## Cleanups

:end
endlocal & (
    if %_EXITCODE%==0 (
        if not defined GIT_HOME set "GIT_HOME=%_GIT_HOME%"
        if not defined MLTON_HOME set "MLTON_HOME=%_MLTON_HOME%"
        if not defined MOSML_HOME set "MOSML_HOME=%_MOSML_HOME%"
        if not defined MOSMLLIB set "MOSMLLIB=%_MOSML_HOME%\lib"
        if not defined SMLNJ_HOME set "SMLNJ_HOME=%_SMLNJ_HOME%"
        set "PATH=%PATH%;%_GIT_PATH%"
        call :print_env %_VERBOSE%
        if not "%CD:~0,2%"=="%_DRIVE_NAME%" (
            if %_DEBUG%==1 echo %_DEBUG_LABEL% cd /d %_DRIVE_NAME% 1>&2
            cd /d %_DRIVE_NAME%
        )
        if %_BASH%==1 (
            @rem see https://conemu.github.io/en/GitForWindows.html
            if %_DEBUG%==1 echo %_DEBUG_LABEL% %_GIT_HOME%\usr\bin\bash.exe --login 1>&2
            cmd.exe /c "%_GIT_HOME%\usr\bin\bash.exe --login"
        )
    )
    if %_DEBUG%==1 echo %_DEBUG_LABEL% _EXITCODE=%_EXITCODE% 1>&2
    for /f "delims==" %%i in ('set ^| findstr /b "_"') do set %%i=
)
