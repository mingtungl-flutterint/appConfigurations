@echo off
@setlocal EnableExtensions DisableDelayedExpansion

@set "DIR_CYGWIN=C:\tools\"
@set "CMD_FIND=%DIR_CYGWIN%\find"
@set "CMD_GREP=%DIR_CYGWIN%\grep"
@set "CMD_7Z=%DIR_CYGWIN%\7z"

@set date=20200421

@set WDIR=y:\minhl
@set "NET=Z:\app_logs"
@set REGLOG=W:\app_logs\10.42.20.3\logs\%date%\10.42.20.3\d$\logs\poker\

@set FILE=%1
@echo %FILE%

%CMD_7Z% x %WDIR%\%FILE% -o%WDIR%

::%CMD_7Z% x %REGLOG%\%FILE% | %CMD_GREP% "DKMC"

@exit /b 0
