:: Author:  Lisandro Dalcin
:: Contact: dalcinl@gmail.com
:: Credits: Olivier Grisel and Kyle Kastner
:: https://github.com/cython/cython/blob/master/appveyor/run_with_env.cmd
@ECHO OFF

SET COMMAND_TO_RUN=%*

SET PYTHON_VERSION_MAJOR=%PYTHON_VERSION:~0,1%
SET PYTHON_VERSION_MINOR=%PYTHON_VERSION:~2,1%

SET WIN_SDK_ROOT=C:\Program Files\Microsoft SDKs\Windows
IF %PYTHON_VERSION_MAJOR% == 2 SET WIN_SDK_VERSION="v7.0"
IF %PYTHON_VERSION_MAJOR% == 3 SET WIN_SDK_VERSION="v7.1"

IF %PYTHON_ARCH% == 64 SET USE_WIN_SDK=1
IF %PYTHON_VERSION_MAJOR% EQU 3 IF %PYTHON_VERSION_MINOR% GEQ 5 SET USE_WIN_SDK=0
IF %PYTHON_VERSION_MAJOR% GTR 3 SET USE_WIN_SDK=0
if %PYTHON_ARCH% == 32 SET USE_WIN_SDK=0

IF %USE_WIN_SDK% == 1 (
    ECHO Configuring Windows SDK %WIN_SDK_VERSION% for %PYTHON_ARCH% bit architecture
    SET DISTUTILS_USE_SDK=1
    SET MSSdk=1
    "%WIN_SDK_ROOT%\%WIN_SDK_VERSION%\Setup\WindowsSdkVer.exe" -q -version:%WIN_SDK_VERSION%
    "%WIN_SDK_ROOT%\%WIN_SDK_VERSION%\Bin\SetEnv.cmd" /x64 /release
    ECHO Executing: %COMMAND_TO_RUN%
    CALL %COMMAND_TO_RUN% || EXIT 1
) ELSE (
    ECHO Using default MSVC build environment for %PYTHON_ARCH% bit architecture
    ECHO Executing: %COMMAND_TO_RUN%
    CALL %COMMAND_TO_RUN% || EXIT 1
)
