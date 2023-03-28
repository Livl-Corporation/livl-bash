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
    read -p "$(echo -e ${CYAN}Entrez le nom du service à vérifier :${RESET}) " service_name

    if [ -z $service_name ]; then # -z = empty
        error_message "Nom de service invalide"
        check_service_status 
    fi

    systemctl status $service_name
}

# Proposer une fonctionnalité supplémentaire : redémarrer un service dont le nom contient une chaîne de caractères (définie en paramètre)
function restart_service() {
    read -p "$(echo -e ${CYAN}Entrez le nom du service à redémarrer :${RESET}) " service_name

    if [ -z $service_name ]; then # -z = empty
        error_message "Nom de service invalide"
        restart_service
    fi
    
    systemctl restart $service_name
}

# Définition des options du menu
options=( "Liste des services disponibles/installés" "Liste des services actifs" "Vérifier le statut d'un service" "Redémarrer un service" "Quitter" )

function show_menu() {
    clear
    
    echo -e "${RED}${BOLD}   _____ __________ _    __________________   ${YELLOW}_______  __ ____  __    ____  ____  __________  "
    echo -e "${RED}  / ___// ____/ __ \ |  / /  _/ ____/ ____/  ${YELLOW}/ ____/ |/ // __ \/ /   / __ \/ __ \/ ____/ __ \ "
    echo -e "${RED}  \__ \/ __/ / /_/ / | / // // /   / __/    ${YELLOW}/ __/  |   // /_/ / /   / / / / /_/ / __/ / /_/ / "
    echo -e "${RED} ___/ / /___/ _  _/| |/ // // /___/ /___   ${YELLOW}/ /___ /   |/ ____/ /___/ /_/ / _  _/ /___/ _, _/  "
    echo -e "${RED}/____/_____/_/ |_| |___/___/\____/_____/  ${YELLOW}/_____//_/|_/_/   /_____/\____/_/ |_/_____/_/ |_|   "
    echo -e "                                                                                             ${RESET}"
    

    display_list_of_option "${options[@]}"
}


while true; do
    clear 

    show_menu
    read -p "Entrez votre choix (1-${#options[@]}): " choice

    case $choice in
        1) run_menu_option "$choice" "${options[$choice-1]}" "list_services" ;;
        2) run_menu_option "$choice" "${options[$choice-1]}" "st_active_services" ;;
        3) run_menu_option "$choice" "${options[$choice-1]}" "check_service_status" ;;
        4) run_menu_option "$choice" "${options[$choice-1]}" "restart_service";;
        5) exit 0 ;;
        *) error_message "Choix invalide" ;;
    esac     
done