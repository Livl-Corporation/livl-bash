#!/bin/bash

# Source the common.sh script
source common.sh

# Définition des options du menu
MENU_OPTIONS=("Liste des services disponibles/installés" "Liste des services actifs" "Vérifier le statut d'un service" "Redémarrer un service" "Quitter")
MENU_ACTIONS=("list_services" "list_active_services" "check_service_status" "restart_service")

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
    service_name=$("ask_for_string" "Entrez le nom du service à vérifier :")
    systemctl status $service_name
}

# d) Proposer une fonctionnalité supplémentaire : redémarrer un service dont le nom contient une chaîne de caractères (définie en paramètre)
function restart_service() {
    service_name=$("ask_for_string" "Entrez le nom du service à redémarrer :")
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
    
    display_list_of_option "${MENU_OPTIONS[@]}"
}


while true; do
    clear 
    show_menu
    read -p "Entrez votre choix (1-${#MENU_OPTIONS[@]}): " choice

    if ((choice >= 1 && choice <= ${#MENU_ACTIONS[@]})); then
        run_menu_option "$choice" "${MENU_OPTIONS[$choice-1]}" "${MENU_ACTIONS[$choice-1]}"
    elif ((choice == ${#MENU_OPTIONS[@]})); then
        exit 0
    else
        error_message "Choix invalide"
    fi   
done