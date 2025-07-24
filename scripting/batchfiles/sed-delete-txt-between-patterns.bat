:: Y:\minhl\batchfiles
:: delete texts between PATTERNs

@echo off
@setlocal EnableExtensions DisableDelayedExpansion

@set /a args_cnt=0
for %%a in (%*) do set /a args_cnt+=1

if %args_cnt% LEQ 2 (
    @echo "Delete text between 2 PATTERNs - inline"
    @echo "Usage: %0 pattern1 pattern2 file"
	@goto :end
)

@set "DIR_CYGWIN=C:\tools\"

@set "CMD_SED=%DIR_CYGWIN%\sed"

:: Do not quote patterns
::@set PATTERN1=2020\/09\/24[[:space:]][[:digit:]]*:00:00
::@set PATTERN2=2020\/09\/24[[:space:]][[:digit:]]*:00:00
@set PATTERN1=%1
@set PATTERN2=%2

@set IN=%2

@echo %PATTERN1%:%PATTERN2% - %IN%

:: delete texts between 2 pattern excluding lines containing  the patterns
:: sed -i '/PATTERN-1/PATTERN-2/{//!d}' input.file
%CMD_SED% "/%PATTERN1%/%PATTERN2%/{//!d}" %IN%

:: delete texts between 2 pattern including lines containing  the patterns
:: sed -i '/PATTERN-1/PATTERN-2/d' input.file
%CMD_SED% "/%PATTERN1%/%PATTERN2%/d" %IN%

:end
@exit /b 0

