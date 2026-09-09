@echo off
setlocal EnableExtensions EnableDelayedExpansion

set "HIDDEN_START=0"
if /I "%~1"=="--hidden" set "HIDDEN_START=1"

rem 先进入运行目录，后续只使用相对路径。避免安装路径中的中文、空格或括号
rem 在 cmd.exe 的括号代码块展开阶段被误解析为批处理语法。
pushd "%~dp0Server" >nul 2>&1
if errorlevel 1 goto runtime_missing

set "RUNTIME=."
set "DATABASE_SERVICE=TLBB-MariaDB"
set "SERVER_CONFIG=%RUNTIME%\Config\ServerInfo.ini"
set "LOGIN_CONFIG=%RUNTIME%\Config\LoginInfo.ini"

call :require_file "%RUNTIME%\ShareMemory.exe" || goto start_failed
call :require_file "%RUNTIME%\Billing.exe" || goto start_failed
call :require_file "%RUNTIME%\World.exe" || goto start_failed
call :require_file "%RUNTIME%\Login.exe" || goto start_failed
call :require_file "%RUNTIME%\Server.exe" || goto start_failed
call :require_file "%SERVER_CONFIG%" || goto start_failed
call :require_file "%LOGIN_CONFIG%" || goto start_failed

rem 端口必须以当前运行配置为准，避免修改 ServerInfo.ini 后启动脚本仍等待旧端口。
call :load_ports || goto start_failed
echo Detected ports: MariaDB=%DATABASE_PORT% Billing=%BILLING_PORT% World=%WORLD_PORT% Login=%LOGIN_PORT% Server=%GAME_PORT%
if /I "%~1"=="--check-ports" (
    popd
    endlocal
    exit /b 0
)

call :assert_stopped || goto start_failed

rem 与参考端 run.sh 一致，启动前清除上次退出时遗留的命令文件。
del /f /q "%RUNTIME%\exit.cmd" >nul 2>&1
del /f /q "%RUNTIME%\quitserver.cmd" >nul 2>&1

call :is_service_installed "%DATABASE_SERVICE%"
if errorlevel 1 (
    echo Required Windows service not found: %DATABASE_SERVICE%
    echo Run Install-TLBB-Environment-x64.cmd before starting the servers.
    goto start_failed
)
call :is_service_running "%DATABASE_SERVICE%"
if errorlevel 1 (
    echo Starting MariaDB service %DATABASE_SERVICE% ...
    sc.exe start "%DATABASE_SERVICE%" >nul 2>&1
    if errorlevel 1 (
        echo Failed to start %DATABASE_SERVICE%. Run this script as administrator.
        goto start_failed
    )
)
call :wait_database_service "%DATABASE_SERVICE%" %DATABASE_PORT% 60
if errorlevel 1 goto start_failed
echo MariaDB service is ready.
if /I "%~1"=="--check-environment" (
    popd
    endlocal
    exit /b 0
)

echo Starting ShareMemory ...
if "%HIDDEN_START%"=="1" (
    start "ShareMemory" /B /D "%RUNTIME%" "%RUNTIME%\ShareMemory.exe" -ignoreassert -ignoremessagebox >nul 2>&1
) else (
    start "ShareMemory" /D "%RUNTIME%" "%RUNTIME%\ShareMemory.exe" -ignoreassert -ignoremessagebox
)
call :wait_stable "ShareMemory.exe" 5 "ShareMemory"
if errorlevel 1 goto start_failed
echo ShareMemory started.

echo Starting Billing ...
if "%HIDDEN_START%"=="1" (
    start "Billing" /B /D "%RUNTIME%" "%RUNTIME%\Billing.exe" -ignoreassert -ignoremessagebox >nul 2>&1
) else (
    start "Billing" /D "%RUNTIME%" "%RUNTIME%\Billing.exe" -ignoreassert -ignoremessagebox
)
call :wait_port "Billing.exe" %BILLING_PORT% 60 "Billing port %BILLING_PORT%"
if errorlevel 1 goto start_failed
echo Billing started.

echo Starting World ...
if "%HIDDEN_START%"=="1" (
    start "World" /B /D "%RUNTIME%" "%RUNTIME%\World.exe" -ignoreassert -ignoremessagebox >nul 2>&1
) else (
    start "World" /D "%RUNTIME%" "%RUNTIME%\World.exe" -ignoreassert -ignoremessagebox
)
call :wait_port "World.exe" %WORLD_PORT% 180 "World port %WORLD_PORT%"
if errorlevel 1 goto start_failed
echo World started.

echo Starting Login ...
if "%HIDDEN_START%"=="1" (
    start "Login" /B /D "%RUNTIME%" "%RUNTIME%\Login.exe" -ignoreassert -ignoremessagebox -singledb >nul 2>&1
) else (
    start "Login" /D "%RUNTIME%" "%RUNTIME%\Login.exe" -ignoreassert -ignoremessagebox -singledb
)
call :wait_port "Login.exe" %LOGIN_PORT% 120 "Login port %LOGIN_PORT%"
if errorlevel 1 goto start_failed
echo Login started.

echo Starting Server ...
if "%HIDDEN_START%"=="1" (
    start "Server" /B /D "%RUNTIME%" "%RUNTIME%\Server.exe" -ignoreassert -ignoremessagebox -loadscriptonce >nul 2>&1
) else (
    start "Server" /D "%RUNTIME%" "%RUNTIME%\Server.exe" -ignoreassert -ignoremessagebox -loadscriptonce
)
call :wait_server_ready "Server.exe" 240
if errorlevel 1 goto start_failed
echo Server started.

echo Started: ShareMemory, Billing, World, Login, Server
popd
endlocal & exit /b 0

:start_failed
echo Server startup failed. Run stop.bat before retrying.
popd
endlocal & exit /b 1

:runtime_missing
echo Runtime directory not found: %~dp0Server
endlocal & exit /b 1

:require_file
if exist "%~1" exit /b 0
echo Required file not found: %~1
exit /b 1

:load_ports
set "DATABASE_PORT="
set "BILLING_PORT="
set "WORLD_PORT="
set "LOGIN_SERVER_ID="
set "GAME_SERVER_ID="
set "LOGIN_PORT="
set "GAME_PORT="

call :read_ini_value "%LOGIN_CONFIG%" "System" "DBPort" DATABASE_PORT
if errorlevel 1 exit /b 1
call :read_ini_value "%SERVER_CONFIG%" "Billing" "Port0" BILLING_PORT
if errorlevel 1 exit /b 1
call :read_ini_value "%SERVER_CONFIG%" "World" "Port" WORLD_PORT
if errorlevel 1 exit /b 1
call :read_ini_value "%LOGIN_CONFIG%" "System" "LoginID" LOGIN_SERVER_ID
if errorlevel 1 exit /b 1
call :read_ini_value "%SERVER_CONFIG%" "System" "CurrentServerID" GAME_SERVER_ID
if errorlevel 1 exit /b 1
call :find_server_port "%SERVER_CONFIG%" "%LOGIN_SERVER_ID%" LOGIN_PORT
if errorlevel 1 exit /b 1
call :find_server_port "%SERVER_CONFIG%" "%GAME_SERVER_ID%" GAME_PORT
if errorlevel 1 exit /b 1

for %%V in (DATABASE_PORT BILLING_PORT WORLD_PORT LOGIN_PORT GAME_PORT) do (
    call :validate_port "%%V" "!%%V!"
    if errorlevel 1 exit /b 1
)
exit /b 0

:read_ini_value
setlocal
set "INI_IN_SECTION=0"
set "INI_VALUE="
for /f "usebackq tokens=* delims=" %%A in ("%~1") do (
    set "INI_LINE=%%A"
    if /I "!INI_LINE!"=="[%~2]" (
        set "INI_IN_SECTION=1"
    ) else (
        if "!INI_LINE:~0,1!"=="[" set "INI_IN_SECTION=0"
        if "!INI_IN_SECTION!"=="1" (
            for /f "tokens=1,* delims==" %%K in ("!INI_LINE!") do (
                if /I "%%K"=="%~3" set "INI_VALUE=%%L"
            )
        )
    )
)
if not defined INI_VALUE (
    echo Missing config value: [%~2] %~3 in %~1
    endlocal & exit /b 1
)
endlocal & set "%~4=%INI_VALUE%" & exit /b 0

:find_server_port
setlocal
set "SERVER_COUNT="
set "MATCHED_PORT="
call :read_ini_value "%~1" "System" "ServerNumber" SERVER_COUNT
if errorlevel 1 (
    endlocal
    exit /b 1
)
set /a "LAST_SERVER_INDEX=SERVER_COUNT-1" >nul 2>&1
if %LAST_SERVER_INDEX% LSS 0 (
    endlocal
    exit /b 1
)
for /L %%I in (0,1,%LAST_SERVER_INDEX%) do (
    set "CANDIDATE_ID="
    set "CANDIDATE_PORT="
    call :read_ini_value "%~1" "Server%%I" "ServerID" CANDIDATE_ID
    if "!CANDIDATE_ID!"=="%~2" (
        call :read_ini_value "%~1" "Server%%I" "Port0" CANDIDATE_PORT
        set "MATCHED_PORT=!CANDIDATE_PORT!"
    )
)
if not defined MATCHED_PORT (
    echo ServerID %~2 has no Port0 entry in %~1
    endlocal
    exit /b 1
)
endlocal & set "%~3=%MATCHED_PORT%" & exit /b 0

:validate_port
setlocal
echo(%~2| findstr.exe /R /X "[1-9][0-9]*" >nul
if errorlevel 1 (
    echo Invalid port value: %~1=%~2
    endlocal & exit /b 1
)
set /a "PORT_VALUE=%~2" >nul 2>&1
if %PORT_VALUE% GTR 65535 (
    echo Invalid port value: %~1=%~2
    endlocal & exit /b 1
)
endlocal & exit /b 0

:assert_stopped
for %%P in (ShareMemory.exe Billing.exe World.exe Login.exe Server.exe BillingServer.exe WorldServer.exe LoginServer.exe GameServer.exe) do (
    call :is_process_running "%%P"
    if not errorlevel 1 (
        echo Server process is already running: %%P
        exit /b 1
    )
)
exit /b 0

:is_process_running
tasklist.exe /FI "IMAGENAME eq %~1" /NH 2>nul | find.exe /I "%~1" >nul
exit /b %ERRORLEVEL%

:is_service_installed
sc.exe query "%~1" >nul 2>&1
exit /b %ERRORLEVEL%

:is_service_running
sc.exe query "%~1" 2>nul | findstr.exe /R /C:"STATE *: *4 " >nul
exit /b %ERRORLEVEL%

:wait_database_service
set /a "WAIT_COUNT=%~3"
:wait_database_service_loop
call :is_service_running "%~1"
if errorlevel 1 (
    echo Windows service %~1 stopped during startup.
    exit /b 1
)
call :is_port_listening %~2
if not errorlevel 1 exit /b 0
if !WAIT_COUNT! LEQ 0 (
    echo Timed out waiting for %~1 port %~2.
    exit /b 1
)
ping.exe -n 2 127.0.0.1 >nul
set /a "WAIT_COUNT-=1"
goto wait_database_service_loop

:is_port_listening
powershell.exe -NoLogo -NoProfile -NonInteractive -Command "$ErrorActionPreference='SilentlyContinue'; try { $connections=@(Get-NetTCPConnection -LocalPort %~1 -State Listen -ErrorAction Stop); if($connections.Count -gt 0){ exit 0 } } catch {}; try { if(Test-NetConnection -ComputerName '127.0.0.1' -Port %~1 -InformationLevel Quiet -WarningAction SilentlyContinue -ErrorAction Stop){ exit 0 } } catch {}; exit 1" >nul 2>&1
exit /b %ERRORLEVEL%

:get_process_pid
setlocal
set "PROCESS_PID="
for /f "tokens=2 delims=," %%P in ('tasklist.exe /FI "IMAGENAME eq %~1" /NH /FO CSV 2^>nul ^| find.exe /I "%~1"') do (
    if not defined PROCESS_PID set "PROCESS_PID=%%~P"
)
if not defined PROCESS_PID (
    endlocal
    exit /b 1
)
endlocal & set "%~2=%PROCESS_PID%" & exit /b 0

:is_process_listening
set "TARGET_PID="
call :get_process_pid "%~1" TARGET_PID
if errorlevel 1 exit /b 1
powershell.exe -NoLogo -NoProfile -NonInteractive -Command "$ErrorActionPreference='SilentlyContinue'; try { $connections=@(Get-NetTCPConnection -LocalPort %~2 -State Listen -ErrorAction Stop | Where-Object { $_.OwningProcess -eq !TARGET_PID! }); if($connections.Count -gt 0){ exit 0 } } catch {}; try { if(Test-NetConnection -ComputerName '127.0.0.1' -Port %~2 -InformationLevel Quiet -WarningAction SilentlyContinue -ErrorAction Stop){ exit 0 } } catch {}; exit 1" >nul 2>&1
exit /b %ERRORLEVEL%

:has_process_world_link
set "TARGET_PID="
call :get_process_pid "%~1" TARGET_PID
if errorlevel 1 exit /b 1
powershell.exe -NoLogo -NoProfile -NonInteractive -Command "$ErrorActionPreference='SilentlyContinue'; try { $connections=@(Get-NetTCPConnection -OwningProcess !TARGET_PID! -RemotePort %~2 -State Established -ErrorAction Stop); if($connections.Count -gt 0){ exit 0 } } catch {}; try { if(Test-NetConnection -ComputerName '127.0.0.1' -Port %~2 -InformationLevel Quiet -WarningAction SilentlyContinue -ErrorAction Stop){ exit 0 } } catch {}; exit 1" >nul 2>&1
exit /b %ERRORLEVEL%

:wait_stable
set /a "WAIT_COUNT=%~2"
:wait_stable_loop
call :is_process_running "%~1"
if errorlevel 1 (
    echo %~3 exited during startup.
    exit /b 1
)
if !WAIT_COUNT! LEQ 0 exit /b 0
ping.exe -n 2 127.0.0.1 >nul
set /a "WAIT_COUNT-=1"
goto wait_stable_loop

:wait_port
set /a "WAIT_COUNT=%~3"
:wait_port_loop
call :is_process_running "%~1"
if errorlevel 1 (
    echo %~4 exited during startup.
    exit /b 1
)
call :is_process_listening "%~1" %~2
if not errorlevel 1 exit /b 0
if !WAIT_COUNT! LEQ 0 (
    echo Timed out waiting for %~4.
    exit /b 1
)
ping.exe -n 2 127.0.0.1 >nul
set /a "WAIT_COUNT-=1"
goto wait_port_loop

:wait_server_ready
set /a "WAIT_COUNT=%~2"
:wait_server_ready_loop
call :is_process_running "%~1"
if errorlevel 1 (
    echo Server exited during startup.
    exit /b 1
)
call :is_process_listening "%~1" %GAME_PORT%
if not errorlevel 1 (
    call :has_process_world_link "%~1" %WORLD_PORT%
    if not errorlevel 1 exit /b 0
)
if !WAIT_COUNT! LEQ 0 (
    echo Timed out waiting for Server port %GAME_PORT% and World port %WORLD_PORT% link.
    exit /b 1
)
ping.exe -n 2 127.0.0.1 >nul
set /a "WAIT_COUNT-=1"
goto wait_server_ready_loop
