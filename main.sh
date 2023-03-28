#!/bin/bash

# Color constants
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
BLUE="\033[0;34m"
CYAN="\033[0;36m"
RESET="\033[0m"
BOLD="\033[1m"

header()
{
    echo -e "${BLUE}${BOLD}               ____               _      __            "
    echo -e "              / __ \_________    (_)__  / /_           "
    echo -e "             / /_/ / ___/ __ \  / / _ \/ __/           "
    echo -e "            / ____/ /  / /_/ / / /  __/ /_             "
    echo -e "           /_/   /_/   \____/_/ /\___/\__/             "
    echo -e "                           /___/                       ${RESET}"
    echo -e "${RED}   _____ __         ____   _____           _       __  "
    echo -e "  / ___// /_  ___  / / /  / ___/__________(_)___  / /_ "
    echo -e "  \__ \/ __ \/ _ \/ / /   \__ \/ ___/ ___/ / __ \/ __/ "
    echo -e " ___/ / / / /  __/ / /   ___/ / /__/ /  / / /_/ / /_   "
    echo -e "/____/_/ /_/\___/_/_/   /____/\___/_/  /_/ .___/\__/   "
    echo -e "                                        /_/            "
}



while true; do
    
    clear

    header

    echo -e "${RESET}"
    echo -e "${YELLOW}Quel script voulez-vous exécuter ?${RESET}"
    echo ""
    echo -e "${BLUE}Partie ${RESET}${RED}1${RESET}${BLUE} - Explorateur de fichiers${RESET}"
    echo -e "${BLUE}Partie ${RESET}${RED}2${RESET}${BLUE} - Explorateur de processus${RESET}"
    echo -e "${BLUE}Partie ${RESET}${RED}3${RESET}${BLUE} - Explorateur de services${RESET}"
    echo ""
    read -p "Entrez un numéro : " choice

    case $choice in
        1)
            echo -e "${BLUE}Partie 1 - Explorateur de fichiers :...${RESET}"
            ./files.sh
            clear
            ;;
        2)
            echo -e "${BLUE}Partie 2 - Explorateur de processus...${RESET}"
            ./processus.sh
            clear
            ;;
        3)
            echo -e "${BLUE}Partie3 - Explorateur de services...${RESET}"
            ./services.sh
            clear
            ;;
        4)
            echo -e "${RED}Au revoir !${RESET}"
            ;;
        *)
            echo -e "${RED}Option invalide${RESET}"
            exit 1
            ;;
    esac
done