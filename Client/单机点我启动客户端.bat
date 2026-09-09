@echo off
setlocal EnableExtensions

rem Keep the two-zone login list in the client Patch directory only.
set "TLBB_LOGIN_SERVER=%~dp0Patch\LoginServer.txt"
powershell.exe -NoLogo -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "$bytes=[Convert]::FromBase64String('I0RFTU8NCg0KVkVSU0lPTiAxDQoNClNFUlZFUl9CRUdJTg0Ku6q2q7Xn0MXSu8f4LMzsz8K12tK7LDAsMTAxLDMsMCwwLFdFTEVDT01FIFRPIFRMQkIsMTI3LjAuMC4xOjE0NDAwLDEyNy4wLjAuMToxNDQwMCwxMjcuMC4wLjE6MTQ0MDAsDQq7qrartefQxdK7x/gsyP3MttOh1MIsMSwxMDEsMiwwLDAsV0VMRUNPTUUgVE8gVExCQiwxMTQuNjYuMTYuMjQ3OjE0NDAwLDExNC42Ni4xNi4yNDc6MTQ0MDAsMTE0LjY2LjE2LjI0NzoxNDQwMCwNClNFUlZFUl9FTkQNCg=='); [IO.File]::WriteAllBytes($env:TLBB_LOGIN_SERVER,$bytes)"
if errorlevel 1 (
    echo Failed to update "%TLBB_LOGIN_SERVER%".
    pause
    endlocal
    exit /b 1
)

cd /d "%~dp0Bin64"
start "" "Game.exe" -fl
endlocal
exit /b 0
