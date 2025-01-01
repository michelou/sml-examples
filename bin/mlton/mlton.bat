@echo off
setlocal

set "_MSYS_HOME=c:\opt\msys64"

for /f "delims=" %%f in ("%~dp0.") do set "_INSTALL_DIR=%%~dpf"
set "_INSTALL_DIR=%_INSTALL_DIR:~0,-1%"

set "_LIB_MLTON_DIR=%_INSTALL_DIR%\lib\mlton"

set "_MLTON_CMD=%_LIB_MLTON_DIR%\mlton-compile.exe"

set _MLTON_OPTS=-ar-script "%_LIB_MLTON_DIR%\static-library" 
set _MLTON_OPTS=%_MLTON_OPTS% -cc "%_MSYS_HOME%\usr\bin\cc.exe"

set _MLTON_OPTS=%_MLTON_OPTS% -cc-opt "-std=gnu11 -fno-common"
set _MLTON_OPTS=%_MLTON_OPTS% -cc-opt "-O1 -fno-strict-aliasing"
set _MLTON_OPTS=%_MLTON_OPTS% -cc-opt "-foptimize-sibling-calls"
set _MLTON_OPTS=%_MLTON_OPTS% -cc-opt "-w"

set _MLTON_OPTS=%_MLTON_OPTS% -cc-opt-quote "-I%_MSYS_HOME%\usr\lib\gcc\x86_64-pc-msys\13.3.0\include"
set _MLTON_OPTS=%_MLTON_OPTS% -cc-opt-quote "-I%_MSYS_HOME%\usr\include"
@rem set _MLTON_OPTS=%_MLTON_OPTS% -cc-opt-quote "-I%_MSYS_HOME%\usr\include\w32api"
set _MLTON_OPTS=%_MLTON_OPTS% -cc-opt-quote "-I%_MSYS_HOME%\mingw64\include"
set _MLTON_OPTS=%_MLTON_OPTS% -cc-opt-quote "-I%_MSYS_HOME%\clang64\include"
set _MLTON_OPTS=%_MLTON_OPTS% -cc-opt-quote "-I%_LIB_MLTON_DIR%\include"

set _MLTON_OPTS=%_MLTON_OPTS% -link-opt "TMPDIR=c:\temp"
set _MLTON_OPTS=%_MLTON_OPTS% -mlb-path-var "SML_LIB %_LIB_MLTON_DIR%\sml"

set _MLTON_OPTS=%_MLTON_OPTS% -target-cc-opt amd64 "-m64"
set _MLTON_OPTS=%_MLTON_OPTS% -target-link-opt amd64 "-m64"

set "_PATH=%PATH%"
set "PATH=%PATH%;%_MSYS_HOME%\usr\bin;%_MSYS_HOME%\mingw64\bin"
@rem https://gcc.gnu.org/onlinedocs/gcc-3.3/gcc/Environment-Variables.html
set "TMPDIR=c:/temp/"

@rem echo [%~n0] "%_MLTON_CMD%" "%_LIB_MLTON_DIR%" %_MLTON_OPTS% %* 1>&2
call "%_MLTON_CMD%" "%_LIB_MLTON_DIR%" %_MLTON_OPTS% %*

set "PATH=%_PATH%"
endlocal
