:: find-multiplefiles.bat WHERE PATTERN
@echo off
@setlocal EnableExtensions DisableDelayedExpansion

::@set /a args_cnt=0
::for %%a in (%*) do set /a args_cnt+=1

::if %args_cnt% LEQ 1 (
::    @echo "Usage: %0 where pattern"
::	@goto :end
::)

@set "DIR_CYGWIN=C:\tools\"
@set "CMD_FIND=%DIR_CYGWIN%\find"

@set WDIR=y:\minhl
@set "NET=Z:\app_logs"

@set WHERE=Y:\prodsupport\fridmyak\TSO-7764
@set PATTERN=%2

@echo %CMD_FIND% %WHERE% -type f \( -name "1421417_G1142777.txt" -o -name "1421496_G1142851.txt" -o -name "1421556_G1142903.txt" -o -name "1421557_G1142906.txt" -o -name "1421639_G1142982.txt" -o -name "1421640_G1142983.txt" -o -name "1421641_G1142984.txt" -o -name "1421642_G1142985.txt" \)
::@echo %WHERE% - %PATTERN%
::%CMD_FIND% %WHERE% -type f \( -name "1421417_G1142777.zip" -o -name "1421496_G1142851.zip" -o -name "1421556_G1142903.zip" -o -name "1421557_G1142906.zip" \)
::%CMD_FIND% %WHERE% -type f \( -name "1421417_G1142777.txt" -o -name "1421496_G1142851.txt" -o -name "1421556_G1142903.txt" -o -name "1421557_G1142906.txt" -o -name "1421639_G1142982.txt" -o -name "1421640_G1142983.txt" -o -name "1421641_G1142984.txt" -o -name "1421642_G1142985.txt" \) | copy 
%CMD_FIND% %WHERE% -type f \( -name "1421639_G1142982.txt" -o -name "1421640_G1142983.txt" -o -name "1421641_G1142984.txt" -o -name "1421642_G1142985.txt" \) | tee files.bat

@pause
@exit /b 0
