@echo off
@setlocal EnableExtensions DisableDelayedExpansion

@set "DIR_CYGWIN=C:\tools\"

@set "CMD_SPLIT=%DIR_CYGWIN%\split.exe"

@set date=20200421

@set WDIR=y:\minhl
@set "NET=Z:\app_logs"
@set REGLOG=W:\app_logs\10.42.20.3\logs\%date%\10.42.20.3\d$\logs\poker\

@set NLINES=167686115
@set IN=%1
@set prefixDIR=%2

@set prefix="SPLIT_20200924."
@set MB500=524288000
@set MB300=314572800
@set MB100=104857600

%CMD_SPLIT% --verbose --suffix-length=3 --numeric-suffixes --lines=%NLINES% %WDIR%\%IN% %prefixDIR%\%prefix%
::%CMD_SPLIT% --verbose --suffix-length=3 --numeric-suffixes --bytes=%MB300% %WDIR%\%IN% %prefixDIR%\%prefix%

@exit /b 0
