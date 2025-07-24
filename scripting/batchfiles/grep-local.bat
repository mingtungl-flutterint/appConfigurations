:: grep-local.bat WHERE PATTERN
@echo off
@setlocal EnableExtensions DisableDelayedExpansion

@set /a args_cnt=0
for %%a in (%*) do set /a args_cnt+=1

if %args_cnt% LEQ 1 (
    @echo "Usage: %0 where pattern"
	@goto :end
)

@set "DIR_CYGWIN=C:\tools\"
@set "CMD_FIND=%DIR_CYGWIN%\find"
@set "CMD_GREP=%DIR_CYGWIN%\grep"

@set WDIR=y:\minhl
@set "NET=Z:\app_logs"

@set WHERE=%1
@set PATTERN=%2

@echo %WHERE% - %PATTERN%
::%CMD_FIND% %REGLOG%\%FILE%
%CMD_GREP% -rnil %WHERE% -e %PATTERN%

:end
@exit /b 0
