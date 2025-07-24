:: print lines from pattern to EOF

@echo off
@setlocal EnableExtensions DisableDelayedExpansion

@set /a args_cnt=0
for %%a in (%*) do set /a args_cnt+=1

if %args_cnt% LEQ 0 (
    @echo "Usage: %0 'pattern' infile"
	@goto :end
)

@set "DIR_CYGWIN=C:\tools\"
@set "CMD_AWK=%DIR_CYGWIN%\gawk"

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
rem %CMD_AWK% -v '/%PATTERN%/, /%$%/' < %INFILE% > %OUTFILE%

:: Powershell
%CMD_AWK% -v '/%PATTERN%/, 0' %INFILE% 2>&1 | Tee-Object %OUTFILE%

	  		  
:end

@endlocal
@exit /b 0

:test
%CMD_AWK% 'BEGIN { print "number user id %uid%" } /%uid%/ { ++total } END { print %uid% appears total times }' %INFILE%
