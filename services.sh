#!/bin/bash

# Source the common.sh script
source common.sh

# a) Identifier les services disponibles/installés sur le système
function list_services() {
    systemctl list-unit-files --type=service --no-pager
}

# b) Identifier les services actifs sur le système
function list_active_services() {
    systemctl list-units --type=service --state=active --no-pager
}

# c) Identifier le statut d’un service dont le nom contient une chaine de caractères (définie en paramètre)
function check_service_status() {
    local service_name=$1
    systemctl status $service_name
}

# Proposer une fonctionnalité supplémentaire : redémarrer un service dont le nom contient une chaîne de caractères (définie en paramètre)
function restart_service() {
    local service_name=$1
    systemctl restart $service_name
}

function show_menu() {
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

# Boucle principale du programme
while true; do
    clear 

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
