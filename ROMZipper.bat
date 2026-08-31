@echo off
setlocal EnableExtensions

set "zipExe=C:\Program Files\7-Zip\7z.exe"
set "COMPRESSION_LEVEL=5"
set "romsDir=%~dp0"
set "outputDir=%romsDir%ROMS compressed"
set /a processed=0
set /a succeeded=0
set /a failed=0
set /a skipped=0
set /a originalBytes=0
set /a compressedBytes=0
set /a spaceSaved=0

if not exist "%zipExe%" (
    echo 7-Zip was not found at:
    echo %zipExe%
    pause
    exit /b 1
)

if not exist "%outputDir%" mkdir "%outputDir%"

echo Starting ROM compression...
echo Source: "%romsDir%"
echo Destination: "%outputDir%"
echo Compression level: %COMPRESSION_LEVEL%
echo.

pushd "%romsDir%"

rem Process each immediate subfolder as a system folder.
for /d %%S in (*) do (
    if /I not "%%~fS"=="%outputDir%" (
        echo Processing system: %%~nxS
        call :processSystem "%%~fS" "%%~nxS"
        echo.
    )
)

popd
set /a originalMB=originalBytes/1048576
set /a compressedMB=compressedBytes/1048576
set /a spaceSavedMB=spaceSaved/1048576
echo ========================================
echo Compression complete.
echo ROMs found:      %processed%
echo Archives created: %succeeded%
echo Failed archives:  %failed%
echo Skipped existing: %skipped%
echo Original size:   %originalMB% MB
echo Compressed size: %compressedMB% MB
echo Space saved:     %spaceSavedMB% MB
echo Output folder:   "%outputDir%"
echo ========================================
pause
exit /b 0

:compress
for %%A in ("%~1") do set "originalSize=%%~zA"
set "archivePath=%~2\%~n1.zip"
set /a processed+=1
set /a systemCurrent+=1
if exist "%archivePath%" goto :alreadyCompressed
echo   Compressing: "%~nx1"
"%zipExe%" a -tzip -mx=%COMPRESSION_LEVEL% "%archivePath%" "%~1"
if errorlevel 1 (
    set /a failed+=1
    echo   FAILED: "%~nx1"
) else (
    for %%A in ("%archivePath%") do set "compressedSize=%%~zA"
    set /a originalBytes+=originalSize
    set /a compressedBytes+=compressedSize
    set /a spaceSaved+=originalSize-compressedSize
    set /a succeeded+=1
    echo   Complete: "%~n1.zip"
)
call :showProgress %%systemCurrent%% %%systemTotal%%
exit /b

:alreadyCompressed
set /a skipped+=1
echo   Skipped (already exists): "%~n1.zip"
call :showProgress %%systemCurrent%% %%systemTotal%%
exit /b

:processSystem
set "systemDir=%~1"
set "systemOutput=%outputDir%\%~2"
set /a systemTotal=0
set /a systemCurrent=0
if not exist "%systemOutput%" mkdir "%systemOutput%"

rem Count supported cartridge ROM files for the progress bar.
for /r "%systemDir%" %%F in (*) do (
    if /I "%%~xF"==".nes" set /a systemTotal+=1
    if /I "%%~xF"==".gb" set /a systemTotal+=1
    if /I "%%~xF"==".gbc" set /a systemTotal+=1
    if /I "%%~xF"==".gg" set /a systemTotal+=1
    if /I "%%~xF"==".gba" set /a systemTotal+=1
    if /I "%%~xF"==".sfc" set /a systemTotal+=1
    if /I "%%~xF"==".smc" set /a systemTotal+=1
    if /I "%%~xF"==".md" set /a systemTotal+=1
    if /I "%%~xF"==".gen" set /a systemTotal+=1
    if /I "%%~xF"==".nds" set /a systemTotal+=1
)
echo   Supported ROMs: %systemTotal%

if %systemTotal% EQU 0 exit /b

rem Process supported cartridge ROM files.
for /r "%systemDir%" %%F in (*) do (
    if /I "%%~xF"==".nes" call :compress "%%~fF" "%systemOutput%"
    if /I "%%~xF"==".gb" call :compress "%%~fF" "%systemOutput%"
    if /I "%%~xF"==".gbc" call :compress "%%~fF" "%systemOutput%"
    if /I "%%~xF"==".gg" call :compress "%%~fF" "%systemOutput%"
    if /I "%%~xF"==".gba" call :compress "%%~fF" "%systemOutput%"
    if /I "%%~xF"==".sfc" call :compress "%%~fF" "%systemOutput%"
    if /I "%%~xF"==".smc" call :compress "%%~fF" "%systemOutput%"
    if /I "%%~xF"==".md" call :compress "%%~fF" "%systemOutput%"
    if /I "%%~xF"==".gen" call :compress "%%~fF" "%systemOutput%"
    if /I "%%~xF"==".nds" call :compress "%%~fF" "%systemOutput%"
)
exit /b

:showProgress
set /a progressPercent=(%~1*100)/%~2
set /a progressFilled=(%~1*20+%~2-1)/%~2
set "progressBar="
for /l %%P in (1,1,20) do (
    if %%P LEQ %progressFilled% call set "progressBar=%%progressBar%%#"
    if %%P GTR %progressFilled% call set "progressBar=%%progressBar%%-"
)
echo   Progress: [%progressBar%] %progressPercent%%% (%~1/%~2)
exit /b
