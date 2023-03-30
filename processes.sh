#!/bin/bash

# Source the common.sh script
source common.sh

# a) Identifier tous les processus présents sur le système et indiquer leur propriétaire
function list_all_processes() {
  echo "Liste de tous les processus:"
  ps -ef
}

# b) Fonction pour afficher la liste des processus actifs
function list_active_processes() {
  echo "Liste des processus actifs:"
  ps -ef | grep -v defunct | grep -v "<defunct>"
}

# c) Identifier les processus appartenant à un utilisateur donné en paramètre
function list_user_processes() {
  read -p "Entrez le nom d'utilisateur: " user

  if [ -z "$user" ]; then
    error_message "Nom d'utilisateur invalide"
    list_user_processes
  fi

  ps -u "$user"
}

# d) Identifier les processus consommant le plus de mémoire et indiquer leur propriétaire
function list_memory_processes() {
  echo "Liste des processus consommant le plus de mémoire:"
  ps -eo pid,user,%mem,command --sort=-%mem | head
}

# e) Identifier les processus dont le nom contient une chaine de caractères (définie en paramètre) et indiquer leur propriétaire
function list_matching_processes() {
  read -p "Entrez une chaîne de caractères pour lister les processus : " pattern
  
  if [ -z "$pattern" ]; then
    error_message "Chaîne de caractères invalide"
    list_matching_processes
  fi

  echo "Liste des processus dont le nom contient '$pattern':"
  ps -eo pid,user,%mem,command | grep "$pattern"
}

# f) Produire un fichier de sortie contenant le résultat de la recherche effectuée qui n’écrase pas les résultats de la recherche précédente (tenir compte par exemple de la date et l’heure système)
function write_processes_to_file() {
  read -p "Entrez une chaîne de caractères pour lister les processus : " pattern

  if [ -z "$pattern" ]; then
    error_message "Chaîne de caractères invalide"
    write_processes_to_file
  fi

  file="processes_$(date +'%Y-%m-%d_%H-%M-%S').txt"
  echo "Écriture de la liste des processus correspondant à '$pattern' dans le fichier '$file'..."
  ps -eo pid,user,%mem,command | grep "$pattern" > "$file"

  echo "Lecture du fichier '$file':"
  echo "---------------------------------"
  cat "$file"
  echo "---------------------------------"
  echo "Fin de lecture du fichier '$file'."
}

# g) Proposer une fonctionnalité supplémentaire que vous jugez intéressante et qui manque à la liste précédente (argumentez votre choix)
# afficher les processus en fonction de leur utilisation de la CPU, car cela peut aider à identifier les processus qui consomment le plus de ressources et à les arrêter si nécessaire
function list_max_to_min_process_memory() {
  ps -eo pid,user,%cpu,args --sort=-%cpu | head
}


function filter_process_help() {
  echo "Options:"
  echo "  -a, --actifs          Afficher uniquement les processus actifs"
  echo "  -m, --memoire <N>     Afficher les processus avec une utilisation mémoire supérieure à N"
  echo "  -n, --nom <NAME>       Afficher les processus avec le nom NAME"
}


# Fonction pour afficher la liste des processus avec des filtres
function filter_process() {
    # Options par défaut
    ACTIVE=false
    MAX_MEMORY=0
    NAME=""

    # Analyse des options
    while [[ $# -gt 0 ]]
    do
        key="$1"
        case $key in
            -a|--actifs)
            ACTIVE=true
            shift
            ;;
            -m|--memoire)
            MAX_MEMORY=$2
            shift
            shift
            ;;
            -n|--nom)
            NAME="$2"
            shift
            shift
            ;;
            *)
            echo "Option invalide : $1"
            return 1
            ;;
        esac
    done

    # Construction de la commande ps avec les filtres
    CMD="ps -eo pid,user,%mem,command"

    if [ "$ACTIVE" = true ]; then
        CMD="$CMD | grep -v defunct | grep -v '<defunct>'"
    fi

    if [ "$MAX_MEMORY" -gt 0 ]; then
        CMD="$CMD | awk '\$3 > $MAX_MEMORY'"
    fi
    
    if [ -n "$NAME" ]; then
        CMD="$CMD | grep $NAME"
    fi
    echo "Commande : $CMD"
    eval $CMD
}

function filter_process_ask_args() {
  filter_process_help
  read -p "Entrez les arguments pour exécuter la fonction lister_processus : " args
  filter_process $args
}


options=("Liste de tous les processus" "Liste des processus actifs" "Liste des processus d'un utilisateur donné" "Liste des processus consommant le plus de mémoire" "Liste des processus dont le nom contient une chaîne de caractères" "Écrire la liste des processus correspondant à un critère de recherche dans un fichier" "Proposer une fonctionnalité supplémentaire que vous jugez intéressante et qui manque à la liste précédente" "Filtrer l'affichage des processus" "Quitter")

function show_menu() {
    clear
    
    echo -e "${RED}${BOLD}    ____  ____  ____  ______________________   ${YELLOW} _______  __ ____  __    ____  ____  __________ "
    echo -e "${RED}   / __ \/ __ \/ __ \/ ____/ ____/ ___/ ___/   ${YELLOW}/ ____/ |/ // __ \/ /   / __ \/ __ \/ ____/ __ \ "
    echo -e "${RED}  / /_/ / /_/ / / / / /   / __/  \__ \\__ \   ${YELLOW}/ __/  |   // /_/ / /   / / / / /_/ / __/ / /_/ / "
    echo -e "${RED} / ____/ _, _/ /_/ / /___/ /___ ___/ /__/ /  ${YELLOW}/ /___ /   |/ ____/ /___/ /_/ / _, _/ /___/ _, _/  "
    echo -e "${RED}/_/   /_/ |_|\____/\____/_____//____/____/  ${YELLOW}/_____//_/|_/_/   /_____/\____/_/ |_/_____/_/ |_|   ${RESET}"
                                                                                               

    display_list_of_option "${options[@]}"
}

# Fonction pour afficher le menu principal

while true; do
  show_menu

  read -p "Entrez votre choix (1-${#options[@]}): " choice

  case $choice in
    1) run_menu_option "$choice" "${options[$choice-1]}" "list_all_processes" ;;
    2) run_menu_option "$choice" "${options[$choice-1]}" "list_active_processes" ;;
    3) run_menu_option "$choice" "${options[$choice-1]}" "list_user_processes" ;;
    4) run_menu_option "$choice" "${options[$choice-1]}" "list_memory_processes" ;;
    5) run_menu_option "$choice" "${options[$choice-1]}" "list_matching_processes" ;;
    6) run_menu_option "$choice" "${options[$choice-1]}" "write_processes_to_file";;
    7) run_menu_option "$choice" "${options[$choice-1]}" "list_processes_by_memory";;
    8) run_menu_option "$choice" "${options[$choice-1]}" "list_max_to_min_process_memory";;
    9) exit 0 ;;
    *) error_message "Choix invalide" ;;
  esac
done