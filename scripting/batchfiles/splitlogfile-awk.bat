@echo off
@setlocal EnableExtensions DisableDelayedExpansion

@set /a args_cnt=0
for %%a in (%*) do set /a args_cnt+=1

if %args_cnt% LEQ 0 (
    @echo "Usage: %0 pattern infile"
	@goto :end
)

@set "DIR_CYGWIN=C:\tools\"
@set "CMD_AWK=%DIR_CYGWIN%\gawk"

@set WDIR=y:\minhl
@set "NET=Z:\app_logs"


@set PATTERN=ageVerificationLicenseThreshold
@set INFILE=%1
@set uid=108858752

%CMD_AWK% -v "v1=%PATTERN%" -v "v2=%INFILE%" '/^v1/{x="v2-SPLIT."++i; next} {print > x;}' %INFILE%

::%CMD_AWK% -v "pat=%PATTERN%" -v "infile=%INFILE%" 'BEGIN { print "Searching for "pat" in "infile"" }
::%CMD_AWK% 'BEGIN { print "Begin searching for #####" } /^#####/{ x="lobby.SPLIT."++i; next } { print > x; } END { print "search next #####" } ' %INFILE%

	::%CMD_AWK% -v "pat=%PATTERN%" -v "infile=%INFILE%" '/^pat/{ x="infile.SPLIT."++i; next } { print > x; } END { print "search next "pat"" } ' %INFILE%

::%CMD_AWK% '/^%PATTERN%/{f=%INFILE%."++i"; next} f{print > ;f}/^END/ {close f; f=""}' %INFILE%
	  		  
:end

@endlocal
@exit /b 0

:test
%CMD_AWK% 'BEGIN { print "number user id %uid%" } /%uid%/ { ++total } END { print %uid% appears total times }' %INFILE%
