:: insert string before PATTERN

@echo off
@setlocal EnableExtensions DisableDelayedExpansion

@set IDIR=Y:\minhl\BG
@set ODIR=C:\Users\mingtungl\wip\BG

@set SED=C:\tools\sed.exe
@set CAT=C:\tools\cat.exe

@set IN=%IDIR%\%1
@set XML=%ODIR%\TSO-7764\%~n1.xml
@set OUT=%ODIR%\TSO-7764\uintid-%1
@set CSV=%ODIR%\TSO-7764\%~n1-gamonplayerids.csv
@set TMP=%ODIR%\tmp

:: delete existing output files
rem del /q %XML% %OUT% %CSV% %TMP%
del /q %OUT% %CSV% %TMP%
@echo %OUT% - %IN%

 @call :split_fields
 @call :extract_gamonplayerid

:end
@exit /b 0

:split_fields

echo -- In split_fields

rem :: %SED% -e "s_%PATTERN1%_\n&_g" -e "s_%PATTERN2%_\n&_g" %IDIR%\%1 > %TMP%

@echo "--- insert \n\t after <GamePlayer>"
%SED% "s_<GamePlayer>_\n&\n\t_g" < %IN% > %XML%

@echo "--- INLINE - insert \n before and after </GamePlayer>"
%SED% -i "s_</GamePlayer>_\n&\n_g" %XML%

@exit /b 0


:extract_gamonplayerid

@echo -- In extract_gamonplayerid
rem :: insert \n after <GAMonPlayerId> and before </GAMonPlayerId>
::%SED% -e "s_<GAMonPlayerId>_\n&_g" -e "s_</GAMonPlayerId>_\n&_g" < %IDIR%\%1 > %TMP%
rem :: insert \n after <GAMonPlayerId>
%SED% -e "s_<GAMonPlayerId>_\n&_g" < %IN% > %TMP%

rem :: INLINE - insert <space>\n before </GAMonPlayerId>
%SED% -i -e "s_</GAMonPlayerId>_ \n&_g" %TMP%

rem :: insert '(' infront of uids and ')' after uids
::%SED% -e "s_<GAMonPlayerId>_\n&(_g" -e "s_</GAMonPlayerId>_)&_g" < %IDIR%\%1 > %TMP%


rem :: INLINE - delete lines that do not contain <GAMonPlayerId>
%SED% -i "/<GAMonPlayerId>/!d" %TMP%

rem :: INLINE - delete <GAMonPlayerId>
%SED% -i "s/<GAMonPlayerId>//g" %TMP%

rem :: INLINE - delete </GAMonPlayerId>
::%SED% -i "s_</GAMonPlayerId>_,_g" %TMP%
rem :: INLINE - delete lines that do not contain <GAMonPlayerId> 
rem :: delete <GAMonPlayerId>
::%SED% -e "/<GAMonPlayerId>/!d" -e "s/<GAMonPlayerId>//g" < %TMP% > %OUT%

%CAT% %TMP% > %OUT%
%CAT% %OUT% > %CSV%

@exit /b 0
goto :end
