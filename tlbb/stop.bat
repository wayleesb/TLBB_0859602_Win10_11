@echo off
setlocal EnableExtensions EnableDelayedExpansion

rem 先进入运行目录，避免安装路径中的中文、空格或括号被 cmd.exe 误解析。
pushd "%~dp0Server" >nul 2>&1
if errorlevel 1 goto runtime_missing

set "RUNTIME=."

rem TLBB-MariaDB 是自动启动的系统服务，停服只停止五个游戏程序，不停止数据库。

rem GameServer 通过 quitserver.cmd 正常退出，使在线角色按服务端流程下线并保存。
call :is_any_running "Server.exe" "GameServer.exe"
if not errorlevel 1 (
    type nul > "%RUNTIME%\quitserver.cmd"
    echo Stopping Server ...
    call :wait_pair_stopped "Server.exe" "GameServer.exe" 180 "Server"
    if errorlevel 1 goto stop_failed
    echo Stopped Server.
)

rem Login、World 和 Windows 版新增的 Billing 没有官方命令文件，按参考端直接结束。
call :force_stop "Login.exe" "LoginServer.exe" "Login"
if errorlevel 1 goto stop_failed
call :force_stop "World.exe" "WorldServer.exe" "World"
if errorlevel 1 goto stop_failed
call :force_stop "Billing.exe" "BillingServer.exe" "Billing"
if errorlevel 1 goto stop_failed

rem ShareMemory 必须最后退出并完成数据落盘，超时也不能自动强杀。
call :is_process_running "ShareMemory.exe"
if not errorlevel 1 (
    type nul > "%RUNTIME%\exit.cmd"
    echo Stopping ShareMemory and saving data ...
    call :wait_pair_stopped "ShareMemory.exe" "__not_used__.exe" 600 "ShareMemory"
    if errorlevel 1 goto stop_failed
    echo Stopped ShareMemory.
)

echo All server processes are stopped.
popd
endlocal & exit /b 0

:stop_failed
echo Server shutdown failed. The remaining process was left running.
popd
endlocal & exit /b 1

:runtime_missing
echo Runtime directory not found: %~dp0Server
endlocal & exit /b 1

:is_process_running
tasklist.exe /FI "IMAGENAME eq %~1" /NH 2>nul | find.exe /I "%~1" >nul
exit /b %ERRORLEVEL%

:is_any_running
call :is_process_running "%~1"
if not errorlevel 1 exit /b 0
call :is_process_running "%~2"
if not errorlevel 1 exit /b 0
exit /b 1

:wait_pair_stopped
set /a "WAIT_COUNT=%~3"
:wait_pair_stopped_loop
call :is_any_running "%~1" "%~2"
if errorlevel 1 exit /b 0
if !WAIT_COUNT! LEQ 0 (
    echo Timed out waiting for %~4 to stop.
    exit /b 1
)
ping.exe -n 2 127.0.0.1 >nul
set /a "WAIT_COUNT-=1"
goto wait_pair_stopped_loop

:force_stop
set "HAD_PROCESS=0"
call :is_process_running "%~1"
if not errorlevel 1 set "HAD_PROCESS=1"
call :is_process_running "%~2"
if not errorlevel 1 set "HAD_PROCESS=1"
if "!HAD_PROCESS!"=="0" exit /b 0

echo Stopping %~3 ...
taskkill.exe /F /IM "%~1" >nul 2>&1
taskkill.exe /F /IM "%~2" >nul 2>&1
call :wait_pair_stopped "%~1" "%~2" 30 "%~3"
if errorlevel 1 exit /b 1
echo Stopped %~3.
exit /b 0
