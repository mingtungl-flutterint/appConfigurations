:: Copy text from PATTERN to end of file

@echo off
@setlocal EnableExtensions DisableDelayedExpansion

@set /a args_cnt=0
for %%a in (%*) do set /a args_cnt+=1

if %args_cnt% LSS 1 (
    @echo "Copy text from PATTERN to EOF"
    @echo "Usage: %0 file"
	@goto :end
)

@set "DIR_CYGWIN=C:\tools"

@set "CMD_SED=%DIR_CYGWIN%\sed"

:: Do not quote patterns
@set PATTERN=\[2020\/03\/09[[:space:]]10:40:22\]

@set IN=%1
@set OUT=out.txt

rem @echo %PATTERN%:%END% - %IN%:%OUT%

:: DOS
rem echo %CMD_SED% -n "/^%PATTERN%/,$p" <%IN% >%OUT%
rem %CMD_SED% -n "/^%PATTERN%/,$p" <%IN% >%OUT%

:: Powershell
echo %CMD_SED% -n "/^%PATTERN%/,$p" %IN% 2>&1 | Tee-Object %OUT%
%CMD_SED% -n "/^%PATTERN%/,$p" %IN% 2>&1 | Tee-Object %OUT%


:end
@exit /b 0

rem C:\tools\sed -n "/^\[2021\/03\/09[[:space:]]00:00:00\]/,$p" 8252258_RegulatorServerInstance.log.20210309