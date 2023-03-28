#!/bin/bash

# Constants for styling
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'
ORANGE='\033[0;33m'
REFRESH_RATE=30


# a) Identifier les services disponibles/installés sur le système
list_services() {
    systemctl list-unit-files --type=service --no-pager
}

# b) Identifier les services actifs sur le système
list_active_services() {
    systemctl list-units --type=service --state=active --no-pager
}

# c) Identifier le statut d’un service dont le nom contient une chaine de caractères (définie en paramètre)
check_service_status() {
    local service_name=$1
    systemctl status $service_name
}

# Proposer une fonctionnalité supplémentaire : redémarrer un service dont le nom contient une chaîne de caractères (définie en paramètre)
restart_service() {
    local service_name=$1
    systemctl restart $service_name
}

show_menu() {
    clear
    
    echo -e "${RED}${BOLD}   _____ __________ _    __________________   ${YELLOW}_______  __ ____  __    ____  ____  __________  "
    echo -e "${RED}  / ___// ____/ __ \ |  / /  _/ ____/ ____/  ${YELLOW}/ ____/ |/ // __ \/ /   / __ \/ __ \/ ____/ __ \ "
    echo -e "${RED}  \__ \/ __/ / /_/ / | / // // /   / __/    ${YELLOW}/ __/  |   // /_/ / /   / / / / /_/ / __/ / /_/ / "
    echo -e "${RED} ___/ / /___/ _  _/| |/ // // /___/ /___   ${YELLOW}/ /___ /   |/ ____/ /___/ /_/ / _  _/ /___/ _, _/  "
    echo -e "${RED}/____/_____/_/ |_| |___/___/\____/_____/  ${YELLOW}/_____//_/|_/_/   /_____/\____/_/ |_/_____/_/ |_|   "
    echo -e "                                                                                             ${RESET}"

    echo ""
    echo -e "${CYAN}1. Liste des services disponibles/installés${RESET}"
    echo -e "${CYAN}2. Liste des services actifs${RESET}"
    echo -e "${CYAN}3. Vérifier le statut d'un service${RESET}"
    echo -e "${CYAN}4. Redémarrer un service${RESET}"
    echo -e "${YELLOW}5. Quitter${RESET}"
    echo
}

# Function that waits for user input and displays a message
wait_for_user_input() {
    echo -e "${ORANGE}Cette liste sera actualisée dans ${REFRESH_RATE} secondes. Appuyez sur une touche pour quitter immédiatement.${RESET}"
    for i in $(seq $REFRESH_RATE -1 1); do
        echo -ne "\rActualisation dans ${YELLOW}$i${RESET} seconde(s)..."
        sleep 1 &
        # if user pressed a key, we exit the loop
        read -t 1 -n 1 input
        if [ $? = 0 ]; then
            return 1
        fi
    done
    return 0
}


# Boucle principale du programme
while true; do
    show_menu
    read -p "Entrez une option : " choice

    # check if input is a number and if it is between 1 and 5
    if ! [[ $choice =~ ^[1-5]$ ]]; then
        echo -e "${RED}Option invalide${RESET}"
        read -t 3 -p "$(echo -e ${ORANGE}Retour au menu principal dans 3 secondes...${RESET})" -n 1
        continue
    fi

    case $choice in
        1)
            while true; do
                clear

                echo -e "${BOLD}Services disponibles/installés :${RESET}"
                list_services

                wait_for_user_input
                if [ $? = 1 ]; then
                    break # exit the while loop
                fi
            done
            ;;
        2)
            while true; do
                clear

                echo -e "${BOLD}Services actifs :${RESET}"
                list_active_services

                wait_for_user_input
                if [ $? = 1 ]; then
                    break # exit the while loop
                fi
            done
            ;;
        3)
            while true; do
                clear

                echo -e "${BOLD}Identifier le statut d’un service :${RESET}"
                read -p "$(echo -e ${CYAN}Entrez le nom du service à vérifier :${RESET} )" service_name
                if [ -z "$service_name" ]; then
                    echo -e "${RED}Nom de service invalide${RESET}"
                else
                    check_service_status "$service_name"
                fi

                wait_for_user_input
                if [ $? = 1 ]; then
                    break # exit the while loop
                fi
            done
            ;;
        4)
            while true; do
                clear
                read -p "$(echo -e ${CYAN}Entrez le nom du service à redémarrer :${RESET}) " service_name
                if [ -z "$service_name" ]; then
                    echo "${RED}Nom de service invalide${RESET}"
                else
                    restart_service "$service_name"
                fi
                
                wait_for_user_input
                if [ $? = 1 ]; then
                    break # exit the while loop
                fi
            done
            ;;
        5)
            exit 0
            ;;
    esac    
done
