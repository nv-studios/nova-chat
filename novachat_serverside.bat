@echo off
setlocal enabledelayedexpansion
title Nova_Chat - Secure Server Hub
color 0C

:: ========================================================
::          NOVA_CHAT SECURE SERVER INTERFACE
:: ========================================================
set "PRIVATE_DB=%~dp0Database"
set "SERVER_CONFIG=%~dp0server_config.ini"
set "ADMIN_USER=Admin"
set "ADMIN_PASS=NovaPass123"
:: ========================================================

if not exist "%PRIVATE_DB%\users" mkdir "%PRIVATE_DB%\users"
if not exist "%PRIVATE_DB%\public" mkdir "%PRIVATE_DB%\public"
if not exist "%PRIVATE_DB%\system" mkdir "%PRIVATE_DB%\system"

if not exist "%SERVER_CONFIG%" (
    cls
    echo =======================================================
    echo          NOVA_CHAT: FIRST-TIME SERVER SETUP            
    echo =======================================================
    echo  To operate securely, this server script must look at the 
    echo  Shared Network Folder where your clients will connect.
    echo.
    echo  Please enter or paste the full path to your shared folder.
    echo  (Example: \\YOUR-PC\SharedFolder or C:\SharedFolder)
    echo =======================================================
    echo.
    set /p "user_portal=  Public Folder Path: "
    if "!user_portal!"=="" goto SERVER_CORE_LOOP
    echo portal=!user_portal!>"%SERVER_CONFIG%"
    echo %ADMIN_PASS%>"%PRIVATE_DB%\users\%ADMIN_USER%.txt"
    echo admin>"%PRIVATE_DB%\users\%ADMIN_USER%_role.txt"
    echo online>"%PRIVATE_DB%\system\status.txt"
)

for /f "usebackq tokens=1,2 delims==" %%a in ("%SERVER_CONFIG%") do (
    if "%%a"=="portal" set "PUBLIC_PORTAL=%%b"
)

if not exist "%PUBLIC_PORTAL%" (
    cls
    echo  [X] ERROR: The configured shared portal directory does not exist.
    echo  Path: "%PUBLIC_PORTAL%"
    echo  Please delete 'server_config.ini' and restart to reconfigure.
    pause
    exit
)

echo online>"%PUBLIC_PORTAL%\status.txt"

cls
echo =======================================================
echo          NOVA_CHAT: SECURE BACKEND CORE IS ACTIVE       
echo =======================================================
echo  Private Database: %PRIVATE_DB%
echo  Public Shared Portal: %PUBLIC_PORTAL%
echo =======================================================
echo  Listening for client requests...
echo   Made with ❤️ by Nova Studios.
echo =======================================================

:SERVER_CORE_LOOP
for %%f in ("%PUBLIC_PORTAL%\REQ_*.txt") do (
    set "req_file=%%f"
    if exist "!req_file!" (
        set /p packet=<"!req_file!"
        
        for /f "tokens=1-4 delims=|" %%a in ("!packet!") do (
            set "action=%%a"
            set "user=%%b"
            set "d1=%%c"
            set "d2=%%d"
        )
        
        if "!action!"=="SIGNUP" (
            if exist "%PRIVATE_DB%\users\!user!.txt" (
                echo RES^|TAKEN>"%PUBLIC_PORTAL%\RES_!user!.txt"
            ) else (
                echo !d1!>"%PRIVATE_DB%\users\!user!.txt"
                echo member>"%PRIVATE_DB%\users\!user!_role.txt"
                echo RES^|SUCCESS>"%PUBLIC_PORTAL%\RES_!user!.txt"
            )
        )
        
        if "!action!"=="LOGIN" (
            if not exist "%PRIVATE_DB%\users\!user!.txt" (
                echo RES^|NOUSER>"%PUBLIC_PORTAL%\RES_!user!.txt"
            ) else (
                set /p check_pass=<"%PRIVATE_DB%\users\!user!.txt"
                if "!d1!"=="!check_pass!" (
                    set /p u_role=<"%PRIVATE_DB%\users\!user!_role.txt"
                    echo RES^|AUTH_OK^|!u_role!>"%PUBLIC_PORTAL%\RES_!user!.txt"
                ) else (
                    echo RES^|BAD_PASS>"%PUBLIC_PORTAL%\RES_!user!.txt"
                )
            )
        )

        if "!action!"=="SEND_MSG" (
            echo [%time:~0,5%] !user!: !d2!>>"%PRIVATE_DB%\public\!d1!.txt"
            type "%PRIVATE_DB%\public\!d1!.txt" > "%PUBLIC_PORTAL%\ROOM_!d1!.txt"
            echo RES^|SENT>"%PUBLIC_PORTAL%\RES_!user!.txt"
        )
        
        del "!req_file!" >nul 2>&1
    )
)
timeout /t 1 >nul
goto SERVER_CORE_LOOP

