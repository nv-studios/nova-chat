@echo off
setlocal enabledelayedexpansion
title Nova_Chat Secure Client Portal
color 8B

:: ========================================================
::            NOVA_CHAT CLIENT CONFIGURATION
:: ========================================================
:: Automatically targets the network folder it is run from!
set "PUBLIC_PORTAL=%~dp0"
:: ========================================================

:SERVER_CHECK
if not exist "%PUBLIC_PORTAL%status.txt" (
    cls
    echo =======================================================
    echo  [!] CLIENT ERROR: CANNOT CONNECT TO NETWORK PORTAL    
    echo =======================================================
    echo  The central server handshake file could not be found.
    echo  Make sure 'Nova_Server.bat' is running on the host PC.
    echo =======================================================
    echo   Made with ❤️ by Nova Studios.
    echo =======================================================
    pause
    exit
)

:WELCOME_MENU
set "menu=Login"
set "menu=Sign Up"
set "menu=Exit"
set "menu_size=3"
set "selection=0"

:WELCOME_LOOP
cls
echo  +---------------------------------------+
echo  ^|      NOVA_CHAT SECURE GATEWAY       ^|
echo  +---------------------------------------+
echo.
for /l %%i in (0,1,%menu_size%-1) do (
    if %%i==%selection% (
        echo    =^> [ !menu[%%i]! ]
    ) else (
        echo         !menu[%%i]!
    )
)
echo.
echo  +---------------------------------------+
echo   Made with ❤️ by Nova Studios.
echo  +---------------------------------------+

for /f "delims=" %%k in ('powershell -Command "[int][System.Console]::ReadKey($true).Key"') do set "key=%%k"
if "%key%"=="38" set /a selection=(selection-1+%menu_size%)%%%menu_size%
if "%key%"=="40" set /a selection=(selection+1)%%%menu_size%
if "%key%"=="13" (
    if "%selection%"=="0" goto LOGIN
    if "%selection%"=="1" goto SIGNUP
    if "%selection%"=="2" exit
)
goto WELCOME_LOOP

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
    echo  [^+] Account created securely!
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
set "m_menu=Chatrooms"
set "m_menu=Logout"
set "m_menu_size=2"
set "m_selection=0"

:MAIN_LOOP
cls
echo  +---------------------------------------+
echo  ^|  NOVA_CHAT HUB (SECURE LAYER)        ^|
echo  ^|  Session Token Verified: %CURRENT_USER%
echo  +---------------------------------------+
echo.
for /l %%i in (0,1,%m_menu_size%-1) do (
    if %%i==%m_selection% (
        echo    =^> [ !m_menu[%%i]! ]
    ) else (
        echo         !m_menu[%%i]!
    )
)
echo.
echo  +---------------------------------------+
echo   Made with ❤️ by Nova Studios.
echo  +---------------------------------------+

for /f "delims=" %%k in ('powershell -Command "[int][System.Console]::ReadKey($true).Key"') do set "key=%%k"
if "%key%"=="38" set /a m_selection=(m_selection-1+%m_menu_size%)%%%m_menu_size%
if "%key%"=="40" set /a m_selection=(m_selection+1)%%%m_menu_size%
if "%key%"=="13" (
    if "%m_selection%"=="0" goto CHANNEL_MENU
    if "%m_selection%"=="1" goto WELCOME_MENU
)
goto MAIN_LOOP

:CHANNEL_MENU
set "c_menu=general"
set "c_menu=gaming"
set "c_menu=Back"
set "c_menu_size=3"
set "c_selection=0"

:CHANNEL_LOOP
cls
echo  +---------------------------------------+
echo  ^|          SELECT CHAT CHANNEL          ^|
echo  +---------------------------------------+
echo.
for /l %%i in (0,1,%c_menu_size%-1) do (
    if %%i==%c_selection% (
        echo    =^> [ !c_menu[%%i]! ]
    ) else (
        echo         !c_menu[%%i]!
    )
)
echo.
echo  +---------------------------------------+
echo   Made with ❤️ by Nova Studios.
echo  +---------------------------------------+

for /f "delims=" %%k in ('powershell -Command "[int][System.Console]::ReadKey($true).Key"') do set "key=%%k"
if "%key%"=="38" set /a c_selection=(c_selection-1+%c_menu_size%)%%%c_menu_size%
if "%key%"=="40" set /a c_selection=(c_selection+1)%%%c_menu_size%
if "%key%"=="13" (
    if "%c_selection%"=="2" goto MAIN_MENU
    set "ACTIVE_CHAN=!c_menu[%c_selection%]!"
    goto CHATROOM_VIEW
)
goto CHANNEL_LOOP

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
echo   Made with ❤️ by Nova Studios.
echo  +---------------------------------------+
set "msg="
set /p "msg=  [%CURRENT_USER%]: "

if "%msg%"=="/b" goto CHANNEL_MENU
if "%msg%"=="" goto CHATROOM_VIEW

echo SEND_MSG^|%CURRENT_USER%^|%ACTIVE_CHAN%^|%msg%>%PUBLIC_PORTAL%REQ_%CURRENT_USER%.txt

timeout /t 1 >nul
goto CHATROOM_VIEW

