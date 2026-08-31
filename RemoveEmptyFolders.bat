@echo off
setlocal EnableExtensions DisableDelayedExpansion

set "rootDir=%~dp0"
set /a scanned=0
set /a removed=0

echo Scanning for empty folders under:
echo "%rootDir%"
echo.

rem Process child folders recursively, then remove each folder if it is empty.
for /d %%D in ("%rootDir%*") do call :cleanFolder "%%~fD"

echo.
echo ========================================
echo Empty-folder cleanup complete.
echo Folders checked: %scanned%
echo Folders removed: %removed%
echo ========================================
pause
exit /b 0

:cleanFolder
set /a scanned+=1

for /d %%D in ("%~1\*") do call :cleanFolder "%%~fD"

rem RD without /S removes the folder only when it contains no files or folders.
rd "%~1" 2>nul
if not exist "%~1" (
    set /a removed+=1
    echo Removed: "%~1"
)
exit /b
