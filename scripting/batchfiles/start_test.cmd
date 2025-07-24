:: $Id start_server.cmd
:: Usage: start_test.cmd "-i" "ReplicatorFranceInstance.log.20220106" "-o" "test.out" "-1" "[2022/01/06 00:00:00]" "-2" "[2022/01/06 00:00:01]"
::
@echo off
@setlocal EnableExtensions DisableDelayedExpansion

@set cwd=%~dp0

@python copy-lines-to-file.py %*

@endlocal
