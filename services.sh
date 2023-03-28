#!/bin/bash

# Constants for styling
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'
ORANGE='\033[0;33m'



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
    
    echo "                                  _                                                __                              "
    echo "    _____  ___    _____ _   __   (_)  _____  ___          ___    _  __    ____    / /  ____    _____  ___    _____ "
    echo "   / ___/ / _ \  / ___/| | / /  / /  / ___/ / _ \        / _ \  | |/_/   / __ \  / /  / __ \  / ___/ / _ \  / ___/ "
    echo "  (__  ) /  __/ / /    | |/ /  / /  / /__  /  __/       /  __/ _>  <    / /_/ / / /  / /_/ / / /    /  __/ / /     "
    echo " /____/  \___/ /_/     |___/  /_/   \___/  \___/        \___/ /_/|_|   / .___/ /_/   \____/ /_/     \___/ /_/      "
    echo "                                                                      /_/                                          "

    echo -e "${BOLD}-----------------------"
    echo "Explorateur de services"
    echo -e "-----------------------${RESET}"
    echo -e "${CYAN}1. Liste des services disponibles/installés${RESET}"
    echo -e "${CYAN}2. Liste des services actifs${RESET}"
    echo -e "${CYAN}3. Vérifier le statut d'un service${RESET}"
    echo -e "${CYAN}4. Redémarrer un service${RESET}"
    echo -e "${YELLOW}5. Quitter${RESET}"
    echo
}

# Boucle principale du programme
while true; do
    show_menu
    read -p "Entrez une option : " choice

    # check if input is a number and if it is between 1 and 5
    if ! [[ $choice =~ ^[1-5]$ ]]; then
        echo -e "${RED}Option invalide${RESET}"
        read -t 2 -p "${ORANGE}Retour au menu principal dans 2 secondes...${RESET}" -n 1
        continue
    fi

    case $choice in
        1)
            while true; do
                clear
                echo -e "${BOLD}Services disponibles/installés :${RESET}"
                list_services
                read -t 10 -p "$(echo -e ${CYAN}Appuyez sur une touche pour continuer...${RESET})" -n 1 input
                if [ $? = 0 ]; then # If user pressed a key
                    break
                fi
            done
            ;;
        2)
            while true; do
                clear
                echo -e "${BOLD}Services actifs :${RESET}"
                list_active_services
                read -t 30 -p "$(echo -e ${CYAN}Appuyez sur une touche pour continuer...${RESET})" -n 1 input
                if [ $? = 0 ]; then # If user pressed a key
                    break
                fi
            done
            ;;
        3)
            while true; do
                clear
                read -p "${CYAN}Entrez le nom du service à vérifier :${RESET} " service_name
                if [ -z "$service_name" ]; then
                    echo -e "${RED}Nom de service invalide${RESET}"
                else
                    check_service_status "$service_name"
                fi
                read -t 30 -p "$(echo -e ${CYAN}Appuyez sur une touche pour continuer...${RESET})" -n 1 input
                if [ $? = 0 ]; then # if user pressed a key
                    break
                fi
            done
            ;;
        4)
            while true; do
                clear
                read -p "${CYAN}Entrez le nom du service à redémarrer :${RESET} " service_name
                if [ -z "$service_name" ]; then
                    echo "${RED}Nom de service invalide${RESET}"
                else
                    restart_service "$service_name"
                fi
                read -t 30 -p "$(echo -e ${CYAN}Appuyez sur une touche pour continuer...${RESET})" -n 1 input
                if [ $? = 0 ]; then # if user pressed a key
                    break
                fi
            done
            ;;
        5)
            exit 0
            ;;
    esac    
done
