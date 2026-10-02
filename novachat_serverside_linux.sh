#!/bin/bash
clear

# ========================================================
#            NOVA_CHAT LOCAL LINUX ENGINE
# ========================================================
PRIVATE_DB="./Database"
SERVER_CONFIG="./server_config.ini"
ADMIN_USER="Admin"
ADMIN_PASS="NovaPass123"
# ========================================================

# Color mapping matrices (Red alerts)
RED='\033[0;31m'
NC='\033[0m'

mkdir -p "$PRIVATE_DB/users" "$PRIVATE_DB/public" "$PRIVATE_DB/system"

if [ ! -f "$SERVER_CONFIG" ]; then
    clear
    echo "======================================================="
    echo "         NOVA_CHAT: FIRST-TIME SERVER SETUP            "
    echo "======================================================="
    echo " To operate securely, enter the local directory path"
    echo " where the client scripts will sync transaction files."
    echo " (Default: ./Public_Shared)"
    echo "======================================================="
    echo
    read -p " Public Folder Path: " user_portal
    if [ -z "$user_portal" ]; then user_portal="./Public_Shared"; fi
    
    echo "portal=$user_portal" > "$SERVER_CONFIG"
    echo "$ADMIN_PASS" > "$PRIVATE_DB/users/$ADMIN_USER.txt"
    echo "admin" > "$PRIVATE_DB/users/${ADMIN_USER}_role.txt"
    echo "online" > "$PRIVATE_DB/system/status.txt"
fi

# Load exchange path values
PUBLIC_PORTAL=$(grep "portal=" "$SERVER_CONFIG" | cut -d'=' -f2)
mkdir -p "$PUBLIC_PORTAL"
echo "online" > "$PUBLIC_PORTAL/status.txt"

clear
echo -e "${RED}======================================================="
echo "          NOVA_CHAT: SECURE BACKEND CORE IS ACTIVE       "
echo "======================================================="
echo " Private Database: $PRIVATE_DB"
echo " Public Shared Portal: $PUBLIC_PORTAL"
echo "======================================================="
echo " Listening for incoming client packet streams..."
echo " Made with ❤️ by Nova Studios."
echo -e "=======================================================${NC}"

while true; do
    # Search for client transaction text tokens inside the shared hub
    for req_file in "$PUBLIC_PORTAL"/REQ_*.txt; do
        if [ -f "$req_file" ]; then
            packet=$(cat "$req_file")
            
            IFS='|' read -r action user d1 d2 <<< "$packet"
            
            # PARSE SIGNUP PROTOCOLS
            if [ "$action" = "SIGNUP" ]; then
                if [ -f "$PRIVATE_DB/users/$user.txt" ]; then
                    echo "RES|TAKEN" > "$PUBLIC_PORTAL/RES_$user.txt"
                else
                    echo "$d1" > "$PRIVATE_DB/users/$user.txt"
                    echo "member" > "$PRIVATE_DB/users/${user}_role.txt"
                    echo "RES|SUCCESS" > "$PUBLIC_PORTAL/RES_$user.txt"
                fi
            fi
            
            # PARSE IDENTITY LOGINS
            if [ "$action" = "LOGIN" ]; then
                if [ ! -f "$PRIVATE_DB/users/$user.txt" ]; then
                    echo "RES|NOUSER" > "$PUBLIC_PORTAL/RES_$user.txt"
                else
                    check_pass=$(cat "$PRIVATE_DB/users/$user.txt")
                    if [ "$d1" = "$check_pass" ]; then
                        u_role=$(cat "$PRIVATE_DB/users/${user}_role.txt")
                        echo "RES|AUTH_OK|$u_role" > "$PUBLIC_PORTAL/RES_$user.txt"
                    else
                        echo "RES|BAD_PASS" > "$PUBLIC_PORTAL/RES_$user.txt"
                    fi
                fi
            fi
            
            # PARSE INBOUND TEXT ROUTING
            if [ "$action" = "SEND_MSG" ]; then
                timestamp=$(date +"%H:%M")
                echo "[$timestamp] $user: $d2" >> "$PRIVATE_DB/public/$d1.txt"
                cat "$PRIVATE_DB/public/$d1.txt" > "$PUBLIC_PORTAL/ROOM_$d1.txt"
                echo "RES|SENT" > "$PUBLIC_PORTAL/RES_$user.txt"
            fi
            
            rm -f "$req_file"
        fi
    done
    sleep 1
done

