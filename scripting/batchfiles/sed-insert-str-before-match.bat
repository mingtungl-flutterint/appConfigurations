:: insert string before PATTERN

@echo off
@setlocal EnableExtensions DisableDelayedExpansion

@set /a args_cnt=0
for %%a in (%*) do set /a args_cnt+=1

if %args_cnt% LEQ 1 (
    @echo "Insert a string before PATTERN"
    @echo "Usage: %0 pattern file"
	@goto :end
)

@set "DIR_CYGWIN=C:\tools\"

@set "CMD_SED=%DIR_CYGWIN%\sed"

:: Do not quote patterns
@set PATTERN=2020\/09\/24[[:space:]][[:digit:]]*:00:00

@set IN=%2
@set OUT=out.txt

@echo %PATTERN% - %IN%

%CMD_SED% "/%PATTERN%/ i #####" <%IN% >%OUT%

:end
@exit /b 0

