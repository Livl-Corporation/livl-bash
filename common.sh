#!/bin/bash

# Constants for styling
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'
ORANGE='\033[0;33m'

# Constants for the script refresh rate
REFRESH_RATE=30

# Function that waits for user input and displays a message
function wait_for_user_input() {
    echo ""
    echo -e "${ORANGE}Cette liste sera actualisée dans ${REFRESH_RATE} secondes. Appuyez sur une touche pour quitter immédiatement.${RESET}"
    for i in $(seq $REFRESH_RATE -1 1); do
        echo -ne "\rActualisation dans ${YELLOW}$i${RESET} seconde(s)... "
        sleep 1 &
        # if user pressed a key, we exit the loop
        read -t 1 -n 1 input
        if [ $? = 0 ]; then
            return 1
        fi
    done
    return 0
}
