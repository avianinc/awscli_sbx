@echo off
SETLOCAL

REM Check for the command argument (start or stop)
IF "%~1"=="" (
    echo Please specify "start" or "stop".
    GOTO End
)

REM Define the action based on the command line argument
SET "ACTION=%1"

REM Define the directory containing the configuration files
SET "CONFIG_DIR=configs"

REM Check if the configuration directory exists
IF NOT EXIST "%CONFIG_DIR%\*" (
    echo Configuration directory "%CONFIG_DIR%" not found.
    GOTO End
)

REM Loop through all .config files in the configuration directory and apply the action
FOR %%f IN ("%CONFIG_DIR%\*.config") DO (
    CALL aws_sbx3.bat %ACTION% -f "%%f"
)

:End
ENDLOCAL
