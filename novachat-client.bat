@echo off
setlocal enabledelayedexpansion
title Nova_Chat Secure Client Hub

:: ========================================================
::            NOVA_CHAT CONFIGURATION LOADER
:: ========================================================
set "CONFIG_FILE=%appdata%\novachat_client_config.ini"

:: Check if the user has already saved a directory path before
if exist "%CONFIG_FILE%" (
    for /f "usebackq tokens=1,2 delims==" %%a in ("%CONFIG_FILE%") do (
        if "%%a"=="portal" set "PUBLIC_PORTAL=%%b"
    )
    goto SERVER_CHECK
)

:SETUP_PORTAL
cls
echo =======================================================
echo          NOVA_CHAT: FIRST-TIME CLIENT SETUP            
echo =======================================================
echo  Please enter or paste the full network path to the 
echo  Shared Server Folder to connect to the chat network.
echo.
echo  (Example: \\YOUR-PC\SharedFolder or C:\SharedFolder)
echo =======================================================
echo.
set /p "user_portal=  Shared Server Folder Path: "
if "!user_portal!"=="" goto SETUP_PORTAL

:: Add a trailing backslash if the user forgot it
set "last_char=!user_portal:~-1!"
if not "!last_char!"=="\" set "user_portal=!user_portal!\"

:: Save the path so they don't have to type it next time
echo portal=!user_portal!>"%CONFIG_FILE%"
set "PUBLIC_PORTAL=!user_portal!"

:SERVER_CHECK
if not exist "%PUBLIC_PORTAL%status.txt" (
    cls
    echo =======================================================
    echo  [!] CLIENT ERROR: CANNOT CONNECT TO SERVER NODE
    echo =======================================================
    echo  Could not find the server files at the targeted folder.
    echo  Path tried: "%PUBLIC_PORTAL%"
    echo =======================================================
    echo  1. Make sure 'Nova_Server.bat' is running on the host PC.
    echo  2. Press any key to reset the path and try again.
    echo =======================================================
    if exist "%CONFIG_FILE%" del "%CONFIG_FILE%"
    pause >nul
    goto SETUP_PORTAL
)
set /p client_check=<"%PUBLIC_PORTAL%status.txt"
if "!client_check!"=="offline" (
    cls
    echo =======================================================
    echo  [!] CONNECTION REFUSED: SERVER NODE IS PAUSED         
    echo =======================================================
    echo  The Admin has set the Server Core status to OFFLINE.
    echo  Please try connecting again later.
    echo =======================================================
    pause
    goto SERVER_CHECK
)

:WELCOME_MENU
powershell -Command " +^
$choices = @('Login Account', 'Sign Up Registry', 'Exit Program'); +^
$selection = 0; +^
while ($true) { +^
    Clear-Host; +^
    Write-Host '  +---------------------------------------+' -ForegroundColor Cyan; +^
    Write-Host '  |       NOVA_CHAT SECURE GATEWAY        |' -ForegroundColor Cyan; +^
    Write-Host '  +---------------------------------------+' -ForegroundColor Cyan; +^
    Write-Host ''; +^
    for ($i=0; $i -lt $choices.Count; $i++) { +^
        if ($i -eq $selection) { +^
            Write-Host ('   -> [ ' + $choices[$i] + ' ] ') -ForegroundColor Black -BackgroundColor Cyan; +^
        } else { +^
            Write-Host ('        ' + $choices[$i]); +^
        } +^
    }; +^
    Write-Host ''; +^
    Write-Host '  +---------------------------------------+' -ForegroundColor Gray; +^
    Write-Host '   Made by Nova Studios.' -ForegroundColor DarkGray; +^
    Write-Host '  +---------------------------------------+' -ForegroundColor Gray; +^
    $key = [System.Console]::ReadKey($true).Key; +^
    if ($key -eq 'UpArrow') { $selection = ($selection -1 + $choices.Count) %% $choices.Count }; +^
    if ($key -eq 'DownArrow') { $selection = ($selection + 1) %% $choices.Count }; +^
    if ($key -eq 'Enter') { exit $selection }; +^
}"
set "action_val=%errorlevel%"

if "%action_val%"=="0" goto LOGIN
if "%action_val%"=="1" goto SIGNUP
if "%action_val%"=="2" exit

:SIGNUP
cls
echo  +---------------------------------------+
echo  ^|         SECURE SIGN UP REGISTER      ^|
echo  +---------------------------------------+
set /p "username=  Desired Username: "
set /p "password=  Secure Password: "
if "%username%"=="" goto WELCOME_MENU

echo SIGNUP^|%username%^|%password%>%PUBLIC_PORTAL%REQ_%username%.txt

:WAIT_SIGNUP
timeout /t 1 >nul
if not exist "%PUBLIC_PORTAL%RES_%username%.txt" goto WAIT_SIGNUP
set /p response=<"%PUBLIC_PORTAL%RES_%username%.txt"
del "%PUBLIC_PORTAL%RES_%username%.txt" >nul 2>&1

if "%response%"=="RES|SUCCESS" (
    echo  [+] Account created securely!
    pause
    goto WELCOME_MENU
) else (
    echo  [X] Username is taken.
    pause
    goto WELCOME_MENU
)

:LOGIN
cls
echo  +---------------------------------------+
echo  ^|         SECURE IDENTITY LOGIN         ^|
echo  +---------------------------------------+
set /p "username=  Username: "
set /p "password=  Password: "

echo LOGIN^|%username%^|%password%>%PUBLIC_PORTAL%REQ_%username%.txt

:WAIT_LOGIN
timeout /t 1 >nul
if not exist "%PUBLIC_PORTAL%RES_%username%.txt" goto WAIT_LOGIN
set /p response=<"%PUBLIC_PORTAL%RES_%username%.txt"
del "%PUBLIC_PORTAL%RES_%username%.txt" >nul 2>&1

for /f "tokens=1-3 delims=|" %%a in ("%response%") do (
    set "r_status=%%b"
    set "r_role=%%c"
)

if "%r_status%"=="AUTH_OK" (
    set "CURRENT_USER=%username%"
    set "USER_ROLE=%r_role%"
    goto MAIN_MENU
) else (
    echo  [X] Invalid login credentials.
    pause
    goto WELCOME_MENU
)

:MAIN_MENU
goto SERVER_CHECK
:MAIN_MENU_RUN
powershell -Command " +^
$choices = @('Open Chatrooms', 'Disconnect / Logout'); +^
$selection = 0; +^
while ($true) { +^
    Clear-Host; +^
    Write-Host '  +---------------------------------------+' -ForegroundColor Cyan; +^
    Write-Host ('  |  NOVA_CHAT HUB (User: ' + '%CURRENT_USER%'.PadRight(15) + ') |') -ForegroundColor Cyan; +^
    Write-Host '  +---------------------------------------+' -ForegroundColor Cyan; +^
    Write-Host ''; +^
    for ($i=0; $i -lt $choices.Count; $i++) { +^
        if ($i -eq $selection) { +^
            Write-Host ('   -> [ ' + $choices[$i] + ' ] ') -ForegroundColor Black -BackgroundColor Cyan; +^
        } else { +^
            Write-Host ('        ' + $choices[$i]); +^
        } +^
    }; +^
    Write-Host ''; +^
    Write-Host '  +---------------------------------------+' -ForegroundColor Gray; +^
    Write-Host '   Made by Nova Studios.' -ForegroundColor DarkGray; +^
    Write-Host '  +---------------------------------------+' -ForegroundColor Gray; +^
    $key = [System.Console]::ReadKey($true).Key; +^
    if ($key -eq 'UpArrow') { $selection = ($selection -1 + $choices.Count) %% $choices.Count }; +^
    if ($key -eq 'DownArrow') { $selection = ($selection + 1) %% $choices.Count }; +^
    if ($key -eq 'Enter') { exit $selection }; +^
}"
set "m_selection=%errorlevel%"

if "%m_selection%"=="0" goto CHANNEL_MENU
if "%m_selection%"=="1" goto WELCOME_MENU

:CHANNEL_MENU
powershell -Command " +^
$choices = @('#general channel', '#gaming channel', '<- Back to Hub'); +^
$selection = 0; +^
while ($true) { +^
    Clear-Host; +^
    Write-Host '  +---------------------------------------+' -ForegroundColor Cyan; +^
    Write-Host '  |          SELECT CHAT CHANNEL          |' -ForegroundColor Cyan; +^
    Write-Host '  +---------------------------------------+' -ForegroundColor Cyan; +^
    Write-Host ''; +^
    for ($i=0; $i -lt $choices.Count; $i++) { +^
        if ($i -eq $selection) { +^
            Write-Host ('   -> [ ' + $choices[$i] + ' ] ') -ForegroundColor Black -BackgroundColor Cyan; +^
        } else { +^
            Write-Host ('        ' + $choices[$i]); +^
        } +^
    }; +^
    Write-Host ''; +^
    Write-Host '  +---------------------------------------+' -ForegroundColor Gray; +^
    Write-Host '   Made by Nova Studios.' -ForegroundColor DarkGray; +^
    Write-Host '  +---------------------------------------+' -ForegroundColor Gray; +^
    $key = [System.Console]::ReadKey($true).Key; +^
    if ($key -eq 'UpArrow') { $selection = ($selection -1 + $choices.Count) %% $choices.Count }; +^
    if ($key -eq 'DownArrow') { $selection = ($selection + 1) %% $choices.Count }; +^
    if ($key -eq 'Enter') { exit $selection }; +^
}"
set "c_selection=%errorlevel%"

if "%c_selection%"=="2" goto MAIN_MENU
if "%c_selection%"=="0" set "ACTIVE_CHAN=general"
if "%c_selection%"=="1" set "ACTIVE_CHAN=gaming"
goto CHATROOM_VIEW

:CHATROOM_VIEW
cls
echo  +---------------------------------------+
echo  ^|  SECURE CHANNEL: #%ACTIVE_CHAN%
echo  ^|  Type '/b' to change channels         ^|
echo  +---------------------------------------+
echo.
if exist "%PUBLIC_PORTAL%ROOM_%ACTIVE_CHAN%.txt" (
    type "%PUBLIC_PORTAL%ROOM_%ACTIVE_CHAN%.txt"
) else (
    echo   [Authenticated Sync Portal Ready.]
)
echo.
echo  +---------------------------------------+
echo   Made by Nova Studios.
echo  +---------------------------------------+
set "msg="
set /p "msg=  [%CURRENT_USER%]: "

if "%msg%"=="/b" goto CHANNEL_MENU
if "%msg%"=="" goto CHATROOM_VIEW

echo SEND_MSG^|%CURRENT_USER%^|%ACTIVE_CHAN%^|%msg%>%PUBLIC_PORTAL%REQ_%CURRENT_USER%.txt

timeout /t 1 >nul
goto CHATROOM_VIEW


