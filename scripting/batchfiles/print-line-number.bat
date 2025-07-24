:: line-number.bat PATTERN FILE
@echo off
@setlocal EnableExtensions DisableDelayedExpansion

@set /a args_cnt=0
for %%a in (%*) do set /a args_cnt+=1

if %args_cnt% LEQ 0 (
    @echo "Usage: %0 pattern file"
	@goto :end
)

@set "DIR_CYGWIN=C:\tools\"

@set "CMD_GREP=%DIR_CYGWIN%\grep"
@set "CMD_SED=%DIR_CYGWIN%\sed"
@set "CMD_GAWK=%DIR_CYGWIN%\gawk"

@set WDIR=y:\minhl
@set "NET=Z:\app_logs"

@set PATTERN="2020\/09\/24[[:space:]][[:digit:]]*:00:00"
@set PATTERN2="2020\/09\/24"

@set FILE=%2

@echo %PATTERN% - %FILE%

::%CMD_GREP% -n %PATTERN% %FILE%

::%CMD_GAWK% -v "pat=%PATTERN%" ' BEGIN { print "Print line number of "pat" " } /pat/ { print NR":"$0; ++total } END { print "pat appears total times" } ' %FILE%

::%CMD_GAWK% ' BEGIN { print "Print line number of "%PATTERN%" " } /%PATTERN%/ { print NR":"$0; ++total } END { print " "%PATTERN%" appears total times" } ' %FILE%
::%CMD_GAWK% -v "pat=%PATTERN2%" ' BEGIN { print "Print line number of "%PATTERN%" " } /^pat/ { print NR":"$0; ++total } END { print ""pat" appears total times" } ' %FILE%

%CMD_SED% -e "/%PATTERN%/!d;=" %FILE%

::%CMD_SED% -e "/%PATTERN%/!d;=" %FILE% | %CMD_SED% "N;s/\n/:/"


:end
@exit /b 0

