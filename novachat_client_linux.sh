#!/bin/bash
clear

# ========================================================
#            NOVA_CHAT LINUX CLIENT ENGINE
# ========================================================
# Dynamically checks the script folder path
PUBLIC_PORTAL="./Public_Shared"
# ========================================================

CYAN='\033[0;36m'
NC='\033[0m'

SERVER_CHECK() {
    if [ ! -f "$PUBLIC_PORTAL/status.txt" ]; then
        clear
        echo "======================================================="
        echo " [!] CLIENT ERROR: CANNOT CONNECT TO NETWORK PORTAL    "
        echo "======================================================="
        echo " Handshake matrix missing. Verify the server is running."
        echo "======================================================="
        exit 1
    fi
}

WELCOME_MENU() {
    while true; do
        clear
        echo -e "${CYAN}+---------------------------------------+"
        echo " |      NOVA_CHAT SECURE GATEWAY       |"
        echo -e "+---------------------------------------+${NC}"
        echo "  1) Login"
        echo "  2) Sign Up"
        echo "  3) Exit"
        echo "---------------------------------------"
        read -p " Select Option [1-3]: " choice
        
        case $choice in
            1) LOGIN ;;
            2) SIGNUP ;;
            3) exit 0 ;;
        esac
    done
}

SIGNUP() {
    clear
    SERVER_CHECK
    echo "+---------------------------------------+"
    echo " |         SECURE SIGN UP REGISTER      |"
    echo "+---------------------------------------+"
    read -p " Desired Username: " username
    read -s -p " Secure Password: " password
    echo
    if [ -z "$username" ]; then return; fi
    
    echo "SIGNUP|$username|$password|" > "$PUBLIC_PORTAL/REQ_$username.txt"
    
    while [ ! -f "$PUBLIC_PORTAL/RES_$username.txt" ]; do sleep 0.5; done
    response=$(cat "$PUBLIC_PORTAL/RES_$username.txt")
    rm -f "$PUBLIC_PORTAL/RES_$username.txt"
    
    if [ "$response" = "RES|SUCCESS" ]; then
        echo " [+] Account created securely!"
        read -p " Press Enter..."
    else
        echo " [X] Username is taken."
        read -p " Press Enter..."
    fi
}

LOGIN() {
    clear
    SERVER_CHECK
    echo "+---------------------------------------+"
    echo " |         SECURE IDENTITY LOGIN         |"
    echo "+---------------------------------------+"
    read -p " Username: " username
    read -s -p " Password: " password
    echo
    
    echo "LOGIN|$username|$password|" > "$PUBLIC_PORTAL/REQ_$username.txt"
    
    while [ ! -f "$PUBLIC_PORTAL/RES_$username.txt" ]; do sleep 0.5; done
    response=$(cat "$PUBLIC_PORTAL/RES_$username.txt")
    rm -f "$PUBLIC_PORTAL/RES_$username.txt"
    
    IFS='|' read -r junk status role <<< "$response"
    
    if [ "$status" = "AUTH_OK" ]; then
        CURRENT_USER=$username
        USER_ROLE=$role
        MAIN_MENU
    else
        echo " [X] Invalid login credentials."
        read -p " Press Enter..."
    fi
}

MAIN_MENU() {
    while true; do
        clear
        echo -e "${CYAN}+---------------------------------------+"
        echo " |  NOVA_CHAT HUB (SECURE LAYER)        |"
        echo " |  Session Token Verified: $CURRENT_USER"
        echo -e "+---------------------------------------+${NC}"
        echo "  1) Chatrooms"
        echo "  2) Logout"
        echo "---------------------------------------"
        read -p " Select Option [1-2]: " m_choice
        
        case $m_choice in
            1) CHANNEL_MENU ;;
            2) return ;;
        esac
    done
}

CHANNEL_MENU() {
    while true; do
        clear
        echo "+---------------------------------------+"
        echo " |          SELECT CHAT CHANNEL          |"
        echo "+---------------------------------------+"
        echo "  1) #general"
        echo "  2) #gaming"
        echo "  3) Back"
        echo "---------------------------------------"
        read -p " Select Option [1-3]: " c_choice
        
        case $c_choice in
            1) ACTIVE_CHAN="general"; CHATROOM_VIEW ;;
            2) ACTIVE_CHAN="gaming"; CHATROOM_VIEW ;;
            3) return ;;
        esac
    done
}

CHATROOM_VIEW() {
    while true; do
        clear
        echo -e "${CYAN}+---------------------------------------+"
        echo " |  SECURE CHANNEL: #$ACTIVE_CHAN"
        echo " |  Type '/b' to change channels         |"
        echo -e "+---------------------------------------+${NC}"
        echo
        if [ -f "$PUBLIC_PORTAL/ROOM_$ACTIVE_CHAN%.txt" ]; then
            cat "$PUBLIC_PORTAL/ROOM_$ACTIVE_CHAN.txt"
        else
            if [ -f "$PUBLIC_PORTAL/ROOM_${ACTIVE_CHAN}.txt" ]; then
                cat "$PUBLIC_PORTAL/ROOM_${ACTIVE_CHAN}.txt"
            else
                echo "   [Authenticated Sync Portal Ready.]"
            fi
        fi
        echo
        echo "---------------------------------------"
        read -p " [$CURRENT_USER]: " msg
        
        if [ "$msg" = "/b" ]; then return; fi
        if [ -z "$msg" ]; then continue; fi
        
        echo "SEND_MSG|$CURRENT_USER|$ACTIVE_CHAN|$msg" > "$PUBLIC_PORTAL/REQ_$CURRENT_USER.txt"
        sleep 0.5
    done
}

WELCOME_MENU

