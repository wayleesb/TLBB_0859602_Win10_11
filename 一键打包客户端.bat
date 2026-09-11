@echo off
setlocal DisableDelayedExpansion
title TLBB 7z Package

for %%D in ("%~dp0.") do set "SOURCE=%%~fD"
for %%D in ("%SOURCE%\..") do set "OUTPUT_DIR=%%~fD\Packages"
set "SEVENZIP="
set "RESULT=1"

if exist "%ProgramFiles%\7-Zip\7z.exe" set "SEVENZIP=%ProgramFiles%\7-Zip\7z.exe"
if not defined SEVENZIP if exist "%ProgramFiles(x86)%\7-Zip\7z.exe" set "SEVENZIP=%ProgramFiles(x86)%\7-Zip\7z.exe"
if not defined SEVENZIP for %%Z in (7z.exe 7zz.exe 7za.exe) do for %%P in (%%~$PATH:Z) do if not defined SEVENZIP set "SEVENZIP=%%P"

if not defined SEVENZIP (
    echo ERROR: 7-Zip was not found. Install 7-Zip and try again.
    goto finish
)
if not exist "%SOURCE%\" (
    echo ERROR: Client folder was not found: "%SOURCE%"
    goto finish
)
if not exist "%OUTPUT_DIR%\" mkdir "%OUTPUT_DIR%"
if not exist "%OUTPUT_DIR%\" (
    echo ERROR: Cannot create output folder: "%OUTPUT_DIR%"
    goto finish
)

set "STAMP="
for /f %%T in ('powershell.exe -NoLogo -NoProfile -Command "Get-Date -Format yyyyMMdd_HHmmss_fff"') do set "STAMP=%%T"
if not defined STAMP (
    echo ERROR: Could not generate the archive timestamp.
    goto finish
)
set "ARCHIVE=%OUTPUT_DIR%\TLBB_0859602_Win10_11_%STAMP%.7z"
set "PARTIAL=%OUTPUT_DIR%\TLBB_0859602_Win10_11_%STAMP%.partial.7z"
if exist "%ARCHIVE%" (
    echo ERROR: Output file already exists: "%ARCHIVE%"
    goto finish
)
if exist "%PARTIAL%" (
    echo ERROR: Temporary file already exists: "%PARTIAL%"
    goto finish
)

echo Source: "%SOURCE%"
echo Output: "%ARCHIVE%"
echo Excluding Git metadata and common credential/private-key filenames.
echo Packaging client files. Please wait...
echo.

rem Do not use .gitignore: the local launcher and database archive are required.
"%SEVENZIP%" a -t7z -mx=5 -mmt=4 -bb0 -bsp1 "%PARTIAL%" "%SOURCE%\" -xr!.git -xr!.git-credentials -xr!.gitconfig -xr!.ssh -xr!.gnupg -xr!.netrc -xr!_netrc -xr!.env -xr!.env.* -xr!id_rsa* -xr!id_dsa* -xr!id_ecdsa* -xr!id_ed25519* -xr!*.pem -xr!*.key -xr!*.p12 -xr!*.pfx
if errorlevel 1 (
    echo ERROR: Compression failed or some files could not be read.
    echo Any incomplete archive is kept at: "%PARTIAL%"
    goto finish
)

echo.
echo Checking archive integrity...
"%SEVENZIP%" t -bb0 -bsp1 "%PARTIAL%"
if errorlevel 1 (
    echo ERROR: Archive verification failed: "%PARTIAL%"
    goto finish
)

ren "%PARTIAL%" "TLBB_0859602_Win10_11_%STAMP%.7z"
if errorlevel 1 (
    echo ERROR: Could not rename the verified archive: "%PARTIAL%"
    goto finish
)
set "RESULT=0"
echo.
echo SUCCESS: "%ARCHIVE%"
echo Git metadata is excluded. Existing game/database settings are preserved.

:finish
echo.
if /i not "%~1"=="--no-pause" pause
exit /b %RESULT%
