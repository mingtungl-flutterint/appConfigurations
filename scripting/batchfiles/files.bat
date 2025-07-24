@echo off
@setlocal EnableExtensions DisableDelayedExpansion

@set "DIR_CYGWIN=C:\tools\"
@set CAT=%DIR_CYGWIN%\cat

@set WDIR=y:\minhl\bg
::@set WHERE=Y:\prodsupport\fridmyak\TSO-7764


%CAT% Y:\prodsupport\fridmyak\TSO-7764/2021091412/1421639_G1142982/1421639_G1142982.txt > %WDIR%\1421639_G1142982.txt
%CAT% Y:\prodsupport\fridmyak\TSO-7764/2021091412/1421640_G1142983/1421640_G1142983.txt > %WDIR%\1421640_G1142983.txt
%CAT% Y:\prodsupport\fridmyak\TSO-7764/2021091412/1421641_G1142984/1421641_G1142984.txt > %WDIR%\1421641_G1142984.txt
%CAT% Y:\prodsupport\fridmyak\TSO-7764/2021091412/1421642_G1142985/1421642_G1142985.txt > %WDIR%\1421642_G1142985.txt
