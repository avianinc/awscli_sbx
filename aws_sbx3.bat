@echo off
SETLOCAL EnableDelayedExpansion

REM Initialize variables
SET "ACTION=%1"
SET "CONFIG_FILE="

REM Check for command line arguments
IF "%~1"=="" (
    echo Please specify "start" or "stop".
    GOTO :EOF
)

REM Parse arguments for -f and configuration file
SET "FOUND_F=0"
FOR %%a IN (%*) DO (
    IF "!FOUND_F!"=="1" (
        SET "CONFIG_FILE=%%~a"
        SET "FOUND_F=0"
    )
    IF "%%~a"=="-f" SET "FOUND_F=1"
)

REM Validate configuration file
IF "%CONFIG_FILE%"=="" (
    echo Configuration file not specified.
    GOTO :EOF
)

IF NOT EXIST "%CONFIG_FILE%" (
    echo Configuration file not found.
    GOTO :EOF
)

REM Load configuration from the specified file
FOR /F "tokens=1* delims==" %%G IN (%CONFIG_FILE%) DO (
    IF /I "%%G"=="PROFILE" SET "PROFILE=%%H"
    IF /I "%%G"=="TAGKEY" SET "TAGKEY=%%H"
    IF /I "%%G"=="TAGVALUE" SET "TAGVALUE=%%H"
)

REM No profile found in configuration
IF "%PROFILE%"=="" (
    echo Profile not specified in configuration file.
    GOTO :EOF
)

REM Perform actions based on the loaded configuration
SET "INSTANCE_IDS="
FOR /F "tokens=*" %%i IN ('aws ec2 describe-instances --filters "Name=tag:%TAGKEY%,Values=%TAGVALUE%" "Name=instance-state-name,Values=pending,running,stopped,stopping" --query "Reservations[*].Instances[*].InstanceId" --output text --profile %PROFILE%') DO (
    SET "INSTANCE_IDS=!INSTANCE_IDS! %%i"
)

IF NOT "!INSTANCE_IDS!"=="" (
    IF "%ACTION%"=="start" (
        aws ec2 start-instances --instance-ids !INSTANCE_IDS! --profile %PROFILE% >nul 2>&1
        echo Affected instance IDs: !INSTANCE_IDS!
    ) ELSE IF "%ACTION%"=="stop" (
        aws ec2 stop-instances --instance-ids !INSTANCE_IDS! --profile %PROFILE% >nul 2>&1
        echo Affected instance IDs: !INSTANCE_IDS!
    ) ELSE (
        echo Invalid action. Use "start" or "stop".
    )
) ELSE (
    echo No instances with the specified tag were found.
)

ENDLOCAL
