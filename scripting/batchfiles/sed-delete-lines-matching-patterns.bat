:: Y:\minhl\batchfiles
:: delete lines that matches PATTERN

@echo off
@setlocal EnableExtensions DisableDelayedExpansion

@set "DIR_CYGWIN=C:\tools\"

@set "CMD_SED=%DIR_CYGWIN%\sed"

:: Do not quote patterns
::@set PATTERN1=2020\/09\/24[[:space:]][[:digit:]]*:00:00
::@set PATTERN2=2020\/09\/24[[:space:]][[:digit:]]*:00:00
@set PATTERN1=MD 20353
@set PATTERN2=MD 21032
@set PATTERN3=MD 21353

@set IN=D:\Users\mingtungl\wip\DK\5085449_ReplicatorDanishInstance.log-wip.20231111

@echo %PATTERN1%:%PATTERN2% - %IN%

:: delete line matching either pattern 1 or 2
%CMD_SED% "/%PATTERN1%/d;/%PATTERN2%/d;/%PATTERN3%/d" -i %IN%

:end
@exit /b 0