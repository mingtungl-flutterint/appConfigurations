:: print lines from start to matched paattern

@echo off
@setlocal EnableExtensions DisableDelayedExpansion

@set /a args_cnt=0
for %%a in (%*) do set /a args_cnt+=1

if %args_cnt% LEQ 0 (
    @echo "Usage: %0 'pattern' infile"
	@goto :end
)

@set "DIR_CYGWIN=C:\tools\"
@set "GAWK=%DIR_CYGWIN%\gawk"
@set "SED=%DIR_CYGWIN%\sed"

@set WDIR=y:\minhl
@set "NET=Z:\app_logs"


@set PATTERN=\[2020\/03\/09[[:space:]]10:40:22\]

@set INFILE=%1
@set OUTFILE=%2
@set uid=108858752

:: --------------------------------------------------------------------------------------------------
:: ref: https://www.baeldung.com/linux/print-lines-between-two-patterns

:: Printing the Data Blocks Including the “BEGIN” Boundary Only
:: awk '/%PATTERN%/, 0' input.txt

:: --------------------------------------------------------------------------------------------------


:: DOS
rem %GAWK% -v '/%PATTERN%/, /%$%/' < %INFILE% > %OUTFILE%

:: Powershell
%GAWK% -v '/%PATTERN%/, 0' %INFILE% 2>&1 | Tee-Object %OUTFILE%

%SED% -n '/%START%,$p/'  %INFILE% 1>%OUTFILE% 2>&1
	  		  
:end

@endlocal
@exit /b 0

:test
%GAWK% 'BEGIN { print "number user id %uid%" } /%uid%/ { ++total } END { print %uid% appears total times }' %INFILE%
