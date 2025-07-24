@echo off

rem Win key + R → type db2cmd
rem change dir to D:\admtools\switch_olap
rem execute 'connect_olap.bat <windows username>'
rem Enter BORDER domain password
rem Execute 'select'


@set outfile=D:\Users\mingtungl\out\DBM_Q_GET_PT_VER_STATUS_FOR_USERS.txt
@set sqlfile=D:\Users\mingtungl\scripts\sql\PT\DBM_Q_GET_PT_VER_STATUS_FOR_USERS.sql

@del /q %outfile%

@pushd D:\admtools\switch_olap

db2 -vtf %sqlfile% -z %outfile% 1>null

@popd