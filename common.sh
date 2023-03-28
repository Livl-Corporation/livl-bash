#!/bin/bash

# Constants for styling
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'
ORANGE='\033[0;33m'
BLINK='\033[5m'

# Constants for the script refresh rate
REFRESH_RATE=30

# Function that waits for user input and displays a message each second before refreshing the screen
function wait_for_user_input() {
    echo ""
    echo -e "${ORANGE}Cette liste sera actualisée dans ${REFRESH_RATE} secondes. Appuyez sur une touche pour quitter immédiatement.${RESET}"
    for i in $(seq $REFRESH_RATE -1 1); do # decrease from REFRESH_RATE to 1
        if [ $(($i % 2)) -eq 0 ]; then
            echo -ne "\r${CYAN}Actualisation dans ${GREEN}$i${CYAN} seconde(s)... ${RESET}"
        else
            echo -ne "\r${BLINK}${CYAN}Actualisation dans ${RED}$i${CYAN} seconde(s)... ${RESET}"
        fi
        sleep 1 &
        # if user pressed a key, we exit the loop
        read -t 1 -n 1 input
        if [ $? = 0 ]; then
            return 1
        fi
    done
    return 0
}

# Function that runs a menu option and waits for user input
function run_menu_option() {
    local menu_option="$1"
    local menu_text="$2"
    local action="$3"

    while true; do
        clear
        if [ -n "$menu_text" ]; then
            echo -e "${CYAN}${BOLD}${menu_text}${RESET}\n"
        fi
        eval "$action"

        wait_for_user_input
        if [ $? = 1 ]; then
            break # exit the while loop
        fi
    done
}

# Function that displays an error message
function error_message() {
    local message="$1"
    echo -e "${RED}${BOLD}Erreur: ${message}${RESET}"
}


# Function that displays a list of options menu for the user to choose from
function display_list_of_option()
{
    local options=("$@") 
    
    echo ""
    for index in "${!options[@]}"; do
    printf -v padded_index "%02d" $(($index+1))
    # if we come to the last element of array, we change its color
    if [[ $index -eq $((${#options[@]}-1)) ]]; then
        echo -e "${ORANGE}${padded_index}. ${options[$index]}${RESET}"
        break 2
    fi
    echo -e "${CYAN}${padded_index}. ${options[$index]}${RESET}"
    done

    echo ""
}