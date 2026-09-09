@echo off
setlocal EnableExtensions

if /I "%~1"=="__hidden_worker" goto hidden_worker

set "TLBB_HIDDEN_LAUNCHER=%~f0"
powershell.exe -NoLogo -NoProfile -NonInteractive -ExecutionPolicy Bypass -WindowStyle Hidden -Command "$q = [char]34; $arg = '/D /C call ' + $q + $env:TLBB_HIDDEN_LAUNCHER + $q + ' __hidden_worker'; Start-Process -FilePath $env:ComSpec -ArgumentList $arg -WorkingDirectory (Split-Path -LiteralPath $env:TLBB_HIDDEN_LAUNCHER) -WindowStyle Hidden"
set "LAUNCH_RESULT=%ERRORLEVEL%"
set "TLBB_HIDDEN_LAUNCHER="
endlocal & exit /b %LAUNCH_RESULT%

:hidden_worker
set "LOG_DIR=%~dp0Server\Log"
if not exist "%LOG_DIR%" mkdir "%LOG_DIR%" >nul 2>&1
set "START_LOG=%LOG_DIR%\run-hidden.log"
>>"%START_LOG%" echo [%date% %time%] Hidden startup requested.
call "%~dp0run.bat" --hidden >>"%START_LOG%" 2>&1
set "START_RESULT=%ERRORLEVEL%"
>>"%START_LOG%" echo [%date% %time%] Hidden startup finished with exit code %START_RESULT%.
endlocal & exit /b %START_RESULT%
