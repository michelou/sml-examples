@echo off
setlocal enabledelayedexpansion

@rem only for interactive debugging !
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
if %_CLEAN%==1 (
    call :clean
    if not !_EXITCODE!==0 goto end
)
if %_COMPILE%==1 (
    call :compile_%_TOOLSET%
    if not !_EXITCODE!==0 goto end
)
if %_RUN%==1 (
    call :run
    if not !_EXITCODE!==0 goto end
)
goto end

@rem #########################################################################
@rem ## Subroutine

@rem output parameters: _DEBUG_LABEL, _ERROR_LABEL, _WARNING_LABEL
@rem                    _SOURCE_DIR, _CM_DIR
:env
set _BASENAME=%~n0
set "_ROOT_DIR=%~dp0"

call :env_colors
set _DEBUG_LABEL=%_NORMAL_BG_CYAN%[%_BASENAME%]%_RESET%
set _ERROR_LABEL=%_STRONG_FG_RED%Error%_RESET%:
set _WARNING_LABEL=%_STRONG_FG_YELLOW%Warning%_RESET%:

set "_SOURCE_DIR=%_ROOT_DIR%src"
set "_TARGET_DIR=%_ROOT_DIR%target"

if not exist "%SMLNJ_HOME%\bin\sml.bat" (
    echo %_ERROR_LABEL% SML/NJ installation not found 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_SML_CMD=%SMLNJ_HOME%\bin\sml.bat"
set "_ML_BUILD_CMD=%SMLNJ_HOME%\bin\ml-build.bat"

set _MOSMLC_CMD=
if exist "%MOSML_HOME%\bin\mosmlc.exe" (
    set "_MOSML_CMD=%MOSML_HOME%\bin\mosml.exe"
    set "_MOSMLC_CMD=%MOSML_HOME%\bin\mosmlc.exe"
    if not exist "%MOSMLLIB%" (
       echo %_ERROR_LABEL% Moscow ML library path is undefined 1>&2
       set _EXITCODE=1
       goto :eof
    )
)
@rem we use the newer PowerShell version if available
where /q pwsh.exe
if %ERRORLEVEL%==0 ( set _PWSH_CMD=pwsh.exe
) else ( set _PWSH_CMD=powershell.exe
)
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
@rem output parameters: _CLEAN, _COMPILE, _DEBUG, _RUN, _VERBOSE
:args
set _CLEAN=0
set _COMPILE=0
set _HELP=0
set _RUN=0
set _TEST=0
set _TOOLSET=smlnj
set _VERBOSE=0
set __N=0
:args_loop
set "__ARG=%~1"
if not defined __ARG (
    if !__N!==0 set _HELP=1
    goto args_done
)
if "%__ARG:~0,1%"=="-" (
    @rem option
    if "%__ARG%"=="-debug" ( set _DEBUG=1
    ) else if "%__ARG%"=="-help" ( set _HELP=1
    ) else if "%__ARG%"=="-mosml" ( set _TOOLSET=mosml
    ) else if "%__ARG%"=="-smlnj" ( set _TOOLSET=smlnj
    ) else if "%__ARG%"=="-verbose" ( set _VERBOSE=1
    ) else (
        echo %_ERROR_LABEL% Unknown option "%__ARG%" 1>&2
        set _EXITCODE=1
        goto args_done
   )
) else (
    @rem subcommand
    if "%__ARG%"=="clean" ( set _CLEAN=1
    ) else if "%__ARG%"=="compile" ( set _COMPILE=1
    ) else if "%__ARG%"=="help" ( set _HELP=1
    ) else if "%__ARG%"=="run" ( set _RUN=1
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
if %_DEBUG%==1 ( set _REDIRECT_STDOUT=1^>CON
) else ( set _REDIRECT_STDOUT=1^>NUL
)
if %_TOOLSET%==mosml if not defined _MOSMLC_CMD (
    echo %_WARNING_LABEL% Moscow ML installation directory not found 1>&2
    set _TOOLSET=smlnj
)
for /f "delims=" %%i in ("%~dp0.") do set "_PROJ_NAME=%%~ni"
set _MAIN_NAME=main
set _MAIN_ARGS=

set _IMAGE_MAIN=MainModule.main
set _IMAGE_NAME=%_PROJ_NAME%-image
set "_IMAGE_FILE=%_TARGET_DIR%\%_IMAGE_NAME%.x86-win32"

set "_EXEC_FILE=%_TARGET_DIR%\%_PROJ_NAME%.exe"

if %_DEBUG%==1 (
    echo %_DEBUG_LABEL% Options    : _DEBUG=%_DEBUG% _TOOLSET=%_TOOLSET% _VERBOSE=%_VERBOSE% 1>&2
    echo %_DEBUG_LABEL% Subcommands: _CLEAN=%_CLEAN% _COMPILE=%_COMPILE% _RUN=%_RUN% 1>&2
    echo %_DEBUG_LABEL% Variables  : "SMLNJ_HOME=%SMLNJ_HOME%" 1>&2
    if defined MOSML_HOME echo %_DEBUG_LABEL% Variables  : "MOSML_HOME=%MOSML_HOME%" 1>&2
    echo %_DEBUG_LABEL% Variables  : _PROJ_NAME=%_PROJ_NAME% _MAIN_NAME=%_MAIN_NAME% 1>&2
)
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
echo     %__BEG_O%-mosml%__END%      select Moscow ML toolset
echo     %__BEG_O%-smlnj%__END%      select SML/NJ toolset
echo     %__BEG_O%-verbose%__END%    print progress messages
echo.
echo   %__BEG_P%Subcommands:%__END%
echo     %__BEG_O%clean%__END%       delete generated files
echo     %__BEG_O%compile%__END%     generate SML image or executable
echo     %__BEG_O%help%__END%        print this help message
echo     %__BEG_O%run%__END%         execute the program "%__BEG_O%%_PROJ_NAME%%__END%"
goto :eof

:clean
call :rmdir "%_SOURCE_DIR%\.cm"
call :rmdir "%_TARGET_DIR%"
goto :eof

@rem input parameter: %1=directory path
:rmdir
set "__DIR=%~1"
if not exist "%__DIR%\" goto :eof
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% rmdir /s /q "%__DIR%" 1>&2
) else if %_VERBOSE%==1 ( echo Delete directory "!__DIR:%_ROOT_DIR%=!" 1>&2
)
rmdir /s /q "%__DIR%"
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to delete directory "!__DIR:%_ROOT_DIR%=!" 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

:compile_mosml
if not exist "%_TARGET_DIR%" mkdir "%_TARGET_DIR%\src"

set __MOSMLC_OPTS=-toplevel -o "%_EXEC_FILE%"

pushd "%_TARGET_DIR%"

if %_DEBUG%==1 (
    echo %_DEBUG_LABEL% Current directory=%cd% 1>&2
    echo %_DEBUG_LABEL% xcopy /q /y "%_SOURCE_DIR%\*.sml" "%_TARGET_DIR%\src\" 1>&2
)
xcopy /q /y "%_SOURCE_DIR%\*.sml" "%_TARGET_DIR%\src\" 1>NUL

set __MAIN_ARGS=
for %%i in (%_MAIN_ARGS%) do (
   if not defined __MAIN_ARGS ( set __MAIN_ARGS="%%i"
   ) else ( set __MAIN_ARGS=!__MAIN_ARGS!,"%%i"
   )
)
echo. >> "%_TARGET_DIR%\src\%_MAIN_NAME%.sml"
echo val _ = %_IMAGE_MAIN% [%__MAIN_ARGS%] >> "%_TARGET_DIR%\src\%_MAIN_NAME%.sml"

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_MOSMLC_CMD%" %__MOSMLC_OPTS% "!_TARGET_DIR:%_ROOT_DIR%=!\src\%_MAIN_NAME%.sml"
) else if %_VERBOSE%==1 ( echo Compile source file "!_TARGET_DIR:%_ROOT_DIR%=!\src\%_MAIN_NAME%.sml" 1>&2
)
call "%_MOSMLC_CMD%" %__MOSMLC_OPTS% "%_TARGET_DIR%\src\%_MAIN_NAME%.sml"
if not %ERRORLEVEL%==0 (
    popd
    echo %_ERROR_LABEL% Failed to compile source file "!_TARGET_DIR:%_ROOT_DIR%=!\src\%_MAIN_NAME%.sml" 1>&2
    set _EXITCODE=1
    goto :eof
)
popd
if %_DEBUG%==1 (
    echo %_DEBUG_LABEL% Current directory=%cd% 1>&2
    echo %_DEBUG_LABEL% xcopy /q /y "%MOSML_HOME%\bin\*rt*.dll" "%_TARGET_DIR%" 1>&2
)
xcopy /q /y "%MOSML_HOME%\bin\*rt*.dll" "%_TARGET_DIR%" 1>NUL
goto :eof

:compile_smlnj
if not exist "%_TARGET_DIR%" mkdir "%_TARGET_DIR%"

call :action_required "%_IMAGE_FILE%" "%_SOURCE_DIR%\*.sml"
if %_ACTION_REQUIRED%==0 goto :eof

pushd "%_TARGET_DIR%"

@rem https://stackoverflow.com/questions/8186848/how-to-disable-smlnj-warnings
set __CM_VERBOSE=%CM_VERBOSE%
if %_DEBUG%==1 ( set CM_VERBOSE=true
) else if %_VERBOSE%==1 ( set CM_VERBOSE=true
) else ( set CM_VERBOSE=false
)
if %_DEBUG%==1 (
    echo %_DEBUG_LABEL% CD=%CD% 1>&2
    echo %_DEBUG_LABEL% CM_VERBOSE=%CM_VERBOSE% 1>&2
    echo %_DEBUG_LABEL% "%_ML_BUILD_CMD%" ../build.cm %_IMAGE_MAIN% %_IMAGE_NAME% 1>&2
) else if %_VERBOSE%==1 ( echo Compile SML source file "%_MAIN_NAME%" 1>&2
)
call "%_ML_BUILD_CMD%" ../build.cm %_IMAGE_MAIN% %_IMAGE_NAME%
if not %ERRORLEVEL%==0 (
    set CM_VERBOSE=%__CM_VERBOSE%
    popd
    echo %_ERROR_LABEL% Failed to compile SML source file "%_MAIN_NAME%" 1>&2
    set _EXITCODE=1
    goto :eof
)
set CM_VERBOSE=%__CM_VERBOSE%
popd
goto :eof

@rem input parameter: 1=target file 2,3,..=path (wildcards accepted)
@rem output parameter: _ACTION_REQUIRED
:action_required
set "__TARGET_FILE=%~1"

set __PATH_ARRAY=
set __PATH_ARRAY1=
:action_path
shift
set __PATH=%~1
if not defined __PATH goto action_next
set __PATH_ARRAY=%__PATH_ARRAY%,'%__PATH%'
set __PATH_ARRAY1=%__PATH_ARRAY1%,'!__PATH:%_ROOT_DIR%=!'
goto action_path

:action_next
set __TARGET_TIMESTAMP=00000000000000
for /f "usebackq" %%i in (`call "%_PWSH_CMD%" -c "gci -path '%__TARGET_FILE%' -ea Stop | select -last 1 -expandProperty LastWriteTime | Get-Date -uformat %%Y%%m%%d%%H%%M%%S" 2^>NUL`) do (
     set __TARGET_TIMESTAMP=%%i
)
set __SOURCE_TIMESTAMP=00000000000000
for /f "usebackq" %%i in (`call "%_PWSH_CMD%" -c "gci -recurse -path %__PATH_ARRAY:~1% -ea Stop | sort LastWriteTime | select -last 1 -expandProperty LastWriteTime | Get-Date -uformat %%Y%%m%%d%%H%%M%%S" 2^>NUL`) do (
    set __SOURCE_TIMESTAMP=%%i
)
call :newer %__SOURCE_TIMESTAMP% %__TARGET_TIMESTAMP%
set _ACTION_REQUIRED=%_NEWER%
if %_DEBUG%==1 (
    echo %_DEBUG_LABEL% %__TARGET_TIMESTAMP% Target : '%__TARGET_FILE%' 1>&2
    echo %_DEBUG_LABEL% %__SOURCE_TIMESTAMP% Sources: %__PATH_ARRAY:~1% 1>&2
    echo %_DEBUG_LABEL% _ACTION_REQUIRED=%_ACTION_REQUIRED% 1>&2
) else if %_VERBOSE%==1 if %_ACTION_REQUIRED%==0 if %__SOURCE_TIMESTAMP% gtr 0 (
    echo No action required ^(%__PATH_ARRAY1:~1%^) 1>&2
)
goto :eof

@rem input parameters: %1=source timestamp, %2=target timestamp
@rem output parameter: _NEWER
:newer
set __TIMESTAMP1=%~1
set __TIMESTAMP2=%~2

set __DATE1=%__TIMESTAMP1:~0,8%
set __TIME1=%__TIMESTAMP1:~-6%

set __DATE2=%__TIMESTAMP2:~0,8%
set __TIME2=%__TIMESTAMP2:~-6%

if %__DATE1% gtr %__DATE2% ( set _NEWER=1
) else if %__DATE1% lss %__DATE2% ( set _NEWER=0
) else if %__TIME1% gtr %__TIME2% ( set _NEWER=1
) else ( set _NEWER=0
)
goto :eof

:run
if exist "%_EXEC_FILE%" ( call :run_native
) else if exist "%_IMAGE_FILE%" ( call :run_image
) else if %_TOOLSET%==mosml ( call :run_mosml
) else ( call :run_sml
)
goto :eof

:run_mosml
if not exist "%_TARGET_DIR%" mkdir "%_TARGET_DIR%"

@rem see https://github.com/kfl/mosml/blob/master/man/mosml.1
set __MOSML_OPTS=-P sml90
if %_DEBUG%==0 if %_VERBOSE%==0 set __MOSML_OPTS=-quietdec %__MOSMLC_OPTS%

set __MAIN_ARGS=
for %%i in (%_MAIN_ARGS%) do (
   if not defined __MAIN_ARGS ( set __MAIN_ARGS="%%i"
   ) else ( set __MAIN_ARGS=!__MAIN_ARGS!,"%%i"
   )
)
set "__SCRIPT_FILE=%_TARGET_DIR%\%_MAIN_NAME%.sml"
echo load "CommandLine"; load "Int"; load "OS"; > "%__SCRIPT_FILE%"
echo. >> "%__SCRIPT_FILE%"
type "%_SOURCE_DIR%\%_MAIN_NAME%.sml" >> "%__SCRIPT_FILE%"
echo. >> "%__SCRIPT_FILE%"
echo val _ = %_IMAGE_MAIN% [%__MAIN_ARGS%] >> "%__SCRIPT_FILE%"

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_MOSML_CMD%" %__MOSML_OPTS% "%__SCRIPT_FILE%" %_MAIN_ARGS% 1>&2
) else if %_VERBOSE%==1 ( echo Execute SML script "!__SCRIPT_FILE:%_ROOT_DIR%=!" %_MAIN_ARGS% 1>&2
)
call "%_MOSML_CMD%" %__MOSML_OPTS% "%__SCRIPT_FILE%" %_MAIN_ARGS%
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to execute SML script "!__SCRIPT_FILE:%_ROOT_DIR%=!" %_MAIN_ARGS% 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

:run_sml
if not exist "%_TARGET_DIR%" mkdir "%_TARGET_DIR%"

set __MAIN_ARGS=
for %%i in (%_MAIN_ARGS%) do (
   if not defined __MAIN_ARGS ( set __MAIN_ARGS="%%i"
   ) else ( set __MAIN_ARGS=!__MAIN_ARGS!,"%%i"
   )
)
set "__SCRIPT_FILE=%_TARGET_DIR%\%_MAIN_NAME%.sml"
copy "%_SOURCE_DIR%\%_MAIN_NAME%.sml" "%__SCRIPT_FILE%" %_REDIRECT_STDOUT%
echo. >> "%__SCRIPT_FILE%"
echo val _ = %_IMAGE_MAIN% [%__MAIN_ARGS%] >> "%__SCRIPT_FILE%"

@rem https://stackoverflow.com/questions/8186848/how-to-disable-smlnj-warnings
set __CM_VERBOSE=%CM_VERBOSE%
if %_DEBUG%==1 ( set CM_VERBOSE=true
) else if %_VERBOSE%==1 ( set CM_VERBOSE=true
) else ( set CM_VERBOSE=false
)
if %_DEBUG%==1 (
    echo %_DEBUG_LABEL% CM_VERBOSE=%CM_VERBOSE% 1>&2
    echo %_DEBUG_LABEL% "%_SML_CMD%" "%__SCRIPT_FILE%" %_MAIN_ARGS% 1>&2
) else if %_VERBOSE%==1 ( echo Execute SML script "!__SCRIPT_FILE:%_ROOT_DIR%=!" %_MAIN_ARGS% 1>&2
)
call "%_SML_CMD%" "%__SCRIPT_FILE%" %_MAIN_ARGS% 2>NUL
if not %ERRORLEVEL%==0 (
    set CM_VERBOSE=%__CM_VERBOSE%
    echo %_ERROR_LABEL% Failed to execute SML script "!__SCRIPT_FILE:%_ROOT_DIR%=!" %_MAIN_ARGS% 1>&2
    set _EXITCODE=1
    goto :eof
)
set CM_VERBOSE=%__CM_VERBOSE%
goto :eof

:run_image
@rem the runtime sees the following argument list: %_IMAGE_FILE% %_MAIN_ARGS%
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_SML_CMD%" @SMLload "%_IMAGE_FILE%" %_MAIN_ARGS% 1>&2
) else if %_VERBOSE%==1 ( echo Execute SML image "!_IMAGE_FILE:%_ROOT_DIR%=!" %_MAIN_ARGS% 1>&2
)
call "%_SML_CMD%" @SMLload "%_IMAGE_FILE%" %_MAIN_ARGS%
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to execute SML image "!_IMAGE_FILE:%_ROOT_DIR%=!" %_MAIN_ARGS% 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

:run_native
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_EXEC_FILE%" %_MAIN_ARGS% 1>&2
) else if %_VERBOSE%==1 ( echo Execute SML program "!_EXEC_FILE:%_ROOT_DIR%=!" %_MAIN_ARGS% 1>&2
)
call "%_EXEC_FILE%" %_MAIN_ARGS%
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to execute SML program "!_EXEC_FILE:%_ROOT_DIR%=!" 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

@rem #########################################################################
@rem ## Cleanups

:end
if %_DEBUG%==1 echo %_DEBUG_LABEL% _EXITCODE=%_EXITCODE% 1>&2
exit /b %_EXITCODE%
endlocal
