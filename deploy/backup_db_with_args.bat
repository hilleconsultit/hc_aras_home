@echo off

set sqlCmdPath=%1
set dataBase=%2
set bakFilePath=%3
rem echo %sqlCmdPath%
rem echo %dataBase%
rem echo %bakFilePath%

REM remove qoutes
set bakFilePath=%bakFilePath:"=%
%sqlCmdPath% -S .\SQLEXPRESS -E  -Q  "BACKUP DATABASE %dataBase% TO DISK='%bakFilePath%' WITH FORMAT"
if EXIST %bakFilePath% (
	echo Backup created
	EXIT /B 0	
	
) ELSE (
	echo DB backup failed
	EXIT /B 1
)

