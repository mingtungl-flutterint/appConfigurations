:: Copy text from input file between PATTERNs

@echo off
@setlocal EnableExtensions DisableDelayedExpansion

@set /a args_cnt=0
for %%a in (%*) do set /a args_cnt+=1

if %args_cnt% LSS 1 (
    @echo "Copy text from input file between PATTERNs"
    @echo "Usage: %0 file"
	@goto :end
)

@set "DIR_CYGWIN=C:\tools"

@set "CMD_SED=%DIR_CYGWIN%\sed"

:: Do not quote patterns
rem @set BEGIN=\[2021\/03\/09[[:space:]]00:00:00\]
rem @set   END=\[2021\/03\/09[[:space:]]00:00:01\]
@set BEGIN=\[2020\/03\/09[[:space:]]10:40:22\]
@set   END=\[2020\/03\/09[[:space:]]10:53:00\]

@set IN=%1
@set OUT=out.txt

rem @echo %BEGIN%:%END% - %IN%:%OUT%

echo %CMD_SED% -n "/^%BEGIN%/,/^%END%/p" <%IN% >%OUT%
%CMD_SED% -n "/^%BEGIN%/,/^%END%/p" <%IN% >%OUT%

:end
@exit /b 0

rem C:\tools\sed -n "/^\[2021\/03\/09[[:space:]]00:00:00\]/,/^\[2021\/03\/09[[:space:]]00:00:01/p" 8252258_RegulatorServerInstance.log.20210309