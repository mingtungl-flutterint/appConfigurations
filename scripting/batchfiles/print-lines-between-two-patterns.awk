:: print lines between two patterns
:: Copy lines between two patterns

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


@set DATA_BEGIN=\[2020\/03\/09[[:space:]]10:40:22\]
@set DATA_END="\[2020\/03\/09[[:space:]]10:40:30\]
@set INFILE=%1
@set OUTFILE=%2
@set uid=108858752

:: --------------------------------------------------------------------------------------------------
:: ref: https://www.baeldung.com/linux/print-lines-between-two-patterns

:: Printing the Data Blocks Including Both Boundaries
:: sed -n '/%DATA_BEGIN%/, /%DATA_END%/p' input.txt
:: awk '/%DATA_BEGIN%/, /%DATA_END%/' input.txt 
:: awk '/%DATA_BEGIN%/{ f = 1 } f; /%DATA_END%/{ f = 0 }' input.txt

:: Printing the Data Blocks Including the “BEGIN” Boundary Only
:: sed -n '/%DATA_BEGIN%/, /%DATA_END%/{ /%DATA_END%/!p }' input.txt
:: awk '/%DATA_BEGIN%/{ f = 1 } /%DATA_END%/{ f = 0 } f' input.txt

::Printing the Data Blocks Including the “END” Boundary Only
:: sed -n '/%DATA_BEGIN%/, /%DATA_END%/{ /%DATA_BEGIN%/!p }' input.txt
:: awk 'f; /%DATA_BEGIN%/{ f = 1 } /%DATA_END%/{ f = 0 }' input.txt

:: Printing the Data Blocks Excluding Both Boundaries
:: sed -n '/%DATA_BEGIN%/, /%DATA_END%/{ /%DATA_BEGIN%/! { /%DATA_END%/! p } }' input.txt
:: awk '/%DATA_BEGIN%/{ f = 1; next } /%DATA_END%/{ f = 0 } f' input.txt

:: --------------------------------------------------------------------------------------------------


:: DOS
rem %CMD_AWK% -v '/%DATA_BEGIN%/, /%DATA_END%/' < %INFILE% > %OUTFILE%

:: Powershell
rem %CMD_AWK% -v '/%DATA_BEGIN%/, /%DATA_END%/' %INFILE% 2>&1 | Tee-Object %OUTFILE%

	  		  
:end

@endlocal
@exit /b 0

:test
%CMD_AWK% 'BEGIN { print "number user id %uid%" } /%uid%/ { ++total } END { print %uid% appears total times }' %INFILE%
