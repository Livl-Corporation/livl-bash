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
UNDERLINE='\033[4m'

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
            echo -e "${CYAN}${BOLD}${UNDERLINE}${menu_text}:${RESET}\n"
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

function ask_for_string()
{
    local string
    local textToDisplay="$1"
    while true; do
        read -p "$(echo -e ${CYAN}"$textToDisplay"${RESET}) " string
        if [ -z "$string" ]; then
            error_message "La chaîne de caractères ne peut pas être vide."
            continue
        else
            echo "$string"
            break
        fi
    done
}

function ask_for_number()
{
    local number
    local textToDisplay="$1"
    while true; do
        read -p "$(echo -e ${CYAN}"$textToDisplay"${RESET})" number 
        if [[ $number =~ ^[0-9]+$ ]]; then
            return $number
        else
            error_message "Le nombre doit être un entier positif."
        fi
    done
}

function ask_for_date() {
    local date
    local textToDisplay="$1"

    if [ -z "$textToDisplay" ]; then
        textToDisplay="Entrez la date (au format YYYY-MM-DD): "
    fi

    while true; do
        read -p "$textToDisplay" date
        check_correct_date "$date"
        if [ $? = 0 ]; then
            return $date
        fi
    done
}

function check_correct_date()
{
    local date="$1"

    if [[ $date =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
        local year=$(echo $date | cut -d'-' -f1)
        local month=$(echo $date | cut -d'-' -f2)
        local day=$(echo $date | cut -d'-' -f3)
        if [[ $month -gt 0 && $month -le 12 ]]; then
            if [[ $day -gt 0 && $day -le 31 ]]; then
                return 0
            else 
                error_message "Le jour doit être compris entre 1 et 31."
            fi
        else 
            error_message "Le mois doit être compris entre 1 et 12."
        fi
    else
        error_message "La date doit être au format YYYY-MM-DD."
    fi
     
    return 1
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
            break
        fi
        echo -e "${CYAN}${padded_index}. ${options[$index]}${RESET}"
    done

    echo ""

}